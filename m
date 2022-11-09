Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1675BC43217
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiKIBko (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiKIBkB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843406713B
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E8CAB81CDA
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF19C433B5;
        Wed,  9 Nov 2022 01:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957948;
        bh=FkCymwrpp/Wiw2oz9eeoaQgbYOovbq5HM77J8gYqWN4=;
        h=Date:To:From:Subject:From;
        b=iPTLzb/1SplDV1Lcb5Uq1336D+X2XFCwxgvTHqgzvk6rH4LZxIIYL43kVCKcHoq1K
         pfnPSastANu+FxA8NeUJKlZw/38t6sUBHIYKC1/1AJQNWcbUAmrlW/PqiHNqPOw/X3
         3xgcUIcKZ83n8A/CPyOuZ+ClfntbJm3oUIpOMHf0=
Date:   Tue, 08 Nov 2022 17:39:08 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com, jarkko@kernel.org,
        dinguyen@kernel.org, dave.hansen@linux.intel.com, daniel@ffwll.ch,
        christian.koenig@amd.com, alexander.deucher@amd.com,
        airlied@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-sgx-use-vm_access_flags.patch removed from -mm tree
Message-Id: <20221109013908.DBF19C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: x86/sgx: use VM_ACCESS_FLAGS
has been removed from the -mm tree.  Its filename was
     x86-sgx-use-vm_access_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: x86/sgx: use VM_ACCESS_FLAGS
Date: Wed, 19 Oct 2022 11:49:42 +0800

Simplify VM_READ|VM_WRITE|VM_EXEC with VM_ACCESS_FLAGS.

Link: https://lkml.kernel.org/r/20221019034945.93081-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/sgx/encl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/sgx/encl.c~x86-sgx-use-vm_access_flags
+++ a/arch/x86/kernel/cpu/sgx/encl.c
@@ -268,7 +268,7 @@ static struct sgx_encl_page *sgx_encl_lo
 						       unsigned long addr,
 						       unsigned long vm_flags)
 {
-	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
+	unsigned long vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
 	struct sgx_encl_page *entry;
 
 	entry = xa_load(&encl->page_array, PFN_DOWN(addr));
@@ -502,7 +502,7 @@ static void sgx_vma_open(struct vm_area_
 int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
 		     unsigned long end, unsigned long vm_flags)
 {
-	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
+	unsigned long vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
 	struct sgx_encl_page *page;
 	unsigned long count = 0;
 	int ret = 0;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


