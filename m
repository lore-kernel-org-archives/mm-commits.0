Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99557C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjDRXeK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjDRXd4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:33:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47E883FA
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:33:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C626162ED3
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CABC433EF;
        Tue, 18 Apr 2023 23:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681860833;
        bh=LCnLGiL1ZMxj417DfLkeRWA432wCX1JM2wjFx/qNH4M=;
        h=Date:To:From:Subject:From;
        b=iY3+pOo59pZsxKEH/SvDw4efEkm5EyLBANWdq6lv5zaPidqbIdPtFLFPBdSVZ5L93
         hpKPDgNCmMxksKQzbkmXoPiNCwYLEpxOdjZlwCIFWMwyOXqT61D0Y3q8ZhdPD71RTs
         OGKQqrB5x3JtISWKydgvpdWOj3RBNslXMapAvRKM=
Date:   Tue, 18 Apr 2023 16:33:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, lstoakes@gmail.com,
        hch@infradead.org, david@fromorbit.com, bhe@redhat.com,
        urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case.patch removed from -mm tree
Message-Id: <20230418233353.26CABC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/test_vmalloc.c: add vm_map_ram()/vm_unmap_ram() test case
has been removed from the -mm tree.  Its filename was
     lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc.c: add vm_map_ram()/vm_unmap_ram() test case
Date: Thu, 30 Mar 2023 21:06:39 +0200

Add vm_map_ram()/vm_unmap_ram() test case to our stress test-suite.

[akpm@linux-foundation.org: fix whitespace, per Lorenzo]
Link: https://lkml.kernel.org/r/20230330190639.431589-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case
+++ a/lib/test_vmalloc.c
@@ -53,6 +53,7 @@ __param(int, run_test_mask, INT_MAX,
 		"\t\tid: 128,  name: pcpu_alloc_test\n"
 		"\t\tid: 256,  name: kvfree_rcu_1_arg_vmalloc_test\n"
 		"\t\tid: 512,  name: kvfree_rcu_2_arg_vmalloc_test\n"
+		"\t\tid: 1024, name: vm_map_ram_test\n"
 		/* Add a new test case description here. */
 );
 
@@ -358,6 +359,41 @@ kvfree_rcu_2_arg_vmalloc_test(void)
 	return 0;
 }
 
+static int
+vm_map_ram_test(void)
+{
+	unsigned long nr_allocated;
+	unsigned int map_nr_pages;
+	unsigned char *v_ptr;
+	struct page **pages;
+	int i;
+
+	map_nr_pages = nr_pages > 0 ? nr_pages:1;
+	pages = kmalloc(map_nr_pages * sizeof(struct page), GFP_KERNEL);
+	if (!pages)
+		return -1;
+
+	nr_allocated = alloc_pages_bulk_array(GFP_KERNEL, map_nr_pages, pages);
+	if (nr_allocated != map_nr_pages)
+		goto cleanup;
+
+	/* Run the test loop. */
+	for (i = 0; i < test_loop_count; i++) {
+		v_ptr = vm_map_ram(pages, map_nr_pages, NUMA_NO_NODE);
+		*v_ptr = 'a';
+		vm_unmap_ram(v_ptr, map_nr_pages);
+	}
+
+cleanup:
+	for (i = 0; i < nr_allocated; i++)
+		__free_page(pages[i]);
+
+	kfree(pages);
+
+	/* 0 indicates success. */
+	return nr_allocated != map_nr_pages;
+}
+
 struct test_case_desc {
 	const char *test_name;
 	int (*test_func)(void);
@@ -374,6 +410,7 @@ static struct test_case_desc test_case_a
 	{ "pcpu_alloc_test", pcpu_alloc_test },
 	{ "kvfree_rcu_1_arg_vmalloc_test", kvfree_rcu_1_arg_vmalloc_test },
 	{ "kvfree_rcu_2_arg_vmalloc_test", kvfree_rcu_2_arg_vmalloc_test },
+	{ "vm_map_ram_test", vm_map_ram_test },
 	/* Add a new test case here. */
 };
 
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-rename-addr_to_vb_xarray-function.patch

