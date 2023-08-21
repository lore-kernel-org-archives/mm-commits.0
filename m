Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B85FCEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbjHUU2h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjHUU2h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:28:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D49110
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:28:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9941163E8D
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2D2C433C8;
        Mon, 21 Aug 2023 20:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692649715;
        bh=7AweA+7haw+iSB0hAa+KSMAmKKgzAZXaQsjBVPTJAZo=;
        h=Date:To:From:Subject:From;
        b=gk8oM9JVzrnj4ZuxCiyAjMpRxhegHcshiOoihNWBt6OEK8or858D9i1pRRe5H7xZ4
         dclKb75SPehWKUft5g1wqi0BoO/H0fUxd442jTtBYOXa5qVc2u3t+yVpzOZjjMKRnN
         Aav0zg+UrKewcmgE43HdcXuAOfrg+d1dseProbig=
Date:   Mon, 21 Aug 2023 13:28:34 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com,
        Liam.Howlett@oracle.com, jannh@google.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-always-lock-new-vma-before-inserting-into-vma-tree-fix.patch removed from -mm tree
Message-Id: <20230821202834.EC2D2C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-always-lock-new-vma-before-inserting-into-vma-tree-fix
has been removed from the -mm tree.  Its filename was
     mm-always-lock-new-vma-before-inserting-into-vma-tree-fix.patch

This patch was dropped because it was folded into mm-always-lock-new-vma-before-inserting-into-vma-tree.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-always-lock-new-vma-before-inserting-into-vma-tree-fix
Date: Mon Aug 14 12:13:22 PM PDT 2023

fix reject fixing in vma_link(), per Jann

Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmap.c~mm-always-lock-new-vma-before-inserting-into-vma-tree-fix
+++ a/mm/mmap.c
@@ -401,10 +401,10 @@ static int vma_link(struct mm_struct *mm
 	if (vma_iter_prealloc(&vmi, vma))
 		return -ENOMEM;
 
-	vma_iter_store(&vmi, vma);
-
 	vma_start_write(vma);
 
+	vma_iter_store(&vmi, vma);
+
 	if (vma->vm_file) {
 		mapping = vma->vm_file->f_mapping;
 		i_mmap_lock_write(mapping);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-always-lock-new-vma-before-inserting-into-vma-tree.patch
mm-fix-get_mctgt_type-kernel-doc-fix.patch

