Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3504BC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  5 Dec 2022 20:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiLEUfM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Dec 2022 15:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbiLEUfK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Dec 2022 15:35:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD41CE0D2
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 12:35:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 498B861389
        for <mm-commits@vger.kernel.org>; Mon,  5 Dec 2022 20:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF71C433D6;
        Mon,  5 Dec 2022 20:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670272508;
        bh=q2+3d47uv8lfBwvTnfrfNKFRH3hemootcgYdEUAyp0I=;
        h=Date:To:From:Subject:From;
        b=Uncl2bKWZW3X5U0LTP+Ld4c3U72iURN4mqcnyN0OOJh282mwZXksAoQGli3Jgg2sS
         IjhMgAFqffKPPxQHGd/nHAUdJGDEnWn/Xr5ELYGZU2JouPzFEyHeAoDIN8plS/t02y
         BoUx7qiAOOzR+4Go/5r5dVCYzEs78L4GplHsaE9o=
Date:   Mon, 05 Dec 2022 12:35:07 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        kirill.shutemov@linux.intel.com, emunson@akamai.com,
        Jason@zx2c4.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-do-not-show-for-vm_lockonfault-pages.patch added to mm-unstable branch
Message-Id: <20221205203508.9FF71C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not show fs mm pc for VM_LOCKONFAULT pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-do-not-show-for-vm_lockonfault-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-do-not-show-for-vm_lockonfault-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Eric B Munson <emunson@akamai.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

mm-do-not-bug_on-missing-brk-mapping-because-userspace-can-unmap-it.patch
mm-do-not-show-for-vm_lockonfault-pages.patch

