From: akpm@linux-foundation.org
Subject: - x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch removed from -mm tree
Date: Thu, 08 May 2008 12:31:44 -0700
Message-ID: <200805081931.m48JViwb001891@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755429AbYEHTco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 15:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, dilinger@debian.org, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: GEODE: cache results from geode_has_vsa2() and uninline
has been removed from the -mm tree.  Its filename was
     x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: GEODE: cache results from geode_has_vsa2() and uninline
From: Andres Salomon <dilinger@queued.net>

This moves geode_has_vsa2 into a .c file, caches the result we get from
the VSA virtual registers, and causes the function to no longer be inline.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/geode_32.c |   19 +++++++++++++++++++
 include/asm-x86/geode.h    |   11 +----------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff -puN arch/x86/kernel/geode_32.c~x86-geode-cache-results-from-geode_has_vsa2-and-uninline arch/x86/kernel/geode_32.c
--- a/arch/x86/kernel/geode_32.c~x86-geode-cache-results-from-geode_has_vsa2-and-uninline
+++ a/arch/x86/kernel/geode_32.c
@@ -161,6 +161,25 @@ void geode_gpio_setup_event(unsigned int
 }
 EXPORT_SYMBOL_GPL(geode_gpio_setup_event);
 
+int geode_has_vsa2(void)
+{
+	static int has_vsa2 = -1;
+
+	if (has_vsa2 == -1) {
+		/*
+		 * The VSA has virtual registers that we can query for a
+		 * signature.
+		 */
+		outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
+		outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
+
+		has_vsa2 = (inw(VSA_VRC_DATA) == VSA_SIG);
+	}
+
+	return has_vsa2;
+}
+EXPORT_SYMBOL_GPL(geode_has_vsa2);
+
 static int __init geode_southbridge_init(void)
 {
 	if (!is_geode())
diff -puN include/asm-x86/geode.h~x86-geode-cache-results-from-geode_has_vsa2-and-uninline include/asm-x86/geode.h
--- a/include/asm-x86/geode.h~x86-geode-cache-results-from-geode_has_vsa2-and-uninline
+++ a/include/asm-x86/geode.h
@@ -185,16 +185,7 @@ static inline int is_geode(void)
 	return (is_geode_gx() || is_geode_lx());
 }
 
-/*
- * The VSA has virtual registers that we can query for a signature.
- */
-static inline int geode_has_vsa2(void)
-{
-	outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
-	outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
