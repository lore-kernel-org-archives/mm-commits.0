From: akpm@linux-foundation.org
Subject: + gru-update-gru-kernel-self-tests-fix.patch added to -mm tree
Date: Fri, 10 Apr 2009 17:24:08 -0700
Message-ID: <200904110024.n3B0O8Ru007687@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754132AbZDKAZL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 20:25:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru-update-gru-kernel-self-tests-fix
has been added to the -mm tree.  Its filename is
     gru-update-gru-kernel-self-tests-fix.patch

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
Subject: gru-update-gru-kernel-self-tests-fix
From: Jack Steiner <steiner@sgi.com>

Add fixes suggested by Andrew.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukservices.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/misc/sgi-gru/grukservices.c~gru-update-gru-kernel-self-tests-fix drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-update-gru-kernel-self-tests-fix
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -933,8 +933,7 @@ done:
 
 static int quicktest2(unsigned long arg)
 {
-	static struct completion cmp;
-	static int inited;
+	static DECLARE_COMPLETION(cmp);
 	unsigned long han;
 	int blade_id = 0;
 	int numcb = 4;
@@ -949,9 +948,6 @@ static int quicktest2(unsigned long arg)
 		return -ENOMEM;
 
 	ret = -EBUSY;
-	if (!inited)
-		init_completion(&cmp);
-	inited = 1;
 	han = gru_reserve_async_resources(blade_id, numcb, 0, &cmp);
 	if (!han)
 		goto done;
_

Patches currently in -mm which might be from steiner@sgi.com are

gru-bug-fixes-for-gru-exception-handling.patch
gru-dump-chiplet-state.patch
gru-dump-chiplet-state-update.patch
gru-dynamic-allocation-of-kernel-contexts.patch
gru-dynamic-allocation-of-kernel-contexts-update.patch
gru-change-context-load-and-unload.patch
gru-support-cch_allocate-for-kernel-threads.patch
gru-change-resource-assignment-for-kernel-threads.patch
gru-support-contexts-with-zero-dsrs-or-cbrs.patch
gru-fix-handling-of-mesq-failures.patch
gru-check-context-state-on-reload.patch
gru-support-instruction-completion-interrupts.patch
gru-support-for-asynchronous-gru-instructions.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
gru-update-gru-kernel-self-tests.patch
gru-update-gru-kernel-self-tests-fix.patch
gru-update-to-rev-09-of-gru-spec.patch

