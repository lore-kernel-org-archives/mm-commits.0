Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BA5C43217
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiKIBky (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiKIBkC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3D467F4D
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4E08B81CD8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D33C433D7;
        Wed,  9 Nov 2022 01:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957952;
        bh=G3f32zqsH33/Iu0i6rLgt9OGIOl4UKV1ei61lmCJ4RI=;
        h=Date:To:From:Subject:From;
        b=rCqGuFJ5LohV0mTk2dxLfpT1xkgW+ygGROHqJDX8+YXRzkrSwp8xtr00HKfk6p/RN
         jM3t4k8m1/FusRjQmnEppRqFpBl4kg04GNk0FxXWiR8A9G+plf6Tkvb+waMxDAVzCF
         KS7b3masoYiomSI4dCi5NOXYSl+dJVvHA+50rPKI=
Date:   Tue, 08 Nov 2022 17:39:11 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com, jarkko@kernel.org,
        dinguyen@kernel.org, dave.hansen@linux.intel.com, daniel@ffwll.ch,
        christian.koenig@amd.com, alexander.deucher@amd.com,
        airlied@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] amdgpu-use-vm_access_flags.patch removed from -mm tree
Message-Id: <20221109013912.77D33C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: amdgpu: use VM_ACCESS_FLAGS
has been removed from the -mm tree.  Its filename was
     amdgpu-use-vm_access_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: amdgpu: use VM_ACCESS_FLAGS
Date: Wed, 19 Oct 2022 11:49:45 +0800

Simplify VM_READ|VM_WRITE|VM_EXEC with VM_ACCESS_FLAGS.

Link: https://lkml.kernel.org/r/20221019034945.93081-6-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c~amdgpu-use-vm_access_flags
+++ a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -255,7 +255,7 @@ static int amdgpu_gem_object_mmap(struct
 	 * becoming writable and makes is_cow_mapping(vm_flags) false.
 	 */
 	if (is_cow_mapping(vma->vm_flags) &&
-	    !(vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC)))
+	    !(vma->vm_flags & VM_ACCESS_FLAGS))
 		vma->vm_flags &= ~VM_MAYWRITE;
 
 	return drm_gem_ttm_mmap(obj, vma);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


