From: akpm@linux-foundation.org
Subject: + mmc_test-add-performance-tests.patch added to -mm tree
Date: Mon, 26 Jul 2010 15:53:25 -0700
Message-ID: <201007262253.o6QMrPrF014702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755628Ab0GZWxd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jul 2010 18:53:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, linux-mmc@vger.kernel.org


The patch titled
     mmc_test: add performance tests
has been added to the -mm tree.  Its filename is
     mmc_test-add-performance-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc_test: add performance tests
From: Adrian Hunter <adrian.hunter@nokia.com>

mmc_test provides tests aimed at testing SD/MMC hosts.  This patch adds
performance tests.

It is advantageous to have performance tests in a kernel
module like mmc_test for the following reasons:
	- transfer times can be measured very accurately
	- arbitrarily large transfers are possible
	- the effect of contiguous vs scattered pages
	can be determined

The new tests are:

	23. Best-case read performance
	24. Best-case write performance
	25. Best-case read performance into scattered pages
	26. Best-case write performance from scattered pages
	27. Single read performance by transfer size
	28. Single write performance by transfer size
	29. Single trim performance by transfer size
	30. Consecutive read performance by transfer size
	31. Consecutive write performance by transfer size
	32. Consecutive trim performance by transfer size

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/mmc_test.c |  793 +++++++++++++++++++++++++++++++++-
 1 file changed, 791 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/card/mmc_test.c~mmc_test-add-performance-tests drivers/mmc/card/mmc_test.c
--- a/drivers/mmc/card/mmc_test.c~mmc_test-add-performance-tests
+++ a/drivers/mmc/card/mmc_test.c
@@ -25,6 +25,54 @@
 #define BUFFER_ORDER		2
 #define BUFFER_SIZE		(PAGE_SIZE << BUFFER_ORDER)
 
+/**
+ * struct mmc_test_pages - pages allocated by 'alloc_pages()'.
+ * @page: first page in the allocation
+ * @order: order of the number of pages allocated
+ */
+struct mmc_test_pages {
+	struct page *page;
+	unsigned int order;
+};
+
+/**
+ * struct mmc_test_mem - allocated memory.
+ * @arr: array of allocations
+ * @cnt: number of allocations
+ */
+struct mmc_test_mem {
+	struct mmc_test_pages *arr;
+	unsigned int cnt;
+};
+
+/**
+ * struct mmc_test_area - information for performance tests.
+ * @dev_addr: address on card at which to do performance tests
+ * @max_sz: test area size (in bytes)
+ * @max_segs: maximum segments in scatterlist @sg
+ * @blocks: number of (512 byte) blocks currently mapped by @sg
+ * @sg_len: length of currently mapped scatterlist @sg
+ * @mem: allocated memory
+ * @sg: scatterlist
+ */
+struct mmc_test_area {
+	unsigned int dev_addr;
+	unsigned int max_sz;
+	unsigned int max_segs;
+	unsigned int blocks;
+	unsigned int sg_len;
+	struct mmc_test_mem *mem;
+	struct scatterlist *sg;
+};
+
+/**
+ * struct mmc_test_card - test information.
+ * @card: card under test
+ * @scratch: transfer buffer
+ * @buffer: transfer buffer
+ * @highmem: buffer for highmem tests
+ * @area: information for performance tests
+ */
 struct mmc_test_card {
 	struct mmc_card	*card;
 
@@ -33,6 +81,7 @@ struct mmc_test_card {
 #ifdef CONFIG_HIGHMEM
 	struct page	*highmem;
 #endif
+	struct mmc_test_area area;
 };
 
 /*******************************************************************/
@@ -97,6 +146,12 @@ static void mmc_test_prepare_mrq(struct 
 	mmc_set_data_timeout(mrq->data, test->card);
 }
 
+static int mmc_test_busy(struct mmc_command *cmd)
+{
+	return !(cmd->resp[0] & R1_READY_FOR_DATA) ||
+		(R1_CURRENT_STATE(cmd->resp[0]) == 7);
+}
+
 /*
  * Wait for the card to finish the busy state
  */
@@ -117,13 +172,13 @@ static int mmc_test_wait_busy(struct mmc
 		if (ret)
 			break;
 
-		if (!busy && !(cmd.resp[0] & R1_READY_FOR_DATA)) {
+		if (!busy && mmc_test_busy(&cmd)) {
 			busy = 1;
 			printk(KERN_INFO "%s: Warning: Host did not "
 				"wait for busy state to end.\n",
 				mmc_hostname(test->card->host));
 		}
-	} while (!(cmd.resp[0] & R1_READY_FOR_DATA));
+	} while (mmc_test_busy(&cmd));
 
 	return ret;
 }
@@ -170,6 +225,246 @@ static int mmc_test_buffer_transfer(stru
 	return 0;
 }
 
+static void mmc_test_free_mem(struct mmc_test_mem *mem)
+{
+	if (!mem)
+		return;
+	while (mem->cnt--)
+		__free_pages(mem->arr[mem->cnt].page,
+			     mem->arr[mem->cnt].order);
+	kfree(mem->arr);
+	kfree(mem);
+}
+
+/*
+ * Allocate a lot of memory, preferrably max_sz but at least min_sz.  In case
+ * there isn't much memory do not exceed 1/16th total RAM.
+ */
+static struct mmc_test_mem *mmc_test_alloc_mem(unsigned int min_sz,
+					       unsigned int max_sz)
+{
+	unsigned int max_page_cnt = DIV_ROUND_UP(max_sz, PAGE_SIZE);
+	unsigned int min_page_cnt = DIV_ROUND_UP(min_sz, PAGE_SIZE);
+	unsigned int page_cnt = 0;
+	struct mmc_test_mem *mem;
+	struct sysinfo si;
+
+	si_meminfo(&si);
+	if (max_page_cnt > si.totalram >> 4)
+		max_page_cnt = si.totalram >> 4;
+	if (max_page_cnt < min_page_cnt)
+		max_page_cnt = min_page_cnt;
+
+	mem = kzalloc(sizeof(struct mmc_test_mem), GFP_KERNEL);
+	if (!mem)
+		return NULL;
+
+	mem->arr = kzalloc(sizeof(struct mmc_test_pages) * max_page_cnt,
+			   GFP_KERNEL);
+	if (!mem->arr)
+		goto out_free;
+
+	while (max_page_cnt) {
+		struct page *page;
+		unsigned int order;
+		gfp_t flags = GFP_KERNEL | GFP_DMA | __GFP_NOWARN |
+				__GFP_NORETRY;
+
+		order = get_order(page_cnt << PAGE_SHIFT);
+		while (1) {
+			page = alloc_pages(flags, order);
+			if (page || !order)
+				break;
+			order -= 1;
+		}
+		if (!page) {
+			if (page_cnt < min_page_cnt)
+				goto out_free;
+			break;
+		}
+		mem->arr[mem->cnt].page = page;
+		mem->arr[mem->cnt].order = order;
+		mem->cnt += 1;
+		max_page_cnt -= 1 << order;
+		page_cnt += 1 << order;
+	}
+
+	return mem;
+
+out_free:
+	mmc_test_free_mem(mem);
+	return NULL;
+}
+
+/*
+ * Map memory into a scatterlist.  Optionally allow the same memory to be
+ * mapped more than once.
+ */
+static int mmc_test_map_sg(struct mmc_test_mem *mem, unsigned int sz,
+			   struct scatterlist *sglist, int repeat,
+			   unsigned int max_segs, unsigned int *sg_len)
+{
+	struct scatterlist *sg = NULL;
+	unsigned int i;
+
+	sg_init_table(sglist, max_segs);
+
+	*sg_len = 0;
+	do {
+		for (i = 0; i < mem->cnt; i++) {
+			unsigned int len = PAGE_SIZE << mem->arr[i].order;
+
+			if (sz < len)
+				len = sz;
+			if (sg)
+				sg = sg_next(sg);
+			else
+				sg = sglist;
+			if (!sg)
+				return -EINVAL;
+			sg_set_page(sg, mem->arr[i].page, len, 0);
+			sz -= len;
+			*sg_len += 1;
+			if (!sz)
+				break;
+		}
+	} while (sz && repeat);
+
+	if (sz)
+		return -EINVAL;
+
+	if (sg)
+		sg_mark_end(sg);
+
+	return 0;
+}
+
+/*
+ * Map memory into a scatterlist so that no pages are contiguous.  Allow the
+ * same memory to be mapped more than once.
+ */
+static int mmc_test_map_sg_max_scatter(struct mmc_test_mem *mem,
+				       unsigned int sz,
+				       struct scatterlist *sglist,
+				       unsigned int max_segs,
+				       unsigned int *sg_len)
+{
+	struct scatterlist *sg = NULL;
+	unsigned int i = mem->cnt, cnt, len;
+	void *base, *addr, *last_addr = NULL;
+
+	sg_init_table(sglist, max_segs);
+
+	*sg_len = 0;
+	while (sz && i) {
+		base = page_address(mem->arr[--i].page);
+		cnt = 1 << mem->arr[i].order;
+		while (sz && cnt) {
+			addr = base + PAGE_SIZE * --cnt;
+			if (last_addr && last_addr + PAGE_SIZE == addr)
+				continue;
+			last_addr = addr;
+			len = PAGE_SIZE;
+			if (sz < len)
+				len = sz;
+			if (sg)
+				sg = sg_next(sg);
+			else
+				sg = sglist;
+			if (!sg)
+				return -EINVAL;
+			sg_set_page(sg, virt_to_page(addr), len, 0);
+			sz -= len;
+			*sg_len += 1;
+		}
+	}
+
+	if (sg)
+		sg_mark_end(sg);
+
+	return 0;
+}
+
+/*
+ * Calculate transfer rate in bytes per second.
+ */
+static unsigned int mmc_test_rate(uint64_t bytes, struct timespec *ts)
+{
+	uint64_t ns;
+
+	ns = ts->tv_sec;
+	ns *= 1000000000;
+	ns += ts->tv_nsec;
+
+	bytes *= 1000000000;
+
+	while (ns > UINT_MAX) {
+		bytes >>= 1;
+		ns >>= 1;
+	}
+
+	if (!ns)
+		return 0;
+
+	do_div(bytes, (uint32_t)ns);
+
+	return bytes;
+}
+
+/*
+ * Print the transfer rate.
+ */
+static void mmc_test_print_rate(struct mmc_test_card *test, uint64_t bytes,
+				struct timespec *ts1, struct timespec *ts2)
+{
+	unsigned int rate, sectors = bytes >> 9;
+	struct timespec ts;
+
+	ts = timespec_sub(*ts2, *ts1);
+
+	rate = mmc_test_rate(bytes, &ts);
+
+	printk(KERN_INFO "%s: Transfer of %u sectors (%u%s KiB) took %lu.%09lu "
+			 "seconds (%u kB/s, %u KiB/s)\n",
+			 mmc_hostname(test->card->host), sectors, sectors >> 1,
+			 (sectors == 1 ? ".5" : ""), (unsigned long)ts.tv_sec,
+			 (unsigned long)ts.tv_nsec, rate / 1000, rate / 1024);
+}
+
+/*
+ * Print the average transfer rate.
+ */
+static void mmc_test_print_avg_rate(struct mmc_test_card *test, uint64_t bytes,
+				    unsigned int count, struct timespec *ts1,
+				    struct timespec *ts2)
+{
+	unsigned int rate, sectors = bytes >> 9;
+	uint64_t tot = bytes * count;
+	struct timespec ts;
+
+	ts = timespec_sub(*ts2, *ts1);
+
+	rate = mmc_test_rate(tot, &ts);
+
+	printk(KERN_INFO "%s: Transfer of %u x %u sectors (%u x %u%s KiB) took "
+			 "%lu.%09lu seconds (%u kB/s, %u KiB/s)\n",
+			 mmc_hostname(test->card->host), count, sectors, count,
+			 sectors >> 1, (sectors == 1 ? ".5" : ""),
+			 (unsigned long)ts.tv_sec, (unsigned long)ts.tv_nsec,
+			 rate / 1000, rate / 1024);
+}
+
+/*
+ * Return the card size in sectors.
+ */
+static unsigned int mmc_test_capacity(struct mmc_card *card)
+{
+	if (!mmc_card_sd(card) && mmc_card_blockaddr(card))
+		return card->ext_csd.sectors;
+	else
+		return card->csd.capacity << (card->csd.read_blkbits - 9);
+}
+
 /*******************************************************************/
 /*  Test preparation and cleanup                                   */
 /*******************************************************************/
@@ -893,8 +1188,410 @@ static int mmc_test_multi_read_high(stru
 	return 0;
 }
 
+#else
+
+static int mmc_test_no_highmem(struct mmc_test_card *test)
+{
+	printk(KERN_INFO "%s: Highmem not configured - test skipped\n",
+	       mmc_hostname(test->card->host));
+	return 0;
+}
+
 #endif /* CONFIG_HIGHMEM */
 
+/*
+ * Map sz bytes so that it can be transferred.
+ */
+static int mmc_test_area_map(struct mmc_test_card *test, unsigned int sz,
+			     int max_scatter)
+{
+	struct mmc_test_area *t = &test->area;
+
+	t->blocks = sz >> 9;
+
+	if (max_scatter) {
+		return mmc_test_map_sg_max_scatter(t->mem, sz, t->sg,
+						   t->max_segs, &t->sg_len);
+	} else {
+		return mmc_test_map_sg(t->mem, sz, t->sg, 1, t->max_segs,
+				       &t->sg_len);
+	}
+}
+
+/*
+ * Transfer bytes mapped by mmc_test_area_map().
+ */
+static int mmc_test_area_transfer(struct mmc_test_card *test,
+				  unsigned int dev_addr, int write)
+{
+	struct mmc_test_area *t = &test->area;
+
+	return mmc_test_simple_transfer(test, t->sg, t->sg_len, dev_addr,
+					t->blocks, 512, write);
+}
+
+/*
+ * Map and transfer bytes.
+ */
+static int mmc_test_area_io(struct mmc_test_card *test, unsigned int sz,
+			    unsigned int dev_addr, int write, int max_scatter,
+			    int timed)
+{
+	struct timespec ts1, ts2;
+	int ret;
+
+	ret = mmc_test_area_map(test, sz, max_scatter);
+	if (ret)
+		return ret;
+
+	if (timed)
+		getnstimeofday(&ts1);
+
+	ret = mmc_test_area_transfer(test, dev_addr, write);
+	if (ret)
+		return ret;
+
+	if (timed)
+		getnstimeofday(&ts2);
+
+	if (timed)
+		mmc_test_print_rate(test, sz, &ts1, &ts2);
+
+	return 0;
+}
+
+/*
+ * Write the test area entirely.
+ */
+static int mmc_test_area_fill(struct mmc_test_card *test)
+{
+	return mmc_test_area_io(test, test->area.max_sz, test->area.dev_addr,
+				1, 0, 0);
+}
+
+/*
+ * Erase the test area entirely.
+ */
+static int mmc_test_area_erase(struct mmc_test_card *test)
+{
+	struct mmc_test_area *t = &test->area;
+
+	if (!mmc_can_erase(test->card))
+		return 0;
+
+	return mmc_erase(test->card, t->dev_addr, test->area.max_sz >> 9,
+			 MMC_ERASE_ARG);
+}
+
+/*
+ * Cleanup struct mmc_test_area.
+ */
+static int mmc_test_area_cleanup(struct mmc_test_card *test)
+{
+	struct mmc_test_area *t = &test->area;
+
+	kfree(t->sg);
+	mmc_test_free_mem(t->mem);
+
+	return 0;
+}
+
+/*
+ * Initialize an area for testing large transfers.  The size of the area is the
+ * preferred erase size which is a good size for optimal transfer speed.  Note
+ * that is typically 4MiB for modern cards.  The test area is set to the middle
+ * of the card because cards may have different charateristics at the front
+ * (for FAT file system optimization).  Optionally, the area is erased (if the
+ * card supports it) which may improve write performance.  Optionally, the area
+ * is filled with data for subsequent read tests.
+ */
+static int mmc_test_area_init(struct mmc_test_card *test, int erase, int fill)
+{
+	struct mmc_test_area *t = &test->area;
+	unsigned int min_sz = 64 * 1024;
+	int ret;
+
+	ret = mmc_test_set_blksize(test, 512);
+	if (ret)
+		return ret;
+
+	/*
+	 * Try to allocate enough memory for the whole area.  Less is OK
+	 * because the same memory can be mapped into the scatterlist more than
+	 * once.
+	 */
+	t->max_sz = test->card->pref_erase << 9;
+	t->mem = mmc_test_alloc_mem(min_sz, t->max_sz);
+	if (!t->mem)
+		return -ENOMEM;
+
+	t->max_segs = DIV_ROUND_UP(t->max_sz, PAGE_SIZE);
+	t->sg = kmalloc(sizeof(struct scatterlist) * t->max_segs, GFP_KERNEL);
+	if (!t->sg) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	t->dev_addr = mmc_test_capacity(test->card) / 2;
+	t->dev_addr -= t->dev_addr % (t->max_sz >> 9);
+
+	if (erase) {
+		ret = mmc_test_area_erase(test);
+		if (ret)
+			goto out_free;
+	}
+
+	if (fill) {
+		ret = mmc_test_area_fill(test);
+		if (ret)
+			goto out_free;
+	}
+
+	return 0;
+
+out_free:
+	mmc_test_area_cleanup(test);
+	return ret;
+}
+
+/*
+ * Prepare for large transfers.  Do not erase the test area.
+ */
+static int mmc_test_area_prepare(struct mmc_test_card *test)
+{
+	return mmc_test_area_init(test, 0, 0);
+}
+
+/*
+ * Prepare for large transfers.  Do erase the test area.
+ */
+static int mmc_test_area_prepare_erase(struct mmc_test_card *test)
+{
+	return mmc_test_area_init(test, 1, 0);
+}
+
+/*
+ * Prepare for large transfers.  Erase and fill the test area.
+ */
+static int mmc_test_area_prepare_fill(struct mmc_test_card *test)
+{
+	return mmc_test_area_init(test, 1, 1);
+}
+
+/*
+ * Test best-case performance.  Best-case performance is expected from
+ * a single large transfer.
+ *
+ * An additional option (max_scatter) allows the measurement of the same
+ * transfer but with no contiguous pages in the scatter list.  This tests
+ * the efficiency of DMA to handle scattered pages.
+ */
+static int mmc_test_best_performance(struct mmc_test_card *test, int write,
+				     int max_scatter)
+{
+	return mmc_test_area_io(test, test->area.max_sz, test->area.dev_addr,
+				write, max_scatter, 1);
+}
+
+/*
+ * Best-case read performance.
+ */
+static int mmc_test_best_read_performance(struct mmc_test_card *test)
+{
+	return mmc_test_best_performance(test, 0, 0);
+}
+
+/*
+ * Best-case write performance.
+ */
+static int mmc_test_best_write_performance(struct mmc_test_card *test)
+{
+	return mmc_test_best_performance(test, 1, 0);
+}
+
+/*
+ * Best-case read performance into scattered pages.
+ */
+static int mmc_test_best_read_perf_max_scatter(struct mmc_test_card *test)
+{
+	return mmc_test_best_performance(test, 0, 1);
+}
+
+/*
+ * Best-case write performance from scattered pages.
+ */
+static int mmc_test_best_write_perf_max_scatter(struct mmc_test_card *test)
+{
+	return mmc_test_best_performance(test, 1, 1);
+}
+
+/*
+ * Single read performance by transfer size.
+ */
+static int mmc_test_profile_read_perf(struct mmc_test_card *test)
+{
+	unsigned int sz, dev_addr;
+	int ret;
+
+	for (sz = 512; sz < test->area.max_sz; sz <<= 1) {
+		dev_addr = test->area.dev_addr + (sz >> 9);
+		ret = mmc_test_area_io(test, sz, dev_addr, 0, 0, 1);
+		if (ret)
+			return ret;
+	}
+	dev_addr = test->area.dev_addr;
+	return mmc_test_area_io(test, sz, dev_addr, 0, 0, 1);
+}
+
+/*
+ * Single write performance by transfer size.
+ */
+static int mmc_test_profile_write_perf(struct mmc_test_card *test)
+{
+	unsigned int sz, dev_addr;
+	int ret;
+
+	ret = mmc_test_area_erase(test);
+	if (ret)
+		return ret;
+	for (sz = 512; sz < test->area.max_sz; sz <<= 1) {
+		dev_addr = test->area.dev_addr + (sz >> 9);
+		ret = mmc_test_area_io(test, sz, dev_addr, 1, 0, 1);
+		if (ret)
+			return ret;
+	}
+	ret = mmc_test_area_erase(test);
+	if (ret)
+		return ret;
+	dev_addr = test->area.dev_addr;
+	return mmc_test_area_io(test, sz, dev_addr, 1, 0, 1);
+}
+
+/*
+ * Single trim performance by transfer size.
+ */
+static int mmc_test_profile_trim_perf(struct mmc_test_card *test)
+{
+	unsigned int sz, dev_addr;
+	struct timespec ts1, ts2;
+	int ret;
+
+	if (!mmc_can_trim(test->card))
+		return RESULT_UNSUP_CARD;
+
+	if (!mmc_can_erase(test->card))
+		return RESULT_UNSUP_HOST;
+
+	for (sz = 512; sz < test->area.max_sz; sz <<= 1) {
+		dev_addr = test->area.dev_addr + (sz >> 9);
+		getnstimeofday(&ts1);
+		ret = mmc_erase(test->card, dev_addr, sz >> 9, MMC_TRIM_ARG);
+		if (ret)
+			return ret;
+		getnstimeofday(&ts2);
+		mmc_test_print_rate(test, sz, &ts1, &ts2);
+	}
+	dev_addr = test->area.dev_addr;
+	getnstimeofday(&ts1);
+	ret = mmc_erase(test->card, dev_addr, sz >> 9, MMC_TRIM_ARG);
+	if (ret)
+		return ret;
+	getnstimeofday(&ts2);
+	mmc_test_print_rate(test, sz, &ts1, &ts2);
+	return 0;
+}
+
+/*
+ * Consecutive read performance by transfer size.
+ */
+static int mmc_test_profile_seq_read_perf(struct mmc_test_card *test)
+{
+	unsigned int sz, dev_addr, i, cnt;
+	struct timespec ts1, ts2;
+	int ret;
+
+	for (sz = 512; sz <= test->area.max_sz; sz <<= 1) {
+		cnt = test->area.max_sz / sz;
+		dev_addr = test->area.dev_addr;
+		getnstimeofday(&ts1);
+		for (i = 0; i < cnt; i++) {
+			ret = mmc_test_area_io(test, sz, dev_addr, 0, 0, 0);
+			if (ret)
+				return ret;
+			dev_addr += (sz >> 9);
+		}
+		getnstimeofday(&ts2);
+		mmc_test_print_avg_rate(test, sz, cnt, &ts1, &ts2);
+	}
+	return 0;
+}
+
+/*
+ * Consecutive write performance by transfer size.
+ */
+static int mmc_test_profile_seq_write_perf(struct mmc_test_card *test)
+{
+	unsigned int sz, dev_addr, i, cnt;
+	struct timespec ts1, ts2;
+	int ret;
+
+	for (sz = 512; sz <= test->area.max_sz; sz <<= 1) {
+		ret = mmc_test_area_erase(test);
+		if (ret)
+			return ret;
+		cnt = test->area.max_sz / sz;
+		dev_addr = test->area.dev_addr;
+		getnstimeofday(&ts1);
+		for (i = 0; i < cnt; i++) {
+			ret = mmc_test_area_io(test, sz, dev_addr, 1, 0, 0);
+			if (ret)
+				return ret;
+			dev_addr += (sz >> 9);
+		}
+		getnstimeofday(&ts2);
+		mmc_test_print_avg_rate(test, sz, cnt, &ts1, &ts2);
+	}
+	return 0;
+}
+
+/*
+ * Consecutive trim performance by transfer size.
+ */
+static int mmc_test_profile_seq_trim_perf(struct mmc_test_card *test)
+{
+	unsigned int sz, dev_addr, i, cnt;
+	struct timespec ts1, ts2;
+	int ret;
+
+	if (!mmc_can_trim(test->card))
+		return RESULT_UNSUP_CARD;
+
+	if (!mmc_can_erase(test->card))
+		return RESULT_UNSUP_HOST;
+
+	for (sz = 512; sz <= test->area.max_sz; sz <<= 1) {
+		ret = mmc_test_area_erase(test);
+		if (ret)
+			return ret;
+		ret = mmc_test_area_fill(test);
+		if (ret)
+			return ret;
+		cnt = test->area.max_sz / sz;
+		dev_addr = test->area.dev_addr;
+		getnstimeofday(&ts1);
+		for (i = 0; i < cnt; i++) {
+			ret = mmc_erase(test->card, dev_addr, sz >> 9,
+					MMC_TRIM_ARG);
+			if (ret)
+				return ret;
+			dev_addr += (sz >> 9);
+		}
+		getnstimeofday(&ts2);
+		mmc_test_print_avg_rate(test, sz, cnt, &ts1, &ts2);
+	}
+	return 0;
+}
+
 static const struct mmc_test_case mmc_test_cases[] = {
 	{
 		.name = "Basic write (no data verification)",
@@ -1040,8 +1737,100 @@ static const struct mmc_test_case mmc_te
 		.cleanup = mmc_test_cleanup,
 	},
 
+#else
+
+	{
+		.name = "Highmem write",
+		.run = mmc_test_no_highmem,
+	},
+
+	{
+		.name = "Highmem read",
+		.run = mmc_test_no_highmem,
+	},
+
+	{
+		.name = "Multi-block highmem write",
+		.run = mmc_test_no_highmem,
+	},
+
+	{
+		.name = "Multi-block highmem read",
+		.run = mmc_test_no_highmem,
+	},
+
 #endif /* CONFIG_HIGHMEM */
 
+	{
+		.name = "Best-case read performance",
+		.prepare = mmc_test_area_prepare_fill,
+		.run = mmc_test_best_read_performance,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Best-case write performance",
+		.prepare = mmc_test_area_prepare_erase,
+		.run = mmc_test_best_write_performance,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Best-case read performance into scattered pages",
+		.prepare = mmc_test_area_prepare_fill,
+		.run = mmc_test_best_read_perf_max_scatter,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Best-case write performance from scattered pages",
+		.prepare = mmc_test_area_prepare_erase,
+		.run = mmc_test_best_write_perf_max_scatter,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Single read performance by transfer size",
+		.prepare = mmc_test_area_prepare_fill,
+		.run = mmc_test_profile_read_perf,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Single write performance by transfer size",
+		.prepare = mmc_test_area_prepare,
+		.run = mmc_test_profile_write_perf,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Single trim performance by transfer size",
+		.prepare = mmc_test_area_prepare_fill,
+		.run = mmc_test_profile_trim_perf,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Consecutive read performance by transfer size",
+		.prepare = mmc_test_area_prepare_fill,
+		.run = mmc_test_profile_seq_read_perf,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Consecutive write performance by transfer size",
+		.prepare = mmc_test_area_prepare,
+		.run = mmc_test_profile_seq_write_perf,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
+	{
+		.name = "Consecutive trim performance by transfer size",
+		.prepare = mmc_test_area_prepare,
+		.run = mmc_test_profile_seq_trim_perf,
+		.cleanup = mmc_test_area_cleanup,
+	},
+
 };
 
 static DEFINE_MUTEX(mmc_test_lock);
_

Patches currently in -mm which might be from adrian.hunter@nokia.com are

linux-next.patch
mmc-recognize-csd-structure.patch
mmc-recognize-csd-structure-fix.patch
mmc-split-mmc_sd_init_card.patch
mmc-implement-sd-combo-iomem-support.patch
mmc-omap-fix-for-bus-width-which-improves-sd-cards-peformance.patch
sdio-allow-non-standard-sdio-cards.patch
omap_hsmmc-add-init_card-pass-through-callback.patch
omap-pandora-pass-wl1251-information-to-sdio-core.patch
mmc-add-erase-secure-erase-trim-and-secure-trim-operations.patch
mmc_block-add-discard-support.patch
omap_hsmmc-add-erase-capability.patch
block-add-secure-discard.patch
mmc_block-add-support-for-secure-discard.patch
mmc_test-add-performance-tests.patch

