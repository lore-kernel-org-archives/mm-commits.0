Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3552EC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 22 Dec 2021 03:43:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242160AbhLVDnN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 22:43:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54658 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhLVDnN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 22:43:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A89E16181A
        for <mm-commits@vger.kernel.org>; Wed, 22 Dec 2021 03:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE16C36AE8;
        Wed, 22 Dec 2021 03:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640144592;
        bh=5CfGDK8JmtnmsdCxtY2UdZBVmlcQY6bhuQQb1KJ2OVY=;
        h=Date:From:To:Subject:From;
        b=ikauw730ZNfr71HHEJC5wSVON5JglqZNuUinpuL0vdZmGUqJZ8pMzVS4movb0kgKa
         yWWDChsK6Dy2FXkFe9Pg5xANaNoS9iOhn1urBL/eWnWg2p+wuI9b5uUpJADtyKoc7V
         0Bkl0hp9xgbmCJbLJJwiWzPAPd0FavPkL1jU6hMU=
Date:   Tue, 21 Dec 2021 19:43:11 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mhocko@suse.com, sfr@canb.auug.org.au
Subject:  + mm-vmalloc-alloc-gfp_nofsio-for-vmalloc-fix.patch added
 to -mm tree
Message-ID: <20211222034311.VTl5j%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc fix
has been added to the -mm tree.  Its filename is
     mm-vmalloc-alloc-gfp_nofsio-for-vmalloc-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-alloc-gfp_nofsio-for-vmalloc-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-alloc-gfp_nofsio-for-vmalloc-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmalloc-alloc-gfp_nofsio-for-vmalloc-fix.patch
firmware_loader-move-firmware-sysctl-to-its-own-files-fix-3.patch

