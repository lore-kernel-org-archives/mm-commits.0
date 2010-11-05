From: akpm@linux-foundation.org
Subject: [merged] audit-do-not-send-uninitialized-data-for-audit_tty_get.patch removed from -mm tree
Date: Fri, 05 Nov 2010 11:29:03 -0700
Message-ID: <201011051830.oA5IUjlO025668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754705Ab0KESbE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Nov 2010 14:31:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, eparis@redhat.com, peterz@infradead.org, stable@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     audit: do not send uninitialized data for AUDIT_TTY_GET
has been removed from the -mm tree.  Its filename was
     audit-do-not-send-uninitialized-data-for-audit_tty_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit: do not send uninitialized data for AUDIT_TTY_GET
From: Thomas Gleixner <tglx@linutronix.de>

audit_receive_msg() sends uninitialized data for AUDIT_TTY_GET when the
task was not found.

Send reply only when task was found.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/audit.c~audit-do-not-send-uninitialized-data-for-audit_tty_get kernel/audit.c
--- a/kernel/audit.c~audit-do-not-send-uninitialized-data-for-audit_tty_get
+++ a/kernel/audit.c
@@ -884,8 +884,10 @@ static int audit_receive_msg(struct sk_b
 			spin_unlock_irq(&tsk->sighand->siglock);
 		}
 		read_unlock(&tasklist_lock);
-		audit_send_reply(NETLINK_CB(skb).pid, seq, AUDIT_TTY_GET, 0, 0,
-				 &s, sizeof(s));
+
+		if (!err)
+			audit_send_reply(NETLINK_CB(skb).pid, seq,
+					 AUDIT_TTY_GET, 0, 0, &s, sizeof(s));
 		break;
 	}
 	case AUDIT_TTY_SET: {
_

Patches currently in -mm which might be from tglx@linutronix.de are

hpet-factor-timer-allocate-from-open.patch
linux-next.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
add-the-common-dma_addr_t-typedef-to-include-linux-typesh.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

