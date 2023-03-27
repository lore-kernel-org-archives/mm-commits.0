Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05CBC6FD1D
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 20:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjC0UCw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 16:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC0UCv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 16:02:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6071B1
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 13:02:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F0F9614C6
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 20:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37EEC433EF;
        Mon, 27 Mar 2023 20:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679947369;
        bh=9MApme3QE04m+pS/IF5wuEMk9EJ/1OcgAbKlkNn7NKU=;
        h=Date:To:From:Subject:From;
        b=u8v5Rsv9c6oKSBP5O4oS2Nfv4yroED+RhJFozjS5ctRo8sieUCUKg+vDeWiBBa3rO
         RP2gKo6wd/ufHALNlXjjKq1jw708uahybDYe3sPP8b3qNMkJSEg/s/duUBVAwskCud
         2ZkF5GSKwSZ9Xwvxda0lNCnImVAoOcOimNFYdXJ4=
Date:   Mon, 27 Mar 2023 13:02:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        oleksiy.avramchenko@sony.com, lstoakes@gmail.com,
        hch@infradead.org, david@fromorbit.com, bhe@redhat.com,
        urezki@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case.patch added to mm-unstable branch
Message-Id: <20230327200249.A37EEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_vmalloc.c: add vm_map_ram()/vm_unmap_ram() test case
has been added to the -mm mm-unstable branch.  Its filename is
     lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case.patch

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
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc.c: add vm_map_ram()/vm_unmap_ram() test case
Date: Mon, 27 Mar 2023 19:01:26 +0200

Add vm_map_ram()/vm_unmap_ram() test case to our stress test-suite.

Link: https://lkml.kernel.org/r/20230327170126.406044-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

--- a/lib/test_vmalloc.c~lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case
+++ a/lib/test_vmalloc.c
@@ -53,6 +53,7 @@ __param(int, run_test_mask, INT_MAX,
 		"\t\tid: 128,  name: pcpu_alloc_test\n"
 		"\t\tid: 256,  name: kvfree_rcu_1_arg_vmalloc_test\n"
 		"\t\tid: 512,  name: kvfree_rcu_2_arg_vmalloc_test\n"
+		"\t\tid: 1024, name: vm_map_ram_test\n"
 		/* Add a new test case description here. */
 );
 
@@ -358,6 +359,45 @@ kvfree_rcu_2_arg_vmalloc_test(void)
 	return 0;
 }
 
+static int
+vm_map_ram_test(void)
+{
+	unsigned int map_nr_pages;
+	unsigned char *v_ptr;
+	unsigned char *p_ptr;
+	struct page **pages;
+	struct page *page;
+	int i;
+
+	map_nr_pages = nr_pages > 0 ? nr_pages:1;
+	pages = kmalloc(map_nr_pages * sizeof(*page), GFP_KERNEL);
+	if (!pages)
+		return -1;
+
+	for (i = 0; i < map_nr_pages; i++) {
+		page = alloc_pages(GFP_KERNEL, 1);
+		if (!page)
+			return -1;
+
+		pages[i] = page;
+	}
+
+	/* Run the test loop. */
+	for (i = 0; i < test_loop_count; i++) {
+		v_ptr = vm_map_ram(pages, map_nr_pages, -1);
+		*v_ptr = 'a';
+		vm_unmap_ram(v_ptr, map_nr_pages);
+	}
+
+	for (i = 0; i < map_nr_pages; i++) {
+		p_ptr = page_address(pages[i]);
+		free_pages((unsigned long)p_ptr, 1);
+	}
+
+	kfree(pages);
+	return 0;
+}
+
 struct test_case_desc {
 	const char *test_name;
 	int (*test_func)(void);
@@ -374,6 +414,7 @@ static struct test_case_desc test_case_a
 	{ "pcpu_alloc_test", pcpu_alloc_test },
 	{ "kvfree_rcu_1_arg_vmalloc_test", kvfree_rcu_1_arg_vmalloc_test },
 	{ "kvfree_rcu_2_arg_vmalloc_test", kvfree_rcu_2_arg_vmalloc_test },
+	{ "vm_map_ram_test", vm_map_ram_test },
 	/* Add a new test case here. */
 };
 
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-remove-a-global-vmap_blocks-xarray.patch
lib-test_vmallocc-add-vm_map_ram-vm_unmap_ram-test-case.patch

