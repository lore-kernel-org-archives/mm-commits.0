From: akpm@linux-foundation.org
Subject: - readahead-on-demand-readahead-logic.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:01:11 -0700
Message-ID: <200707192001.l6JK1BRQ019516@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57618 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932227AbXGSU3t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:29:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, linuxram@us.ibm.com, rusty@rustcorp.com.au, slpratt@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     readahead: on-demand readahead logic
has been removed from the -mm tree.  Its filename was
     readahead-on-demand-readahead-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: readahead: on-demand readahead logic
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

This is a minimal readahead algorithm that aims to replace the current one. 
It is more flexible and reliable, while maintaining almost the same behavior
and performance.  Also it is full integrated with adaptive readahead.

It is designed to be called on demand:
	- on a missing page, to do synchronous readahead
	- on a lookahead page, to do asynchronous readahead

In this way it eliminated the awkward workarounds for cache hit/miss,
readahead thrashing, retried read, and unaligned read.  It also adopts the
data structure introduced by adaptive readahead, parameterizes readahead
pipelining with `lookahead_index', and reduces the current/ahead windows to
one single window.

HEURISTICS

The logic deals with four cases:

	- sequential-next
		found a consistent readahead window, so push it forward

	- random
		standalone small read, so read as is

	- sequential-first
		create a new readahead window for a sequential/oversize request

	- lookahead-clueless
		hit a lookahead page not associated with the readahead window,
		so create a new readahead window and ramp it up

In each case, three parameters are determined:

	- readahead index: where the next readahead begins
	- readahead size:  how much to readahead
	- lookahead size:  when to do the next readahead (for pipelining)

BEHAVIORS

The old behaviors are maximally preserved for trivial sequential/random reads.
Notable changes are:

	- It no longer imposes strict sequential checks.
	  It might help some interleaved cases, and clustered random reads.
	  It does introduce risks of a random lookahead hit triggering an
	  unexpected readahead. But in general it is more likely to do good
	  than to do evil.

	- Interleaved reads are supported in a minimal way.
	  Their chances of being detected and proper handled are still low.

	- Readahead thrashings are better handled.
	  The current readahead leads to tiny average I/O sizes, because it
	  never turn back for the thrashed pages.  They have to be fault in
	  by do_generic_mapping_read() one by one.  Whereas the on-demand
	  readahead will redo readahead for them.

OVERHEADS

The new code reduced the overheads of

	- excessively calling the readahead routine on small sized reads
	  (the current readahead code insists on seeing all requests)

	- doing a lot of pointless page-cache lookups for small cached files
	  (the current readahead only turns itself off after 256 cache hits,
	  unfortunately most files are < 1MB, so never see that chance)

That accounts for speedup of
	- 0.3% on 1-page sequential reads on sparse file
	- 1.2% on 1-page cache hot sequential reads
	- 3.2% on 256-page cache hot sequential reads
	- 1.3% on cache hot `tar /lib`

However, it does introduce one extra page-cache lookup per cache miss, which
impacts random reads slightly. That's 1% overheads for 1-page random reads on
sparse file.

PERFORMANCE

The basic benchmark setup is
	- 2.6.20 kernel with on-demand readahead
	- 1MB max readahead size
	- 2.9GHz Intel Core 2 CPU
	- 2GB memory
	- 160G/8M Hitachi SATA II 7200 RPM disk

The benchmarks show that
	- it maintains the same performance for trivial sequential/random reads
	- sysbench/OLTP performance on MySQL gains up to 8%
	- performance on readahead thrashing gains up to 3 times

iozone throughput (KB/s): roughly the same
==========================================
iozone -c -t1 -s 4096m -r 64k

			       2.6.20          on-demand      gain
first run
	  "  Initial write "   61437.27        64521.53      +5.0%
	  "        Rewrite "   47893.02        48335.20      +0.9%
	  "           Read "   62111.84        62141.49      +0.0%
	  "        Re-read "   62242.66        62193.17      -0.1%
	  "   Reverse Read "   50031.46        49989.79      -0.1%
	  "    Stride read "    8657.61         8652.81      -0.1%
	  "    Random read "   13914.28        13898.23      -0.1%
	  " Mixed workload "   19069.27        19033.32      -0.2%
	  "   Random write "   14849.80        14104.38      -5.0%
	  "         Pwrite "   62955.30        65701.57      +4.4%
	  "          Pread "   62209.99        62256.26      +0.1%

second run
	  "  Initial write "   60810.31        66258.69      +9.0%
	  "        Rewrite "   49373.89        57833.66     +17.1%
	  "           Read "   62059.39        62251.28      +0.3%
	  "        Re-read "   62264.32        62256.82      -0.0%
	  "   Reverse Read "   49970.96        50565.72      +1.2%
	  "    Stride read "    8654.81         8638.45      -0.2%
	  "    Random read "   13901.44        13949.91      +0.3%
	  " Mixed workload "   19041.32        19092.04      +0.3%
	  "   Random write "   14019.99        14161.72      +1.0%
	  "         Pwrite "   64121.67        68224.17      +6.4%
	  "          Pread "   62225.08        62274.28      +0.1%

In summary, writes are unstable, reads are pretty close on average:

			  access pattern  2.6.20  on-demand   gain
				   Read  62085.61  62196.38  +0.2%
				Re-read  62253.49  62224.99  -0.0%
			   Reverse Read  50001.21  50277.75  +0.6%
			    Stride read   8656.21   8645.63  -0.1%
			    Random read  13907.86  13924.07  +0.1%
	 		 Mixed workload  19055.29  19062.68  +0.0%
				  Pread  62217.53  62265.27  +0.1%

aio-stress: roughly the same
============================
aio-stress -l -s4096 -r128 -t1 -o1 knoppix511-dvd-cn.iso
aio-stress -l -s4096 -r128 -t1 -o3 knoppix511-dvd-cn.iso

					2.6.20      on-demand  delta
			sequential	 92.57s      92.54s    -0.0%
			random		311.87s     312.15s    +0.1%

sysbench fileio: roughly the same
=================================
sysbench --test=fileio --file-io-mode=async --file-test-mode=rndrw \
	 --file-total-size=4G --file-block-size=64K \
	 --num-threads=001 --max-requests=10000 --max-time=900 run

				threads    2.6.20   on-demand    delta
		first run
				      1   59.1974s    59.2262s  +0.0%
				      2   58.0575s    58.2269s  +0.3%
				      4   48.0545s    47.1164s  -2.0%
				      8   41.0684s    41.2229s  +0.4%
				     16   35.8817s    36.4448s  +1.6%
				     32   32.6614s    32.8240s  +0.5%
				     64   23.7601s    24.1481s  +1.6%
				    128   24.3719s    23.8225s  -2.3%
				    256   23.2366s    22.0488s  -5.1%

		second run
				      1   59.6720s    59.5671s  -0.2%
				      8   41.5158s    41.9541s  +1.1%
				     64   25.0200s    23.9634s  -4.2%
				    256   22.5491s    20.9486s  -7.1%

Note that the numbers are not very stable because of the writes.
The overall performance is close when we sum all seconds up:

                sum all up               495.046s    491.514s   -0.7%

sysbench oltp (trans/sec): up to 8% gain
========================================
sysbench --test=oltp --oltp-table-size=10000000 --oltp-read-only \
	 --mysql-socket=/var/run/mysqld/mysqld.sock \
	 --mysql-user=root --mysql-password=readahead \
	 --num-threads=064 --max-requests=10000 --max-time=900 run

	10000-transactions run
				threads    2.6.20   on-demand    gain
				      1     62.81       64.56   +2.8%
				      2     67.97       70.93   +4.4%
				      4     81.81       85.87   +5.0%
				      8     94.60       97.89   +3.5%
				     16     99.07      104.68   +5.7%
				     32     95.93      104.28   +8.7%
				     64     96.48      103.68   +7.5%
	5000-transactions run
				      1     48.21       48.65   +0.9%
				      8     68.60       70.19   +2.3%
				     64     70.57       74.72   +5.9%
	2000-transactions run
				      1     37.57       38.04   +1.3%
				      2     38.43       38.99   +1.5%
				      4     45.39       46.45   +2.3%
				      8     51.64       52.36   +1.4%
				     16     54.39       55.18   +1.5%
				     32     52.13       54.49   +4.5%
				     64     54.13       54.61   +0.9%

That's interesting results. Some investigations show that
	- MySQL is accessing the db file non-uniformly: some parts are
	  more hot than others
	- It is mostly doing 4-page random reads, and sometimes doing two
	  reads in a row, the latter one triggers a 16-page readahead.
	- The on-demand readahead leaves many lookahead pages (flagged
	  PG_readahead) there. Many of them will be hit, and trigger
	  more readahead pages. Which might save more seeks.
	- Naturally, the readahead windows tend to lie in hot areas,
	  and the lookahead pages in hot areas is more likely to be hit.
	- The more overall read density, the more possible gain.

That also explains the adaptive readahead tricks for clustered random reads.

readahead thrashing: 3 times better
===================================
We boot kernel with "mem=128m single", and start a 100KB/s stream on every
second, until reaching 200 streams.

			      max throughput     min avg I/O size
		2.6.20:            5MB/s               16KB
		on-demand:        15MB/s              140KB

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Steven Pratt <slpratt@austin.ibm.com>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +
 mm/readahead.c     |  174 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 180 insertions(+)

diff -puN include/linux/mm.h~readahead-on-demand-readahead-logic include/linux/mm.h
--- a/include/linux/mm.h~readahead-on-demand-readahead-logic
+++ a/include/linux/mm.h
@@ -1138,6 +1138,12 @@ int do_page_cache_readahead(struct addre
 			pgoff_t offset, unsigned long nr_to_read);
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			pgoff_t offset, unsigned long nr_to_read);
+unsigned long page_cache_readahead_ondemand(struct address_space *mapping,
+			  struct file_ra_state *ra,
+			  struct file *filp,
+			  struct page *page,
+			  pgoff_t offset,
+			  unsigned long size);
 unsigned long page_cache_readahead(struct address_space *mapping,
 			  struct file_ra_state *ra,
 			  struct file *filp,
diff -puN mm/readahead.c~readahead-on-demand-readahead-logic mm/readahead.c
--- a/mm/readahead.c~readahead-on-demand-readahead-logic
+++ a/mm/readahead.c
@@ -611,3 +611,177 @@ unsigned long ra_submit(struct file_ra_s
 	return actual;
 }
 EXPORT_SYMBOL_GPL(ra_submit);
+
+/*
+ *  Get the previous window size, ramp it up, and
+ *  return it as the new window size.
+ */
+static unsigned long get_next_ra_size2(struct file_ra_state *ra,
+						unsigned long max)
+{
+	unsigned long cur = ra->readahead_index - ra->ra_index;
+	unsigned long newsize;
+
+	if (cur < max / 16)
+		newsize = cur * 4;
+	else
+		newsize = cur * 2;
+
+	return min(newsize, max);
+}
+
+/*
+ * On-demand readahead design.
+ *
+ * The fields in struct file_ra_state represent the most-recently-executed
+ * readahead attempt:
+ *
+ *                    |-------- last readahead window -------->|
+ *       |-- application walking here -->|
+ * ======#============|==================#=====================|
+ *       ^la_index    ^ra_index          ^lookahead_index      ^readahead_index
+ *
+ * [ra_index, readahead_index) represents the last readahead window.
+ *
+ * [la_index, lookahead_index] is where the application would be walking(in
+ * the common case of cache-cold sequential reads): the last window was
+ * established when the application was at la_index, and the next window will
+ * be bring in when the application reaches lookahead_index.
+ *
+ * To overlap application thinking time and disk I/O time, we do
+ * `readahead pipelining': Do not wait until the application consumed all
+ * readahead pages and stalled on the missing page at readahead_index;
+ * Instead, submit an asynchronous readahead I/O as early as the application
+ * reads on the page at lookahead_index. Normally lookahead_index will be
+ * equal to ra_index, for maximum pipelining.
+ *
+ * In interleaved sequential reads, concurrent streams on the same fd can
+ * be invalidating each other's readahead state. So we flag the new readahead
+ * page at lookahead_index with PG_readahead, and use it as readahead
+ * indicator. The flag won't be set on already cached pages, to avoid the
+ * readahead-for-nothing fuss, saving pointless page cache lookups.
+ *
+ * prev_index tracks the last visited page in the _previous_ read request.
+ * It should be maintained by the caller, and will be used for detecting
+ * small random reads. Note that the readahead algorithm checks loosely
+ * for sequential patterns. Hence interleaved reads might be served as
+ * sequential ones.
+ *
+ * There is a special-case: if the first page which the application tries to
+ * read happens to be the first page of the file, it is assumed that a linear
+ * read is about to happen and the window is immediately set to the initial size
+ * based on I/O request size and the max_readahead.
+ *
+ * The code ramps up the readahead size aggressively at first, but slow down as
+ * it approaches max_readhead.
+ */
+
+/*
+ * A minimal readahead algorithm for trivial sequential/random reads.
+ */
+static unsigned long
+ondemand_readahead(struct address_space *mapping,
+		   struct file_ra_state *ra, struct file *filp,
+		   struct page *page, pgoff_t offset,
+		   unsigned long req_size)
+{
+	unsigned long max;	/* max readahead pages */
+	pgoff_t ra_index;	/* readahead index */
+	unsigned long ra_size;	/* readahead size */
+	unsigned long la_size;	/* lookahead size */
+	int sequential;
+
+	max = ra->ra_pages;
+	sequential = (offset - ra->prev_index <= 1UL) || (req_size > max);
+
+	/*
+	 * Lookahead/readahead hit, assume sequential access.
+	 * Ramp up sizes, and push forward the readahead window.
+	 */
+	if (offset && (offset == ra->lookahead_index ||
+			offset == ra->readahead_index)) {
+		ra_index = ra->readahead_index;
+		ra_size = get_next_ra_size2(ra, max);
+		la_size = ra_size;
+		goto fill_ra;
+	}
+
+	/*
+	 * Standalone, small read.
+	 * Read as is, and do not pollute the readahead state.
+	 */
+	if (!page && !sequential) {
+		return __do_page_cache_readahead(mapping, filp,
+						offset, req_size, 0);
+	}
+
+	/*
+	 * It may be one of
+	 * 	- first read on start of file
+	 * 	- sequential cache miss
+	 * 	- oversize random read
+	 * Start readahead for it.
+	 */
+	ra_index = offset;
+	ra_size = get_init_ra_size(req_size, max);
+	la_size = ra_size > req_size ? ra_size - req_size : ra_size;
+
+	/*
+	 * Hit on a lookahead page without valid readahead state.
+	 * E.g. interleaved reads.
+	 * Not knowing its readahead pos/size, bet on the minimal possible one.
+	 */
+	if (page) {
+		ra_index++;
+		ra_size = min(4 * ra_size, max);
+	}
+
+fill_ra:
+	ra_set_index(ra, offset, ra_index);
+	ra_set_size(ra, ra_size, la_size);
+
+	return ra_submit(ra, mapping, filp);
+}
+
+/**
+ * page_cache_readahead_ondemand - generic file readahead
+ * @mapping: address_space which holds the pagecache and I/O vectors
+ * @ra: file_ra_state which holds the readahead state
+ * @filp: passed on to ->readpage() and ->readpages()
+ * @page: the page at @offset, or NULL if non-present
+ * @offset: start offset into @mapping, in PAGE_CACHE_SIZE units
+ * @req_size: hint: total size of the read which the caller is performing in
+ *            PAGE_CACHE_SIZE units
+ *
+ * page_cache_readahead_ondemand() is the entry point of readahead logic.
+ * This function should be called when it is time to perform readahead:
+ * 1) @page == NULL
+ *    A cache miss happened, time for synchronous readahead.
+ * 2) @page != NULL && PageReadahead(@page)
+ *    A look-ahead hit occured, time for asynchronous readahead.
+ */
+unsigned long
+page_cache_readahead_ondemand(struct address_space *mapping,
+				struct file_ra_state *ra, struct file *filp,
+				struct page *page, pgoff_t offset,
+				unsigned long req_size)
+{
+	/* no read-ahead */
+	if (!ra->ra_pages)
+		return 0;
+
+	if (page) {
+		ClearPageReadahead(page);
+
+		/*
+		 * Defer asynchronous read-ahead on IO congestion.
+		 */
+		if (bdi_read_congested(mapping->backing_dev_info))
+			return 0;
+	}
+
+	/* do read-ahead */
+	return ondemand_readahead(mapping, ra, filp, page,
+					offset, req_size);
+}
+EXPORT_SYMBOL_GPL(page_cache_readahead_ondemand);
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

origin.patch
