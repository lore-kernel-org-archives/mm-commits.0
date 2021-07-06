Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D439C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 695076128D
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbhGFTO7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhGFTO7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 771F360C3D;
        Tue,  6 Jul 2021 19:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598740;
        bh=qS/Oate+IT1+bNj59d/1QMHrqg37b2a7wzVv2FNK9KY=;
        h=Date:From:To:Subject:From;
        b=BugjWaIqTskH9GayL63pD/8mWZ5E47i/nigU9kuSwLGE2BigbwLBp1J2WvQy3W1N4
         0nzka60x4IYJ0UagWDKlGsxSehGsmWXgTpP1E3LC88T88dz73zCUBRmxUc6KIwU6cN
         Gdjbk+K61Q/3WySWDt9GEJiEW+PIPB5sHCQClNzs=
Date:   Tue, 06 Jul 2021 12:12:20 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, liu.xiang@zlingsmart.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-memoryc-fix-comment-of-finish_mkwrite_fault.patch removed from -mm tree
Message-ID: <20210706191220.H_dYrejAh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: fix comment of finish_mkwrite_fault()
has been removed from the -mm tree.  Its filename was
     mm-memoryc-fix-comment-of-finish_mkwrite_fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Liu Xiang <liu.xiang@zlingsmart.com>
Subject: mm/memory.c: fix comment of finish_mkwrite_fault()

Fix the return value in comment of finish_mkwrite_fault().

Link: https://lkml.kernel.org/r/20210513093931.15234-1-liu.xiang@zlingsmart.com
Signed-off-by: Liu Xiang <liu.xiang@zlingsmart.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memoryc-fix-comment-of-finish_mkwrite_fault
+++ a/mm/memory.c
@@ -3049,7 +3049,7 @@ oom:
  * The function expects the page to be locked or other protection against
  * concurrent faults / writeback (such as DAX radix tree locks).
  *
- * Return: %VM_FAULT_WRITE on success, %0 when PTE got changed before
+ * Return: %0 on success, %VM_FAULT_NOPAGE when PTE got changed before
  * we acquired PTE lock.
  */
 vm_fault_t finish_mkwrite_fault(struct vm_fault *vmf)
_

Patches currently in -mm which might be from liu.xiang@zlingsmart.com are


