Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47339C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 18:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3348C6128B
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 18:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234715AbhJSSlc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 14:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234124AbhJSSl3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 14:41:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1410610E5;
        Tue, 19 Oct 2021 18:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634668756;
        bh=FBMCkHYuR68XY7av8mjXRpsPW9EWgSPbC7bVSdmPwNs=;
        h=Date:From:To:Subject:From;
        b=2eNbom1RHVVDtMTCARIIHBLOugfZPeyyfhcdQLo7kWSDewFPXwzYFOjOEvc7q30pL
         LrazaCm7qxOgKy+lDyeCf8NIfCwu+vMKtlyBVroZ7IcqOQYwp5UO1bo13UBJLxl4me
         zkD/04ivopyWbMU+2nYE0KEpPxSrz43AnW848ss0=
Date:   Tue, 19 Oct 2021 11:39:16 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, geert+renesas@glider.be,
        mm-commits@vger.kernel.org, peng.fan@nxp.com, rppt@linux.ibm.com
Subject:  [merged] memblock-check-memory-total_size.patch removed
 from -mm tree
Message-ID: <20211019183916.caww4l0C2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: check memory total_size
has been removed from the -mm tree.  Its filename was
     memblock-check-memory-total_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peng Fan <peng.fan@nxp.com>
Subject: memblock: check memory total_size

mem=[X][G|M] is broken on ARM64 platform, there are cases that even
type.cnt is 1, but total_size is not 0 because regions are merged into 1. 
So only check 'cnt' is not enough, total_size should be used, othersize
bootargs 'mem=[X][G|B]' not work anymore.

Link: https://lkml.kernel.org/r/20210930024437.32598-1-peng.fan@oss.nxp.com
Fixes: e888fa7bb882 ("memblock: Check memory add/cap ordering")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memblock.c~memblock-check-memory-total_size
+++ a/mm/memblock.c
@@ -1692,7 +1692,7 @@ void __init memblock_cap_memory_range(ph
 	if (!size)
 		return;
 
-	if (memblock.memory.cnt <= 1) {
+	if (!memblock_memory->total_size) {
 		pr_warn("%s: No memory registered yet\n", __func__);
 		return;
 	}
_

Patches currently in -mm which might be from peng.fan@nxp.com are


