From: akpm@linux-foundation.org
Subject: + x86-kill-arch-x86-kernel-mpparsec-debugging-printk.patch added to -mm tree
Date: Fri, 08 Aug 2008 13:51:35 -0700
Message-ID: <200808082051.m78KpZGC027833@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760698AbYHHUwM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 16:52:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@keyaccess.nl, rene.herman@gmail.com


The patch titled
     x86: kill arch/x86/kernel/mpparse.c debugging printk
has been added to the -mm tree.  Its filename is
     x86-kill-arch-x86-kernel-mpparsec-debugging-printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: kill arch/x86/kernel/mpparse.c debugging printk
From: Rene Herman <rene.herman@keyaccess.nl>

commit 11a62a056093a7f25f1595fbd8bd5f93559572b6 turns some formerly nopped
debugging printks in arch/x86/kernel/mppparse.c into regular ones.  The
one at the top of smp_scan_config() in particular also prints on
!CONFIG_SMP/CONFIG_X86_LOCAL_APIC kernels and UP machines without anything
resembling MP tables which makes their lowly UP owners wonder...

Given that it was up to this point also not considered valuable user-level
information, let's just kill that one.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/mpparse.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/x86/kernel/mpparse.c~x86-kill-arch-x86-kernel-mpparsec-debugging-printk arch/x86/kernel/mpparse.c
--- a/arch/x86/kernel/mpparse.c~x86-kill-arch-x86-kernel-mpparsec-debugging-printk
+++ a/arch/x86/kernel/mpparse.c
@@ -697,7 +697,6 @@ static int __init smp_scan_config(unsign
 	unsigned int *bp = phys_to_virt(base);
 	struct intel_mp_floating *mpf;
 
-	printk(KERN_DEBUG "Scan SMP from %p for %ld bytes.\n", bp, length);
 	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
 	while (length > 0) {
_

Patches currently in -mm which might be from rene.herman@keyaccess.nl are

x86-kill-arch-x86-kernel-mpparsec-debugging-printk.patch
i2c-dont-autograb-i2c-pca-is.patch

