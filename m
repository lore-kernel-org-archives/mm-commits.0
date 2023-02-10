Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E36C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:57:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjBJA5K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjBJAz0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7E86F8D4
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 897D8B822D1
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C5DC433EF;
        Fri, 10 Feb 2023 00:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990466;
        bh=ydxPoDCcT64JIAl0Ey9VznVC559wb/Wk3FV2FDDX+iE=;
        h=Date:To:From:Subject:From;
        b=GxSdads5quaCys/ckr2SYdFKwu7zno2h4cUVceL6ju3D5m5Ee/GIuHfk4hb1Tj1GH
         f981g7YEt1CEOTzODOToDPl36ifjrWci3zz5O58ESfpXGkhV6iNa5DXE0RGwnmSFqV
         E/jQrdXCZ+hziesSE5YR/ujpr4n7gCjPAzl7N2OM=
Date:   Thu, 09 Feb 2023 16:54:25 -0800
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        stephen.s.brennan@oracle.com, lstoakes@gmail.com,
        error27@gmail.com, bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch removed from -mm tree
Message-Id: <20230210005426.46C5DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sh: mm: set VM_IOREMAP flag to the vmalloc area
has been removed from the -mm tree.  Its filename was
     sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: sh: mm: set VM_IOREMAP flag to the vmalloc area
Date: Mon, 6 Feb 2023 16:40:20 +0800

Currently, for vmalloc areas with flag VM_IOREMAP set, except of the
specific alignment clamping in __get_vm_area_node(), they will be

1) Shown as ioremap in /proc/vmallocinfo;

2) Ignored by /proc/kcore reading via vread()

So for the ioremap in __sq_remap() of sh, we should set VM_IOREMAP in flag
to make it handled correctly as above.

Link: https://lkml.kernel.org/r/20230206084020.174506-8-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/cpu/sh4/sq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/kernel/cpu/sh4/sq.c~sh-mm-set-vm_ioremap-flag-to-the-vmalloc-area
+++ a/arch/sh/kernel/cpu/sh4/sq.c
@@ -103,7 +103,7 @@ static int __sq_remap(struct sq_mapping
 #if defined(CONFIG_MMU)
 	struct vm_struct *vma;
 
-	vma = __get_vm_area_caller(map->size, VM_ALLOC, map->sq_addr,
+	vma = __get_vm_area_caller(map->size, VM_IOREMAP, map->sq_addr,
 			SQ_ADDRMAX, __builtin_return_address(0));
 	if (!vma)
 		return -ENOMEM;
_

Patches currently in -mm which might be from bhe@redhat.com are


