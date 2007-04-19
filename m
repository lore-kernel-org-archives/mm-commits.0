From: akpm@linux-foundation.org
Subject: - allow-vmsplice-to-work-in-32-bit-mode-on-ppc64.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:01:34 -0700
Message-ID: <200704192001.l3JK1Y1M029306@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766981AbXDSUBz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:01:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dzickus@redhat.com, benh@kernel.crashing.org, paulus@samba.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     allow vmsplice to work in 32-bit mode on ppc64
has been removed from the -mm tree.  Its filename was
     allow-vmsplice-to-work-in-32-bit-mode-on-ppc64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: allow vmsplice to work in 32-bit mode on ppc64
From: Don Zickus <dzickus@redhat.com>

Trivial change to pass vmsplice arguments through the compat layer on
pp64.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/systbl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-powerpc/systbl.h~allow-vmsplice-to-work-in-32-bit-mode-on-ppc64 include/asm-powerpc/systbl.h
--- a/include/asm-powerpc/systbl.h~allow-vmsplice-to-work-in-32-bit-mode-on-ppc64
+++ a/include/asm-powerpc/systbl.h
@@ -288,7 +288,7 @@ COMPAT_SYS(ppoll)
 SYSCALL_SPU(unshare)
 SYSCALL_SPU(splice)
 SYSCALL_SPU(tee)
-SYSCALL_SPU(vmsplice)
+COMPAT_SYS_SPU(vmsplice)
 COMPAT_SYS_SPU(openat)
 SYSCALL_SPU(mkdirat)
 SYSCALL_SPU(mknodat)
_

Patches currently in -mm which might be from dzickus@redhat.com are

origin.patch
