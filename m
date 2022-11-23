Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70743C46467
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 19:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbiKWT7I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Nov 2022 14:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239949AbiKWT6C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Nov 2022 14:58:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D171D310
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 11:57:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7E5661EE3
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 19:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2521C433C1;
        Wed, 23 Nov 2022 19:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669233476;
        bh=7undMfy1VzlMk5plttukmPe1ZwG0SwwkVXjNVl2iocQ=;
        h=Date:To:From:Subject:From;
        b=hthsv9z/e1L03ec2KJC+eLBjmTfpqoTvFLCeB6IG35QSxKVyNjWXKRDMG/uZ28x/r
         K2gGmFH7yPh7zcLszrgRZO5QT5t9rLqOzUg3AvuUKwkh0Toco3DUG4j/PQSk6rmsnK
         1NSTC9QZtpMTJYXP5RmZ1eUMIIna+o3/TdjSaVYE=
Date:   Wed, 23 Nov 2022 11:57:55 -0800
To:     mm-commits@vger.kernel.org, zokeefe@google.com, mhocko@suse.com,
        shy828301@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4.patch added to mm-hotfixes-unstable branch
Message-Id: <20221123195755.F2521C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: replace VM_WARN_ON to pr_warn if the node is offline with __GFP_THISNODE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Yang Shi <shy828301@gmail.com>
Subject: mm: replace VM_WARN_ON to pr_warn if the node is offline with __GFP_THISNODE
Date: Wed, 23 Nov 2022 11:30:14 -0800

renamed nid to this_node and gfp to warn_gfp to make the code more
readable per Michal.

Link: https://lkml.kernel.org/r/20221123193014.153983-1-shy828301@gmail.com
Reported-by: syzbot+0044b22d177870ee974f@syzkaller.appspotmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Michal Hocko <mhocko@suse.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/include/linux/gfp.h~mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4
+++ a/include/linux/gfp.h
@@ -210,14 +210,18 @@ alloc_pages_bulk_array_node(gfp_t gfp, i
 	return __alloc_pages_bulk(gfp, nid, NULL, nr_pages, NULL, page_array);
 }
 
-static inline void warn_if_node_offline(int nid, gfp_t gfp_mask)
+static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
 {
-	gfp_t gfp = gfp_mask & (__GFP_THISNODE|__GFP_NOWARN);
+	gfp_t warn_gfp = gfp_mask & (__GFP_THISNODE|__GFP_NOWARN);
 
-	if ((gfp == (__GFP_THISNODE|__GFP_NOWARN)) && !node_online(nid)) {
-		pr_warn("%pGg allocation from offline node %d\n", &gfp, nid);
-		dump_stack();
-	}
+	if (warn_gfp != (__GFP_THISNODE|__GFP_NOWARN))
+		return;
+
+	if(node_online(this_node))
+		return;
+
+	pr_warn("%pGg allocation from offline node %d\n", &warn_gfp, this_node);
+	dump_stack();
 }
 
 /*
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode.patch
mm-replace-vm_warn_on-to-pr_warn-if-the-node-is-offline-with-__gfp_thisnode-v4.patch

