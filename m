From: akpm@linux-foundation.org
Subject: [merged] kernel-sysc-fix-compat-uname-machine.patch removed from -mm tree
Date: Mon, 26 Apr 2010 10:26:05 -0400
Message-ID: <201004261727.o3QHRdUY009048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431Ab0DZR2I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Apr 2010 13:28:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwab@linux-m68k.org, davem@davemloft.net, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     kernel/sys.c: fix compat uname machine
has been removed from the -mm tree.  Its filename was
     kernel-sysc-fix-compat-uname-machine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/sys.c: fix compat uname machine
From: Andreas Schwab <schwab@linux-m68k.org>

On ppc64 you get this error:

$ setarch ppc -R true
setarch: ppc: Unrecognized architecture

because uname still reports ppc64 as the machine.

So mask off the personality flags when checking for PER_LINUX32.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~kernel-sysc-fix-compat-uname-machine kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-fix-compat-uname-machine
+++ a/kernel/sys.c
@@ -1118,7 +1118,7 @@ DECLARE_RWSEM(uts_sem);
 
 #ifdef COMPAT_UTS_MACHINE
 #define override_architecture(name) \
-	(current->personality == PER_LINUX32 && \
+	(personality(current->personality) == PER_LINUX32 && \
 	 copy_to_user(name->machine, COMPAT_UTS_MACHINE, \
 		      sizeof(COMPAT_UTS_MACHINE)))
 #else
_

Patches currently in -mm which might be from schwab@linux-m68k.org are

origin.patch
vfs-o_-bit-numbers-uniqueness-check.patch
improve-sys_personality-for-compat-architectures.patch

