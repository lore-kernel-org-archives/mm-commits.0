From: akpm@linux-foundation.org
Subject: + mmc_test-fix-large-memory-allocation.patch added to -mm tree
Date: Tue, 03 Aug 2010 14:21:45 -0700
Message-ID: <201008032121.o73LLjEM011786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756208Ab0HCVVx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Aug 2010 17:21:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com


The patch titled
     mmc_test: fix large memory allocation
has been added to the -mm tree.  Its filename is
     mmc_test-fix-large-memory-allocation.patch

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
Subject: mmc_test: fix large memory allocation
From: Adrian Hunter <adrian.hunter@nokia.com>

- Fix mmc_test_alloc_mem.

- Use nr_free_buffer_pages() instead of sysinfo.totalram to determine
  total lowmem pages.

- Change variables containing memory sizes to unsigned long.

- Limit maximum test area size to 128MiB because that is the maximum MMC
  high capacity erase size (the maxmium SD allocation unit size is just
  4MiB)

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/card/mmc_test.c |   76 +++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 29 deletions(-)

diff -puN drivers/mmc/card/mmc_test.c~mmc_test-fix-large-memory-allocation drivers/mmc/card/mmc_test.c
--- a/drivers/mmc/card/mmc_test.c~mmc_test-fix-large-memory-allocation
+++ a/drivers/mmc/card/mmc_test.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 
 #include <linux/scatterlist.h>
+#include <linux/swap.h>		/* For nr_free_buffer_pages() */
 
 #define RESULT_OK		0
 #define RESULT_FAIL		1
@@ -25,6 +26,12 @@
 #define BUFFER_ORDER		2
 #define BUFFER_SIZE		(PAGE_SIZE << BUFFER_ORDER)
 
+/*
+ * Limit the test area size to the maximum MMC HC erase group size.  Note that
+ * the maximum SD allocation unit size is just 4MiB.
+ */
+#define TEST_AREA_MAX_SIZE (128 * 1024 * 1024)
+
 /**
  * struct mmc_test_pages - pages allocated by 'alloc_pages()'.
  * @page: first page in the allocation
@@ -47,8 +54,8 @@ struct mmc_test_mem {
 
 /**
  * struct mmc_test_area - information for performance tests.
- * @dev_addr: address on card at which to do performance tests
  * @max_sz: test area size (in bytes)
+ * @dev_addr: address on card at which to do performance tests
  * @max_segs: maximum segments in scatterlist @sg
  * @blocks: number of (512 byte) blocks currently mapped by @sg
  * @sg_len: length of currently mapped scatterlist @sg
@@ -56,8 +63,8 @@ struct mmc_test_mem {
  * @sg: scatterlist
  */
 struct mmc_test_area {
+	unsigned long max_sz;
 	unsigned int dev_addr;
-	unsigned int max_sz;
 	unsigned int max_segs;
 	unsigned int blocks;
 	unsigned int sg_len;
@@ -238,20 +245,19 @@ static void mmc_test_free_mem(struct mmc
 
 /*
  * Allocate a lot of memory, preferrably max_sz but at least min_sz.  In case
- * there isn't much memory do not exceed 1/16th total RAM.
+ * there isn't much memory do not exceed 1/16th total lowmem pages.
  */
-static struct mmc_test_mem *mmc_test_alloc_mem(unsigned int min_sz,
-					       unsigned int max_sz)
+static struct mmc_test_mem *mmc_test_alloc_mem(unsigned long min_sz,
+					       unsigned long max_sz)
 {
-	unsigned int max_page_cnt = DIV_ROUND_UP(max_sz, PAGE_SIZE);
-	unsigned int min_page_cnt = DIV_ROUND_UP(min_sz, PAGE_SIZE);
-	unsigned int page_cnt = 0;
+	unsigned long max_page_cnt = DIV_ROUND_UP(max_sz, PAGE_SIZE);
+	unsigned long min_page_cnt = DIV_ROUND_UP(min_sz, PAGE_SIZE);
+	unsigned long page_cnt = 0;
+	unsigned long limit = nr_free_buffer_pages() >> 4;
 	struct mmc_test_mem *mem;
-	struct sysinfo si;
 
-	si_meminfo(&si);
-	if (max_page_cnt > si.totalram >> 4)
-		max_page_cnt = si.totalram >> 4;
+	if (max_page_cnt > limit)
+		max_page_cnt = limit;
 	if (max_page_cnt < min_page_cnt)
 		max_page_cnt = min_page_cnt;
 
@@ -270,7 +276,7 @@ static struct mmc_test_mem *mmc_test_all
 		gfp_t flags = GFP_KERNEL | GFP_DMA | __GFP_NOWARN |
 				__GFP_NORETRY;
 
-		order = get_order(page_cnt << PAGE_SHIFT);
+		order = get_order(max_page_cnt << PAGE_SHIFT);
 		while (1) {
 			page = alloc_pages(flags, order);
 			if (page || !order)
@@ -285,8 +291,10 @@ static struct mmc_test_mem *mmc_test_all
 		mem->arr[mem->cnt].page = page;
 		mem->arr[mem->cnt].order = order;
 		mem->cnt += 1;
-		max_page_cnt -= 1 << order;
-		page_cnt += 1 << order;
+		if (max_page_cnt <= (1UL << order))
+			break;
+		max_page_cnt -= 1UL << order;
+		page_cnt += 1UL << order;
 	}
 
 	return mem;
@@ -300,7 +308,7 @@ out_free:
  * Map memory into a scatterlist.  Optionally allow the same memory to be
  * mapped more than once.
  */
-static int mmc_test_map_sg(struct mmc_test_mem *mem, unsigned int sz,
+static int mmc_test_map_sg(struct mmc_test_mem *mem, unsigned long sz,
 			   struct scatterlist *sglist, int repeat,
 			   unsigned int max_segs, unsigned int *sg_len)
 {
@@ -312,7 +320,7 @@ static int mmc_test_map_sg(struct mmc_te
 	*sg_len = 0;
 	do {
 		for (i = 0; i < mem->cnt; i++) {
-			unsigned int len = PAGE_SIZE << mem->arr[i].order;
+			unsigned long len = PAGE_SIZE << mem->arr[i].order;
 
 			if (sz < len)
 				len = sz;
@@ -344,13 +352,14 @@ static int mmc_test_map_sg(struct mmc_te
  * same memory to be mapped more than once.
  */
 static int mmc_test_map_sg_max_scatter(struct mmc_test_mem *mem,
-				       unsigned int sz,
+				       unsigned long sz,
 				       struct scatterlist *sglist,
 				       unsigned int max_segs,
 				       unsigned int *sg_len)
 {
 	struct scatterlist *sg = NULL;
-	unsigned int i = mem->cnt, cnt, len;
+	unsigned int i = mem->cnt, cnt;
+	unsigned long len;
 	void *base, *addr, *last_addr = NULL;
 
 	sg_init_table(sglist, max_segs);
@@ -1202,7 +1211,7 @@ static int mmc_test_no_highmem(struct mm
 /*
  * Map sz bytes so that it can be transferred.
  */
-static int mmc_test_area_map(struct mmc_test_card *test, unsigned int sz,
+static int mmc_test_area_map(struct mmc_test_card *test, unsigned long sz,
 			     int max_scatter)
 {
 	struct mmc_test_area *t = &test->area;
@@ -1233,7 +1242,7 @@ static int mmc_test_area_transfer(struct
 /*
  * Map and transfer bytes.
  */
-static int mmc_test_area_io(struct mmc_test_card *test, unsigned int sz,
+static int mmc_test_area_io(struct mmc_test_card *test, unsigned long sz,
 			    unsigned int dev_addr, int write, int max_scatter,
 			    int timed)
 {
@@ -1308,19 +1317,22 @@ static int mmc_test_area_cleanup(struct 
 static int mmc_test_area_init(struct mmc_test_card *test, int erase, int fill)
 {
 	struct mmc_test_area *t = &test->area;
-	unsigned int min_sz = 64 * 1024;
+	unsigned long min_sz = 64 * 1024;
 	int ret;
 
 	ret = mmc_test_set_blksize(test, 512);
 	if (ret)
 		return ret;
 
+	if (test->card->pref_erase > TEST_AREA_MAX_SIZE >> 9)
+		t->max_sz = TEST_AREA_MAX_SIZE;
+	else
+		t->max_sz = (unsigned long)test->card->pref_erase << 9;
 	/*
 	 * Try to allocate enough memory for the whole area.  Less is OK
 	 * because the same memory can be mapped into the scatterlist more than
 	 * once.
 	 */
-	t->max_sz = test->card->pref_erase << 9;
 	t->mem = mmc_test_alloc_mem(min_sz, t->max_sz);
 	if (!t->mem)
 		return -ENOMEM;
@@ -1430,7 +1442,8 @@ static int mmc_test_best_write_perf_max_
  */
 static int mmc_test_profile_read_perf(struct mmc_test_card *test)
 {
-	unsigned int sz, dev_addr;
+	unsigned long sz;
+	unsigned int dev_addr;
 	int ret;
 
 	for (sz = 512; sz < test->area.max_sz; sz <<= 1) {
@@ -1448,7 +1461,8 @@ static int mmc_test_profile_read_perf(st
  */
 static int mmc_test_profile_write_perf(struct mmc_test_card *test)
 {
-	unsigned int sz, dev_addr;
+	unsigned long sz;
+	unsigned int dev_addr;
 	int ret;
 
 	ret = mmc_test_area_erase(test);
@@ -1472,7 +1486,8 @@ static int mmc_test_profile_write_perf(s
  */
 static int mmc_test_profile_trim_perf(struct mmc_test_card *test)
 {
-	unsigned int sz, dev_addr;
+	unsigned long sz;
+	unsigned int dev_addr;
 	struct timespec ts1, ts2;
 	int ret;
 
@@ -1506,7 +1521,8 @@ static int mmc_test_profile_trim_perf(st
  */
 static int mmc_test_profile_seq_read_perf(struct mmc_test_card *test)
 {
-	unsigned int sz, dev_addr, i, cnt;
+	unsigned long sz;
+	unsigned int dev_addr, i, cnt;
 	struct timespec ts1, ts2;
 	int ret;
 
@@ -1531,7 +1547,8 @@ static int mmc_test_profile_seq_read_per
  */
 static int mmc_test_profile_seq_write_perf(struct mmc_test_card *test)
 {
-	unsigned int sz, dev_addr, i, cnt;
+	unsigned long sz;
+	unsigned int dev_addr, i, cnt;
 	struct timespec ts1, ts2;
 	int ret;
 
@@ -1559,7 +1576,8 @@ static int mmc_test_profile_seq_write_pe
  */
 static int mmc_test_profile_seq_trim_perf(struct mmc_test_card *test)
 {
-	unsigned int sz, dev_addr, i, cnt;
+	unsigned long sz;
+	unsigned int dev_addr, i, cnt;
 	struct timespec ts1, ts2;
 	int ret;
 
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
mmc_test-fix-large-memory-allocation.patch

