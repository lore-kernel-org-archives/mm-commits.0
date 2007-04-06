From: akpm@linux-foundation.org
Subject: + re-enable-vdso-by-default-with-paravirt.patch added to -mm tree
Date: Thu, 05 Apr 2007 17:47:26 -0700
Message-ID: <200704060047.l360lQgj030796@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59543 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767451AbXDFArc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 20:47:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, jeremy@xensource.com


The patch titled
     Re-enable VDSO by default with PARAVIRT
has been added to the -mm tree.  Its filename is
     re-enable-vdso-by-default-with-paravirt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Re-enable VDSO by default with PARAVIRT
From: Jeremy Fitzhardinge <jeremy@goop.org>

Everyone wants VDSO to be enabled by default.  COMPAT_VDSO still needs a fix,
but with luck that will turn up soon.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/sysenter.c |    4 ----
 1 files changed, 4 deletions(-)

diff -puN arch/i386/kernel/sysenter.c~re-enable-vdso-by-default-with-paravirt arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c~re-enable-vdso-by-default-with-paravirt
+++ a/arch/i386/kernel/sysenter.c
@@ -27,11 +27,7 @@
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
  */
-#ifdef CONFIG_PARAVIRT
-unsigned int __read_mostly vdso_enabled = 0;
-#else
 unsigned int __read_mostly vdso_enabled = 1;
-#endif
 
 EXPORT_SYMBOL_GPL(vdso_enabled);
 
_

Patches currently in -mm which might be from jeremy@goop.org are

re-enable-vdso-by-default-with-paravirt.patch
remove-noreplacement-option.patch
remove-smp_alt_instructions.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
allow-boot-time-disable-of-smp-altinstructions.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
