Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3055CEB64DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Jul 2023 17:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjGLRgX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjGLRgW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2023 13:36:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43B11991
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 10:36:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AA1761898
        for <mm-commits@vger.kernel.org>; Wed, 12 Jul 2023 17:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C89C433B6;
        Wed, 12 Jul 2023 17:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689183379;
        bh=onGPAQrkBewBFwObFgs/uNQykl450fF8dZqNIr8PHj8=;
        h=Date:To:From:Subject:From;
        b=zmk9+qAk5W04Qt8DaHzAAWnnuYCrDvff8ubGyWdk9vRfi149lOhkwTp9DVceD1hhh
         e6fWupipz1mHAAVTQXhxPGSKVL1ejJKA5LKPSa4p9VkrpENv8fvgRM6I1UzKXMU9Gj
         GUBKouHCC7eVfzMFvj21CIxd7gzceNR+z0RrbmnU=
Date:   Wed, 12 Jul 2023 10:36:19 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        dan.carpenter@linaro.org, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch added to mm-unstable branch
Message-Id: <20230712173619.D3C89C433B6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: userfaultfd: add new UFFDIO_POISON ioctl: fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm: userfaultfd: add new UFFDIO_POISON ioctl: fix
Date: Tue, 11 Jul 2023 18:27:17 -0700 (PDT)

Smatch has observed that pte_offset_map_lock() is now allowed to fail, and
then ptl should not be unlocked.  Use -EAGAIN here like elsewhere.

Link: https://lkml.kernel.org/r/bc7bba61-d34f-ad3a-ccf1-c191585ef851@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/userfaultfd.c~mm-userfaultfd-add-new-uffdio_poison-ioctl-fix
+++ a/mm/userfaultfd.c
@@ -300,7 +300,10 @@ static int mfill_atomic_pte_poison(pmd_t
 	spinlock_t *ptl;
 
 	_dst_pte = make_pte_marker(PTE_MARKER_POISONED);
+	ret = -EAGAIN;
 	dst_pte = pte_offset_map_lock(dst_mm, dst_pmd, dst_addr, &ptl);
+	if (!dst_pte)
+		goto out;
 
 	if (mfill_file_over_size(dst_vma, dst_addr)) {
 		ret = -EFAULT;
@@ -319,6 +322,7 @@ static int mfill_atomic_pte_poison(pmd_t
 	ret = 0;
 out_unlock:
 	pte_unmap_unlock(dst_pte, ptl);
+out:
 	return ret;
 }
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch

