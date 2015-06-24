From: akpm@linux-foundation.org
Subject: [folded-merged]
 rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch removed from -mm tree
Date: Wed, 24 Jun 2015 16:46:56 -0700
Message-ID: <558b4170.dmqK9w9xF4LHSqSJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbbFXXq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:46:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, kirill.shutemov@linux.intel.com, paulmck@linux.vnet.ibm.com, riel@redhat.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix
has been removed from the -mm tree.  Its filename was
     rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch

This patch was dropped because it was folded into rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix

tweak comment, per Minchan

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/rmap.c~rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix mm/rmap.c
--- a/mm/rmap.c~rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix
+++ a/mm/rmap.c
@@ -952,8 +952,8 @@ void page_move_anon_rmap(struct page *pa
 	anon_vma = (void *) anon_vma + PAGE_MAPPING_ANON;
 	/*
 	 * Ensure that anon_vma and the PAGE_MAPPING_ANON bit are written
-	 * simultaneously, so a concurrent reader (eg shrink_active_list) will
-	 * not see one without the other.
+	 * simultaneously, so a concurrent reader (eg page_referenced()'s
+	 * PageAnon()) will not see one without the other.
 	 */
 	WRITE_ONCE(page->mapping, (struct address_space *) anon_vma);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas.patch
mm-new-mm-hook-framework.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch

