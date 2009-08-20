From: akpm@linux-foundation.org
Subject: + mips-octeon-add-hardware-rng-platform-device.patch added to -mm tree
Date: Thu, 20 Aug 2009 16:29:32 -0700
Message-ID: <200908202329.n7KNTXMA004310@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754117AbZHTXaf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 19:30:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ddaney@caviumnetworks.com, herbert@gondor.apana.org.au, mpm@selenic.com, ralf@linux-mips.org


The patch titled
     mips: octeon: add hardware RNG platform device
has been added to the -mm tree.  Its filename is
     mips-octeon-add-hardware-rng-platform-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mips: octeon: add hardware RNG platform device
From: David Daney <ddaney@caviumnetworks.com>

Add a platform device for the Octeon Random Number Generator (RNG).

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/cavium-octeon/setup.c              |   43 ++++++++
 arch/mips/include/asm/octeon/cvmx-rnm-defs.h |   88 +++++++++++++++++
 2 files changed, 131 insertions(+)

diff -puN arch/mips/cavium-octeon/setup.c~mips-octeon-add-hardware-rng-platform-device arch/mips/cavium-octeon/setup.c
--- a/arch/mips/cavium-octeon/setup.c~mips-octeon-add-hardware-rng-platform-device
+++ a/arch/mips/cavium-octeon/setup.c
@@ -33,6 +33,7 @@
 #include <asm/time.h>
 
 #include <asm/octeon/octeon.h>
+#include <asm/octeon/cvmx-rnm-defs.h>
 
 #ifdef CONFIG_CAVIUM_DECODE_RSL
 extern void cvmx_interrupt_rsl_decode(void);
@@ -926,3 +927,45 @@ out:
 	return ret;
 }
 device_initcall(octeon_cf_device_init);
+
+/* Octeon Random Number Generator.  */
+static int __init octeon_rng_device_init(void)
+{
+	struct platform_device *pd;
+	int ret = 0;
+
+	struct resource rng_resources[] = {
+		{
+			.flags	= IORESOURCE_MEM,
+			.start	= XKPHYS_TO_PHYS(CVMX_RNM_CTL_STATUS),
+			.end	= XKPHYS_TO_PHYS(CVMX_RNM_CTL_STATUS) + 0xf
+		}, {
+			.flags	= IORESOURCE_MEM,
+			.start	= cvmx_build_io_address(8, 0),
+			.end	= cvmx_build_io_address(8, 0) + 0x7
+		}
+	};
+
+	pd = platform_device_alloc("octeon_rng", -1);
+	if (!pd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = platform_device_add_resources(pd, rng_resources,
+					    ARRAY_SIZE(rng_resources));
+	if (ret)
+		goto fail;
+
+	ret = platform_device_add(pd);
+	if (ret)
+		goto fail;
+
+	return ret;
+fail:
+	platform_device_put(pd);
+
+out:
+	return ret;
+}
+device_initcall(octeon_rng_device_init);
diff -puN /dev/null arch/mips/include/asm/octeon/cvmx-rnm-defs.h
--- /dev/null
+++ a/arch/mips/include/asm/octeon/cvmx-rnm-defs.h
@@ -0,0 +1,88 @@
+/***********************license start***************
+ * Author: Cavium Networks
+ *
+ * Contact: support@caviumnetworks.com
+ * This file is part of the OCTEON SDK
+ *
+ * Copyright (c) 2003-2008 Cavium Networks
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, Version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This file is distributed in the hope that it will be useful, but
+ * AS-IS and WITHOUT ANY WARRANTY; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, TITLE, or
+ * NONINFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this file; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ * or visit http://www.gnu.org/licenses/.
+ *
+ * This file may also be available under a different license from Cavium.
+ * Contact Cavium Networks for more information
+ ***********************license end**************************************/
+
+#ifndef __CVMX_RNM_DEFS_H__
+#define __CVMX_RNM_DEFS_H__
+
+#include <linux/types.h>
+
+#define CVMX_RNM_BIST_STATUS \
+	 CVMX_ADD_IO_SEG(0x0001180040000008ull)
+#define CVMX_RNM_CTL_STATUS \
+	 CVMX_ADD_IO_SEG(0x0001180040000000ull)
+
+union cvmx_rnm_bist_status {
+	uint64_t u64;
+	struct cvmx_rnm_bist_status_s {
+		uint64_t reserved_2_63:62;
+		uint64_t rrc:1;
+		uint64_t mem:1;
+	} s;
+	struct cvmx_rnm_bist_status_s cn30xx;
+	struct cvmx_rnm_bist_status_s cn31xx;
+	struct cvmx_rnm_bist_status_s cn38xx;
+	struct cvmx_rnm_bist_status_s cn38xxp2;
+	struct cvmx_rnm_bist_status_s cn50xx;
+	struct cvmx_rnm_bist_status_s cn52xx;
+	struct cvmx_rnm_bist_status_s cn52xxp1;
+	struct cvmx_rnm_bist_status_s cn56xx;
+	struct cvmx_rnm_bist_status_s cn56xxp1;
+	struct cvmx_rnm_bist_status_s cn58xx;
+	struct cvmx_rnm_bist_status_s cn58xxp1;
+};
+
+union cvmx_rnm_ctl_status {
+	uint64_t u64;
+	struct cvmx_rnm_ctl_status_s {
+		uint64_t reserved_9_63:55;
+		uint64_t ent_sel:4;
+		uint64_t exp_ent:1;
+		uint64_t rng_rst:1;
+		uint64_t rnm_rst:1;
+		uint64_t rng_en:1;
+		uint64_t ent_en:1;
+	} s;
+	struct cvmx_rnm_ctl_status_cn30xx {
+		uint64_t reserved_4_63:60;
+		uint64_t rng_rst:1;
+		uint64_t rnm_rst:1;
+		uint64_t rng_en:1;
+		uint64_t ent_en:1;
+	} cn30xx;
+	struct cvmx_rnm_ctl_status_cn30xx cn31xx;
+	struct cvmx_rnm_ctl_status_cn30xx cn38xx;
+	struct cvmx_rnm_ctl_status_cn30xx cn38xxp2;
+	struct cvmx_rnm_ctl_status_s cn50xx;
+	struct cvmx_rnm_ctl_status_s cn52xx;
+	struct cvmx_rnm_ctl_status_s cn52xxp1;
+	struct cvmx_rnm_ctl_status_s cn56xx;
+	struct cvmx_rnm_ctl_status_s cn56xxp1;
+	struct cvmx_rnm_ctl_status_s cn58xx;
+	struct cvmx_rnm_ctl_status_s cn58xxp1;
+};
+
+#endif
_

Patches currently in -mm which might be from ddaney@caviumnetworks.com are

origin.patch
mips-octeon-add-hardware-rng-platform-device.patch
hw_random-add-hardware-rng-for-octeon-socs.patch
maintainers-add-matt-mackall-and-herbert-xu-to-hardware-random-number-generator.patch

