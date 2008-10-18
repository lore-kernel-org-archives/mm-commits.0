From: akpm@linux-foundation.org
Subject: - vmscan-split-lru-lists-into-anon-file-sets-adjust-quicklists-field-of-proc-meminfo.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:32:01 -0700
Message-ID: <200810182332.m9INW17G031416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbYJRXcW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:32:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ] adjust Quicklists field of /proc/meminfo
has been removed from the -mm tree.  Its filename was
     vmscan-split-lru-lists-into-anon-file-sets-adjust-quicklists-field-of-proc-meminfo.patch

This patch was dropped because it was folded into vmscan-split-lru-lists-into-anon-file-sets.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ] adjust Quicklists field of /proc/meminfo
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

vmscan-split-lru-lists-into-anon-file-sets.patch changed /proc/meminfo output length,
but only Quicklists: field doesn't.
(because quicklists field added after than split-lru)

example:

$ cat /proc/meminfo

  MemTotal:        7994624 kB
  MemFree:           21376 kB
(snip)
  SUnreclaim:        78912 kB
  PageTables:      1233472 kB
  Quicklists:       7808 kB
  NFS_Unstable:          0 kB

this patch fix it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_misc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/proc_misc.c~vmscan-split-lru-lists-into-anon-file-sets-adjust-quicklists-field-of-proc-meminfo fs/proc/proc_misc.c
--- a/fs/proc/proc_misc.c~vmscan-split-lru-lists-into-anon-file-sets-adjust-quicklists-field-of-proc-meminfo
+++ a/fs/proc/proc_misc.c
@@ -194,7 +194,7 @@ static int meminfo_read_proc(char *page,
 		"SUnreclaim:     %8lu kB\n"
 		"PageTables:     %8lu kB\n"
 #ifdef CONFIG_QUICKLIST
-		"Quicklists:   %8lu kB\n"
+		"Quicklists:     %8lu kB\n"
 #endif
 		"NFS_Unstable:   %8lu kB\n"
 		"Bounce:         %8lu kB\n"
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-split-lru-lists-into-anon-file-sets-adjust-quicklists-field-of-proc-meminfo.patch
vmscan-split-lru-lists-into-anon-file-sets-adjust-hugepage-related-field-of-proc-meminfo.patch
vmscan-split-lru-lists-into-anon-file-sets-fix-style-issue-of-get_scan_ratio.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-nommu-fix.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mlock-mlocked-pages-are-unevictable.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-__mlock_vma_pages_range-comment-block.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscam-kill-unused-lru-functions.patch
mlock-revert-mainline-handling-of-mlock-error-return.patch
mlock-make-mlock-error-return-posixly-correct.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-unlockless-reclaim.patch
coredump_filter-add-hugepage-dumping-v4.patch
hugepage-support-zero_page.patch
documentation-clarify-dirty_ratio-and-dirty_background_ratio-description-v2.patch
add-config_core_dump_default_elf_headers.patch
make-mm-rmapc-anon_vma_cachep-static.patch

