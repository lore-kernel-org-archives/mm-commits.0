From: akpm@linux-foundation.org
Subject: + purgatory-core-purgatory-functionality-fix.patch added to -mm
 tree
Date: Mon, 07 Jul 2014 12:20:56 -0700
Message-ID: <53baf318.Iv3Fy69ioquldK9a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:32882 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaGGTU5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 15:20:57 -0400
Received: by mail-qc0-f201.google.com with SMTP id c9so674281qcz.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 12:20:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: purgatory: run host built programs from objtree
has been added to the -mm tree.  Its filename is
     purgatory-core-purgatory-functionality-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/purgatory-core-purgatory-functionality-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/purgatory-core-purgatory-functionality-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: purgatory: run host built programs from objtree

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/purgatory/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/purgatory/Makefile~purgatory-core-purgatory-functionality-fix arch/x86/purgatory/Makefile
--- a/arch/x86/purgatory/Makefile~purgatory-core-purgatory-functionality-fix
+++ a/arch/x86/purgatory/Makefile
@@ -18,7 +18,7 @@ $(obj)/purgatory.ro: $(PURGATORY_OBJS) F
 targets += kexec-purgatory.c
 
 quiet_cmd_bin2c = BIN2C   $@
-      cmd_bin2c = cat $(obj)/purgatory.ro | $(srctree)/scripts/basic/bin2c kexec_purgatory > $(obj)/kexec-purgatory.c
+      cmd_bin2c = cat $(obj)/purgatory.ro | $(objtree)/scripts/basic/bin2c kexec_purgatory > $(obj)/kexec-purgatory.c
 
 $(obj)/kexec-purgatory.c: $(obj)/purgatory.ro FORCE
 	$(call if_changed,bin2c)
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kbuild-explain-stack-protector-strong-config-logic.patch
cma-generalize-cma-reserved-area-management-functionality-fix.patch
printk-allow-increasing-the-ring-buffer-depending-on-the-number-of-cpus-fix.patch
purgatory-core-purgatory-functionality-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-3.patch
linux-next.patch
kernel-forkc-export-kernel_thread-to-modules.patch

