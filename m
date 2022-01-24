Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD34C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 03:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S246426AbiAYDrH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Jan 2022 22:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1323785AbiAYD3l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Jan 2022 22:29:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3216CC08E803
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 15:03:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E36F3B815E2
        for <mm-commits@vger.kernel.org>; Mon, 24 Jan 2022 23:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E5BC340E5;
        Mon, 24 Jan 2022 23:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643065418;
        bh=HYdh1Lr30fpmUqED598f21MYkME2wh09xIdqt4XF2fM=;
        h=Date:From:To:Subject:From;
        b=BTwL66zuKKMr8zhO2agryp7I3uFT/VmUcm4bPPgRjUcpmNge1im9i4Xx8Hv+IN1Ly
         Oh4Ui7KuWSgnDQFmbHwU0zsFWogKncAA/ywVsWJNIMCaI7DQlmzVx2dTLaDzgjuqSS
         CSulkrHoOgSt7wng83bsaI7EPu09QqEEs6WVvxe4=
Date:   Mon, 24 Jan 2022 15:03:38 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  +
 mm-vmalloc-remove-unneeded-function-forward-declaration.patch added to -mm
 tree
Message-ID: <20220124230338.3VJJ2wyy9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: remove unneeded function forward declaration
has been added to the -mm tree.  Its filename is
     mm-vmalloc-remove-unneeded-function-forward-declaration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-remove-unneeded-function-forward-declaration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-remove-unneeded-function-forward-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmalloc: remove unneeded function forward declaration

The forward declaration for lazy_max_pages() is unnecessary.  Remove it.

Link: https://lkml.kernel.org/r/20220124133752.60663-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-unneeded-function-forward-declaration
+++ a/mm/vmalloc.c
@@ -792,7 +792,6 @@ RB_DECLARE_CALLBACKS_MAX(static, free_vm
 
 static void purge_vmap_area_lazy(void);
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
-static unsigned long lazy_max_pages(void);
 
 static atomic_long_t nr_vmalloc_pages;
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmalloc-remove-unneeded-function-forward-declaration.patch

