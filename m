Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6969BC761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbjDFCpJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbjDFCod (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FC99013
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDD83642A2
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FBFC433EF;
        Thu,  6 Apr 2023 02:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749071;
        bh=D9kOoAvn1osQBZkD6CYLi/QXnwz7DipWnwpyWYeQt9I=;
        h=Date:To:From:Subject:From;
        b=cdlQHfbKaTtdW+F41pzaqiDmkthbjmXNpaGmE23ArZsU/JuKuWRwSyiJECEOvTzgj
         cMqXWdr1y8awMxaE9cnkz43xNfJGMcmikTC3W4fV/DSvgKwnbxE3FvGSpC9dB2igaE
         1qpOtAFcZTqgw+fMlUfmey8s2p6EiGONZpXxqG+A=
Date:   Wed, 05 Apr 2023 19:44:30 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, richard@nod.at,
        johannes@sipsolutions.net, anton.ivanov@cambridgegreys.com,
        kirill.shutemov@linux.intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] um-fix-max_order-usage-in-linux_main.patch removed from -mm tree
Message-Id: <20230406024431.43FBFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: um: fix MAX_ORDER usage in linux_main()
has been removed from the -mm tree.  Its filename was
     um-fix-max_order-usage-in-linux_main.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: um: fix MAX_ORDER usage in linux_main()
Date: Wed, 15 Mar 2023 14:31:25 +0300

MAX_ORDER is not inclusive: the maximum allocation order buddy allocator
can deliver is MAX_ORDER-1.

Fix MAX_ORDER usage in linux_main().

Link: https://lkml.kernel.org/r/20230315113133.11326-3-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/um_arch.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/um/kernel/um_arch.c~um-fix-max_order-usage-in-linux_main
+++ a/arch/um/kernel/um_arch.c
@@ -368,10 +368,10 @@ int __init linux_main(int argc, char **a
 	max_physmem = TASK_SIZE - uml_physmem - iomem_size - MIN_VMALLOC;
 
 	/*
-	 * Zones have to begin on a 1 << MAX_ORDER page boundary,
+	 * Zones have to begin on a 1 << MAX_ORDER-1 page boundary,
 	 * so this makes sure that's true for highmem
 	 */
-	max_physmem &= ~((1 << (PAGE_SHIFT + MAX_ORDER)) - 1);
+	max_physmem &= ~((1 << (PAGE_SHIFT + MAX_ORDER - 1)) - 1);
 	if (physmem_size + iomem_size > max_physmem) {
 		highmem = physmem_size + iomem_size - max_physmem;
 		physmem_size -= highmem;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


