From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch removed from -mm tree
Date: Wed, 20 Nov 2013 13:24:24 -0800
Message-ID: <528d2888.92s+ij84BBkYv6Jx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3KTVYZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Nov 2013 16:24:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, pshelar@nicira.com, minchan@kernel.org, mgorman@suse.de, khalid.aziz@oracle.com, jweiner@redhat.com, gregkh@linuxfoundation.org, cl@linux.com, bhutchings@solarflare.com, andi@firstfloor.org, aarcange@redhat.com, akpm@linux-foundation.org

Subject: [to-be-updated] mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch removed from -mm tree
To: akpm@linux-foundation.org,aarcange@redhat.com,andi@firstfloor.org,bhutchings@solarflare.com,cl@linux.com,gregkh@linuxfoundation.org,jweiner@redhat.com,khalid.aziz@oracle.com,mgorman@suse.de,minchan@kernel.org,pshelar@nicira.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 20 Nov 2013 13:24:24 -0800


The patch titled
     Subject: mm/hugetlb.c: simplify PageHeadHuge() and PageHuge()
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hugetlb.c: simplify PageHeadHuge() and PageHuge()

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pravin Shelar <pshelar@nicira.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-simplify-pageheadhuge-and-pagehuge mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-simplify-pageheadhuge-and-pagehuge
+++ a/mm/hugetlb.c
@@ -690,15 +690,11 @@ static void prep_compound_gigantic_page(
  */
 int PageHuge(struct page *page)
 {
-	compound_page_dtor *dtor;
-
 	if (!PageCompound(page))
 		return 0;
 
 	page = compound_head(page);
-	dtor = get_compound_page_dtor(page);
-
-	return dtor == free_huge_page;
+	return get_compound_page_dtor(page) == free_huge_page;
 }
 EXPORT_SYMBOL_GPL(PageHuge);
 
@@ -708,14 +704,10 @@ EXPORT_SYMBOL_GPL(PageHuge);
  */
 int PageHeadHuge(struct page *page_head)
 {
-	compound_page_dtor *dtor;
-
 	if (!PageHead(page_head))
 		return 0;
 
-	dtor = get_compound_page_dtor(page_head);
-
-	return dtor == free_huge_page;
+	return get_compound_page_dtor(page_head) == free_huge_page;
 }
 EXPORT_SYMBOL_GPL(PageHeadHuge);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-thp-give-transparent-hugepage-code-a-separate-copy_page-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

