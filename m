From: akpm@linux-foundation.org
Subject: + i386-fix-section-mismatch-warning-in-intel_cacheinfo.patch added to -mm tree
Date: Mon, 04 Jun 2007 14:41:50 -0700
Message-ID: <200706042141.l54LfoLU019876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41823 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbXFDVmD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 17:42:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org


The patch titled
     i386: fix section mismatch warning in intel_cacheinfo
has been added to the -mm tree.  Its filename is
     i386-fix-section-mismatch-warning-in-intel_cacheinfo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: fix section mismatch warning in intel_cacheinfo
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: arch/i386/kernel/built-in.o(.init.text+0x3818): Section mismatch: reference to .exit.text:cache_remove_dev (between 'cacheinfo_cpu_callback' and 'cache_sysfs_init')

It points out that a function marked __cpuexit is calling a function marked
__cpuinit => oops.

The call happens only in an error-condition which may explain why we have
not seen it before.

The offending function was not used anywhere else - so marked it __cpuexit.

Note: This warning triggers only with a local copy of modpost
      but that version will soon be pushed out.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/intel_cacheinfo.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/cpu/intel_cacheinfo.c~i386-fix-section-mismatch-warning-in-intel_cacheinfo arch/i386/kernel/cpu/intel_cacheinfo.c
--- a/arch/i386/kernel/cpu/intel_cacheinfo.c~i386-fix-section-mismatch-warning-in-intel_cacheinfo
+++ a/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -710,7 +710,7 @@ static int __cpuinit cache_add_dev(struc
 	return retval;
 }
 
-static void __cpuexit cache_remove_dev(struct sys_device * sys_dev)
+static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
 {
 	unsigned int cpu = sys_dev->id;
 	unsigned long i;
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-kbuild.patch
use-posix-bre-in-headers-install-target.patch
fix-x86_64-mm-xen-core-xen-implementation.patch
x86-fix-section-mismatch-warnings-in-mtrr.patch
i386-fix-section-mismatch-warning-in-intel_cacheinfo.patch
git-newsetup.patch
