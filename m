Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88367C7EE2E
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbjFLVce (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjFLVce (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:32:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C62690
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:32:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C50E96175D
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25181C433EF;
        Mon, 12 Jun 2023 21:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686605552;
        bh=rfl5g+9YDKNW290TxycYrVijYM34+TzKyt/S90lshpo=;
        h=Date:To:From:Subject:From;
        b=LzCMs78gtcDS3GOiDMrwmcDaK0Mzm3iQJ+mkuOSFlsKv6ZgI0aStsOWbf5XYKMRuB
         4tqvcCUaU0RcmnpZKernXPumRPHPKLTt5dFXccJREPVtNtJNKE8uNcuFlh5HoUCWJM
         qgjkZrYCgMzf2AgFDkfrmjllu8g0dfHOez+45rOQ=
Date:   Mon, 12 Jun 2023 14:32:31 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com,
        yuehaibing@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unused-vma_init_lock.patch added to mm-unstable branch
Message-Id: <20230612213232.25181C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unused vma_init_lock()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-unused-vma_init_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unused-vma_init_lock.patch

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
From: YueHaibing <yuehaibing@huawei.com>
Subject: mm: remove unused vma_init_lock()
Date: Sat, 10 Jun 2023 18:19:56 +0800

commit c7f8f31c00d1 ("mm: separate vma->lock from vm_area_struct")
left this behind.

Link: https://lkml.kernel.org/r/20230610101956.20592-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mm.h~mm-remove-unused-vma_init_lock
+++ a/include/linux/mm.h
@@ -725,7 +725,6 @@ struct vm_area_struct *lock_vma_under_rc
 
 #else /* CONFIG_PER_VMA_LOCK */
 
-static inline void vma_init_lock(struct vm_area_struct *vma) {}
 static inline bool vma_start_read(struct vm_area_struct *vma)
 		{ return false; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
_

Patches currently in -mm which might be from yuehaibing@huawei.com are

kernel-pid_namespace-remove-unused-set_memfd_noexec_scope.patch
mm-remove-unused-vma_init_lock.patch

