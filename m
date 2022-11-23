Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF3CC43219
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 19:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236231AbiKWT7J (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Nov 2022 14:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239952AbiKWT6G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2022 14:58:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E823617E08
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 11:57:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88FB361DB3
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 19:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E042EC433D6;
        Wed, 23 Nov 2022 19:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669233478;
        bh=SURucoY9vD8lOWQ6LVLFmPSQjNESYYOHpLxR1Tu4sxQ=;
        h=Date:To:From:Subject:From;
        b=XYyImgamJiTFVLnIWAG1iA8l8UakVDFRsyk8aQH6C3canNyPtmLFuaBTBs3EIOVZL
         Q42PgF4wIY7SPtYDsKcUSJd2gOWjlHX2T/P4YMElhDiAN3p/mQQEoT6okkmNhM18ZQ
         1pdwwsFZaI/ZM5nHaraQERKUWsgHR/GCoO2bemsU=
Date:   Wed, 23 Nov 2022 11:57:57 -0800
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20221123195757.E042EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix.patch

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

mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4-fix.patch
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

