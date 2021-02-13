Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EFCCC433E9
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:41:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA2F064DCF
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhBMEli (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Feb 2021 23:41:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:48172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhBMElg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Feb 2021 23:41:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A06C864E9C;
        Sat, 13 Feb 2021 04:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613191256;
        bh=Cs5eznjaZKPF8whCvwWe8sHquPHf5uDBZgqbVOyGv7g=;
        h=Date:From:To:Subject:From;
        b=hsJi9smE6Y0jGq2J55L4Iez65nV6fjcNmftfenVRBIypxJVDNUF4gNQ7ykkPnurK8
         7VkBfx1LUi75QIR396gTkvfRRh1CWd7jMi62EV/yhm4kKi88+mGvaLR04Q6AGNCr1o
         IX4tFxgq8wrRZA6+N1LV6eCjihm28RQY44bNxfQw=
Date:   Fri, 12 Feb 2021 20:40:55 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        song.bao.hua@hisilicon.com, sjenning@redhat.com, lkp@intel.com,
        efault@gmx.de, ddstreet@ieee.org, bigeasy@linutronix.de,
        tiantao6@hisilicon.com
Subject:  [folded-merged]
 mm-zswap-fix-variable-entry-is-uninitialized-when-used.patch removed from -mm
 tree
Message-ID: <20210213044055.Te6Cq%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zswap: fix variable 'entry' is uninitialized when used
has been removed from the -mm tree.  Its filename was
     mm-zswap-fix-variable-entry-is-uninitialized-when-used.patch

This patch was dropped because it was folded into mm-zswap-add-the-flag-can_sleep_mapped.patch

------------------------------------------------------
From: Tian Tao <tiantao6@hisilicon.com>
Subject: mm/zswap: fix variable 'entry' is uninitialized when used

the entry has not been initialized when it is used, so allocate PAGE_SIZE

Link: https://lkml.kernel.org/r/1611223030-58346-1-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/zswap.c~mm-zswap-fix-variable-entry-is-uninitialized-when-used
+++ a/mm/zswap.c
@@ -943,8 +943,7 @@ static int zswap_writeback_entry(struct
 	};
 
 	if (!zpool_can_sleep_mapped(pool)) {
-
-		tmp = kmalloc(entry->length, GFP_ATOMIC);
+		tmp = kmalloc(PAGE_SIZE, GFP_ATOMIC);
 		if (!tmp)
 			return -ENOMEM;
 	}
_

Patches currently in -mm which might be from tiantao6@hisilicon.com are

mm-zswap-add-the-flag-can_sleep_mapped.patch
mm-set-the-sleep_mapped-to-true-for-zbud-and-z3fold.patch

