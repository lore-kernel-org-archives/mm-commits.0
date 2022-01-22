Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C733C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiAVBWZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiAVBWZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:22:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3576CC06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 17:22:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 93792CE2514
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43B6C340E4;
        Sat, 22 Jan 2022 01:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814541;
        bh=vDyTpALHmPIy/RWiQ8QmtmXIxuKThR9cLBnUzOcw380=;
        h=Date:From:To:Subject:From;
        b=N3K2xqUwT0me9Ej/axtdbP7sHgzdF7CxhuBNZF+XZQkBSO+4rt9y8gFzUhEP3KkvP
         ZYtmVoiU4t3z2EvPoZDHZOHYwkYdnKWh1ymjvLttAykJGOONNZJwaGzV5UQ4xd6mXm
         ZDo8Jnc7r5KFPBG+y5ZAuLnGJT9Hmw/mYgtY7Fy0=
Date:   Fri, 21 Jan 2022 17:22:21 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, lkp@intel.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        songmuchun@bytedance.com
Subject:  [folded-merged]
 proc-remove-pde_data-completely-fix-fix.patch removed from -mm tree
Message-ID: <20220122012221.kRWwYhea1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc-remove-pde_data-completely-fix-fix
has been removed from the -mm tree.  Its filename was
     proc-remove-pde_data-completely-fix-fix.patch

This patch was dropped because it was folded into proc-remove-pde_data-completely.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-remove-pde_data-completely-fix-fix

Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/nubus/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nubus/proc.c~proc-remove-pde_data-completely-fix-fix
+++ a/drivers/nubus/proc.c
@@ -93,7 +93,7 @@ struct nubus_proc_pde_data {
 static struct nubus_proc_pde_data *
 nubus_proc_alloc_pde_data(unsigned char *ptr, unsigned int size)
 {
-	struct nubus_proc_pded *pded;
+	struct nubus_proc_pde_data *pded;
 
 	pded = kmalloc(sizeof(*pded), GFP_KERNEL);
 	if (!pded)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

proc-remove-pde_data-completely.patch
mm-remove-cleancache-fix.patch
mm-simplify-try_to_unuse-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
arch-x86-include-asm-pgtableh-needs-spinlockh.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

