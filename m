Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F043AC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 23:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbiAaXEq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 18:04:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34850 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbiAaXEp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 18:04:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A34086159D
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 23:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5470C340E8;
        Mon, 31 Jan 2022 23:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643670285;
        bh=9fSAWk1bKYKGIZF2PX67WQnkhykc+CIwvTVg7tKeN2I=;
        h=Date:To:From:Subject:From;
        b=EO87VhhB/e/GuWWUImWcaitWep+ldzZdHQgHxgmJxYbiS5PgK18R+w6yDsQ8I2HGU
         amyEj30NocoVlV9OlJ5FRpHthaOJo6u80VkrRlxettyXYnZRdCWhefetIjvT1E4uf/
         bGMx6pwdVjhhQcaHU/0uXuzKo1RuIhPmmW6yN4As=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 15:04:43 -0800
Date:   Mon, 31 Jan 2022 15:04:43 -0800
To:     mm-commits@vger.kernel.org, bhe@redhat.com,
        abaci@linux.alibaba.com, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-vmcore-fix-vmcore_alloc_buf-kernel-doc-comment.patch added to -mm tree
Message-Id: <20220131230443.E5470C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/vmcore: fix vmcore_alloc_buf() kernel-doc comment
has been added to the -mm tree.  Its filename is
     proc-vmcore-fix-vmcore_alloc_buf-kernel-doc-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/proc-vmcore-fix-vmcore_alloc_buf-kernel-doc-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/proc-vmcore-fix-vmcore_alloc_buf-kernel-doc-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: proc/vmcore: fix vmcore_alloc_buf() kernel-doc comment

Fix a spelling problem to remove warnings found by running
scripts/kernel-doc, which is caused by using 'make W=1'.

fs/proc/vmcore.c:492: warning: Function parameter or member 'size' not
described in 'vmcore_alloc_buf'
fs/proc/vmcore.c:492: warning: Excess function parameter 'sizez'
description in 'vmcore_alloc_buf'

Link: https://lkml.kernel.org/r/20220129011449.105278-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/vmcore.c~proc-vmcore-fix-vmcore_alloc_buf-kernel-doc-comment
+++ a/fs/proc/vmcore.c
@@ -480,7 +480,7 @@ static const struct vm_operations_struct
 
 /**
  * vmcore_alloc_buf - allocate buffer in vmalloc memory
- * @sizez: size of buffer
+ * @size: size of buffer
  *
  * If CONFIG_MMU is defined, use vmalloc_user() to allow users to mmap
  * the buffer to user-space by means of remap_vmalloc_range().
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

proc-vmcore-fix-vmcore_alloc_buf-kernel-doc-comment.patch

