Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B268C2D0A8
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC946208FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599243201;
	bh=8+UjZ+Cjb1lG0UXEyMdY0U6rkeicd+yI7i08fKX4qWw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xG6ymLoltEV2GUJOA6HEY07zmVCrymxkIsvQuCxAaWoQbaIpNHwcfpbk00bkwI8Nw
	 x46r8Mw01Yq+qUsk8UwDA5igD3ojAXwT6UZ5VfILNUUucEvzlSlZ47Civky6kejlaB
	 +Jh/IaVaJ31lwEJ4fk3cZGKcq0EhDRKzfw7E0UfQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgIDSNV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 14:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgIDSNU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 14:13:20 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD1EF208DB;
        Fri,  4 Sep 2020 18:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599243199;
        bh=8+UjZ+Cjb1lG0UXEyMdY0U6rkeicd+yI7i08fKX4qWw=;
        h=Date:From:To:Subject:From;
        b=WFvP8mHx9ZONGreTMjAbBod6c2ZZgpIcH8bj1YQfd1xyQMuWqL4Y0OCLGo3ExLa+x
         b0DASvXjReOAxHjW8nfDDd6qCdodMxVhqUSj7JSxQBmI5icAZT/LJwoSZ96vPS++1E
         oR9NhqR4t9ZridJPd460RzywlkdN3CejJlbOePYk=
Date:   Fri, 04 Sep 2020 11:13:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mateusznosek0@gmail.com,
        akpm@linux-foundation.org
Subject:  +
 mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
 added to -mm tree
Message-ID: <20200904181319.6jx-2%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix
has been added to the -mm tree.  Its filename is
     mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch

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
Subject: mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix

remove `tmp' altogether

Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix
+++ a/mm/page_alloc.c
@@ -5637,7 +5637,6 @@ static int find_next_best_node(int node,
 	int n, val;
 	int min_val = INT_MAX;
 	int best_node = NUMA_NO_NODE;
-	const struct cpumask *tmp;
 
 	/* Use the local node if we haven't already */
 	if (!node_isset(node, *used_node_mask)) {
@@ -5658,8 +5657,7 @@ static int find_next_best_node(int node,
 		val += (n < node);
 
 		/* Give preference to headless and unused nodes */
-		tmp = cpumask_of_node(n);
-		if (!cpumask_empty(tmp))
+		if (!cpumask_empty(cpumask_of_node(n)))
 			val += PENALTY_FOR_NODE_WITH_CPUS;
 
 		/* Slight preference for less loaded node */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-slub-re-initialize-randomized-freelist-sequence-in-calculate_sizes-fix.patch
mm.patch
mm-memory_hotplug-introduce-default-phys_to_target_node-implementation-fix.patch
device-dax-make-align-a-per-device-property-fix.patch
powerpc-mm-move-setting-pte-specific-flags-to-pfn_pte-fix.patch
mm-gup-dont-permit-users-to-call-get_user_pages-with-foll_longterm-fix.patch
mm-page_allocc-clean-code-by-removing-unnecessary-initialization-fix.patch
memblock-make-memblock_debug-and-related-functionality-private-fix.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range-fix.patch
xarray-add-xa_get_order-fix.patch
xarray-add-xas_split-fix.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page-fix.patch
mmhwpoison-drop-unneeded-pcplist-draining-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
fs-binfmt_elf-use-pt_load-p_align-values-for-suitable-start-address-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
arch-x86-makefile-use-config_shell.patch
kernel-forkc-export-kernel_thread-to-modules.patch

