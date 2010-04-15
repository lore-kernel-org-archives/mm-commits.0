From: akpm@linux-foundation.org
Subject: [merged] kernel-user-remove-unreachable-code.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:39:06 -0400
Message-ID: <201004151840.o3FIeimV024448@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755843Ab0DOSl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:41:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, a.p.zijlstra@chello.nl, dhaval.giani@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kernel/user: remove unreachable code
has been removed from the -mm tree.  Its filename was
     kernel-user-remove-unreachable-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/user: remove unreachable code
From: Jiri Slaby <jslaby@suse.cz>

The code which executed this code was removed in 7c9414385ebfdd87cc542
(sched: Remove USER_SCHED).  Remove the dangling code too.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/user.c~kernel-user-remove-unreachable-code kernel/user.c
--- a/kernel/user.c~kernel-user-remove-unreachable-code
+++ a/kernel/user.c
@@ -178,8 +178,6 @@ struct user_struct *alloc_uid(struct use
 
 	return up;
 
-	put_user_ns(new->user_ns);
-	kmem_cache_free(uid_cachep, new);
 out_unlock:
 	return NULL;
 }
_

Patches currently in -mm which might be from jslaby@suse.cz are

origin.patch
linux-next.patch
gpu-vga_switcheroo-fix-lock-imbalance.patch
dvb-usb-gp8psk-fix-potential-null-derefernce.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

