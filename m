Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 151C8C61DA4
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjBJAsB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjBJAsA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:48:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F756BD12
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:47:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F60FB82397
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D60C433EF;
        Fri, 10 Feb 2023 00:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990072;
        bh=q1d+ox3sZUAgLoRZK22oknj+LPCLFtCmLPIO0uvWtuA=;
        h=Date:To:From:Subject:From;
        b=djgXtB/iQdGsH6VcE3L3r3Vn+BBmVElkDNC1u5E9DCCAY/DyNrmI2hHtO5KnLo1sV
         k9Ka94hDCKnY9iQBvPEn5gIUIZqjnpaMwVpXFY2P7eY7HeOmC6uinkARXOHQLSB+Vn
         QULMsAkV3rrdG/9ibLta7HYaViRzpsq2DIW8Jcxw=
Date:   Thu, 09 Feb 2023 16:47:52 -0800
To:     mm-commits@vger.kernel.org, conor.dooley@microchip.com,
        rppt@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem-fix.patch removed from -mm tree
Message-Id: <20230210004752.B9D60C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem-fix
has been removed from the -mm tree.  Its filename was
     mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem-fix.patch

This patch was dropped because it was folded into mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem.patch

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem-fix
Date: Tue, 31 Jan 2023 20:41:49 +0200

The generic pfn_valid() does not take into account pfn_offset when it
compares it with max_mapnr.

Link: https://lkml.kernel.org/r/Y9lg7R1Yd931C+y5@kernel.org
Signed-off-by: Mike Rapoport <rppt@kernel.org>
Reported-by: Conor Dooley <conor.dooley@microchip.com>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/asm-generic/memory_model.h~mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem-fix
+++ a/include/asm-generic/memory_model.h
@@ -26,7 +26,7 @@ static inline int pfn_valid(unsigned lon
 	extern unsigned long max_mapnr;
 	unsigned long pfn_offset = ARCH_PFN_OFFSET;
 
-	return pfn >= pfn_offset && pfn < max_mapnr;
+	return pfn >= pfn_offset && (pfn - pfn_offset) < max_mapnr;
 }
 #define pfn_valid pfn_valid
 #endif
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-include-asm-generic-memory_modelh-from-pageh-rather-than-memoryh.patch
m68k-use-asm-generic-memory_modelh-for-both-mmu-and-mmu.patch
mips-drop-definition-of-pfn_valid-for-discontigmem.patch
mm-arch-add-generic-implementation-of-pfn_valid-for-flatmem.patch

