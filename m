Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4141EC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  9 May 2022 23:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbiEIXXK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 May 2022 19:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiEIXXG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2022 19:23:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63A220D4F9
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 16:19:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7343B819C8
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 23:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD5FC385B3;
        Mon,  9 May 2022 23:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652138348;
        bh=OcQ9WSrBYV0RGSKTbwD6OoSVutWfF60QOcFrrG/W6SM=;
        h=Date:To:From:Subject:From;
        b=UfZu0qpbUMSS02tS58WqU8BqbDmtXayoziFC0WQ3AHkfOyvkH4jk4FpFvOOXCYvK1
         SIjND4noCNdGo2AvWBdaHFTFZhotBKne/VQkNPhGRwLj3VE7qoPHFwnsD7k/myvmxe
         amFvv+MQ2qT/jXoRZAcGtAiseFWCqEmOMItQJMoA=
Date:   Mon, 09 May 2022 16:19:07 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        pizhenwei@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-disable-hwpoison-filter-during-removing.patch added to mm-unstable branch
Message-Id: <20220509231908.5DD5FC385B3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: disable hwpoison filter during removing
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hwpoison-disable-hwpoison-filter-during-removing.patch

This patch should soon appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: zhenwei pi <pizhenwei@bytedance.com>
Subject: mm/hwpoison: disable hwpoison filter during removing

hwpoison filter is enabled by hwpoison-inject module, after removing this
module, hwpoison filter still works.  What is worse, user can not find the
debugfs entries to know this.

Disable the hwpoison filter during removing hwpoison-inject module.

Link: https://lkml.kernel.org/r/20220509105641.491313-5-pizhenwei@bytedance.com
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hwpoison-inject.c~mm-hwpoison-disable-hwpoison-filter-during-removing
+++ a/mm/hwpoison-inject.c
@@ -65,6 +65,7 @@ DEFINE_DEBUGFS_ATTRIBUTE(unpoison_fops,
 
 static void pfn_inject_exit(void)
 {
+	hwpoison_filter_enable = 0;
 	debugfs_remove_recursive(hwpoison_dir);
 }
 
_

Patches currently in -mm which might be from pizhenwei@bytedance.com are

mm-memory-failurec-move-clear_hwpoisoned_pages.patch
mm-memory-failurec-simplify-num_poisoned_pages_dec.patch
mm-memory-failurec-add-hwpoison_filter-for-soft-offline.patch
mm-hwpoison-disable-hwpoison-filter-during-removing.patch
mm-memory-failurec-simplify-num_poisoned_pages_inc-dec.patch

