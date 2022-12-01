Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53709C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiLAAR1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiLAARB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:17:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624C6920B3
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:13:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDDA461903
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CDCC43470;
        Thu,  1 Dec 2022 00:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669853635;
        bh=vcfnrdEStZK2ygb+Zmnpptg3CLFJ+RJGmKYRiS7xhyo=;
        h=Date:To:From:Subject:From;
        b=PoOVbKTfcY+L3ctfBpiKAD2rexKtooDiT7WhAxC5Eepr5/aWg6Srh36OHl9UW+cuW
         fip8MLBgt1Wb7kk7XFWI77TJy5vm+wY6js8tfRVC0opdOAL4sUZYBG6+XQuHhdw185
         9lSz+bhLpPXmKqpGB7QwnnpSpk3vbqH+I1MnrY8I=
Date:   Wed, 30 Nov 2022 16:13:54 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, rongtao@cestc.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] radix-tree-test-suite-fix-uninitialized-variable-compilation-warning.patch removed from -mm tree
Message-Id: <20221201001355.23CDCC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib/radix-tree.c: fix uninitialized variable compilation warning
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-fix-uninitialized-variable-compilation-warning.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


