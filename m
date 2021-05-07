Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2426C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 00:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9781C61104
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 00:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhEGALh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 20:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233434AbhEGALh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 20:11:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D98361164;
        Fri,  7 May 2021 00:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620346238;
        bh=QR9qlcN22Ce5Pt+qrrb0P/K5800nmoN+uKjPODI8pMI=;
        h=Date:From:To:Subject:From;
        b=Cr5Ne7WsfazQnjmcz+BA12gcZJPK7U4vKnAtk9ETa/ix9e/YiT5OFmGOIO5bxTLHs
         Hu65Vw9SshufJvZUbBBlG9XzfDEd5ZG9aDQ0eP9R8YHG8/FapNlWvNx+W1+TMJawCE
         G/Zg/hNuKhpRjxpN4gXIKjODlDF8nJKgRnO7k5Bo=
Date:   Thu, 06 May 2021 17:10:37 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, apopple@nvidia.com, lkp@intel.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?kernel-resource-allow-region=5Fintersects-users-to-hold-res?=
 =?US-ASCII?Q?ource=5Flock-fix.patch?= removed from -mm tree
Message-ID: <20210507001037.xhL-1AmWJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix
has been removed from the -mm tree.  Its filename was
     kernel-resource-allow-region_intersects-users-to-hold-resource_lock-fix.patch

This patch was dropped because it was folded into kernel-resource-allow-region_intersects-users-to-hold-resource_lock.patch

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

kernel-resource-allow-region_intersects-users-to-hold-resource_lock.patch
mm.patch
linux-next-rejects.patch
cifsd-is-broken.patch
kernel-forkc-export-kernel_thread-to-modules.patch

