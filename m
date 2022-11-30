Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59EDC47088
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 22:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiK3WrT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 17:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiK3WrR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 17:47:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CA08DBDD
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 14:47:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AD1161E1E
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 22:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC48C433C1;
        Wed, 30 Nov 2022 22:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848435;
        bh=kcGD8xUSCBsOnv70RmwmyFo/QoTu1WloqGjZzzIIZLo=;
        h=Date:To:From:Subject:From;
        b=qVCizYpA/xrFe2RbLY6/LCHeuajaj8GwdWfU1EtcljOnK73VW8uJPCGYOly/jyVya
         F0dKq7kOMqIbf+gy+zejjO2PF8OqmxVRH3vQlHZEuTvVRZr1S+/SKxE83VwzFJfsl8
         lqnrdrjTo6HSKR4L3mnb0X6xPmUGJnAuP5NouPWQ=
Date:   Wed, 30 Nov 2022 14:47:14 -0800
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix.patch removed from -mm tree
Message-Id: <20221130224715.6EC48C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix
has been removed from the -mm tree.  Its filename was
     mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix.patch

This patch was dropped because it was folded into mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix
Date: Wed Nov 23 11:56:07 AM PST 2022

fix whitespace

Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/gfp.h~mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix
+++ a/include/linux/gfp.h
@@ -217,7 +217,7 @@ static inline void warn_if_node_offline(
 	if (warn_gfp != (__GFP_THISNODE|__GFP_NOWARN))
 		return;
 
-	if(node_online(this_node))
+	if (node_online(this_node))
 		return;
 
 	pr_warn("%pGg allocation from offline node %d\n", &warn_gfp, this_node);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode.patch
mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix-2.patch
revert-kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch
mm-document-sys-class-bdi-bdi-min_bytes-knob-fix.patch
mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch

