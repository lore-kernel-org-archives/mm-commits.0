Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1754BC433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA10321582
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630892;
	bh=DBzteXfjJaxCrG9haRe+7VYBG0uX3U1juz03VuuF/EA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Y5PHO5EtEmmomk5DQcBU8EaELPOq4enwQfULjR38K+DOMvSfvEIFSplC+itBsBW7W
	 h5kqxZbt+L9yE5vr6LIASa4Ul1hvCoPvDsjvEZkmqRLtmjDemhjpmOuZpOvX2etvue
	 xcR0ERHMrzaxywFGGIGzObmv0OjwHBwC1gJmsCs4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgJMXOw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:14:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727344AbgJMXOw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:14:52 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 341E121D7B;
        Tue, 13 Oct 2020 23:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630891;
        bh=DBzteXfjJaxCrG9haRe+7VYBG0uX3U1juz03VuuF/EA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=c1tQUJRJJJ/MAp07764aZsSmNWRIQEYIPNLJLkQQn0vR25irUrUJo+YERJm8s7ZXE
         9sik9FeC/mZkdcx3myNLU64J8MokgGVhc+/h6VyaLx32x/Nb+I+M5Rvbo2HJPgU8an
         FjPkwGMsxE04mJmJSwZvIZCnJWOktKIfdsuBqpsg=
Date:   Tue, 13 Oct 2020 16:14:50 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, lkp@intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        sfr@canb.auug.org.au
Subject:  [folded-merged]
 arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
 removed from -mm tree
Message-ID: <20201013231450.P42ezYN2_%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix
has been removed from the -mm tree.  Its filename was
     arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch

This patch was dropped because it was folded into arch-drivers-replace-for_each_membock-with-for_each_mem_range.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix

fix arch/arm/mm/pmsa-v7.c build

Reported-by: kernel test robot <lkp@intel.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/pmsa-v7.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mm/pmsa-v7.c~arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix
+++ a/arch/arm/mm/pmsa-v7.c
@@ -273,7 +273,7 @@ void __init pmsav7_adjust_lowmem_bounds(
 				panic("First memory bank must be contiguous from PHYS_OFFSET");
 
 			mem_start = reg_start;
-			mem_end = reg_end
+			mem_end = reg_end;
 			specified_mem_size = mem_end - mem_start;
 		} else {
 			/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-drivers-replace-for_each_membock-with-for_each_mem_range.patch
mm.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-memory_hotplug-simplify-page-offlining-fix.patch
checkpatch-warn-on-self-assignments-checkpatch-fixes.patch
checkpatch-emit-a-warning-on-embedded-filenames-fix.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
fs-fuse-virtio_fsc-fix-for-mm-memremap_pages-convert-to-struct-range.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix-fix-fix-fix-fix-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

