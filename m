Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F91AC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237103AbjHKXB3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237155AbjHKXAD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:00:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D5C3AB6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0DD1678C4
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2273EC433C7;
        Fri, 11 Aug 2023 22:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794795;
        bh=P9gfkRwrPUm+RWO7ZXMQxreoWuTKQmKyexfGg6hWoMA=;
        h=Date:To:From:Subject:From;
        b=yahBKR8j4W35j5IN+ANFlun0CgAg49q8EalLAzFKXH7n+c0rfdBT91n0KB6Tirkrg
         vvoWdQiZyPZdlJsOyupdmP0pgnt3YGZWuPvApNH7LXNcGCkJ10KjaDwBxUiqFAz6jh
         TUwlPKk6ZfLeMrigOuRuQLhw7KDeMMXSMsDafSg4=
Date:   Fri, 11 Aug 2023 15:59:54 -0700
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        dan.carpenter@linaro.org, axelrasmussen@google.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch removed from -mm tree
Message-Id: <20230811225955.2273EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: userfaultfd: add new UFFDIO_POISON ioctl: fix
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-add-new-uffdio_poison-ioctl-fix.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: userfaultfd: add new UFFDIO_POISON ioctl: fix
Date: Tue, 11 Jul 2023 18:27:17 -0700 (PDT)

Smatch has observed that pte_offset_map_lock() is now allowed to fail, and
then ptl should not be unlocked.  Use -EAGAIN here like elsewhere.

Link: https://lkml.kernel.org/r/bc7bba61-d34f-ad3a-ccf1-c191585ef851@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
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


