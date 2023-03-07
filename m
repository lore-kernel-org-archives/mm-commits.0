Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AEEC6FA99
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 20:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCGUVH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 15:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjCGUVG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 15:21:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EC6DA335F
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 12:21:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42B7CB819BA
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 20:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DB9C433EF;
        Tue,  7 Mar 2023 20:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678220459;
        bh=tthw1/pVlWldCi6Xi/4Pwoy50ialsoovQ3nKTxnJZ9E=;
        h=Date:To:From:Subject:From;
        b=e449WVh2cXJKnJBYy+G0CNc0r60/SpGqQ5+BmEVtp6gu/57lJVz95s9U4qHwxjBN6
         M8kOWOJF1zo8T8s9wPu/TlITlZVnuc3oKOmZScozD00mL+AoOrJqqR4fVRsfxmuQEb
         gjpalDsPnBP0juqxWWvMQZd2GHKSy2zCmhSVjb6E=
Date:   Tue, 07 Mar 2023 12:20:59 -0800
To:     mm-commits@vger.kernel.org, spasswolf@web.de,
        Liam.Howlett@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-mprotect-fix-successful-vma_merge-of-next-in-do_mprotect_pkey.patch removed from -mm tree
Message-Id: <20230307202059.D2DB9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mprotect: Fix successful vma_merge() of next in do_mprotect_pkey()
has been removed from the -mm tree.  Its filename was
     mm-mprotect-fix-successful-vma_merge-of-next-in-do_mprotect_pkey.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mprotect: Fix successful vma_merge() of next in do_mprotect_pkey()
Date: Fri, 24 Feb 2023 16:20:55 -0500

If mprotect_fixup() successfully calls vma_merge() and replaces vma and
the next vma, then the tmp variable in the do_mprotect_pkey() is not
updated to point to the new vma end.  This results in the loop detecting a
gap between VMAs that does not exist.  Fix the faulty value of tmp by
setting it to the end location of the vma iterator at the end of the loop.

Link: https://lkml.kernel.org/r/20230224212055.1786100-1-Liam.Howlett@oracle.com
Fixes: 2286a6914c77 ("mm: change mprotect_fixup to vma iterator")
Link: https://lore.kernel.org/linux-mm/20230223120407.729110a6ecd1416ac59d9cb0@linux-foundation.org/
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Bert Karwatzki <spasswolf@web.de>
  Link: https://bugzilla.kernel.org/show_bug.cgi?id=217061
Tested-by: Bert Karwatzki <spasswolf@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mprotect.c~mm-mprotect-fix-successful-vma_merge-of-next-in-do_mprotect_pkey
+++ a/mm/mprotect.c
@@ -832,6 +832,7 @@ static int do_mprotect_pkey(unsigned lon
 		if (error)
 			break;
 
+		tmp = vma_iter_end(&vmi);
 		nstart = tmp;
 		prot = reqprot;
 	}
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

maple_tree-fix-mas_skip_node-end-slot-detection.patch
test_maple_tree-add-more-testing-for-mas_empty_area.patch
maple_tree-be-more-cautious-about-dead-nodes.patch
maple_tree-detect-dead-nodes-in-mas_start.patch
maple_tree-fix-freeing-of-nodes-in-rcu-mode.patch
maple_tree-remove-extra-smp_wmb-from-mas_dead_leaves.patch
maple_tree-fix-write-memory-barrier-of-nodes-once-dead-for-rcu-mode.patch
maple_tree-add-smp_rmb-to-dead-node-detection.patch
maple_tree-add-rcu-lock-checking-to-rcu-callback-functions.patch
mm-enable-maple-tree-rcu-mode-by-default.patch

