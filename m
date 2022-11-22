Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477B1C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Nov 2022 23:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbiKVXAq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 18:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235267AbiKVXAm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 18:00:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FD158029
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 15:00:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DD457CE1FCA
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 23:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9127C433D7;
        Tue, 22 Nov 2022 23:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669158031;
        bh=HA0bPpWubAlNsgXy0xJFCH3Pzk/EMsPx/QCbj47/3i8=;
        h=Date:To:From:Subject:From;
        b=F+fpPXhpiRj3wuT7d/hJXBD1ZgQDt8vLXsl1/HetnynOt3tb6uRrAK54RWsoPYz+Q
         +Tz7LmAJb1J91zvWpjlO3GKhHdxE+CMMTOQwvN4k8o0vaY0a/AEUu6vtcsfvWFxKUz
         LkLWcaRsr8+6M/suI99CfC1q9Xq5RW+063QAnyfQ=
Date:   Tue, 22 Nov 2022 15:00:29 -0800
To:     mm-commits@vger.kernel.org, shr@devkernel.io, sfr@canb.auug.org.au,
        clm@meta.com, axboe@kernel.dk, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch added to mm-unstable branch
Message-Id: <20221122230030.D9127C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix
Date: Tue Nov 22 02:59:02 PM PST 2022

fix htmldocs warnings

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Mason <clm@meta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-bdi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/ABI/testing/sysfs-class-bdi~mm-document-sys-class-bdi-bdi-min_ratio_fine-knob-fix
+++ a/Documentation/ABI/testing/sysfs-class-bdi
@@ -54,8 +54,8 @@ Description:
 
 	The 'min_ratio_fine' parameter allows assigning a minimum reserve
 	of the write-back cache to a particular device. The value is
-    expressed as part of 1 million. For example, this is useful for
-    providing a minimum QoS.
+	expressed as part of 1 million. For example, this is useful for
+	providing a minimum QoS.
 
 	(read-write)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kbuild-fix-wimplicit-function-declaration-in-license_is_gpl_compatible-fix.patch
mm-fix-unexpected-changes-to-failslabfail_page_allocattr-fix.patch
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

