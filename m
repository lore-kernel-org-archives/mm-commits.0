Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC12C4321E
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiBGVAz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiBGVAe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:00:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31863C0401E0
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:00:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5EFAB811FE
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A954C004E1;
        Mon,  7 Feb 2022 21:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267625;
        bh=Jw+aWmijfXJ7ZoOYDtBhTn9YRr0iubd2bKU9uT7FGw0=;
        h=Date:To:From:Subject:From;
        b=vH/TC60WXEHrCLrKhwWbJYRJ0n91hB9cfkXO/FeUl9ALA6jQr3c/uXoGLJmQMI+vh
         DnKAZ0KKBQ6ZRs5TPY3W/AxTNx9/zr/ixzjHbsN64J8KrNf6rJKqb+cEBHs8EKjVGh
         BQwWsmuTlp6yXLWVnjlpuOAJ+n9C54YJg2HEUOjA=
Date:   Mon, 07 Feb 2022 13:00:24 -0800
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-clean-up-try_offline_node.patch added to -mm tree
Message-Id: <20220207210025.6A954C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: clean up try_offline_node
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-clean-up-try_offline_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-clean-up-try_offline_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-clean-up-try_offline_node.patch

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
Subject: mm/memory_hotplug: clean up try_offline_node

We can use helper macro node_spanned_pages to check whether node spans
pages.  And we can change the parameter of check_cpu_on_node to nid as
that's what it really cares.  Thus we can further get rid of the local
variable pgdat and improve the readability a bit.

Link: https://lkml.kernel.org/r/20220207133643.23427-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-clean-up-try_offline_node
+++ a/mm/memory_hotplug.c
@@ -2005,12 +2005,12 @@ static int get_nr_vmemmap_pages_cb(struc
 	return mem->nr_vmemmap_pages;
 }
 
-static int check_cpu_on_node(pg_data_t *pgdat)
+static int check_cpu_on_node(int nid)
 {
 	int cpu;
 
 	for_each_present_cpu(cpu) {
-		if (cpu_to_node(cpu) == pgdat->node_id)
+		if (cpu_to_node(cpu) == nid)
 			/*
 			 * the cpu on this node isn't removed, and we can't
 			 * offline this node.
@@ -2044,7 +2044,6 @@ static int check_no_memblock_for_node_cb
  */
 void try_offline_node(int nid)
 {
-	pg_data_t *pgdat = NODE_DATA(nid);
 	int rc;
 
 	/*
@@ -2052,7 +2051,7 @@ void try_offline_node(int nid)
 	 * offline it. A node spans memory after move_pfn_range_to_zone(),
 	 * e.g., after the memory block was onlined.
 	 */
-	if (pgdat->node_spanned_pages)
+	if (node_spanned_pages(nid))
 		return;
 
 	/*
@@ -2064,7 +2063,7 @@ void try_offline_node(int nid)
 	if (rc)
 		return;
 
-	if (check_cpu_on_node(pgdat))
+	if (check_cpu_on_node(nid))
 		return;
 
 	/*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memremap-avoid-calling-kasan_remove_zero_shadow-for-device-private-memory.patch
mm-sparse-make-mminit_validate_memmodel_limits-static.patch
mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-mmzoneh-remove-unused-macros.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
mm-memory_hotplug-remove-obsolete-comment-of-__add_pages.patch
mm-memory_hotplug-avoid-calling-zone_intersects-for-zone_normal.patch
mm-memory_hotplug-clean-up-try_offline_node.patch
mm-memory_hotplug-fix-misplaced-comment-in-offline_pages.patch
mm-highmem-remove-unnecessary-done-label.patch
mm-hmmc-remove-unneeded-local-variable-ret.patch

