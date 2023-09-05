Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A42C83F3E
	for <mm-commits@archiver.kernel.org>; Tue,  5 Sep 2023 19:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239461AbjIETA6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Sep 2023 15:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbjIETAy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Sep 2023 15:00:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5FA1719
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 12:00:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 661A4CE1268
        for <mm-commits@vger.kernel.org>; Tue,  5 Sep 2023 16:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB3BC433C8;
        Tue,  5 Sep 2023 16:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693929937;
        bh=V+8bi2YfTPfKw77CWttouhgz4JXn2vr+1xRv2wPpQhI=;
        h=Date:To:From:Subject:From;
        b=dZi0j+bdB/px2wvOWRmodGkqW0QVDiqQMBA7bvolKATg0PX84CZ422nNXZHVbN818
         5MMnucKfiTUUgzHc+a88vcNGNzCWP0+WropH7x5fbOTS5sW33jw4ugXeEkOET7zfVu
         A89scpKhWpbdjP7XAk+eUGyv8KBH6WUI69uHEfSg=
Date:   Tue, 05 Sep 2023 09:05:36 -0700
To:     mm-commits@vger.kernel.org, yuancan@huawei.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-use-bulk-allocator-in-alloc_vmemmap_page_list.patch added to mm-unstable branch
Message-Id: <20230905160537.8EB3BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb_vmemmap: use bulk allocator in alloc_vmemmap_page_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-use-bulk-allocator-in-alloc_vmemmap_page_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-use-bulk-allocator-in-alloc_vmemmap_page_list.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb_vmemmap: use bulk allocator in alloc_vmemmap_page_list()
Date: Tue, 5 Sep 2023 18:35:08 +0800

It is needed 4095 pages(1G) or 7 pages(2M) to be allocated once in
alloc_vmemmap_page_list(), so let's add a bulk allocator interface
alloc_pages_bulk_list_node() and switch alloc_vmemmap_page_list() to use
it to accelerate page allocation.

Simple test on arm64's qemu with 1G Hugetlb, 870,842ns vs 3,845,252ns,
even if there is a certain fluctuation, it is still a nice improvement.

Link: https://lkml.kernel.org/r/20230905103508.2996474-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: Yuan Can <yuancan@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h  |    9 +++++++++
 mm/hugetlb_vmemmap.c |    6 ++++++
 2 files changed, 15 insertions(+)

--- a/include/linux/gfp.h~mm-hugetlb_vmemmap-use-bulk-allocator-in-alloc_vmemmap_page_list
+++ a/include/linux/gfp.h
@@ -196,6 +196,15 @@ alloc_pages_bulk_list(gfp_t gfp, unsigne
 }
 
 static inline unsigned long
+alloc_pages_bulk_list_node(gfp_t gfp, int nid, unsigned long nr_pages, struct list_head *list)
+{
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+
+	return __alloc_pages_bulk(gfp, nid, NULL, nr_pages, list, NULL);
+}
+
+static inline unsigned long
 alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_array)
 {
 	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, page_array);
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-use-bulk-allocator-in-alloc_vmemmap_page_list
+++ a/mm/hugetlb_vmemmap.c
@@ -385,7 +385,13 @@ static int alloc_vmemmap_page_list(unsig
 	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
 	int nid = page_to_nid((struct page *)start);
 	struct page *page, *next;
+	unsigned long nr_allocated;
 
+	nr_allocated = alloc_pages_bulk_list_node(gfp_mask, nid, nr_pages, list);
+	if (!nr_allocated)
+		return -ENOMEM;
+
+	nr_pages -= nr_allocated;
 	while (nr_pages--) {
 		page = alloc_pages_node(nid, gfp_mask, 0);
 		if (!page)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hugetlb_vmemmap-use-bulk-allocator-in-alloc_vmemmap_page_list.patch

