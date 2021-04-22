Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94CB2C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 00:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7124C61445
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 00:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343832AbhDVAJC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Apr 2021 20:09:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235036AbhDVAJB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 21 Apr 2021 20:09:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 176F8613C2;
        Thu, 22 Apr 2021 00:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619050106;
        bh=XeStRLvsnNZN6bQtNIJQrxg3Zh3/X0oH88KGm8++iTk=;
        h=Date:From:To:Subject:From;
        b=GrU00FrxrZJXvY/90lI0T/65GAcQUvToF4gCxZrlW0AxvN4ndvJDbENNYxKI5pMcz
         IINiF2Imt1gdqHRfyiySOyXKVmwo9CF1Yx+LZ9iEc2pSilEYylI3Xe8l9hu7rms32B
         McZW1tikE+GFGgfe7knbf2XA02DalagwM8KnQS6U=
Date:   Wed, 21 Apr 2021 17:08:25 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, apopple@nvidia.com, lkp@intel.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?kernel-resource-allow-region=5Fintersects-users-to-hold-res?=
 =?US-ASCII?Q?ource=5Flock-fix.patch?= added to -mm tree
Message-ID: <20210422000825.f_cdxEwZK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix
has been added to the -mm tree.  Its filename is
     kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix

make __region_intersects static

Reported-by: kernel test robot <lkp@intel.com>
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/resource.c~kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix
+++ a/kernel/resource.c
@@ -502,8 +502,8 @@ int __weak page_is_ram(unsigned long pfn
 }
 EXPORT_SYMBOL_GPL(page_is_ram);
 
-int __region_intersects(resource_size_t start, size_t size, unsigned long flags,
-			unsigned long desc)
+static int __region_intersects(resource_size_t start, size_t size,
+			unsigned long flags, unsigned long desc)
 {
 	struct resource res;
 	int type = 0; int other = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

scripts-a-new-script-for-checking-duplicate-struct-declaration-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-vmalloc-remove-unmap_kernel_range-fix-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mm-drop-redundant-arch_enable__migration-fix.patch
mm-drop-redundant-arch_enable__migration-fix-fix.patch
kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

