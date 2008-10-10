From: akpm@linux-foundation.org
Subject: + vmscan-split-lru-lists-into-anon-file-sets-adjust-hugepage-related-field-of-proc-meminfo.patch added to -mm tree
Date: Fri, 10 Oct 2008 12:56:18 -0700
Message-ID: <200810101956.m9AJuIDL028540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758490AbYJJT4z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Oct 2008 15:56:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, lee.schermerhorn@hp.com, riel@redhat.com


The patch titled
     adjust hugepage related field of /proc/meminfo
has been added to the -mm tree.  Its filename is
     vmscan-split-lru-lists-into-anon-file-sets-adjust-hugepage-related-field-of-proc-meminfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adjust hugepage related field of /proc/meminfo
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

adjust hugepage related field in /proc/meminfo.
(because vmscan-split-lru-lists-into-anon-file-sets.patch changed
length of other field)

before:

CommitLimit:     6028800 kB
Committed_AS:    8685888 kB
VmallocTotal:   17592177655808 kB
VmallocUsed:       28544 kB
VmallocChunk:   17592177626816 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:    262144 kB

after:

CommitLimit:     6028800 kB
Committed_AS:    8685888 kB
VmallocTotal:   17592177655808 kB
VmallocUsed:       28544 kB
VmallocChunk:   17592177626816 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:     262144 kB

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~vmscan-split-lru-lists-into-anon-file-sets-adjust-hugepage-related-field-of-proc-meminfo mm/hugetlb.c
--- a/mm/hugetlb.c~vmscan-split-lru-lists-into-anon-file-sets-adjust-hugepage-related-field-of-proc-meminfo
+++ a/mm/hugetlb.c
@@ -1459,11 +1459,11 @@ int hugetlb_report_meminfo(char *buf)
 {
 	struct hstate *h = &default_hstate;
 	return sprintf(buf,
-			"HugePages_Total: %5lu\n"
-			"HugePages_Free:  %5lu\n"
-			"HugePages_Rsvd:  %5lu\n"
-			"HugePages_Surp:  %5lu\n"
-			"Hugepagesize:    %5lu kB\n",
+			"HugePages_Total:   %5lu\n"
+			"HugePages_Free:    %5lu\n"
+			"HugePages_Rsvd:    %5lu\n"
+			"HugePages_Surp:    %5lu\n"
+			"Hugepagesize:   %8lu kB\n",
 			h->nr_huge_pages,
 			h->free_huge_pages,
 			h->resv_huge_pages,
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

git-tip.patch
mm-do_generic_file_read-never-gets-a-null-filp-argument.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-split-lru-lists-into-anon-file-sets-adjust-quicklists-field-of-proc-meminfo.patch
vmscan-split-lru-lists-into-anon-file-sets-adjust-hugepage-related-field-of-proc-meminfo.patch
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
mlock-mlocked-pages-are-unevictable-fix.patch
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
add-config_core_dump_default_elf_headers.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

