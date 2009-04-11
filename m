From: akpm@linux-foundation.org
Subject: + gru-dump-chiplet-state-update.patch added to -mm tree
Date: Fri, 10 Apr 2009 17:20:49 -0700
Message-ID: <200904110020.n3B0KnDP006306@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179AbZDKAWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Apr 2009 20:22:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru-dump-chiplet-state-update
has been added to the -mm tree.  Its filename is
     gru-dump-chiplet-state-update.patch

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

gru-bug-fixes-for-gru-exception-handling.patch
gru-dump-chiplet-state.patch
gru-dump-chiplet-state-update.patch
gru-dynamic-allocation-of-kernel-contexts.patch
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
gru-update-to-rev-09-of-gru-spec.patch

