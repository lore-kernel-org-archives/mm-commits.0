Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC08C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiKIBko (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiKIBjv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:39:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F25067133
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 185ECB81CD8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B1BC433D6;
        Wed,  9 Nov 2022 01:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957947;
        bh=vmMPy5rLF7QAksComtCbBfceG+EziFxDHD0HzzhIzYQ=;
        h=Date:To:From:Subject:From;
        b=PvRIKgovA/ouOZdT1daXlBqiKsAkrOp0a3i4124J5NdM9utgsh6TLQpLj3ekdplrh
         0XCIRUu9Kvx3BnOKucU7D3+ihfhUvzSzedwiJ2nt0qyv1fpgFT/g5tucIToVBSMsBS
         iyloeuYTkiSJrYh9621+WO17njd9HYofIrtflPkQ=
Date:   Tue, 08 Nov 2022 17:39:07 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com, jarkko@kernel.org,
        dinguyen@kernel.org, dave.hansen@linux.intel.com, daniel@ffwll.ch,
        christian.koenig@amd.com, alexander.deucher@amd.com,
        airlied@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] nios2-remove-unused-init_mmap.patch removed from -mm tree
Message-Id: <20221109013907.B5B1BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nios2: remove unused INIT_MMAP
has been removed from the -mm tree.  Its filename was
     nios2-remove-unused-init_mmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: nios2: remove unused INIT_MMAP
Date: Wed, 19 Oct 2022 11:49:41 +0800

Patch series "mm: cleanup with VM_ACCESS_FLAGS".


This patch (of 5):

It seems that INIT_MMAP is gone in 2.4.10, not sure, anyways, it is
useless now, kill it.

Link: https://lkml.kernel.org/r/20221019034945.93081-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20221019034945.93081-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/include/asm/processor.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/nios2/include/asm/processor.h~nios2-remove-unused-init_mmap
+++ a/arch/nios2/include/asm/processor.h
@@ -50,9 +50,6 @@ struct thread_struct {
 	unsigned long kpsr;
 };
 
-#define INIT_MMAP \
-	{ &init_mm, (0), (0), __pgprot(0x0), VM_READ | VM_WRITE | VM_EXEC }
-
 # define INIT_THREAD {			\
 	.kregs	= NULL,			\
 	.ksp	= 0,			\
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


