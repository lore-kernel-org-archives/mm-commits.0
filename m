From: akpm@linux-foundation.org
Subject: + um-reinstate-kernel-version-in-generated-config.patch added to -mm tree
Date: Tue, 28 Jun 2011 15:56:20 -0700
Message-ID: <201106282256.p5SMuKMF012530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814Ab1F1W4a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Jun 2011 18:56:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, richard@nod.at


The patch titled
     um: reinstate kernel version in generated .config
has been added to the -mm tree.  Its filename is
     um-reinstate-kernel-version-in-generated-config.patch

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
Subject: um: reinstate kernel version in generated .config
From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 0954828fcbf3bd13d593499b16b901a4e801b0b9 ("kconfig: replace
KERNELVERSION usage by the mainmenu's prompt") made the kernel version
disappear from the generated .config file when configuring for UML.  As
UML's Kconfig doesn't have a mainmenu, kconfig falls back to the default
string "Linux Kernel Configuration".

Add a suitable mainmenu to the main UML Kconfig file to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig.x86 |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/um/Kconfig.x86~um-reinstate-kernel-version-in-generated-config arch/um/Kconfig.x86
--- a/arch/um/Kconfig.x86~um-reinstate-kernel-version-in-generated-config
+++ a/arch/um/Kconfig.x86
@@ -1,3 +1,5 @@
+mainmenu "User Mode Linux/$SUBARCH $KERNELVERSION Kernel Configuration"
+
 source "arch/um/Kconfig.common"
 
 menu "UML-specific options"
_

Patches currently in -mm which might be from geert@linux-m68k.org are

mm-nommuc-fix-remap_pfn_range.patch
linux-next.patch
cris-fix-a-build-error-in-kernel-forkc.patch
cris-fix-a-build-error-in-sync_serial_open.patch
cris-fix-the-prototype-of-sync_serial_ioctl.patch
cris-add-missing-declaration-of-kgdb_init-and-breakpoint.patch
fb-fix-potential-deadlock-between-lock_fb_info-and-console_lock.patch
m68k-exec-remove-redundant-set_fsuser_ds.patch
um-reinstate-kernel-version-in-generated-config.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch

