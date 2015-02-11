From: akpm@linux-foundation.org
Subject: [merged] ocfs2-dlm-dlmdomain-remove-unused-function.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:21:10 -0800
Message-ID: <54dbb9b6.v+CWKVMNSTKmCG4S%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbBKUVL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rickard_strandqvist@spectrumdigital.se, jlbec@evilplan.org, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: dlm: dlmdomain: remove unused function
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-dlmdomain-remove-unused-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
