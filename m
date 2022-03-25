Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40608C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357396AbiCYBd4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357434AbiCYBdL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A064BF02D
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 268EB61937
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6F2C340ED;
        Fri, 25 Mar 2022 01:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171869;
        bh=kSJO2Exf1HVu7QVjAHYVHg/0IA3jSiE6mrOdZoIywdM=;
        h=Date:To:From:Subject:From;
        b=ws/PMKtDh/HiigBQadp/8T7vxGjYvsFck0KLZi1BAuVAPPoDf7Pu2CK5jPTOH4dFq
         48plnFcc1/aZT3qtDPJGiDrFMABD/eSpPQL/wzDvpC+2sPg6eL2un0Jn0HRlK54j+i
         7Wo7SCRTLjbDTYfZ8I4JXAUL0dudQWgErh/CCHLA=
Date:   Thu, 24 Mar 2022 18:31:08 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-vmalloc-remove-unneeded-function-forward-declaration.patch removed from -mm tree
Message-Id: <20220325013109.7D6F2C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: remove unneeded function forward declaration
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-unneeded-function-forward-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmalloc: remove unneeded function forward declaration

The forward declaration for lazy_max_pages() is unnecessary.  Remove it.

Link: https://lkml.kernel.org/r/20220124133752.60663-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-unneeded-function-forward-declaration
+++ a/mm/vmalloc.c
@@ -791,7 +791,6 @@ RB_DECLARE_CALLBACKS_MAX(static, free_vm
 
 static void purge_vmap_area_lazy(void);
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
-static unsigned long lazy_max_pages(void);
 
 static atomic_long_t nr_vmalloc_pages;
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

