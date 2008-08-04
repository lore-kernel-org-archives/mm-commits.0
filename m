From: akpm@linux-foundation.org
Subject: + mn10300-fix-up-__bug_table-handling-in-module-loader.patch added to -mm tree
Date: Mon, 04 Aug 2008 15:08:37 -0700
Message-ID: <200808042208.m74M8bIr001695@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833AbYHDWJ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 18:09:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, dhowells@redhat.com


The patch titled
     mn10300: fix up __bug_table handling in module loader
has been added to the -mm tree.  Its filename is
     mn10300-fix-up-__bug_table-handling-in-module-loader.patch

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
Subject: mn10300: fix up __bug_table handling in module loader
From: Paul Mundt <lethal@linux-sh.org>

Platforms that are using GENERIC_BUG must call in to
module_bug_finalize()/module_bug_cleanup() in order to scan modules with
their own __bug_table sections that are otherwise unaccounted.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/module.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/mn10300/kernel/module.c~mn10300-fix-up-__bug_table-handling-in-module-loader arch/mn10300/kernel/module.c
--- a/arch/mn10300/kernel/module.c~mn10300-fix-up-__bug_table-handling-in-module-loader
+++ a/arch/mn10300/kernel/module.c
@@ -24,6 +24,7 @@
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/bug.h>
 
 #if 0
 #define DEBUGP printk
@@ -195,7 +196,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs,
 		    struct module *me)
 {
-	return 0;
+	return module_bug_finalize(hdr, sechdrs, me);
 }
 
 /*
@@ -203,4 +204,5 @@ int module_finalize(const Elf_Ehdr *hdr,
  */
 void module_arch_cleanup(struct module *mod)
 {
+	module_bug_cleanup(mod);
 }
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
mn10300-fix-up-__bug_table-handling-in-module-loader.patch
linux-next.patch
i2c-renesas-highlander-fpga-smbus-support.patch
maple-allow-removal-and-reinsertion-of-keyboard-driver-module.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
kdump-make-elfcorehdr_addr-independent-of-config_proc_vmcore.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

