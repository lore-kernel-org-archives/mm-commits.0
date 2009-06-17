From: akpm@linux-foundation.org
Subject: [folded] gru-dump-chiplet-state-update.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:56:42 -0700
Message-ID: <200906172256.n5HMug3F016099@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50047 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757054AbZFQW5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru-dump-chiplet-state-update
has been removed from the -mm tree.  Its filename was
     gru-dump-chiplet-state-update.patch

This patch was dropped because it was folded into gru-dump-chiplet-state.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru-dump-chiplet-state-update
From: Jack Steiner <steiner@sgi.com>

Updated per comments received from Andrew

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukdump.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grukdump.c~gru-dump-chiplet-state-update drivers/misc/sgi-gru/grukdump.c
--- a/drivers/misc/sgi-gru/grukdump.c~gru-dump-chiplet-state-update
+++ a/drivers/misc/sgi-gru/grukdump.c
@@ -15,6 +15,7 @@
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
 #include <linux/delay.h>
+#include <linux/bitops.h>
 #include <asm/uv/uv_hub.h>
 #include "gru.h"
 #include "grutables.h"
@@ -25,7 +26,7 @@
 
 static int gru_user_copy_handle(void __user **dp, void *s)
 {
-	if (copy_to_user(*(void __user **)dp, s, GRU_HANDLE_BYTES))
+	if (copy_to_user(dp, s, GRU_HANDLE_BYTES))
 		return -1;
 	*dp += GRU_HANDLE_BYTES;
 	return 0;
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch
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

