From: akpm@linux-foundation.org
Subject: [merged] purgatory-add-clean-up-for-purgatory-directory.patch
 removed from -mm tree
Date: Wed, 03 Sep 2014 10:57:59 -0700
Message-ID: <540756a7.m4hXZCnVoT23wOcE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42927 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbaICR6A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:58:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mwelling@ieee.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: purgatory: add clean-up for purgatory directory
has been removed from the -mm tree.  Its filename was
     purgatory-add-clean-up-for-purgatory-directory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michael Welling <mwelling@ieee.org>
Subject: kexec: purgatory: add clean-up for purgatory directory

Without this patch the kexec-purgatory.c and purgatory.ro files are not
removed after make mrproper.

Signed-off-by: Michael Welling <mwelling@ieee.org>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/Makefile~purgatory-add-clean-up-for-purgatory-directory arch/x86/Makefile
--- a/arch/x86/Makefile~purgatory-add-clean-up-for-purgatory-directory
+++ a/arch/x86/Makefile
@@ -251,6 +251,7 @@ archclean:
 	$(Q)rm -rf $(objtree)/arch/x86_64
 	$(Q)$(MAKE) $(clean)=$(boot)
 	$(Q)$(MAKE) $(clean)=arch/x86/tools
+	$(Q)$(MAKE) $(clean)=arch/x86/purgatory
 
 PHONY += kvmconfig
 kvmconfig:
_

Patches currently in -mm which might be from mwelling@ieee.org are


