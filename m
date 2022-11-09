Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A382C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiKIBkw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiKIBkB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A508067F42
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66448B81CD9
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129C9C433C1;
        Wed,  9 Nov 2022 01:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957950;
        bh=YWnc69DZuP56J9kjiMyRduTaXth+4Fe5BdzG6SFh97g=;
        h=Date:To:From:Subject:From;
        b=By8f2oxx2sAVTLSt620+CYISIPZgTjKsUfNvq5L4044JkYmg5yQyNIUTQty0EABd3
         g2ytjRLmYLWXebb8c9E0w7V3eyZMTlWng0dY3AayxwwE7dgTSktATj795rhzh8VmO0
         BBRR2CaZckmQklFNhKAtNE9fdb1hQJJQqF5ZLg/A=
Date:   Tue, 08 Nov 2022 17:39:09 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com, jarkko@kernel.org,
        dinguyen@kernel.org, dave.hansen@linux.intel.com, daniel@ffwll.ch,
        christian.koenig@amd.com, alexander.deucher@amd.com,
        airlied@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-use-vm_access_flags.patch removed from -mm tree
Message-Id: <20221109013910.129C9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: mprotect: use VM_ACCESS_FLAGS
has been removed from the -mm tree.  Its filename was
     mm-mprotect-use-vm_access_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mprotect: use VM_ACCESS_FLAGS
Date: Wed, 19 Oct 2022 11:49:43 +0800

Simplify VM_READ|VM_WRITE|VM_EXEC with VM_ACCESS_FLAGS.

Link: https://lkml.kernel.org/r/20221019034945.93081-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-use-vm_access_flags
+++ a/mm/mprotect.c
@@ -756,8 +756,7 @@ static int do_mprotect_pkey(unsigned lon
 		 * If a permission is not passed to mprotect(), it must be
 		 * cleared from the VMA.
 		 */
-		mask_off_old_flags = VM_READ | VM_WRITE | VM_EXEC |
-					VM_FLAGS_CLEAR;
+		mask_off_old_flags = VM_ACCESS_FLAGS | VM_FLAGS_CLEAR;
 
 		new_vma_pkey = arch_override_mprotect_pkey(vma, prot, pkey);
 		newflags = calc_vm_prot_bits(prot, new_vma_pkey);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


