From: akpm@linux-foundation.org
Subject: + mm-swapc-reorganize-put_compound_page-fix.patch added to -mm
 tree
Date: Tue, 19 Nov 2013 16:39:55 -0800
Message-ID: <528c04db.EVfuQUFCrUJ2RjGT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3KTAj4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 19:39:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, aarcange@redhat.com, akpm@linux-foundation.org

Subject: + mm-swapc-reorganize-put_compound_page-fix.patch added to -mm tree
To: akpm@linux-foundation.org,aarcange@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 16:39:55 -0800


The patch titled
     Subject: mm-swapc-reorganize-put_compound_page-fix
has been added to the -mm tree.  Its filename is
     mm-swapc-reorganize-put_compound_page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swapc-reorganize-put_compound_page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swapc-reorganize-put_compound_page-fix.patch

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
Subject: mm-swapc-reorganize-put_compound_page-fix

Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap.c~mm-swapc-reorganize-put_compound_page-fix mm/swap.c
--- a/mm/swap.c~mm-swapc-reorganize-put_compound_page-fix
+++ a/mm/swap.c
@@ -84,7 +84,7 @@ static void put_compound_page(struct pag
 {
 	struct page *page_head;
 
-	if (likely(PageTail(page))) {
+	if (likely(!PageTail(page))) {
 		if (put_page_testzero(page)) {
 			if (PageHead(page))
 				__put_compound_page(page);
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
mm-swapc-reorganize-put_compound_page.patch
mm-swapc-reorganize-put_compound_page-fix.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

