Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCD5C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 00:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356622AbhK1AWm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 19:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237365AbhK1AUm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 19:20:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03A0C061758
        for <mm-commits@vger.kernel.org>; Sat, 27 Nov 2021 16:17:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 741A0B80B2C
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 00:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD510C53FBF;
        Sun, 28 Nov 2021 00:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638058644;
        bh=at19d6P5r9J9rQPm+9tZjwZHfrLUP1h4z+qx/dAAP2s=;
        h=Date:From:To:Subject:From;
        b=afh8MQM8jWYt/OHBYITnkgAOnTDaoMaUvOtmKSLL8jDuBnK2wvR2iz5NsbKOdH+d0
         d9ijkGl3A3uBa8tAzZq8AptjA71HManKqJ2BZ1kHsWQJleKAv44IEzM/iOFnasLsc4
         R30DrKW4Fz77xN+mvHtIQ1SnwCxogQmu3cx7haug=
Date:   Sat, 27 Nov 2021 16:17:23 -0800
From:   akpm@linux-foundation.org
To:     ch0.han@lge.com, mm-commits@vger.kernel.org, seanga2@gmail.com,
        sfr@canb.auug.org.au, tangbin@cmss.chinamobile.com,
        weizhenliang@huawei.com, zhangshengju@cmss.chinamobile.com
Subject:  +
 tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling-fix.patch added
 to -mm tree
Message-ID: <20211128001723.NeHg5hxRP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page_owner_sort.c: fix NULL-pointer dereference when comparing stack traces
has been added to the -mm tree.  Its filename is
     tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sean Anderson <seanga2@gmail.com>
Subject: tools/vm/page_owner_sort.c: fix NULL-pointer dereference when comparing stack traces

If there is no newline in a block, then strchr returns NULL.  We check for
this in stacktrace_compare, but not when culling.  Fix this (and any
future bugs like it) by replacing NULL stack traces with "" in add_list.

Link: https://lkml.kernel.org/r/20211125162653.1855958-1-seanga2@gmail.com
Fixes: d0abbab9e9e9 ("tools/vm/page_owner_sort.c: sort by stacktrace before culling")
Signed-off-by: Sean Anderson <seanga2@gmail.com>
Cc: Changhee Han <ch0.han@lge.com>
Cc: Zhenliang Wei <weizhenliang@huawei.com>
Cc: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Cc: Tang Bin <tangbin@cmss.chinamobile.com>
Cc: Sean Anderson <seanga2@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page_owner_sort.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/vm/page_owner_sort.c~tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling-fix
+++ a/tools/vm/page_owner_sort.c
@@ -56,7 +56,7 @@ static int compare_stacktrace(const void
 {
 	const struct block_list *l1 = p1, *l2 = p2;
 
-	return strcmp(l1->stacktrace ?: "", l2->stacktrace ?: "");
+	return strcmp(l1->stacktrace, l2->stacktrace);
 }
 
 static int compare_num(const void *p1, const void *p2)
@@ -122,7 +122,7 @@ static void add_list(char *buf, int len)
 	list[list_size].page_num = get_page_num(buf);
 	memcpy(list[list_size].txt, buf, len);
 	list[list_size].txt[len] = 0;
-	list[list_size].stacktrace = strchr(list[list_size].txt, '\n');
+	list[list_size].stacktrace = strchr(list[list_size].txt, '\n') ?: "";
 	list_size++;
 	if (list_size % 1000 == 0) {
 		printf("loaded %d\r", list_size);
_

Patches currently in -mm which might be from seanga2@gmail.com are

tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling.patch
tools-vm-page_owner_sortc-sort-by-stacktrace-before-culling-fix.patch
tools-vm-page_owner_sortc-support-sorting-by-stack-trace.patch

