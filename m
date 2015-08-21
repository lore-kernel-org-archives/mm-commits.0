From: akpm@linux-foundation.org
Subject: +
 ocfs2-remove-unneeded-code-in-dlm_register_domain_handlers.patch added to
 -mm tree
Date: Fri, 21 Aug 2015 13:59:21 -0700
Message-ID: <55d79129.w/uwk/bDPIrF5c9N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39937 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbbHUU7W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Aug 2015 16:59:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: remove unneeded code in dlm_register_domain_handlers
has been added to the -mm tree.  Its filename is
     ocfs2-remove-unneeded-code-in-dlm_register_domain_handlers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-remove-unneeded-code-in-dlm_register_domain_handlers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-remove-unneeded-code-in-dlm_register_domain_handlers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: remove unneeded code in dlm_register_domain_handlers

The last goto statement is unneeded, so remove it.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-unneeded-code-in-dlm_register_domain_handlers fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-remove-unneeded-code-in-dlm_register_domain_handlers
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -1846,8 +1846,6 @@ static int dlm_register_domain_handlers(
 					sizeof(struct dlm_exit_domain),
 					dlm_begin_exit_domain_handler,
 					dlm, NULL, &dlm->dlm_domain_handlers);
-	if (status)
-		goto bail;
 
 bail:
 	if (status)
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

ocfs2-fix-race-between-dio-and-recover-orphan.patch
ocfs2-fix-several-issues-of-append-dio.patch
ocfs2-do-not-bug-if-buffer-not-uptodate-in-__ocfs2_journal_access.patch
ocfs2-clean-up-unused-local-variables-in-ocfs2_file_write_iter.patch
ocfs2-adjust-code-to-match-locking-unlocking-order.patch
ocfs2-remove-unneeded-code-in-ocfs2_dlm_init.patch
ocfs2-fix-bug-when-o2hb_register_callback-fails.patch
ocfs2-remove-unneeded-code-in-dlm_register_domain_handlers.patch
ocfs2-fix-race-between-crashed-dio-and-rm.patch

