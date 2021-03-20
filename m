Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B88AC433DB
	for <mm-commits@archiver.kernel.org>; Sat, 20 Mar 2021 03:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 477A66197F
	for <mm-commits@archiver.kernel.org>; Sat, 20 Mar 2021 03:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCTDH3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 23:07:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhCTDHU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 23:07:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3807961979;
        Sat, 20 Mar 2021 03:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616209640;
        bh=KhLQAVqp52vrOq0TKKW4OMb0yacRHk31oeT+ZdrG9dM=;
        h=Date:From:To:Subject:From;
        b=netsOnPRQO5sPa2tz63uCDe1CV/SKk6c27a1XE9J1KJaFRqltb+p90Dyh71TzNQ0y
         BpYdpY3n8GiQMLikypnfNnEFu7/G9IVfIGsUr+m/35pALYNVqH0ThnBxeNvOtuEufZ
         5ow+vU0nCg+duLFrRCFVMHjtG92zBnV2oHSi1vIQ=
Date:   Fri, 19 Mar 2021 20:07:19 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-rejects.patch removed from -mm tree
Message-ID: <20210320030719.So-9kdxpv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-rejects.patch

This patch was dropped because it is obsolete

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
mm-gup-check-page-posion-status-for-coredump-fix.patch
mm-memcontrol-switch-to-rstat-fix.patch
kasan-remove-redundant-config-option-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

