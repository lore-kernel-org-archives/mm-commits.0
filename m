Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E74C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 107B861A51
	for <mm-commits@archiver.kernel.org>; Thu, 30 Sep 2021 20:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347746AbhI3Ub7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 16:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347637AbhI3Ub7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Sep 2021 16:31:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EC9961994;
        Thu, 30 Sep 2021 20:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633033816;
        bh=qmn/Svjb7c6EOQlBk9Tg0gRp7GYJ/Zk8670owE+WevU=;
        h=Date:From:To:Subject:From;
        b=WgJfLa/wbXmfCCO2nZpYMLCb7gOMK7uCjJWsNJm9fBRF67h+o80J0mmfmhnZhj8Tt
         m4zi6EUlUZH5Llxxicl9eWR+BUaHp9K3LWx0W2qikXehd8XxiiDj2HpSBQQGbqsW4J
         vqq8mk0MZGfdqoyBSLmAntaw7/RPwDYveeJW2qiA=
Date:   Thu, 30 Sep 2021 13:30:15 -0700
From:   akpm@linux-foundation.org
To:     christophe.leroy@csgroup.eu, jgross@suse.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        Shahab.Vahedi@synopsys.com
Subject:  + arch_numa-simplify-numa_distance-allocation.patch added
 to -mm tree
Message-ID: <20210930203015.3YWLuTbpV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch_numa: simplify numa_distance allocation
has been added to the -mm tree.  Its filename is
     arch_numa-simplify-numa_distance-allocation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arch_numa-simplify-numa_distance-allocation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arch_numa-simplify-numa_distance-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arch_numa: simplify numa_distance allocation

Patch series "memblock: cleanup memblock_free interface", v2.

This is the fix for memblock freeing APIs mismatch [1].

The first patch is a cleanup of numa_distance allocation in arch_numa I've
spotted during the conversion.  The second patch is a fix for Xen memory
freeing on some of the error paths.

[1] https://lore.kernel.org/all/CAHk-=wj9k4LZTz+svCxLYs5Y1=+yKrbAUArH1+ghyG3OLd8VVg@mail.gmail.com


This patch (of 6):

Memory allocation of numa_distance uses memblock_phys_alloc_range()
without actual range limits, converts the returned physical address to
virtual and then only uses the virtual address for further initialization.

Simplify this by replacing memblock_phys_alloc_range() with
memblock_alloc().

Link: https://lkml.kernel.org/r/20210930185031.18648-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20210930185031.18648-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Juergen Gross <jgross@suse.com>
Cc: Shahab Vahedi <Shahab.Vahedi@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/arch_numa.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/base/arch_numa.c~arch_numa-simplify-numa_distance-allocation
+++ a/drivers/base/arch_numa.c
@@ -275,15 +275,13 @@ void __init numa_free_distance(void)
 static int __init numa_alloc_distance(void)
 {
 	size_t size;
-	u64 phys;
 	int i, j;
 
 	size = nr_node_ids * nr_node_ids * sizeof(numa_distance[0]);
-	phys = memblock_phys_alloc_range(size, PAGE_SIZE, 0, PFN_PHYS(max_pfn));
-	if (WARN_ON(!phys))
+	numa_distance = memblock_alloc(size, PAGE_SIZE);
+	if (WARN_ON(!numa_distance))
 		return -ENOMEM;
 
-	numa_distance = __va(phys);
 	numa_distance_cnt = nr_node_ids;
 
 	/* fill with the default distances */
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

arch_numa-simplify-numa_distance-allocation.patch
xen-x86-free_p2m_page-use-memblock_free_ptr-to-free-a-virtual-pointer.patch
memblock-drop-memblock_free_early_nid-and-memblock_free_early.patch
memblock-stop-aliasing-__memblock_free_late-with-memblock_free_late.patch
memblock-rename-memblock_free-to-memblock_phys_free.patch
memblock-use-memblock_free-for-freeing-virtual-pointers.patch

