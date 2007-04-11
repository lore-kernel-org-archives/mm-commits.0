From: akpm@linux-foundation.org
Subject: + remove-hardcoding-of-hard_smp_processor_id-on-up-systems-sparc64-fix.patch added to -mm tree
Date: Tue, 10 Apr 2007 19:37:54 -0700
Message-ID: <200704110237.l3B2bsGq026208@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56457 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964974AbXDKCiA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 22:38:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp


The patch titled
     Remove hardcoding of hard_smp_processor_id on UP systems - sparc64 fix
has been added to the -mm tree.  Its filename is
     remove-hardcoding-of-hard_smp_processor_id-on-up-systems-sparc64-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove hardcoding of hard_smp_processor_id on UP systems - sparc64 fix
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>

To use hard_smp_processor_id in UP kernels just including linux/smp.h does
not suffice anymore.  Now hard_smp_processor_id is architecture specific
code and consequently asm/smp.h should be included explicitly.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/kernel/traps.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/sparc64/kernel/traps.c~remove-hardcoding-of-hard_smp_processor_id-on-up-systems-sparc64-fix arch/sparc64/kernel/traps.c
--- a/arch/sparc64/kernel/traps.c~remove-hardcoding-of-hard_smp_processor_id-on-up-systems-sparc64-fix
+++ a/arch/sparc64/kernel/traps.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/kdebug.h>
 
+#include <asm/smp.h>
 #include <asm/delay.h>
 #include <asm/system.h>
 #include <asm/ptrace.h>
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

remove-hardcoding-of-hard_smp_processor_id-on-up.patch
remove-hardcoding-of-hard_smp_processor_id-on-up-systems-sparc64-fix.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch
