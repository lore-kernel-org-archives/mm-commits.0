From: akpm@linux-foundation.org
Subject: + mm-soft_offline-improve-hugepage-soft-offlining-error-log.patch added to -mm tree
Date: Mon, 16 Oct 2017 15:48:47 -0700
Message-ID: <59e5374f.J97JOZrvQ0JwpDXR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45826 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753432AbdJPWss (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 18:48:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laszlth@gmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, soft_offline: improve hugepage soft offlining error log
has been added to the -mm tree.  Its filename is
     mm-soft_offline-improve-hugepage-soft-offlining-error-log.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-soft_offline-improve-hugepage-soft-offlining-error-log.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-soft_offline-improve-hugepage-soft-offlining-error-log.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laszlo Toth <laszlth@gmail.com>
Subject: mm, soft_offline: improve hugepage soft offlining error log

On a failed attempt, we get the following entry: soft offline: 0x3c0000:
migration failed 1, type 17ffffc0008008 (uptodate|head)

Make this more specific to be straightforward and to follow other error
log formats in soft_offline_huge_page().

Link: http://lkml.kernel.org/r/20171016171757.GA3018@ubuntu-desk-vm
Signed-off-by: Laszlo Toth <laszlth@gmail.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-soft_offline-improve-hugepage-soft-offlining-error-log mm/memory-failure.c
--- a/mm/memory-failure.c~mm-soft_offline-improve-hugepage-soft-offlining-error-log
+++ a/mm/memory-failure.c
@@ -1587,7 +1587,7 @@ static int soft_offline_huge_page(struct
 	ret = migrate_pages(&pagelist, new_page, NULL, MPOL_MF_MOVE_ALL,
 				MIGRATE_SYNC, MR_MEMORY_FAILURE);
 	if (ret) {
-		pr_info("soft offline: %#lx: migration failed %d, type %lx (%pGp)\n",
+		pr_info("soft offline: %#lx: hugepage migration failed %d, type %lx (%pGp)\n",
 			pfn, ret, page->flags, &page->flags);
 		if (!list_empty(&pagelist))
 			putback_movable_pages(&pagelist);
_

Patches currently in -mm which might be from laszlth@gmail.com are

mm-soft_offline-improve-hugepage-soft-offlining-error-log.patch

