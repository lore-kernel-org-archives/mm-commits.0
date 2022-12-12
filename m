Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE946C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiLLCSX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiLLCQq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:16:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EEBDFCB
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:15:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C93C960E14
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF11C433F0;
        Mon, 12 Dec 2022 02:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811305;
        bh=fpieZgA1trlmrEsy6sl08PkHdfIJF/xuEDBZjaWSyzM=;
        h=Date:To:From:Subject:From;
        b=e4da5lZoJ07hJ2VQkVl93TMPiHzPbKiGd6lzrfUXncV54HHVYW4iblhdWiSW/Xwyz
         fqF17kiweV6bgcixzeEoXvxvv4MSia43TGVYAIwtd+NirDNzwfBuSpcDnTlh8DIJDV
         MI36uMK8x6hyoyyLl20tvBeAQN9zTuSglXVt6EPo=
Date:   Sun, 11 Dec 2022 18:15:04 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        kirill.shutemov@linux.intel.com, emunson@akamai.com,
        Jason@zx2c4.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-do-not-show-for-vm_lockonfault-pages.patch removed from -mm tree
Message-Id: <20221212021505.2FF11C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: do not show fs mm pc for VM_LOCKONFAULT pages
has been removed from the -mm tree.  Its filename was
     mm-do-not-show-for-vm_lockonfault-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: mm: do not show fs mm pc for VM_LOCKONFAULT pages
Date: Mon, 5 Dec 2022 18:30:07 +0100

When VM_LOCKONFAULT was added, /proc/PID/smaps wasn't hooked up to it, so
looking at /proc/PID/smaps, it shows '??' instead of something
intelligable.  This can be reached by userspace by simply calling
`mlock2(..., MLOCK_ONFAULT);`.

Fix this by adding "lf" to denote VM_LOCKONFAULT.

Link: https://lkml.kernel.org/r/20221205173007.580210-1-Jason@zx2c4.com
Fixes: de60f5f10c58 ("mm: introduce VM_LOCKONFAULT")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/task_mmu.c~mm-do-not-show-for-vm_lockonfault-pages
+++ a/fs/proc/task_mmu.c
@@ -674,6 +674,7 @@ static void show_smap_vma_flags(struct s
 		[ilog2(VM_RAND_READ)]	= "rr",
 		[ilog2(VM_DONTCOPY)]	= "dc",
 		[ilog2(VM_DONTEXPAND)]	= "de",
+		[ilog2(VM_LOCKONFAULT)]	= "lf",
 		[ilog2(VM_ACCOUNT)]	= "ac",
 		[ilog2(VM_NORESERVE)]	= "nr",
 		[ilog2(VM_HUGETLB)]	= "ht",
_

Patches currently in -mm which might be from Jason@zx2c4.com are


