From: akpm@linux-foundation.org
Subject: - arch-ppc-user-array_size-macro-when-appropriate.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:48:00 -0800
Message-ID: <200702080948.l189m0XT011005@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35725 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423195AbXBHJsH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:48:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     PPC: user ARRAY_SIZE macro when appropriate
has been removed from the -mm tree.  Its filename was
     arch-ppc-user-array_size-macro-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PPC: user ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ppc/lib/rheap.c         |    3 ++-
 arch/ppc/syslib/m8xx_setup.c |    2 +-
 arch/ppc/xmon/ppc-opc.c      |    7 +++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/ppc/lib/rheap.c~arch-ppc-user-array_size-macro-when-appropriate arch/ppc/lib/rheap.c
--- a/arch/ppc/lib/rheap.c~arch-ppc-user-array_size-macro-when-appropriate
+++ a/arch/ppc/lib/rheap.c
@@ -14,6 +14,7 @@
  */
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 
@@ -654,7 +655,7 @@ void rh_dump(rh_info_t * info)
 	int maxnr;
 	int i, nr;
 
-	maxnr = sizeof(st) / sizeof(st[0]);
+	maxnr = ARRAY_SIZE(st);
 
 	printk(KERN_INFO
 	       "info @0x%p (%d slots empty / %d max)\n",
diff -puN arch/ppc/syslib/m8xx_setup.c~arch-ppc-user-array_size-macro-when-appropriate arch/ppc/syslib/m8xx_setup.c
--- a/arch/ppc/syslib/m8xx_setup.c~arch-ppc-user-array_size-macro-when-appropriate
+++ a/arch/ppc/syslib/m8xx_setup.c
@@ -77,7 +77,7 @@ static struct mtd_partition mpc8xxads_pa
 	}
 };
 
-#define mpc8xxads_part_num (sizeof (mpc8xxads_partitions) / sizeof (mpc8xxads_partitions[0]))
+#define mpc8xxads_part_num ARRAY_SIZE(mpc8xxads_partitions)
 
 #endif
 
diff -puN arch/ppc/xmon/ppc-opc.c~arch-ppc-user-array_size-macro-when-appropriate arch/ppc/xmon/ppc-opc.c
--- a/arch/ppc/xmon/ppc-opc.c~arch-ppc-user-array_size-macro-when-appropriate
+++ a/arch/ppc/xmon/ppc-opc.c
@@ -19,6 +19,7 @@ along with this file; see the file COPYI
 Software Foundation, 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.  */
 
 #include <linux/posix_types.h>
+#include <linux/kernel.h>
 #include "ansidecl.h"
 #include "ppc.h"
 
@@ -2669,8 +2670,7 @@ const struct powerpc_opcode powerpc_opco
 
 };
 
-const int powerpc_num_opcodes =
-  sizeof (powerpc_opcodes) / sizeof (powerpc_opcodes[0]);
+const int powerpc_num_opcodes = ARRAY_SIZE(powerpc_opcodes);
 
 /* The macro table.  This is only used by the assembler.  */
 
@@ -2717,5 +2717,4 @@ const struct powerpc_macro powerpc_macro
 
 };
 
-const int powerpc_num_macros =
-  sizeof (powerpc_macros) / sizeof (powerpc_macros[0]);
+const int powerpc_num_macros = ARRAY_SIZE(powerpc_macros);
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
