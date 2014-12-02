From: akpm@linux-foundation.org
Subject: + mm-dont-split-thp-page-when-syscall-is-called-fix.patch added
 to -mm tree
Date: Mon, 01 Dec 2014 16:14:14 -0800
Message-ID: <547d0456.VD17Ct0ErdIaXKaD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbaLBAOP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2014 19:14:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pebolle@tiscali.nl, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: Fix comment typo "CONFIG_TRANSPARNTE_HUGE"
has been added to the -mm tree.  Its filename is
     mm-dont-split-thp-page-when-syscall-is-called-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-split-thp-page-when-syscall-is-called-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-split-thp-page-when-syscall-is-called-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Bolle <pebolle@tiscali.nl>
Subject: mm: Fix comment typo "CONFIG_TRANSPARNTE_HUGE"

The commit "mm: don't split THP page when syscall is called" added a
reference to CONFIG_TRANSPARNTE_HUGE in a comment.  Use
CONFIG_TRANSPARENT_HUGEPAGE instead, as was probably intended.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~mm-dont-split-thp-page-when-syscall-is-called-fix mm/rmap.c
--- a/mm/rmap.c~mm-dont-split-thp-page-when-syscall-is-called-fix
+++ a/mm/rmap.c
@@ -708,7 +708,7 @@ static int page_referenced_one(struct pa
 		/*
 		 * Use pmd_freeable instead of raw pmd_dirty because in some
 		 * of architecture, pmd_dirty is not defined unless
-		 * CONFIG_TRANSPARNTE_HUGE is enabled
+		 * CONFIG_TRANSPARENT_HUGEPAGE is enabled
 		 */
 		if (!pmd_freeable(*pmd))
 			dirty++;
_

Patches currently in -mm which might be from pebolle@tiscali.nl are

kernel-res_counter-remove-the-unused-api-fix.patch
kernel-res_counter-remove-the-unused-api-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
linux-next.patch

