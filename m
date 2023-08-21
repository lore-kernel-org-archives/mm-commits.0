Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D64DEE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjHUUlK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjHUUke (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:40:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF17F1A3
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 475B264B18
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDECC433C8;
        Mon, 21 Aug 2023 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650407;
        bh=Y/QK/w9ElOpwrWZJisxbNqgtevU28XOuTT443FEcXdY=;
        h=Date:To:From:Subject:From;
        b=QPapc/DM9DO9+wCQDYgsOc49oPMPe8jdn4XdflR2KZmZTD3hioxq2p8DpylJoMpYU
         J3ZuW5//ST6kPladilKWHLO2eGO013wuNYbivf+G+XwAzMeAEcWPpHIert72fk8TnY
         CMEPUQCOd7zlfV94zJ6fit24OwpN1FgEl0xmrjz0=
Date:   Mon, 21 Aug 2023 13:40:07 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org, linmiaohe@huawei.com,
        david@redhat.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-no-need-to-export-mm_kobj.patch removed from -mm tree
Message-Id: <20230821204007.9FDECC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: no need to export mm_kobj
has been removed from the -mm tree.  Its filename was
     mm-no-need-to-export-mm_kobj.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: mm: no need to export mm_kobj
Date: Fri, 4 Aug 2023 08:43:37 +0200

There are no modules using mm_kobj, so do not export it.

Link: https://lkml.kernel.org/r/2023080436-algebra-cabana-417d@gregkh
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/mm_init.c~mm-no-need-to-export-mm_kobj
+++ a/mm/mm_init.c
@@ -154,7 +154,6 @@ early_param("mminit_loglevel", set_mmini
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 
 struct kobject *mm_kobj;
-EXPORT_SYMBOL_GPL(mm_kobj);
 
 #ifdef CONFIG_SMP
 s32 vm_committed_as_batch = 32;
_

Patches currently in -mm which might be from gregkh@linuxfoundation.org are


