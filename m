From: akpm@linux-foundation.org
Subject: - remove-hardcoding-of-hard_smp_processor_id-on-up-systems-sparc64-fix.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:08:07 -0700
Message-ID: <200704302008.l3UK87pj013801@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423657AbXD3UIM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:08:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Remove hardcoding of hard_smp_processor_id on UP systems - sparc64 fix
has been removed from the -mm tree.  Its filename was
     remove-hardcoding-of-hard_smp_processor_id-on-up-systems-sparc64-fix.patch

This patch was dropped because it was folded into remove-hardcoding-of-hard_smp_processor_id-on-up.patch

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
