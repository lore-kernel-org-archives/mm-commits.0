From: akpm@linux-foundation.org
Subject: + powerpc-swsusp-make-altivec-code-depend-on-config_altivec.patch added to -mm tree
Date: Fri, 09 Nov 2007 13:07:21 -0800
Message-ID: <200711092107.lA9L7LOo031830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751525AbXKIVIQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 16:08:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johannes@sipsolutions.net, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     powerpc swsusp: make altivec code depend on CONFIG_ALTIVEC
has been added to the -mm tree.  Its filename is
     powerpc-swsusp-make-altivec-code-depend-on-config_altivec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

powerpc-swsusp-make-altivec-code-depend-on-config_altivec.patch
git-kbuild.patch
git-wireless.patch
hibernate-fix-lockdep-report-2.patch
