Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 704A0C05027
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjBJAqs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjBJAqr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:46:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624F91714
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:46:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11ADDB82395
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2ECC4339B;
        Fri, 10 Feb 2023 00:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990002;
        bh=g3fp9CNaQWTfnZF+uGVdgoWwvG0kKyXVfChX0KdYZFk=;
        h=Date:To:From:Subject:From;
        b=jxYsiDfhajm1insccbkX9Bx7sIwBQdFMZBujt8HJ3gmFU0Hcq30RJFIXC3zJXwIjz
         snU1qoMjiTZ/gWZOaWwjzs/sboNoBIElb28xCJ7NYNZ/GaNKLq6JWS8Rl64H93S+xi
         XMj7XI6JYxpoFgEp7JHl2vjNdU4cMfj8ztrifQSw=
Date:   Thu, 09 Feb 2023 16:46:42 -0800
To:     mm-commits@vger.kernel.org, surenb@google.com, 42.hyeyoo@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch removed from -mm tree
Message-Id: <20230210004642.AE2ECC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix
has been removed from the -mm tree.  Its filename was
     mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch

This patch was dropped because it was folded into mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix
Date: Tue Jan 31 12:50:59 PM PST 2023

fix drivers/misc/open-dice.c, per Hyeonggon Yoo

Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/misc/open-dice.c~mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix
+++ a/drivers/misc/open-dice.c
@@ -95,7 +95,7 @@ static int open_dice_mmap(struct file *f
 		if (vma->vm_flags & VM_WRITE)
 			return -EPERM;
 		/* Ensure userspace cannot acquire VM_WRITE later. */
-		vm_flags_clear(vma, VM_MAYSHARE);
+		vm_flags_clear(vma, VM_MAYWRITE);
 	}
 
 	/* Create write-combine mapping so all clients observe a wipe. */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls.patch
kasan-infer-allocation-size-by-scanning-metadata-fix.patch
shmem-add-shmem_read_folio-and-shmem_read_folio_gfp-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

