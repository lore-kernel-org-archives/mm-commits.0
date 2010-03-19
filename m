From: akpm@linux-foundation.org
Subject: + kernel-user-remove-unreachable-code.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:53:25 -0700
Message-ID: <201003192353.o2JNrPR0019366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60083 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186Ab0CSXyK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:54:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jslaby@suse.cz, a.p.zijlstra@chello.nl, dhaval.giani@gmail.com, mingo@elte.hu


The patch titled
     kernel/user: remove unreachable code
has been added to the -mm tree.  Its filename is
     kernel-user-remove-unreachable-code.patch

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
kernel-user-remove-unreachable-code.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch
gpu-vga_switcheroo-fix-lock-imbalance.patch
dvb-usb-gp8psk-fix-potential-null-derefernce.patch

