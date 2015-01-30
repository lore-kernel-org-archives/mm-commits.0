From: akpm@linux-foundation.org
Subject: + mincore-apply-page-table-walker-on-do_mincore-fix-fix.patch
 added to -mm tree
Date: Fri, 30 Jan 2015 15:12:29 -0800
Message-ID: <54cc0fdd.M741Ctwy1s0Slcx9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758201AbbA3XMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jan 2015 18:12:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daeseok.youn@gmail.com, hannes@cmpxchg.org, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mincore: remove unneeded variable 'err'
has been added to the -mm tree.  Its filename is
     mincore-apply-page-table-walker-on-do_mincore-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mincore-apply-page-table-walker-on-do_mincore-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mincore-apply-page-table-walker-on-do_mincore-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: mincore: remove unneeded variable 'err'

mincore_hugetlb() returns always '0'

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/mincore.c~mincore-apply-page-table-walker-on-do_mincore-fix-fix mm/mincore.c
--- a/mm/mincore.c~mincore-apply-page-table-walker-on-do_mincore-fix-fix
+++ a/mm/mincore.c
@@ -22,7 +22,6 @@
 static int mincore_hugetlb(pte_t *pte, unsigned long hmask, unsigned long addr,
 			unsigned long end, struct mm_walk *walk)
 {
-	int err = 0;
 #ifdef CONFIG_HUGETLB_PAGE
 	unsigned char present;
 	unsigned char *vec = walk->private;
@@ -38,7 +37,7 @@ static int mincore_hugetlb(pte_t *pte, u
 #else
 	BUG();
 #endif
-	return err;
+	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

ocfs2-remove-unreachable-code.patch
ocfs2-removes-mlog_errno-call-twice-in-ocfs2_find_dir_space_el.patch
ocfs2-remove-unreachable-code-in-__ocfs2_recovery_thread.patch
mincore-apply-page-table-walker-on-do_mincore-fix-fix.patch
linux-next.patch

