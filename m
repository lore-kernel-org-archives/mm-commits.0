From: akpm@linux-foundation.org
Subject: + ocfs2-dlm-dlmdomain-remove-unused-function.patch added to -mm
 tree
Date: Mon, 12 Jan 2015 16:26:07 -0800
Message-ID: <54b4661f.CdKtfijhArSBIE5x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37613 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbbAMA0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 19:26:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rickard_strandqvist@spectrumdigital.se, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: dlm: dlmdomain: remove unused function
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-dlmdomain-remove-unused-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-dlmdomain-remove-unused-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-dlmdomain-remove-unused-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: ocfs2: dlm: dlmdomain: remove unused function

Remove dlm_joined() that is not used anywhere.

This was partially found by using a static code analysis program called
cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmdomain.c |   14 --------------
 fs/ocfs2/dlm/dlmdomain.h |    1 -
 2 files changed, 15 deletions(-)

diff -puN fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-dlmdomain-remove-unused-function fs/ocfs2/dlm/dlmdomain.c
--- a/fs/ocfs2/dlm/dlmdomain.c~ocfs2-dlm-dlmdomain-remove-unused-function
+++ a/fs/ocfs2/dlm/dlmdomain.c
@@ -674,20 +674,6 @@ static void dlm_leave_domain(struct dlm_
 	spin_unlock(&dlm->spinlock);
 }
 
-int dlm_joined(struct dlm_ctxt *dlm)
-{
-	int ret = 0;
-
-	spin_lock(&dlm_domain_lock);
-
-	if (dlm->dlm_state == DLM_CTXT_JOINED)
-		ret = 1;
-
-	spin_unlock(&dlm_domain_lock);
-
-	return ret;
-}
