Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB18BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 21:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiANV21 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 16:28:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44790 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiANV21 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 16:28:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24B93B82A34
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 21:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89A5C36AE5;
        Fri, 14 Jan 2022 21:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642195704;
        bh=3UnjBlufYg/QzoxYi9zuBT/Q5NyT0Ys6IObxNV9G+GU=;
        h=Date:From:To:Subject:From;
        b=xMafZM1EEGHjGG9x4pR4JRwOfdNVVfhf7h5Jug+KZtXe/Xf9DiKYSc1/i/1S+iJSY
         wmfGvwSZ/tGb3/F4olVZN2ioyqxUvnlbPuUTHfPBww+wpxUfhxZRoDW5rHlhePTzC2
         sZcjalAom9TRqL94j2VCrL3xPBknj1QIF0O1LjIg=
Date:   Fri, 14 Jan 2022 13:28:24 -0800
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 mm-vmalloc-alloc-gfp_nofsio-for-vmalloc-fix.patch removed from -mm tree
Message-ID: <20220114212824.f71NjzejF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-alloc-gfp_nofsio-for-vmalloc-fix.patch

This patch was dropped because it was folded into mm-vmalloc-alloc-gfp_nofsio-for-vmalloc.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc fix

Link: https://lkml.kernel.org/r/20211217232641.0148710c@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmalloc.c~mm-vmalloc-alloc-gfp_nofsio-for-vmalloc-fix
+++ a/mm/vmalloc.c
@@ -39,6 +39,7 @@
 #include <linux/pgtable.h>
 #include <linux/uaccess.h>
 #include <linux/hugetlb.h>
+#include <linux/sched/mm.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-vmalloc-alloc-gfp_nofsio-for-vmalloc.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-3.patch

