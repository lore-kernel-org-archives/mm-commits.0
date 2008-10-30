From: akpm@linux-foundation.org
Subject: - adjust-init-section-definitions.patch removed from -mm tree
Date: Thu, 30 Oct 2008 12:04:44 -0700
Message-ID: <200810301904.m9UJ4ijV024892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427AbYJ3TEx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 15:04:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     adjust init section definitions
has been removed from the -mm tree.  Its filename was
     adjust-init-section-definitions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: adjust init section definitions
From: "Jan Beulich" <jbeulich@novell.com>

Add rodata equivalents for assembly use, and fix the section attributes
used by __REFCONST.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/linux/init.h~adjust-init-section-definitions include/linux/init.h
--- a/include/linux/init.h~adjust-init-section-definitions
+++ a/include/linux/init.h
@@ -112,21 +112,25 @@
 #define __FINIT		.previous
 
 #define __INITDATA	.section	".init.data","aw"
+#define __INITRODATA	.section	".init.rodata","a"
 #define __FINITDATA	.previous
 
 #define __DEVINIT        .section	".devinit.text", "ax"
 #define __DEVINITDATA    .section	".devinit.data", "aw"
+#define __DEVINITRODATA  .section	".devinit.rodata", "a"
 
 #define __CPUINIT        .section	".cpuinit.text", "ax"
 #define __CPUINITDATA    .section	".cpuinit.data", "aw"
+#define __CPUINITRODATA  .section	".cpuinit.rodata", "a"
 
 #define __MEMINIT        .section	".meminit.text", "ax"
 #define __MEMINITDATA    .section	".meminit.data", "aw"
+#define __MEMINITRODATA  .section	".meminit.rodata", "a"
 
 /* silence warnings when references are OK */
 #define __REF            .section       ".ref.text", "ax"
 #define __REFDATA        .section       ".ref.data", "aw"
-#define __REFCONST       .section       ".ref.rodata", "aw"
+#define __REFCONST       .section       ".ref.rodata", "a"
 
 #ifndef __ASSEMBLY__
 /*
_

Patches currently in -mm which might be from jbeulich@novell.com are

linux-next.patch

