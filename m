Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 760B6C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357330AbiCYBcC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357346AbiCYBbu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF103819E
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCC986191D
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2045FC340ED;
        Fri, 25 Mar 2022 01:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171810;
        bh=F5TpQMckvlZALkSQWasox5EBCvjLl2P0g0kdqpyZ8f0=;
        h=Date:To:From:Subject:From;
        b=vzwR8e1NxrwRCuernMx8X784iF1cUfRbHr6d6c9ZUMF4xU4A6Q1+gYyWGwh2nBx3P
         whELJZyhfeJ3Kpxqcsx2597uKPxAxPLNW9OvpxK/on0gsk/Hg5TgXlaftFiOjuXnsk
         jcU1b/4VJqOosHybGRuVF1xv+NLZGYFVHHuZNy1o=
Date:   Thu, 24 Mar 2022 18:30:09 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-shmem-use-helper-macro-__attr_rw.patch removed from -mm tree
Message-Id: <20220325013010.2045FC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shmem: use helper macro __ATTR_RW
has been removed from the -mm tree.  Its filename was
     mm-shmem-use-helper-macro-__attr_rw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: shmem: use helper macro __ATTR_RW

Use helper macro __ATTR_RW to define shmem_enabled_attr to make code more
clear.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220312082252.55586-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-helper-macro-__attr_rw
+++ a/mm/shmem.c
@@ -3965,8 +3965,7 @@ static ssize_t shmem_enabled_store(struc
 	return count;
 }
 
-struct kobj_attribute shmem_enabled_attr =
-	__ATTR(shmem_enabled, 0644, shmem_enabled_show, shmem_enabled_store);
+struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_SYSFS */
 
 #else /* !CONFIG_SHMEM */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

