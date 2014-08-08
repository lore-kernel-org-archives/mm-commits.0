From: akpm@linux-foundation.org
Subject: [folded-merged] purgatory-core-purgatory-functionality-fix.patch
 removed from -mm tree
Date: Fri, 08 Aug 2014 14:02:33 -0700
Message-ID: <53e53ae9.2cI/GSOB1I/T3k7j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:48252 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241AbaHHVCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 17:02:34 -0400
Received: by mail-pd0-f202.google.com with SMTP id w10so1564895pde.3
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 14:02:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: purgatory: run host built programs from objtree
has been removed from the -mm tree.  Its filename was
     purgatory-core-purgatory-functionality-fix.patch

This patch was dropped because it was folded into purgatory-core-purgatory-functionality.patch

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

origin.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig.patch
purgatory-core-purgatory-functionality.patch

