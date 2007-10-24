From: akpm@linux-foundation.org
Subject: + lguest-build-fix.patch added to -mm tree
Date: Wed, 24 Oct 2007 16:33:50 -0700
Message-ID: <200710242333.l9ONXoVB018178@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52990 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754801AbXJXXeJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 19:34:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, jgarzik@redhat.com, rusty@rustcorp.com.au


The patch titled
     lguest: build fix
has been added to the -mm tree.  Its filename is
     lguest-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: lguest: build fix
=46rom: Jeff Garzik <jeff@garzik.org>

=46ix this error (i386 !SMP build)

arch/x86/lguest/boot.c: In function =E2=80=98lguest_init=E2=80=99:
arch/x86/lguest/boot.c:1059: error: =E2=80=98pm_power_off=E2=80=99 unde=
clared (first use in this function)

by including linux/pm.h.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/lguest/boot.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/lguest/boot.c~lguest-build-fix arch/x86/lguest/boot.=
c
--- a/arch/x86/lguest/boot.c~lguest-build-fix
+++ a/arch/x86/lguest/boot.c
@@ -56,6 +56,7 @@
 #include <linux/lguest.h>
 #include <linux/lguest_launcher.h>
 #include <linux/virtio_console.h>
+#include <linux/pm.h>
 #include <asm/paravirt.h>
 #include <asm/param.h>
 #include <asm/page.h>
_

Patches currently in -mm which might be from jeff@garzik.org are

lguest-build-fix.patch
acpi-sbs-fix-retval-warning.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
scsi-expose-an-support-to-user-space.patch
libata-expose-an-to-user-space.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.=
patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196c=
c0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
scsi-use-notifier-chain-for-asynchronous-event.patch
git-wireless.patch
mac80211-fix-warning-created-by-bit.patch
x86-fix-config_smp-warning-in-processorc.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
isdn-sc-fix-longstanding-warning.patch
