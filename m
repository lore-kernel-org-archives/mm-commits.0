Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA2DC43219
	for <mm-commits@archiver.kernel.org>; Thu, 24 Nov 2022 19:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiKXTXJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Nov 2022 14:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiKXTXJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Nov 2022 14:23:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E9D62E88
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 11:23:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B156F62220
        for <mm-commits@vger.kernel.org>; Thu, 24 Nov 2022 19:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18C1C433D6;
        Thu, 24 Nov 2022 19:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669317787;
        bh=DiIVrfPBM5ed4OjvU/w+jZZDYaiM2dtZc+YCpMvuo1c=;
        h=Date:To:From:Subject:From;
        b=MGW8qLYzB4ZW80ix3VXCX75FG7BeRu4rBAIWPwJrQyIm7PXR23OhppSX3Bg/uEAN9
         hAfwPyAAnFpyLhmdi5Smp2KFLMI1MCCE60AcHZhnsWLUPFSUaPdD1M9KfoI0QfRvj3
         HfjT1p2HCPqH0Q3CCumnfOGSf9Ns77XvEYPccLbw=
Date:   Thu, 24 Nov 2022 11:23:06 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com,
        shy828301@gmail.com, mhocko@suse.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix-2.patch added to mm-hotfixes-unstable branch
Message-Id: <20221124192306.F18C1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix-2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix-2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix.patch
mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix-2.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
mm-gup-remove-foll_migration-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
mm-introduce-encoded-page-pointers-with-embedded-extra-bits-fix.patch
mm-delay-page_remove_rmap-until-after-the-tlb-has-been-flushed-fix.patch
mm-document-sys-class-bdi-bdi-min_bytes-knob-fix.patch
mm-document-sys-class-bdi-bdi-max_ratio_fine-knob-fix.patch
mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch

