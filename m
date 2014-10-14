From: akpm@linux-foundation.org
Subject: [merged]
 try-to-use-automatic-variable-in-kexec-purgatory-makefile.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:21:18 -0700
Message-ID: <543d699e.7L21QUgLZ2+Gj1Bm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbaJNSVR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, hpa@zytor.com, mingo@elte.hu, sfr@canb.auug.org.au, tglx@linutronix.de, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/purgatory/Makefile: try to use automatic variable in kexec purgatory makefile
has been removed from the -mm tree.  Its filename was
     try-to-use-automatic-variable-in-kexec-purgatory-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: arch/x86/purgatory/Makefile: try to use automatic variable in kexec purgatory makefile

Make the Makefile of kexec purgatory be consistent with others in linux
src tree, and make it look generic and simple.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/purgatory/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/purgatory/Makefile~try-to-use-automatic-variable-in-kexec-purgatory-makefile arch/x86/purgatory/Makefile
--- a/arch/x86/purgatory/Makefile~try-to-use-automatic-variable-in-kexec-purgatory-makefile
+++ a/arch/x86/purgatory/Makefile
@@ -18,8 +18,9 @@ $(obj)/purgatory.ro: $(PURGATORY_OBJS) F
 
 targets += kexec-purgatory.c
 
+CMD_BIN2C = $(objtree)/scripts/basic/bin2c
 quiet_cmd_bin2c = BIN2C   $@
-      cmd_bin2c = cat $(obj)/purgatory.ro | $(objtree)/scripts/basic/bin2c kexec_purgatory > $(obj)/kexec-purgatory.c
+      cmd_bin2c = $(CMD_BIN2C) kexec_purgatory < $< > $@
 
 $(obj)/kexec-purgatory.c: $(obj)/purgatory.ro FORCE
 	$(call if_changed,bin2c)
_

Patches currently in -mm which might be from bhe@redhat.com are

origin.patch

