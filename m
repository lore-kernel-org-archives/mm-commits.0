Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A476C77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbjDRXNr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbjDRXNq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:13:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D104044B5
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:13:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5BCB661240
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C39C433EF;
        Tue, 18 Apr 2023 23:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681859624;
        bh=uBHvaSmtG8xtMBt4DSk745V09m12EBBKHVwOnswz7gg=;
        h=Date:To:From:Subject:From;
        b=T1DmgcgLun3rEMKK6aPoMYXuI1uB8mBu6X6YmPlaIgg+d2D7KI4HfDUa7LIGfjoFu
         2MmCcRKn12acdw3DkMIzDo+RPZSO7W5OstbAJF9Q3o+kebIalCOCsB26CNRk5pvD+Z
         jLQDSMPTkRpgMiFS2mGFylTuynKvGNUjVmX8fYLA=
Date:   Tue, 18 Apr 2023 16:13:43 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, linux@roeck-us.net,
        kirill@shutemov.name, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-treewide-redefine-max_order-sanely-fix-fix-fix.patch removed from -mm tree
Message-Id: <20230418231344.A7C39C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-treewide-redefine-max_order-sanely-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-treewide-redefine-max_order-sanely-fix-fix-fix.patch

This patch was dropped because it was folded into mm-treewide-redefine-max_order-sanely-fix-fix.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-treewide-redefine-max_order-sanely-fix-fix-fix
Date: Fri Apr  7 02:42:27 PM PDT 2023

fix comment, per Mike

Link: https://lkml.kernel.org/r/ZDBa7HWZK69dKKzH@kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memblock.c~mm-treewide-redefine-max_order-sanely-fix-fix-fix
+++ a/mm/memblock.c
@@ -2047,7 +2047,7 @@ static void __init __free_pages_memory(u
 		 * Free the pages in the largest chunks alignment allows.
 		 *
 		 * __ffs() behaviour is undefined for 0. start == 0 is
-		 * MAX_ORDER-aligned, Set order to MAX_ORDER for the case.
+		 * MAX_ORDER-aligned, set order to MAX_ORDER for the case.
 		 */
 		if (start)
 			order = min_t(int, MAX_ORDER, __ffs(start));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-treewide-redefine-max_order-sanely-fix-fix.patch
mm-khugepaged-fix-kernel-bug-in-hpage_collapse_scan_file-fix.patch
memcg-do-not-drain-charge-pcp-caches-on-remote-isolated-cpus-fix.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case-fix.patch
scripts-gdb-create-linux-vfspy-for-vfs-related-gdb-helpers-fix.patch

