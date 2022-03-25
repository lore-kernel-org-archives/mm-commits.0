Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C89AC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357540AbiCYBgt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357484AbiCYBfr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E7331238
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D66DB81DE2
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA36CC340F1;
        Fri, 25 Mar 2022 01:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172021;
        bh=OmCcFIzKSgI2ZdgBScvPkJ1BOsarzxaeCqyQ3IUKV4U=;
        h=Date:To:From:Subject:From;
        b=O75KVWPyxpfajJYoslHc6Gvxev6WtVYmIAo60h/qVrW1p22xZ+ga29juWVBUvefDq
         RUyYwWCn+TwUwwkJcPVTqS4URfqB775Eg6FhI+gxeXKGEPvj6ZOGMSCJt6JBC2XCaa
         DL42BDPmgwYKq1bMAIALCPD59emAhmjqndPKfMyg=
Date:   Thu, 24 Mar 2022 18:33:41 -0700
To:     mm-commits@vger.kernel.org, bhe@redhat.com,
        abaci@linux.alibaba.com, yang.lee@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] proc-vmcore-fix-vmcore_alloc_buf-kernel-doc-comment.patch removed from -mm tree
Message-Id: <20220325013341.CA36CC340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: proc/vmcore: fix vmcore_alloc_buf() kernel-doc comment
has been removed from the -mm tree.  Its filename was
     proc-vmcore-fix-vmcore_alloc_buf-kernel-doc-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


