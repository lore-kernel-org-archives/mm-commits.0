From: akpm@linux-foundation.org
Subject: - cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:20:34 -0800
Message-ID: <200802082020.m18KKFWL011149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53705 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935189AbYBHUf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:35:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cpu: fix section mismatch warnings for enable_nonboot_cpus
has been removed from the -mm tree.  Its filename was
     cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu: fix section mismatch warnings for enable_nonboot_cpus
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: o-x86_64/kernel/built-in.o(.text+0x36d8b): Section mismatch in reference from the function enable_nonboot_cpus() to the function .cpuinit.text:_cpu_up()

enable_nonboot_cpus() are used solely from CONFIG_CONFIG_PM_SLEEP_SMP=y
and PM_SLEEP_SMP imply HOTPLUG_CPU therefore the reference
to _cpu_up() is valid.
Annotate enable_nonboot_cpus() with __ref to silence modpost.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpu.c~cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus kernel/cpu.c
--- a/kernel/cpu.c~cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus
+++ a/kernel/cpu.c
@@ -389,7 +389,7 @@ int disable_nonboot_cpus(void)
 	return error;
 }
 
-void enable_nonboot_cpus(void)
+void __ref enable_nonboot_cpus(void)
 {
 	int cpu, error;
 
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
linux-kernel-markers-create-modpost-file.patch
typhoon-section-fix.patch
natsemi-section-fix.patch
bnx2x-section-fix.patch
bnx2c-section-fix.patch
via-velocity-section-fix.patch
starfire-secton-fix.patch
