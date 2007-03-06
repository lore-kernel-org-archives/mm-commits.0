From: akpm@linux-foundation.org
Subject: - readahead-nfsd-case-fix-uninitialized-ra_min-ra_max.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:52:43 -0800
Message-ID: <200703060152.l261qhha008422@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46165 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933839AbXCFBw4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:52:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead nfsd case: fix uninitialized ra_min/ra_max
has been removed from the -mm tree.  Its filename was
     readahead-nfsd-case-fix-uninitialized-ra_min-ra_max.patch

This patch was dropped because it was folded into readahead-nfsd-case.patch

------------------------------------------------------
Subject: readahead nfsd case: fix uninitialized ra_min/ra_max
From: Fengguang Wu <wfg@mail.ustc.edu.cn>

ra_min/ra_max are not initialized, fix it.

New benchmark numbers on

	hda: ST3250820A, ATA DISK drive
	hda: max request size: 512KiB
	hda: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63, UDMA(100)

with nfs mount
	mount -o tcp,rsize=$((rsize<<10)) localhost:$EXPORT $MNT

   rsize      stock  adaptive
   ==================================
f
      8k       3.07    2.51    -18.2%
     32k       2.40    2.17     -9.6%
    128k       2.40    2.35     -2.1%
ff
      8k      12.44    6.40    -48.6%
     32k      14.62    5.46    -62.7%
    128k      15.79    5.19    -67.1%
d
      8k       2.84    2.48    -12.7%
     32k       2.53    1.99    -21.3%
    128k       2.18    2.00     -8.3%
dd
      8k       8.16    7.99     -2.1%
     32k       8.27    6.88    -16.8%
    128k       7.75    6.97    -10.1%

The 4 patterns tested are:
	 f: single file read
	ff: double file parallel read
	 d: single dir read
	dd: double dir parallel read

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 mm/readahead.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff -puN mm/readahead.c~readahead-nfsd-case-fix-uninitialized-ra_min-ra_max mm/readahead.c
--- a/mm/readahead.c~readahead-nfsd-case-fix-uninitialized-ra_min-ra_max
+++ a/mm/readahead.c
@@ -1607,6 +1607,10 @@ page_cache_readahead_adaptive(struct add
 	unsigned long ra_max;
 	int ret;
 
+	/* no read-ahead */
+	if (!ra->ra_pages)
+		return 0;
+
 	if (page) {
 		ClearPageReadahead(page);
 
@@ -1626,9 +1630,6 @@ page_cache_readahead_adaptive(struct add
 						offset + LAPTOP_POLL_INTERVAL);
 			return 0;
 		}
-	} else if (ra->flags & RA_FLAG_NFSD) { /* nfsd read */
-		ra_size = max_sane_readahead(req_size);
-		goto readit;
 	}
 
 	if (page)
@@ -1638,11 +1639,13 @@ page_cache_readahead_adaptive(struct add
 
 	ra_max = get_max_readahead(ra);
 
-	/* read-ahead disabled? */
-	if (unlikely(!ra_max || !readahead_ratio)) {
-		ra_size = max_sane_readahead(req_size);
+	/* read as is */
+	if (!readahead_ratio)
+		goto readit;
+
+	/* nfsd read */
+	if (!page && (ra->flags & RA_FLAG_NFSD))
 		goto readit;
-	}
 
 	/*
 	 * Start of file.
@@ -1689,11 +1692,11 @@ page_cache_readahead_adaptive(struct add
 		return 0;
 	}
 
+readit:
 	/*
 	 * Random read.
 	 */
 	ra_size = min(req_size, ra_max);
-readit:
 	ra_size = __do_page_cache_readahead(mapping, filp, offset, ra_size, 0);
 
 	ra_account(ra, RA_EVENT_RANDOM_READ, ra_size);
_

Patches currently in -mm which might be from wfg@mail.ustc.edu.cn are

readahead-kconfig-options.patch
radixtree-introduce-scan-hole-data-functions.patch
mm-introduce-probe_page.patch
mm-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-insert-cond_resched-calls.patch
readahead-minmax_ra_pages.patch
readahead-events-accounting.patch
readahead-rescue_pages.patch
readahead-sysctl-parameters.patch
readahead-min-max-sizes.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-routines.patch
readahead-state-based-method.patch
readahead-context-based-method.patch
readahead-initial-method-guiding-sizes.patch
readahead-initial-method-thrashing-guard-size.patch
readahead-initial-method-user-recommended-size.patch
readahead-initial-method.patch
readahead-backward-prefetching-method.patch
readahead-thrashing-recovery-method.patch
readahead-call-scheme.patch
readahead-laptop-mode.patch
readahead-loop-case.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix-uninitialized-ra_min-ra_max.patch
readahead-nfsd-case-remove-ra_min.patch
readahead-turn-on-by-default.patch
readahead-remove-size-limit-on-read_ahead_kb.patch
readahead-remove-size-limit-of-max_sectors_kb-on-read_ahead_kb.patch
readahead-partial-sendfile-fix.patch
