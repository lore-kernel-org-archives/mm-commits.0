Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C356C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 23:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEAB964F38
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 23:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhCRXsI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 Mar 2021 19:48:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:36932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233327AbhCRXrr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 18 Mar 2021 19:47:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69FB064E81;
        Thu, 18 Mar 2021 23:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616111267;
        bh=KL1VKY/VbicuOJFjCXH1lsFfXqVacGIZQavu16iZWKA=;
        h=Date:From:To:Subject:From;
        b=g9ytMa1yGr4glKy1c8i5FenTj1RgRJyN59tgx4BU4n2/M9P0+csT4GR3s9/l6fldB
         4LCxuvowafTXDTbKKKTmKAWQg7TAX8x/w2kEHq8rBPo7t3bLQmNqRUYtnOFggMEPHT
         A9xgnZwhxcCCyw0FNGwBGaleE+YK+f0i3sEZLbK0=
Date:   Thu, 18 Mar 2021 16:47:47 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-rejects.patch added to -mm tree
Message-ID: <20210318234747.XNwH_Mfuy%akpm@linux-foundation.org>
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

 mm/memcontrol.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c~linux-next-rejects
+++ a/mm/memcontrol.c
@@ -6565,7 +6565,14 @@ int mem_cgroup_charge(struct page *page,
 	if (mem_cgroup_disabled())
 		return 0;
 
-	memcg = get_mem_cgroup_from_mm(mm);
+	if (!mm) {
+		memcg = get_mem_cgroup_from_current();
+		(!memcg)
+			memcg = get_mem_cgroup_from_mm(current->mm);
+	} else {
+		memcg = get_mem_cgroup_from_mm(mm);
+	}
+
 	ret = __mem_cgroup_charge(page, memcg, gfp_mask);
 	css_put(&memcg->css);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
kasan-remove-redundant-config-option-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

