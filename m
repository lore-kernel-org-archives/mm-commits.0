Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 547D3C4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 22:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiK3Wr0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 17:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiK3WrU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 17:47:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB628E592
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 14:47:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23F7EB81D4B
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 22:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04DBC433B5;
        Wed, 30 Nov 2022 22:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848436;
        bh=maSIxth3hFqHmkL5TeaZyvjRultDqgPmSng++B3mrAU=;
        h=Date:To:From:Subject:From;
        b=0cwU340xr/fonVybbj2hvL+xwieIdFM7JGvL+u2A3FaqN/IsTO87qp1WfjlJNdq7B
         GSsXEwQL/aj/NZVQj2o4bSxMHbuEG9vfgbKtJKhfiFm4WUkNU717+jTy64xEQf6wKf
         HEEzvh15/0dAMFoMxsYEXkG/gyxBEcnGW/oKt+V8=
Date:   Wed, 30 Nov 2022 14:47:16 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        shy828301@gmail.com, mhocko@suse.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix-2.patch removed from -mm tree
Message-Id: <20221130224716.C04DBC433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix-2
has been removed from the -mm tree.  Its filename was
     mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix-2.patch

This patch was dropped because it was folded into mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix-2
Date: Thu Nov 24 11:21:47 AM PST 2022

print gfp_mask instead of warn_gfp, per Michel

Cc: Michal Hocko <mhocko@suse.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/gfp.h~mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix-2
+++ a/include/linux/gfp.h
@@ -220,7 +220,7 @@ static inline void warn_if_node_offline(
 	if (node_online(this_node))
 		return;
 
-	pr_warn("%pGg allocation from offline node %d\n", &warn_gfp, this_node);
+	pr_warn("%pGg allocation from offline node %d\n", &gfp_mask, this_node);
 	dump_stack();
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode.patch
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

