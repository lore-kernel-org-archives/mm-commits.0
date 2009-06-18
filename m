From: akpm@linux-foundation.org
Subject: [merged] ptrace-remove-pt_dtrace-from-arch-h8300.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:18 -0700
Message-ID: <200906182246.n5IMkIsJ005330@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757252AbZFRW6M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     ptrace: remove PT_DTRACE from arch/h8300
has been removed from the -mm tree.  Its filename was
     ptrace-remove-pt_dtrace-from-arch-h8300.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: remove PT_DTRACE from arch/h8300
From: Oleg Nesterov <oleg@redhat.com>

h8300 defines PT_DTRACE for asm but never uses it.

DEFINE(PT_PTRACED, PT_PTRACED) seems to be unused too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/asm-offsets.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/h8300/kernel/asm-offsets.c~ptrace-remove-pt_dtrace-from-arch-h8300 arch/h8300/kernel/asm-offsets.c
--- a/arch/h8300/kernel/asm-offsets.c~ptrace-remove-pt_dtrace-from-arch-h8300
+++ a/arch/h8300/kernel/asm-offsets.c
@@ -55,7 +55,6 @@ int main(void)
 	DEFINE(LRET,  offsetof(struct pt_regs, pc)       - sizeof(long));
 
 	DEFINE(PT_PTRACED, PT_PTRACED);
-	DEFINE(PT_DTRACE, PT_DTRACE);
 
 	return 0;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

