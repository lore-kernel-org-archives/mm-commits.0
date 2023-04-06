Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C84A3C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 03:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbjDFDEd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 23:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234826AbjDFDEG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 23:04:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A258683FD
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 20:03:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39B04640CA
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 03:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90379C433EF;
        Thu,  6 Apr 2023 03:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680750232;
        bh=wEKipNnNyckevjVbKv7CLEqlIIeb3YpY21F42XQgs54=;
        h=Date:To:From:Subject:From;
        b=fsvvvMEEo2G5ZAV1igXjXkFu44J+I0OCpJ0XjLhoqeYaMEOjM1ezD1svfiwmxcbmC
         L+Q3dnnYaSyxVcqKiSadu1nzcbMREONAjSrPF87+qDNOtX6f0HvF4BDk30JbstewUz
         FiOvoEmLVFduasHPqlmTShn++DQRHq6Vf3nQUBrU=
Date:   Wed, 05 Apr 2023 20:03:52 -0700
To:     mm-commits@vger.kernel.org, laurent.dufour@fr.ibm.com,
        surenb@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-prevent-do_swap_page-from-handling-page-faults-under-vma-lock.patch removed from -mm tree
Message-Id: <20230406030352.90379C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: prevent do_swap_page from handling page faults under VMA lock
has been removed from the -mm tree.  Its filename was
     mm-prevent-do_swap_page-from-handling-page-faults-under-vma-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: prevent do_swap_page from handling page faults under VMA lock
Date: Mon, 27 Feb 2023 09:36:25 -0800

Due to the possibility of do_swap_page dropping mmap_lock, abort fault
handling under VMA lock and retry holding mmap_lock.  This can be handled
more gracefully in the future.

Link: https://lkml.kernel.org/r/20230227173632.3292573-27-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Laurent Dufour <laurent.dufour@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/memory.c~mm-prevent-do_swap_page-from-handling-page-faults-under-vma-lock
+++ a/mm/memory.c
@@ -3697,6 +3697,11 @@ vm_fault_t do_swap_page(struct vm_fault
 	if (!pte_unmap_same(vmf))
 		goto out;
 
+	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
+		ret = VM_FAULT_RETRY;
+		goto out;
+	}
+
 	entry = pte_to_swp_entry(vmf->orig_pte);
 	if (unlikely(non_swap_entry(entry))) {
 		if (is_migration_entry(entry)) {
_

Patches currently in -mm which might be from surenb@google.com are


