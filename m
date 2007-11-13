From: akpm@linux-foundation.org
Subject: - powerpc-swsusp-make-altivec-code-depend-on-config_altivec.patch removed from -mm tree
Date: Mon, 12 Nov 2007 20:07:14 -0800
Message-ID: <200711130407.lAD47DG9025219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53731 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757424AbXKMEIG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 23:08:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johannes@sipsolutions.net, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc swsusp: make altivec code depend on CONFIG_ALTIVEC
has been removed from the -mm tree.  Its filename was
     powerpc-swsusp-make-altivec-code-depend-on-config_altivec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc swsusp: make altivec code depend on CONFIG_ALTIVEC
From: Johannes Berg <johannes@sipsolutions.net>

This makes the altivec code in swsusp_32.S depend on CONFIG_ALTIVEC to
avoid build failures for systems that don't have altivec. I'm not sure
whether the code will actually work for other systems, but it was merged
for just ppc32 rather than powermac a very long time ago.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/swsusp_32.S |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/powerpc/kernel/swsusp_32.S~powerpc-swsusp-make-altivec-code-depend-on-config_altivec arch/powerpc/kernel/swsusp_32.S
--- a/arch/powerpc/kernel/swsusp_32.S~powerpc-swsusp-make-altivec-code-depend-on-config_altivec
+++ a/arch/powerpc/kernel/swsusp_32.S
@@ -133,10 +133,12 @@ _GLOBAL(swsusp_arch_suspend)
 /* Resume code */
 _GLOBAL(swsusp_arch_resume)
 
+#ifdef CONFIG_ALTIVEC
 	/* Stop pending alitvec streams and memory accesses */
 BEGIN_FTR_SECTION
 	DSSALL
 END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
+#endif
  	sync
 
 	/* Disable MSR:DR to make sure we don't take a TLB or
_

Patches currently in -mm which might be from johannes@sipsolutions.net are

origin.patch
git-kbuild.patch
git-net.patch
git-wireless.patch
hibernate-fix-lockdep-report-2.patch
