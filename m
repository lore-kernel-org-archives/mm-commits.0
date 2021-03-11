Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B7E5C433E9
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 18:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4D3965002
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 18:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhCKSv3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 13:51:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhCKSvI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 13:51:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4CE264FDD;
        Thu, 11 Mar 2021 18:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615488668;
        bh=o1wpbSLPHVbkeB4n9ttBqvLUnVmM8K/TEqoy8AILiGI=;
        h=Date:From:To:Subject:From;
        b=odiqzwgpc+pUflK2xXhbsLIpOFd9TgHgoxHOJIQ3wkB2KOY/mAnEgTz4ooK8I8fwD
         X97G8WsnZvYVwC095HUFuoJPHOCTm2LDdR63RiY9oyBjbOZKOcFEHW0ugwQSngIkAc
         Q3wFgKeF0eKU4TrUULY4oAn6z0nfHtIEos5RiHYU=
Date:   Thu, 11 Mar 2021 10:51:07 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-rejects.patch added to -mm tree
Message-ID: <20210311185107.ETlpQXJIW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been added to the -mm tree.  Its filename is
     linux-next-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~linux-next-rejects
+++ a/mm/memory_hotplug.c
@@ -1017,7 +1017,7 @@ bool mhp_supports_memmap_on_memory(unsig
  */
 int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
-	struct mhp_params params = { .pgprot = PAGE_KERNEL };
+	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
 	struct vmem_altmap mhp_altmap = {};
 	u64 start, size;
 	bool new_node = false;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-refactor-initialization-of-struct-page-for-holes-in-memory-layout-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

