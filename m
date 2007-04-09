From: akpm@linux-foundation.org
Subject: + allow-vmsplice-to-work-in-32-bit-mode-on-ppc64.patch added to -mm tree
Date: Mon, 09 Apr 2007 16:42:51 -0700
Message-ID: <200704092342.l39Ngp1R026549@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35955 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661AbXDIXnM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 19:43:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dzickus@redhat.com, benh@kernel.crashing.org, paulus@samba.org, sfr@canb.auug.org.au


The patch titled
     allow vmsplice to work in 32-bit mode on ppc64
has been added to the -mm tree.  Its filename is
     allow-vmsplice-to-work-in-32-bit-mode-on-ppc64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: allow vmsplice to work in 32-bit mode on ppc64
From: Don Zickus <dzickus@redhat.com>

Trivial change to pass vmsplice arguments through the compat layer on
pp64.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-powerpc/systbl.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

allow-vmsplice-to-work-in-32-bit-mode-on-ppc64.patch
