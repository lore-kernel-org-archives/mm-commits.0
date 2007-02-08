From: akpm@linux-foundation.org
Subject: - arch-powerpc-user-array_size-macro-when-appropriate.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:47:56 -0800
Message-ID: <200702080947.l189lu7A010989@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35720 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423176AbXBHJsF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:48:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     PowerPC: user ARRAY_SIZE macro when appropriate
has been removed from the -mm tree.  Its filename was
     arch-powerpc-user-array_size-macro-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PowerPC: user ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/lib/rheap.c    |    3 ++-
 arch/powerpc/xmon/ppc-opc.c |    7 +++----
 arch/powerpc/xmon/spu-opc.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/lib/rheap.c~arch-powerpc-user-array_size-macro-when-appropriate arch/powerpc/lib/rheap.c
--- a/arch/powerpc/lib/rheap.c~arch-powerpc-user-array_size-macro-when-appropriate
+++ a/arch/powerpc/lib/rheap.c
@@ -14,6 +14,7 @@
  */
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 
@@ -670,7 +671,7 @@ void rh_dump(rh_info_t * info)
 	int maxnr;
 	int i, nr;
 
-	maxnr = sizeof(st) / sizeof(st[0]);
+	maxnr = ARRAY_SIZE(st);
 
 	printk(KERN_INFO
 	       "info @0x%p (%d slots empty / %d max)\n",
diff -puN arch/powerpc/xmon/ppc-opc.c~arch-powerpc-user-array_size-macro-when-appropriate arch/powerpc/xmon/ppc-opc.c
--- a/arch/powerpc/xmon/ppc-opc.c~arch-powerpc-user-array_size-macro-when-appropriate
+++ a/arch/powerpc/xmon/ppc-opc.c
@@ -21,6 +21,7 @@
    02110-1301, USA.  */
 
 #include <linux/stddef.h>
+#include <linux/kernel.h>
 #include "nonstdio.h"
 #include "ppc.h"
 
@@ -4932,8 +4933,7 @@ const struct powerpc_opcode powerpc_opco
 
 };
 
-const int powerpc_num_opcodes =
-  sizeof (powerpc_opcodes) / sizeof (powerpc_opcodes[0]);
+const int powerpc_num_opcodes = ARRAY_SIZE(powerpc_opcodes);
 
 /* The macro table.  This is only used by the assembler.  */
 
@@ -4989,5 +4989,4 @@ const struct powerpc_macro powerpc_macro
 { "clrlslwi.",4,  PPCCOM,	"rlwinm. %0,%1,%3,(%2)-(%3),31-(%3)" },
 };
 
-const int powerpc_num_macros =
-  sizeof (powerpc_macros) / sizeof (powerpc_macros[0]);
+const int powerpc_num_macros = ARRAY_SIZE(powerpc_macros);
diff -puN arch/powerpc/xmon/spu-opc.c~arch-powerpc-user-array_size-macro-when-appropriate arch/powerpc/xmon/spu-opc.c
--- a/arch/powerpc/xmon/spu-opc.c~arch-powerpc-user-array_size-macro-when-appropriate
+++ a/arch/powerpc/xmon/spu-opc.c
@@ -18,6 +18,7 @@
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street - Fifth Floor, Boston, MA 02110-1301, USA.  */
 
+#include <linux/kernel.h>
 #include "spu.h"
 
 /* This file holds the Spu opcode table */
@@ -40,5 +41,4 @@ const struct spu_opcode spu_opcodes[] = 
 #undef APUOPFB
 };
 
-const int spu_num_opcodes =
-  sizeof (spu_opcodes) / sizeof (spu_opcodes[0]);
+const int spu_num_opcodes = ARRAY_SIZE(spu_opcodes);
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
toshiba-acpi-use-array_size-macro-when-appropriate.patch
git-agpgart.patch
arch-arm-use-array_size-macro-when-appropriate.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
git-powerpc.patch
drm-use-array_size-macro-when-appropriate.patch
git-dvb.patch
atm-use-array_size-macro-when-appropriate.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
s390-drivers-use-array_size-macro-when-appropriate.patch
git-scsi-misc.patch
arch-arm26-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
w1-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate-2.patch
reiserfs-use-array_size-macro-when-appropriate.patch
isdn-capi-use-array_size-when-appropriate.patch
isdn-eicon-use-array_size-macro-when-appropriate.patch
rcutorture-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
