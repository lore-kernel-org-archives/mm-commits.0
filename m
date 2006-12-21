From: akpm@osdl.org
Subject: + microcode-fix-mc_cpu_notifier-section-warning.patch added to -mm tree
Date: Wed, 20 Dec 2006 16:48:20 -0800
Message-ID: <200612210048.kBL0mK4A011543@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54044 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161093AbWLUAsi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 19:48:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, tigran@aivazian.fsnet.co.uk


The patch titled
     microcode: Fix mc_cpu_notifier section warning
has been added to the -mm tree.  Its filename is
     microcode-fix-mc_cpu_notifier-section-warning.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: microcode: Fix mc_cpu_notifier section warning
From: Jean Delvare <khali@linux-fr.org>

Structure mc_cpu_notifier references a __cpuinit function, but isn't
declared __cpuinitdata itself:

WARNING: arch/i386/kernel/microcode.o - Section mismatch: reference
to .init.text: from .data after 'mc_cpu_notifier' (at offset 0x118)

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/kernel/microcode.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/microcode.c~microcode-fix-mc_cpu_notifier-section-warning arch/i386/kernel/microcode.c
--- a/arch/i386/kernel/microcode.c~microcode-fix-mc_cpu_notifier-section-warning
+++ a/arch/i386/kernel/microcode.c
@@ -722,7 +722,7 @@ mc_cpu_callback(struct notifier_block *n
 	return NOTIFY_OK;
 }
 
-static struct notifier_block mc_cpu_notifier = {
+static struct notifier_block __cpuinitdata mc_cpu_notifier = {
 	.notifier_call = mc_cpu_callback,
 };
 
_

Patches currently in -mm which might be from khali@linux-fr.org are

microcode-fix-mc_cpu_notifier-section-warning.patch
git-alsa.patch
git-drm.patch

