From: akpm@linux-foundation.org
Subject: [folded] gru-update-gru-kernel-self-tests-fix.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:57:45 -0700
Message-ID: <200906172257.n5HMvkIZ017199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757444AbZFQW6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:58:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru-update-gru-kernel-self-tests-fix
has been removed from the -mm tree.  Its filename was
     gru-update-gru-kernel-self-tests-fix.patch

This patch was dropped because it was folded into gru-update-gru-kernel-self-tests.patch

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

origin.patch
gru-bug-fixes-for-gru-exception-handling.patch
gru-dump-chiplet-state.patch
gru-dynamic-allocation-of-kernel-contexts.patch
gru-change-context-load-and-unload.patch
gru-support-cch_allocate-for-kernel-threads.patch
gru-change-resource-assignment-for-kernel-threads.patch
gru-support-contexts-with-zero-dsrs-or-cbrs.patch
gru-fix-handling-of-mesq-failures.patch
gru-check-context-state-on-reload.patch
gru-support-instruction-completion-interrupts.patch
gru-support-for-asynchronous-gru-instructions.patch
gru-update-gru-kernel-self-tests.patch
gru-update-gru-kernel-self-tests-fix.patch
gru-update-to-rev-09-of-gru-spec.patch
gru-fix-cache-coherency-issues-with-instruction-retry.patch
gru-add-user-request-to-explicitly-unload-a-gru-context.patch
gru-fix-automatic-retry-of-gru-instruction-failures.patch
gru-collect-per-context-user-statistics.patch
gru-delete-user-request-for-fetching-chiplet-status.patch
gru-cleanup-gru-inline-functions.patch
gru-generic-infrastructure-for-context-options.patch
gru-add-user-request-to-specify-gru-slice.patch
gru-fix-potential-use-after-free-when-purging-gru-tlbs.patch
gru-fixes-to-grudump-utility.patch
gru-remove-references-to-the-obsolete-global-status-handle.patch
gru-copyright-fixes.patch

