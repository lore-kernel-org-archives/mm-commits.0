From: akpm@linux-foundation.org
Subject: + use-the-apic-to-determine-the-hardware-processor-id-i386-fix.patch added to -mm tree
Date: Fri, 02 Mar 2007 14:10:58 -0800
Message-ID: <200703022210.l22MAw9J020518@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43128 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030573AbXCBWLC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 17:11:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp


The patch titled
     hard_smp_processor_id definition for UP systems without APIC (i386)
has been added to the -mm tree.  Its filename is
     use-the-apic-to-determine-the-hardware-processor-id-i386-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: hard_smp_processor_id definition for UP systems without APIC (i386)
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Provide hard_smp_processor_id definition also for non apic case.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/smp.h |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN include/asm-i386/smp.h~use-the-apic-to-determine-the-hardware-processor-id-i386-fix include/asm-i386/smp.h
--- a/include/asm-i386/smp.h~use-the-apic-to-determine-the-hardware-processor-id-i386-fix
+++ a/include/asm-i386/smp.h
@@ -90,6 +90,7 @@ extern unsigned int num_processors;
 #ifndef __ASSEMBLY__
 
 #ifdef CONFIG_X86_LOCAL_APIC
+
 #ifdef APIC_DEFINITION
 extern int hard_smp_processor_id(void);
 #else
@@ -100,6 +101,13 @@ static inline int hard_smp_processor_id(
 	return GET_APIC_ID(*(unsigned long *)(APIC_BASE+APIC_ID));
 }
 #endif /* APIC_DEFINITION */
+
+#else /* CONFIG_X86_LOCAL_APIC */
+
+#ifndef CONFIG_SMP
+#define hard_smp_processor_id()		0
+#endif
+
 #endif /* CONFIG_X86_LOCAL_APIC */
 
 extern u8 apicid_2_node[];
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

remove-hardcoding-of-hard_smp_processor_id-on-up.patch
remove-hardcoding-of-hard_smp_processor_id-on-up-move-definition-of-hard_smp_processor_id-to-asm-smph.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-i386-fix.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor.patch
