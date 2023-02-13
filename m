Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630F4C636D4
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbjBMX42 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjBMXzy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B1B193C5
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7760A611B2
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE802C433EF;
        Mon, 13 Feb 2023 23:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332541;
        bh=2wnX9l+f0jaAV+OCM8ekwzRgg4fPfuMbmNIA6gI4Noo=;
        h=Date:To:From:Subject:From;
        b=cC8OgssaFw/RTrnz+V58Hxzbl2OjGs92uhrincEQyoV57sEA3Jhoc5k3UOKkpY4Fj
         9fzwoR9TGJkf+G6k8JV/RvKYXfa+gvfO7aUbXWeoQBUHmlszs3rwE5EuWe/P3tUWut
         M+ORWJSj1Bn8aPD9k2quu1XpxuCJ9w78GnJMQXUY=
Date:   Mon, 13 Feb 2023 15:55:41 -0800
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        rppt@kernel.org, jwilk@jwilk.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-typo-in-__vm_enough_memory-warning.patch removed from -mm tree
Message-Id: <20230213235541.CE802C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix typo in __vm_enough_memory warning
has been removed from the -mm tree.  Its filename was
     mm-fix-typo-in-__vm_enough_memory-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jakub Wilk <jwilk@jwilk.net>
Subject: mm: fix typo in __vm_enough_memory warning
Date: Fri, 10 Feb 2023 21:33:16 +0100

Link: https://lkml.kernel.org/r/20230210203316.5613-1-jwilk@jwilk.net
Signed-off-by: Jakub Wilk <jwilk@jwilk.net>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/util.c~mm-fix-typo-in-__vm_enough_memory-warning
+++ a/mm/util.c
@@ -967,7 +967,7 @@ int __vm_enough_memory(struct mm_struct
 	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
 		return 0;
 error:
-	pr_warn_ratelimited("%s: pid: %d, comm: %s, no enough memory for the allocation\n",
+	pr_warn_ratelimited("%s: pid: %d, comm: %s, not enough memory for the allocation\n",
 			    __func__, current->pid, current->comm);
 	vm_unacct_memory(pages);
 
_

Patches currently in -mm which might be from jwilk@jwilk.net are


