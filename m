Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91EB7C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67BCE60F48
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 22:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhI3WQd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 18:16:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229644AbhI3WQb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 18:16:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F66461882;
        Thu, 30 Sep 2021 22:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633040088;
        bh=dUs7uqEIfvNLdV3Aod4Vl/boilUUuqdaS+U02WpldeQ=;
        h=Date:From:To:Subject:From;
        b=f7yk8atBK5zRdZFKLpjXHtV2wr2PJD9WR5i2oGyFj0Vt+mMtHApclzIQSKFWxhoyS
         aJfCeLHRu1cDVQFMUu+yUXxJcWTlLSWm+dxFwag/KFj+9a9nrPjLwwwmTV+hx7Lr1R
         R0MO7FmLnxoTTricyKrOK42S0wuVrKLdYPESkCPk=
Date:   Thu, 30 Sep 2021 15:14:48 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org, rppt@kernel.org
Subject:  + memblock-neaten-logging.patch added to -mm tree
Message-ID: <20210930221448.ge7TCvY_I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: neaten logging
has been added to the -mm tree.  Its filename is
     memblock-neaten-logging.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memblock-neaten-logging.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memblock-neaten-logging.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: memblock: neaten logging

Use more typical kernel logging styles.

o Add and use #define pr_fmt KBUILD_MODNAME ": " fmt
o Neaten memblock_dbg to use %s: %pS: to output __func__ and caller
o Convert existing uses of pr_<level> and memblock_dbg appropriately

Logging output is now always prefixed with 'memblock: '
Debugging output is now prefixed with 'memblock: ', function and caller

Link: https://lkml.kernel.org/r/623750dd31aa3fe5e45c416be98ab37707e2c45d.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |   59 +++++++++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 33 deletions(-)

--- a/mm/memblock.c~memblock-neaten-logging
+++ a/mm/memblock.c
@@ -6,6 +6,8 @@
  * Copyright (C) 2001 Peter Bergner.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -146,10 +148,12 @@ static __refdata struct memblock_type *m
 	     i++, rgn = &memblock_type->regions[i])
 
 #define memblock_dbg(fmt, ...)						\
-	do {								\
-		if (memblock_debug)					\
-			pr_info(fmt, ##__VA_ARGS__);			\
-	} while (0)
+do {									\
+	if (memblock_debug)						\
+		pr_info("%s: %pS: " fmt,				\
+			__func__, __builtin_return_address(0),		\
+			##__VA_ARGS__);					\
+} while (0)
 
 static int memblock_debug __initdata_memblock;
 static bool system_has_some_mirror __initdata_memblock = false;
@@ -447,14 +451,14 @@ static int __init_memblock memblock_doub
 		new_array = addr ? __va(addr) : NULL;
 	}
 	if (!addr) {
-		pr_err("memblock: Failed to double %s array from %ld to %ld entries !\n",
+		pr_err("Failed to double %s array from %ld to %ld entries !\n",
 		       type->name, type->max, type->max * 2);
 		return -1;
 	}
 
 	new_end = addr + new_size - 1;
-	memblock_dbg("memblock: %s is doubled to %ld at [%pa-%pa]",
-			type->name, type->max * 2, &addr, &new_end);
+	memblock_dbg("%s is doubled to %ld at [%pa-%pa]\n",
+		     type->name, type->max * 2, &addr, &new_end);
 
 	/*
 	 * Found space, we now need to move the array over before we add the
@@ -667,8 +671,7 @@ int __init_memblock memblock_add_node(ph
 {
 	phys_addr_t end = base + size - 1;
 
-	memblock_dbg("%s: [%pa-%pa] nid=%d %pS\n", __func__,
-		     &base, &end, nid, (void *)_RET_IP_);
+	memblock_dbg("[%pa-%pa] nid=%d\n", &base, &end, nid);
 
 	return memblock_add_range(&memblock.memory, base, size, nid, 0);
 }
@@ -688,8 +691,7 @@ int __init_memblock memblock_add(phys_ad
 {
 	phys_addr_t end = base + size - 1;
 
-	memblock_dbg("%s: [%pa-%pa] %pS\n", __func__,
-		     &base, &end, (void *)_RET_IP_);
+	memblock_dbg("[%pa-%pa]\n", &base, &end);
 
 	return memblock_add_range(&memblock.memory, base, size, MAX_NUMNODES, 0);
 }
@@ -789,8 +791,7 @@ int __init_memblock memblock_remove(phys
 {
 	phys_addr_t end = base + size - 1;
 
-	memblock_dbg("%s: [%pa-%pa] %pS\n", __func__,
-		     &base, &end, (void *)_RET_IP_);
+	memblock_dbg("[%pa-%pa]\n", &base, &end);
 
 	return memblock_remove_range(&memblock.memory, base, size);
 }
@@ -821,8 +822,7 @@ int __init_memblock memblock_phys_free(p
 {
 	phys_addr_t end = base + size - 1;
 
-	memblock_dbg("%s: [%pa-%pa] %pS\n", __func__,
-		     &base, &end, (void *)_RET_IP_);
+	memblock_dbg("[%pa-%pa]\n", &base, &end);
 
 	kmemleak_free_part_phys(base, size);
 	return memblock_remove_range(&memblock.reserved, base, size);
@@ -832,8 +832,7 @@ int __init_memblock memblock_reserve(phy
 {
 	phys_addr_t end = base + size - 1;
 
-	memblock_dbg("%s: [%pa-%pa] %pS\n", __func__,
-		     &base, &end, (void *)_RET_IP_);
+	memblock_dbg("[%pa-%pa]\n", &base, &end);
 
 	return memblock_add_range(&memblock.reserved, base, size, MAX_NUMNODES, 0);
 }
@@ -843,8 +842,7 @@ int __init_memblock memblock_physmem_add
 {
 	phys_addr_t end = base + size - 1;
 
-	memblock_dbg("%s: [%pa-%pa] %pS\n", __func__,
-		     &base, &end, (void *)_RET_IP_);
+	memblock_dbg("[%pa-%pa]\n", &base, &end);
 
 	return memblock_add_range(&physmem, base, size, MAX_NUMNODES, 0);
 }
@@ -1409,9 +1407,8 @@ phys_addr_t __init memblock_phys_alloc_r
 					     phys_addr_t start,
 					     phys_addr_t end)
 {
-	memblock_dbg("%s: %llu bytes align=0x%llx from=%pa max_addr=%pa %pS\n",
-		     __func__, (u64)size, (u64)align, &start, &end,
-		     (void *)_RET_IP_);
+	memblock_dbg("%llu bytes align=0x%llx from=%pa max_addr=%pa\n",
+		     (u64)size, (u64)align, &start, &end);
 	return memblock_alloc_range_nid(size, align, start, end, NUMA_NO_NODE,
 					false);
 }
@@ -1510,9 +1507,8 @@ void * __init memblock_alloc_exact_nid_r
 			phys_addr_t min_addr, phys_addr_t max_addr,
 			int nid)
 {
-	memblock_dbg("%s: %llu bytes align=0x%llx nid=%d from=%pa max_addr=%pa %pS\n",
-		     __func__, (u64)size, (u64)align, nid, &min_addr,
-		     &max_addr, (void *)_RET_IP_);
+	memblock_dbg("%llu bytes align=0x%llx nid=%d from=%pa max_addr=%pa\n",
+		     (u64)size, (u64)align, nid, &min_addr, &max_addr);
 
 	return memblock_alloc_internal(size, align, min_addr, max_addr, nid,
 				       true);
@@ -1542,9 +1538,8 @@ void * __init memblock_alloc_try_nid_raw
 			phys_addr_t min_addr, phys_addr_t max_addr,
 			int nid)
 {
-	memblock_dbg("%s: %llu bytes align=0x%llx nid=%d from=%pa max_addr=%pa %pS\n",
-		     __func__, (u64)size, (u64)align, nid, &min_addr,
-		     &max_addr, (void *)_RET_IP_);
+	memblock_dbg("%llu bytes align=0x%llx nid=%d from=%pa max_addr=%pa\n",
+		     (u64)size, (u64)align, nid, &min_addr, &max_addr);
 
 	return memblock_alloc_internal(size, align, min_addr, max_addr, nid,
 				       false);
@@ -1574,9 +1569,8 @@ void * __init memblock_alloc_try_nid(
 {
 	void *ptr;
 
-	memblock_dbg("%s: %llu bytes align=0x%llx nid=%d from=%pa max_addr=%pa %pS\n",
-		     __func__, (u64)size, (u64)align, nid, &min_addr,
-		     &max_addr, (void *)_RET_IP_);
+	memblock_dbg("%llu bytes align=0x%llx nid=%d from=%pa max_addr=%pa\n",
+		     (u64)size, (u64)align, nid, &min_addr, &max_addr);
 	ptr = memblock_alloc_internal(size, align,
 					   min_addr, max_addr, nid, false);
 	if (ptr)
@@ -1599,8 +1593,7 @@ void __init memblock_free_late(phys_addr
 	phys_addr_t cursor, end;
 
 	end = base + size - 1;
-	memblock_dbg("%s: [%pa-%pa] %pS\n",
-		     __func__, &base, &end, (void *)_RET_IP_);
+	memblock_dbg("[%pa-%pa]\n", &base, &end);
 	kmemleak_free_part_phys(base, size);
 	cursor = PFN_UP(base);
 	end = PFN_DOWN(base + size);
_

Patches currently in -mm which might be from joe@perches.com are

memblock-neaten-logging.patch

