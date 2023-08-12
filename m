Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960ABC04E69
	for <mm-commits@archiver.kernel.org>; Sat, 12 Aug 2023 22:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjHLWGV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Aug 2023 18:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbjHLWGK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 12 Aug 2023 18:06:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06651993
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 15:06:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36776620CF
        for <mm-commits@vger.kernel.org>; Sat, 12 Aug 2023 22:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6BFC433C8;
        Sat, 12 Aug 2023 22:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691877964;
        bh=cx9Hn1tC5tKce/EHbYY0xB8C4on2mq3sXOml3dMFCpQ=;
        h=Date:To:From:Subject:From;
        b=AQkK/GjdciKaDW45+H2zzJ6Pahy02gcOyDh/gZF/C+wj40qpiCtRAIRr/bKXf5mya
         6fP3cYyP/olUt1CgMeYi7nSeumZNxvRRjcMUKfWxZ39ETZZKfbEADmOaOpjiEFLSyR
         mr4A0iN8gpHrxjOS/1F93a+ie4d5DLLMFY3+F84k=
Date:   Sat, 12 Aug 2023 15:06:04 -0700
To:     mm-commits@vger.kernel.org, tsbogend@alpha.franken.de,
        tglx@linutronix.de, mingo@redhat.com, linux@rasmusvillemoes.dk,
        hpa@zytor.com, dave.hansen@linux.intel.com, bp@alien8.de,
        bhelgaas@google.com, alexander.sverdlin@nokia.com,
        andriy.shevchenko@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] rangeh-move-resource-api-and-constant-to-respective-files.patch removed from -mm tree
Message-Id: <20230812220604.8A6BFC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: range.h: Move resource API and constant to respective files
has been removed from the -mm tree.  Its filename was
     rangeh-move-resource-api-and-constant-to-respective-files.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: range.h: Move resource API and constant to respective files
Date: Fri, 4 Aug 2023 09:46:36 +0300

range.h works with struct range data type. The resource_size_t
is an alien here.

(1) Move cap_resource() implementation into its only user, and
(2) rename and move RESOURCE_SIZE_MAX to limits.h.

Link: https://lkml.kernel.org/r/20230804064636.15368-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/cavium-octeon/setup.c |    2 +-
 arch/x86/pci/amd_bus.c          |    8 ++++++++
 arch/x86/pci/bus_numa.c         |    2 +-
 include/linux/limits.h          |    2 ++
 include/linux/range.h           |    8 --------
 5 files changed, 12 insertions(+), 10 deletions(-)

--- a/arch/mips/cavium-octeon/setup.c~rangeh-move-resource-api-and-constant-to-respective-files
+++ a/arch/mips/cavium-octeon/setup.c
@@ -1240,7 +1240,7 @@ static int __init octeon_no_pci_init(voi
 	 */
 	octeon_dummy_iospace = vzalloc(IO_SPACE_LIMIT);
 	set_io_port_base((unsigned long)octeon_dummy_iospace);
-	ioport_resource.start = MAX_RESOURCE;
+	ioport_resource.start = RESOURCE_SIZE_MAX;
 	ioport_resource.end = 0;
 	return 0;
 }
--- a/arch/x86/pci/amd_bus.c~rangeh-move-resource-api-and-constant-to-respective-files
+++ a/arch/x86/pci/amd_bus.c
@@ -51,6 +51,14 @@ static struct pci_root_info __init *find
 	return NULL;
 }
 
+static inline resource_size_t cap_resource(u64 val)
+{
+	if (val > RESOURCE_SIZE_MAX)
+		return RESOURCE_SIZE_MAX;
+
+	return val;
+}
+
 /**
  * early_root_info_init()
  * called before pcibios_scan_root and pci_scan_bus
--- a/arch/x86/pci/bus_numa.c~rangeh-move-resource-api-and-constant-to-respective-files
+++ a/arch/x86/pci/bus_numa.c
@@ -101,7 +101,7 @@ void update_res(struct pci_root_info *in
 	if (start > end)
 		return;
 
-	if (start == MAX_RESOURCE)
+	if (start == RESOURCE_SIZE_MAX)
 		return;
 
 	if (!merge)
--- a/include/linux/limits.h~rangeh-move-resource-api-and-constant-to-respective-files
+++ a/include/linux/limits.h
@@ -10,6 +10,8 @@
 #define SSIZE_MAX	((ssize_t)(SIZE_MAX >> 1))
 #define PHYS_ADDR_MAX	(~(phys_addr_t)0)
 
+#define RESOURCE_SIZE_MAX	((resource_size_t)~0)
+
 #define U8_MAX		((u8)~0U)
 #define S8_MAX		((s8)(U8_MAX >> 1))
 #define S8_MIN		((s8)(-S8_MAX - 1))
--- a/include/linux/range.h~rangeh-move-resource-api-and-constant-to-respective-files
+++ a/include/linux/range.h
@@ -31,12 +31,4 @@ int clean_sort_range(struct range *range
 
 void sort_range(struct range *range, int nr_range);
 
-#define MAX_RESOURCE ((resource_size_t)~0)
-static inline resource_size_t cap_resource(u64 val)
-{
-	if (val > MAX_RESOURCE)
-		return MAX_RESOURCE;
-
-	return val;
-}
 #endif
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are


