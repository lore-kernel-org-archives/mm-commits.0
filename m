From: akpm@linux-foundation.org
Subject: [merged] sgi-ia64-uv-fix-ia64-build-error-in-the-linux-next-tree.patch removed from -mm tree
Date: Tue, 17 Feb 2009 12:08:43 -0800
Message-ID: <200902172008.n1HK8hwO000946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753152AbZBQUPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 15:15:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, mingo@elte.hu, steiner@sgi.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     sgi ia64 uv: fix ia64 build error in the linux-next tree
has been removed from the -mm tree.  Its filename was
     sgi-ia64-uv-fix-ia64-build-error-in-the-linux-next-tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi ia64 uv: fix ia64 build error in the linux-next tree
From: Dean Nelson <dcn@sgi.com>

Fix the ia64 build error that occurs in the linux-next tree by introducing
an ia64 version of uv.h.  Additionally, clean up the usage of
is_uv_system().

Presumably repairs

commit 5b221278d61e3907a5e4104a844b63bc8bb3d43a
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jan 21 11:30:07 2009 +0100

    x86: uv cleanup, build fix #2
    

Signed-off-by: Dean Nelson <dcn@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/asm/uv/uv.h  |   13 +++++++++++++
 drivers/misc/sgi-gru/gru.h     |    2 --
 drivers/misc/sgi-gru/grufile.c |   18 +++---------------
 drivers/misc/sgi-xp/xp.h       |   22 ++++++++--------------
 4 files changed, 24 insertions(+), 31 deletions(-)

diff -puN /dev/null arch/ia64/include/asm/uv/uv.h
--- /dev/null
+++ a/arch/ia64/include/asm/uv/uv.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_IA64_UV_UV_H
+#define _ASM_IA64_UV_UV_H
+
+#include <asm/system.h>
+#include <asm/sn/simulator.h>
+
+static inline int is_uv_system(void)
+{
+	/* temporary support for running on hardware simulator */
+	return IS_MEDUSA() || ia64_platform_is("uv");
+}
+
+#endif	/* _ASM_IA64_UV_UV_H */
diff -puN drivers/misc/sgi-gru/gru.h~sgi-ia64-uv-fix-ia64-build-error-in-the-linux-next-tree drivers/misc/sgi-gru/gru.h
--- a/drivers/misc/sgi-gru/gru.h~sgi-ia64-uv-fix-ia64-build-error-in-the-linux-next-tree
+++ a/drivers/misc/sgi-gru/gru.h
@@ -19,8 +19,6 @@
 #ifndef __GRU_H__
 #define __GRU_H__
 
-#include <asm/uv/uv.h>
-
 /*
  * GRU architectural definitions
  */
diff -puN drivers/misc/sgi-gru/grufile.c~sgi-ia64-uv-fix-ia64-build-error-in-the-linux-next-tree drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~sgi-ia64-uv-fix-ia64-build-error-in-the-linux-next-tree
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -36,23 +36,11 @@
 #include <linux/interrupt.h>
 #include <linux/proc_fs.h>
 #include <linux/uaccess.h>
+#include <asm/uv/uv.h>
 #include "gru.h"
 #include "grulib.h"
 #include "grutables.h"
 
-#if defined CONFIG_X86_64
-#include <asm/genapic.h>
-#include <asm/irq.h>
-#define IS_UV()		is_uv_system()
-#elif defined CONFIG_IA64
-#include <asm/system.h>
-#include <asm/sn/simulator.h>
-/* temp support for running on hardware simulator */
-#define IS_UV()		IS_MEDUSA() || ia64_platform_is("uv")
-#else
-#define IS_UV()		0
-#endif
-
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_mmrs.h>
 
@@ -381,7 +369,7 @@ static int __init gru_init(void)
 	char id[10];
 	void *gru_start_vaddr;
 
-	if (!IS_UV())
+	if (!is_uv_system())
 		return 0;
 
 #if defined CONFIG_IA64
@@ -451,7 +439,7 @@ static void __exit gru_exit(void)
 	int order = get_order(sizeof(struct gru_state) *
 			      GRU_CHIPLETS_PER_BLADE);
 
-	if (!IS_UV())
+	if (!is_uv_system())
 		return;
 
 	for (i = 0; i < GRU_CHIPLETS_PER_BLADE; i++)
diff -puN drivers/misc/sgi-xp/xp.h~sgi-ia64-uv-fix-ia64-build-error-in-the-linux-next-tree drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-ia64-uv-fix-ia64-build-error-in-the-linux-next-tree
+++ a/drivers/misc/sgi-xp/xp.h
@@ -15,21 +15,19 @@
 
 #include <linux/mutex.h>
 
+#if defined CONFIG_X86_UV || defined CONFIG_IA64_SGI_UV
 #include <asm/uv/uv.h>
+#define is_uv()		is_uv_system()
+#endif
+
+#ifndef is_uv
+#define is_uv()		0
+#endif
 
-#ifdef CONFIG_IA64
+#if defined CONFIG_IA64
 #include <asm/system.h>
 #include <asm/sn/arch.h>	/* defines is_shub1() and is_shub2() */
 #define is_shub()	ia64_platform_is("sn2")
-#ifdef CONFIG_IA64_SGI_UV
-#define is_uv()		ia64_platform_is("uv")
-#else
-#define is_uv()		0
-#endif
-#endif
-#ifdef CONFIG_X86_64
-#include <asm/genapic.h>
-#define is_uv()		is_uv_system()
 #endif
 
 #ifndef is_shub1
@@ -44,10 +42,6 @@
 #define is_shub()	0
 #endif
 
-#ifndef is_uv
-#define is_uv()		0
-#endif
