From: akpm@linux-foundation.org
Subject: + mm-vmscan-fix-mapping-use-after-free.patch added to -mm tree
Date: Mon, 14 Jun 2010 23:22:46 -0700
Message-ID: <201006150622.o5F6Mdq2021756@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916Ab0FOGWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jun 2010 02:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de


The patch titled
     mm/vmscan.c: fix mapping use after free
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-mapping-use-after-free.patch

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
Subject: mm/vmscan.c: fix mapping use after free
From: Nick Piggin <npiggin@suse.de>

We need lock_page_nosync() here because we have no reference to the
mapping when taking the page lock.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-fix-mapping-use-after-free mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-fix-mapping-use-after-free
+++ a/mm/vmscan.c
@@ -296,7 +296,7 @@ static int may_write_to_queue(struct bac
 static void handle_write_error(struct address_space *mapping,
 				struct page *page, int error)
 {
-	lock_page(page);
+	lock_page_nosync(page);
 	if (page_mapping(page) == mapping)
 		mapping_set_error(mapping, error);
 	unlock_page(page);
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
avr32-invoke-oom-killer-from-page-fault.patch
mm-vmscan-fix-mapping-use-after-free.patch
fs-move-code-out-of-bufferc.patch
mm-vmap-area-cache.patch
mm-vmap-area-cache-fix.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-remove-special-handling-for-pagefault-ooms.patch
reiser4.patch

