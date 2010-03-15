From: akpm@linux-foundation.org
Subject: [merged] copy_signal-cleanup-clean-tty_audit_fork.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:01:28 -0400
Message-ID: <201003150702.o2F721rh016831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935852Ab0COHCO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:02:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vfalico@redhat.com, oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     copy_signal() cleanup: clean tty_audit_fork()
has been removed from the -mm tree.  Its filename was
     copy_signal-cleanup-clean-tty_audit_fork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: copy_signal() cleanup: clean tty_audit_fork()
From: Veaceslav Falico <vfalico@redhat.com>

Remove unneeded initialization in tty_audit_fork().  It is called only via
copy_signal() and is useless after the kmem_cache_zalloc() was used.

Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_audit.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/tty_audit.c~copy_signal-cleanup-clean-tty_audit_fork drivers/char/tty_audit.c
--- a/drivers/char/tty_audit.c~copy_signal-cleanup-clean-tty_audit_fork
+++ a/drivers/char/tty_audit.c
@@ -148,7 +148,6 @@ void tty_audit_fork(struct signal_struct
 	spin_lock_irq(&current->sighand->siglock);
 	sig->audit_tty = current->signal->audit_tty;
 	spin_unlock_irq(&current->sighand->siglock);
-	sig->tty_audit_buf = NULL;
 }
 
 /**
_

Patches currently in -mm which might be from vfalico@redhat.com are

origin.patch

