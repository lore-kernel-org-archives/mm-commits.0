From: akpm@linux-foundation.org
Subject: + i386-fix-the-k7-nmi-watchdog-checkbit.patch added to -mm tree
Date: Fri, 20 Jul 2007 17:23:45 -0700
Message-ID: <200707210023.l6L0NjD1024083@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbXGUAYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 20:24:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: B.Steinbrink@gmx.de, andi@firstfloor.org, dzickus@redhat.com, eranian@hpl.hp.com


The patch titled
     i386: Fix the K7 NMI watchdog checkbit
has been added to the -mm tree.  Its filename is
     i386-fix-the-k7-nmi-watchdog-checkbit.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: i386: Fix the K7 NMI watchdog checkbit
=46rom: Bj=F6rn Steinbrink <B.Steinbrink@gmx.de>

The performance counters on K7 are only 48 bits wide, so using bit 63 t=
o
check if the counter overflowed is wrong.  Let's use bit 47 instead.

Signed-off-by: Bj=F6rn Steinbrink <B.Steinbrink@gmx.de>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Stephane Eranian <eranian@hpl.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/perfctr-watchdog.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/perfctr-watchdog.c~i386-fix-the-k7-nmi-w=
atchdog-checkbit arch/i386/kernel/cpu/perfctr-watchdog.c
--- a/arch/i386/kernel/cpu/perfctr-watchdog.c~i386-fix-the-k7-nmi-watch=
dog-checkbit
+++ a/arch/i386/kernel/cpu/perfctr-watchdog.c
@@ -325,7 +325,7 @@ static struct wd_ops k7_wd_ops =3D {
 	.stop =3D single_msr_stop_watchdog,
 	.perfctr =3D MSR_K7_PERFCTR0,
 	.evntsel =3D MSR_K7_EVNTSEL0,
-	.checkbit =3D 1ULL<<63,
+	.checkbit =3D 1ULL<<47,
 };
=20
 /* Intel Model 6 (PPro+,P2,P3,P-M,Core1) */
_

Patches currently in -mm which might be from B.Steinbrink@gmx.de are

origin.patch
i386-fix-the-k7-nmi-watchdog-checkbit.patch
