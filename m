Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB82C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiKJAY6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiKJAY5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:24:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFCFA28E36
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:24:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 48964CE1FF4
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD4AC433D7;
        Thu, 10 Nov 2022 00:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668039893;
        bh=MAc/bDx4bUwFYtB+zFwoMpbtcB5xpqMrs55kb8jfKBg=;
        h=Date:To:From:Subject:From;
        b=PyUUwYjtdTnI3KJ6vK00Hg3u2Dy7+MonjPvlIa8RxbtatqPf982WrkbQraPBgwNnh
         35LXxk1TDYLnT/TAIOHTXprZxdVrfEYwK80WnYgxqKNZ1mP5fLs7uYcuJRmHqE/vWy
         CDkTsEJ2lu3mmGzOdUT9/zKv9SjbHjCchZ/gB0mo=
Date:   Wed, 09 Nov 2022 16:24:52 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, rongtao@cestc.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + radix-tree-test-suite-fix-uninitialized-variable-compilation-warning.patch added to mm-nonmm-unstable branch
Message-Id: <20221110002453.7CD4AC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/radix-tree.c: fix uninitialized variable compilation warning
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     radix-tree-test-suite-fix-uninitialized-variable-compilation-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/radix-tree-test-suite-fix-uninitialized-variable-compilation-warning.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Rong Tao <rongtao@cestc.cn>
Subject: lib/radix-tree.c: fix uninitialized variable compilation warning
Date: Wed, 9 Nov 2022 22:34:25 +0800

We need to set an initial value for offset to eliminate compilation
warning.

How to reproduce warning:

$ make -C tools/testing/radix-tree
radix-tree.c: In function `radix_tree_tag_clear':
radix-tree.c:1046:17: warning: `offset' may be used uninitialized in this function [-Wmaybe-uninitialized]
 1046 |                 node_tag_clear(root, parent, tag, offset);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Link: https://lkml.kernel.org/r/tencent_DF74099967595DCEA93CBDC28D062026180A@qq.com
Signed-off-by: Rong Tao <rongtao@cestc.cn>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/radix-tree.c~radix-tree-test-suite-fix-uninitialized-variable-compilation-warning
+++ a/lib/radix-tree.c
@@ -1029,7 +1029,7 @@ void *radix_tree_tag_clear(struct radix_
 {
 	struct radix_tree_node *node, *parent;
 	unsigned long maxindex;
-	int offset;
+	int offset = 0;
 
 	radix_tree_load_root(root, &node, &maxindex);
 	if (index > maxindex)
_

Patches currently in -mm which might be from rongtao@cestc.cn are

tools-vm-page_owner-ignore-page_owner_sort-binary.patch
radix-tree-test-suite-fix-uninitialized-variable-compilation-warning.patch

