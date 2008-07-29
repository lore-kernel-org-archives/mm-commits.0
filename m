From: akpm@linux-foundation.org
Subject: + kmemcheck-include-moduleh-to-prevent-warnings.patch added to -mm tree
Date: Tue, 29 Jul 2008 00:13:22 -0700
Message-ID: <200807290713.m6T7DMdc020383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129AbYG2HOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 03:14:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, mingo@elte.hu, penberg@cs.helsinki.fi, vegard.nossum@gmail.com


The patch titled
     kmemcheck: include module.h to prevent warnings
has been added to the -mm tree.  Its filename is
     kmemcheck-include-moduleh-to-prevent-warnings.patch

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
Subject: kmemcheck: include module.h to prevent warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

kmemcheck/shadow.c needs to include <linux/module.h> to prevent
the following warnings:

linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : data definition has no type or storage class
linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
linux-next-20080724/arch/x86/mm/kmemcheck/shadow.c:64: warning : parameter names (without types) in function declaration

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/kmemcheck/shadow.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/mm/kmemcheck/shadow.c~kmemcheck-include-moduleh-to-prevent-warnings arch/x86/mm/kmemcheck/shadow.c
--- a/arch/x86/mm/kmemcheck/shadow.c~kmemcheck-include-moduleh-to-prevent-warnings
+++ a/arch/x86/mm/kmemcheck/shadow.c
@@ -1,5 +1,6 @@
 #include <linux/kmemcheck.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kmemcheck-include-moduleh-to-prevent-warnings.patch
documentation-build-source-files-in-documentation-sub-dir.patch
genksyms-parser-fix-the-__attribute__-rule.patch
genksyms-include-extern-information-in-dumps.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
lkdtm-fix-for-config_scsi=n.patch
git-unionfs.patch
profile-likely-unlikely-macros.patch

