Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B19C25B06
	for <mm-commits@archiver.kernel.org>; Mon, 15 Aug 2022 00:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiHOAGK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 14 Aug 2022 20:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiHOAGF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 14 Aug 2022 20:06:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC961055C
        for <mm-commits@vger.kernel.org>; Sun, 14 Aug 2022 17:06:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE13B60F3E
        for <mm-commits@vger.kernel.org>; Mon, 15 Aug 2022 00:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F95EC433D7;
        Mon, 15 Aug 2022 00:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660521964;
        bh=y/Y/J69tQZim5INFdFY3zKLfuUyzY9Wb4gQPQwx4ioI=;
        h=Date:To:From:Subject:From;
        b=NA77TpBC4dkrfisCoYm1oKHs3yuzvFR9qYyhoLg0/3asfx2q0wKhgsKtRPTTORP0c
         9RJiFEBuj9kQeTt8qc4iXAzx4haNbqc8kyYAipR1ndmQnKs1mfTDPtYbKJCRXJv4Mq
         uiqyQDizA02WNkiJdnRKEhMgNPRGQKM5dgNXPI3o=
Date:   Sun, 14 Aug 2022 17:06:03 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        almasrymina@google.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb_cgroup-use-helper-macro-numa_no_node.patch added to mm-unstable branch
Message-Id: <20220815000604.0F95EC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb_cgroup: use helper macro NUMA_NO_NODE
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb_cgroup-use-helper-macro-numa_no_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb_cgroup-use-helper-macro-numa_no_node.patch

This patch will later appear in the mm-unstable branch at
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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: hugetlb_cgroup: use helper macro NUMA_NO_NODE
Date: Fri, 29 Jul 2022 16:01:05 +0800

It's better to use NUMA_NO_NODE instead of magic number -1. Minor
readability improvement.

Link: https://lkml.kernel.org/r/20220729080106.12752-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-use-helper-macro-numa_no_node
+++ a/mm/hugetlb_cgroup.c
@@ -154,9 +154,9 @@ hugetlb_cgroup_css_alloc(struct cgroup_s
 	 * function.
 	 */
 	for_each_node(node) {
-		/* Set node_to_alloc to -1 for offline nodes. */
+		/* Set node_to_alloc to NUMA_NO_NODE for offline nodes. */
 		int node_to_alloc =
-			node_state(node, N_NORMAL_MEMORY) ? node : -1;
+			node_state(node, N_NORMAL_MEMORY) ? node : NUMA_NO_NODE;
 		h_cgroup->nodeinfo[node] =
 			kzalloc_node(sizeof(struct hugetlb_cgroup_per_node),
 				     GFP_KERNEL, node_to_alloc);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch
hugetlb_cgroup-remove-unneeded-nr_pages-0-check.patch
hugetlb_cgroup-hugetlbfs-use-helper-macro-sz_1kmg.patch
hugetlb_cgroup-remove-unneeded-return-value.patch
hugetlb_cgroup-use-helper-macro-numa_no_node.patch
hugetlb_cgroup-use-helper-for_each_hstate-and-hstate_index.patch

