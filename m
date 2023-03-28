Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FA9C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjC1XVn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjC1XV0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACFC2D51
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 752A2B81F56
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6E1C433D2;
        Tue, 28 Mar 2023 23:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045676;
        bh=yPCz4SaxldiADp0TY0CePdh78riF6OtW2bvh7l2uesI=;
        h=Date:To:From:Subject:From;
        b=zIsR3jJ1EgLO2g4+d83tGQI+UJ/qNEOpCeywgwZ1WkeLO47hKc6EYxS4fJk6UxvEh
         jwQVDOnqaMQedCE4R/rST2z2X54yz4tW2IcNloBlxJHpsE14qkjLFUcvqXt6eWYPVt
         /6MUS7uFK/+KBNFrDAznhHCkkgGCloan7CCk/HrM=
Date:   Tue, 28 Mar 2023 16:21:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        senozhatsky@chromium.org, rostedt@goodmis.org, pmladek@suse.com,
        john.ogness@linutronix.de, joe@perches.com, david@redhat.com,
        andriy.shevchenko@linux.intel.com, 42.hyeyoo@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug-use-%pgt-to-display-page_type-in-dump_page.patch removed from -mm tree
Message-Id: <20230328232116.1D6E1C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/debug: use %pGt to display page_type in dump_page()
has been removed from the -mm tree.  Its filename was
     mm-debug-use-%pgt-to-display-page_type-in-dump_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Subject: mm/debug: use %pGt to display page_type in dump_page()
Date: Mon, 30 Jan 2023 13:25:14 +0900

Some page flags are stored in page_type rather than ->flags field.
Use newly introduced page type %pGt in dump_page().

Below are some examples:

page:00000000da7184dd refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x101cb3
flags: 0x2ffff0000000000(node=0|zone=2|lastcpupid=0xffff)
page_type: 0xffffffff()
raw: 02ffff0000000000 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: newly allocated page

page:00000000da7184dd refcount:0 mapcount:-128 mapping:0000000000000000 index:0x0 pfn:0x101cb3
flags: 0x2ffff0000000000(node=0|zone=2|lastcpupid=0xffff)
page_type: 0xffffff7f(buddy)
raw: 02ffff0000000000 ffff88813fff8e80 ffff88813fff8e80 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffff7f 0000000000000000
page dumped because: freed page

page:0000000042202316 refcount:3 mapcount:2 mapping:0000000000000000 index:0x7f634722a pfn:0x11994e
memcg:ffff888100135000
anon flags: 0x2ffff0000080024(uptodate|active|swapbacked|node=0|zone=2|lastcpupid=0xffff)
page_type: 0x1()
raw: 02ffff0000080024 0000000000000000 dead000000000122 ffff8881193398f1
raw: 00000007f634722a 0000000000000000 0000000300000001 ffff888100135000
page dumped because: user-mapped page

Link: https://lkml.kernel.org/r/20230130042514.2418-4-42.hyeyoo@gmail.com
Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/debug.c~mm-debug-use-%pgt-to-display-page_type-in-dump_page
+++ a/mm/debug.c
@@ -120,6 +120,8 @@ static void __dump_page(struct page *pag
 
 	pr_warn("%sflags: %pGp%s\n", type, &head->flags,
 		page_cma ? " CMA" : "");
+	pr_warn("page_type: %pGt\n", &head->page_type);
+
 	print_hex_dump(KERN_WARNING, "raw: ", DUMP_PREFIX_NONE, 32,
 			sizeof(unsigned long), page,
 			sizeof(struct page), false);
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are


