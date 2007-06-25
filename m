From: akpm@linux-foundation.org
Subject: + fix-nmi_watchdog=2-bootup-hang-take-2.patch added to -mm tree
Date: Mon, 25 Jun 2007 12:01:25 -0700
Message-ID: <200706251901.l5PJ1PmU008465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343AbXFYTCi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 15:02:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: B.Steinbrink@gmx.de, andi@firstfloor.org, jeremy@goop.org, mingo@elte.hu, rusty@rustcorp.com.au


The patch titled
     fix nmi_watchdog=3D2 bootup hang
has been added to the -mm tree.  Its filename is
     fix-nmi_watchdog=3D2-bootup-hang-take-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: fix nmi_watchdog=3D2 bootup hang
=46rom: Bj=F6rn Steinbrink <B.Steinbrink@gmx.de>

wrmsrl() is broken, dropping the upper 32bits of the value to be
written. This broke the NMI watchdog on AMD hardware. (and it
probably broke other code too.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/paravirt.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-i386/paravirt.h~fix-nmi_watchdog=3D2-bootup-hang-=
take-2 include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~fix-nmi_watchdog=3D2-bootup-hang-take=
-2
+++ a/include/asm-i386/paravirt.h
@@ -542,7 +542,7 @@ static inline int paravirt_write_msr(uns
 	val =3D paravirt_read_msr(msr, &_err);	\
 } while(0)
=20
-#define wrmsrl(msr,val)		((void)paravirt_write_msr(msr, val, 0))
+#define wrmsrl(msr,val)		wrmsr(msr, (u32)((u64)(val)), ((u64)(val))>>3=
2)
 #define wrmsr_safe(msr,a,b)	paravirt_write_msr(msr, a, b)
=20
 /* rdmsr with exception handling */
_

Patches currently in -mm which might be from B.Steinbrink@gmx.de are

fix-nmi_watchdog=3D2-bootup-hang-take-2.patch
