From: akpm@linux-foundation.org
Subject: +
 rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch added to -mm tree
Date: Tue, 12 May 2015 15:28:50 -0700
Message-ID: <55527ea2.AthLPsiS4Hx0qBck%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbbELW2v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 May 2015 18:28:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, kirill.shutemov@linux.intel.com, paulmck@linux.vnet.ibm.com, riel@redhat.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix
has been added to the -mm tree.  Its filename is
     rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/rmap.c~rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix mm/rmap.c
--- a/mm/rmap.c~rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix
+++ a/mm/rmap.c
@@ -950,6 +950,11 @@ void page_move_anon_rmap(struct page *pa
 	VM_BUG_ON_PAGE(page->index != linear_page_index(vma, address), page);
 
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
+	/*
+	 * Ensure that anon_vma and the PAGE_MAPPING_ANON bit are written
+	 * simultaneously, so a concurrent reader (eg shrink_active_list) will
+	 * not see one without the other.
+	 */
 	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch
gfp-add-__gfp_noaccount-v2-fix.patch
cma-page_isolation-check-buddy-before-access-it-fix.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch
linux-next-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

