From: akpm@linux-foundation.org
Subject: - i386-work-around-miscompilation-of-alternatives-code.patch removed from -mm tree
Date: Fri, 11 May 2007 22:32:17 -0700
Message-ID: <200705120532.l4C5WHIh002039@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbXELFci (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:32:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg.roedel@amd.com, ak@suse.de, bhalevy@panasas.com, zaitcev@redhat.com, mm-commits@vger.kernel.org


The patch titled
     i386: work around miscompilation of alternatives code
has been removed from the -mm tree.  Its filename was
     i386-work-around-miscompilation-of-alternatives-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: work around miscompilation of alternatives code
From: "Joerg Roedel" <joerg.roedel@amd.com>

A recent change makes my Dell 1501 hang on boot.  It's an AMD MK-36.  I use
an x86_64 kernel.  It is 100% reproducible.

I debugged this problem a bit and my compiler[1]interprets the =A constraint
as %rax instead of %edx:%eax on x86_64 which causes the problem.  The appended
patch provides a workaround for this and fixed the hang on my machine.

[1] gcc version 4.1.3 20070429 (prerelease) (Debian 4.1.2-5)

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Benny Halevy <bhalevy@panasas.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>
Cc: "Joerg Roedel" <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/alternative.h   |    6 ++++++
 include/asm-i386/tsc.h           |    6 ++++--
 include/asm-x86_64/alternative.h |    6 ++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff -puN include/asm-i386/alternative.h~i386-work-around-miscompilation-of-alternatives-code include/asm-i386/alternative.h
--- a/include/asm-i386/alternative.h~i386-work-around-miscompilation-of-alternatives-code
+++ a/include/asm-i386/alternative.h
@@ -98,6 +98,12 @@ static inline void alternatives_smp_swit
 		      ".previous" : output : [feat] "i" (feature), ##input)
 
 /*
+ * use this macro(s) if you need more than one output parameter
+ * in alternative_io
+ */
+#define ASM_OUTPUT2(a, b) a, b
+
+/*
  * Alternative inline assembly for SMP.
  *
  * The LOCK_PREFIX macro defined here replaces the LOCK and
diff -puN include/asm-i386/tsc.h~i386-work-around-miscompilation-of-alternatives-code include/asm-i386/tsc.h
--- a/include/asm-i386/tsc.h~i386-work-around-miscompilation-of-alternatives-code
+++ a/include/asm-i386/tsc.h
@@ -35,14 +35,16 @@ static inline cycles_t get_cycles(void)
 static __always_inline cycles_t get_cycles_sync(void)
 {
 	unsigned long long ret;
-	unsigned eax;
+	unsigned eax, edx;
 
 	/*
   	 * Use RDTSCP if possible; it is guaranteed to be synchronous
  	 * and doesn't cause a VMEXIT on Hypervisors
 	 */
 	alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
-			 	 "=A" (ret), "0" (0ULL) : "ecx", "memory");
+		       ASM_OUTPUT2("=a" (eax), "=d" (edx)),
+		       "a" (0U), "d" (0U) : "ecx", "memory");
+	ret = (((unsigned long long)edx) << 32) | ((unsigned long long)eax);
 	if (ret)
 		return ret;
 
diff -puN include/asm-x86_64/alternative.h~i386-work-around-miscompilation-of-alternatives-code include/asm-x86_64/alternative.h
--- a/include/asm-x86_64/alternative.h~i386-work-around-miscompilation-of-alternatives-code
+++ a/include/asm-x86_64/alternative.h
@@ -103,6 +103,12 @@ static inline void alternatives_smp_swit
 		      ".previous" : output : [feat] "i" (feature), ##input)
 
 /*
+ * use this macro(s) if you need more than one output parameter
+ * in alternative_io
+ */
+#define ASM_OUTPUT2(a, b) a, b
+
+/*
  * Alternative inline assembly for SMP.
  *
  * The LOCK_PREFIX macro defined here replaces the LOCK and
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

origin.patch
