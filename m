Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E19C64ED6
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 22:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjBZWks (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 17:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjBZWkr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 17:40:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8B8F96B
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 14:40:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6FC56CE0EA3
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 22:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934ECC433D2;
        Sun, 26 Feb 2023 22:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677451242;
        bh=e2hxr3taXKdBmyhUXCwOflICYhetEpt6A4nw/FV3/U8=;
        h=Date:To:From:Subject:From;
        b=rPlblYqwnrlLRpffIkHOk4f0W3C+/vw8vEDRrqxvndd1IaMYjQW6Afpwqtm+sQie3
         0Gvu7XnCWGUlfIfP8EemkxAPcG8QpZEBjnCZQePJl8wrEXpt0OZzEE17xdJuKQ50iL
         AzvtbqlF8DuaKxTAAeRFo9v6KjLUs0E2AxF+gLRg=
Date:   Sun, 26 Feb 2023 14:40:41 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        senozhatsky@chromium.org, rostedt@goodmis.org, pmladek@suse.com,
        john.ogness@linutronix.de, joe@perches.com, david@redhat.com,
        andriy.shevchenko@linux.intel.com, 42.hyeyoo@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug-use-%pgt-to-display-page_type-in-dump_page.patch added to mm-unstable branch
Message-Id: <20230226224042.934ECC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug: use %pGt to display page_type in dump_page()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug-use-%pgt-to-display-page_type-in-dump_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug-use-%pgt-to-display-page_type-in-dump_page.patch

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


diff --git a/mm/debug.c~mm-debug-use-%pgt-to-display-page_type-in-dump_page b/mm/debug.c
--- a/mm/debug.c~mm-debug-use-%pgt-to-display-page_type-in-dump_page
+++ b/mm/debug.c
@@ -120,6 +120,8 @@ static void __dump_page(struct page *page)
 
 	pr_warn("%sflags: %pGp%s\n", type, &head->flags,
 		page_cma ? " CMA" : "");
+	pr_warn("page_type: %pGt\n", &head->page_type);
+
 	print_hex_dump(KERN_WARNING, "raw: ", DUMP_PREFIX_NONE, 32,
 			sizeof(unsigned long), page,
 			sizeof(struct page), false);
_

Patches currently in -mm which might be from 42.hyeyoo@gmail.com are

mmflagsh-use-less-error-prone-method-to-define-pageflag_names.patch
mm-printk-introduce-new-format-%pgt-for-page_type.patch
mm-debug-use-%pgt-to-display-page_type-in-dump_page.patch

