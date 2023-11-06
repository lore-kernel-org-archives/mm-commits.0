Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E20F2C4167B
	for <mm-commits@archiver.kernel.org>; Mon,  6 Nov 2023 17:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbjKFR2P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Nov 2023 12:28:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbjKFR2L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Nov 2023 12:28:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E06125
        for <mm-commits@vger.kernel.org>; Mon,  6 Nov 2023 09:28:08 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAFDC433C9;
        Mon,  6 Nov 2023 17:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699291688;
        bh=mMed4leIE8gUHsMIIwFLnhBQbEYPOni1YfXtQtk1R44=;
        h=Date:To:From:Subject:From;
        b=SgKzj4xMp2URxPtZCM6YBgUkUiPi78uRag9jWCFc4S/4Ixgn/IHAhgUM0zYl5J6LG
         JUvXLlRFE+cJge9wq472bB+PDGwOikyp1gFFyOqD6oz0xZjk/5S8HzTEFtt+b4Smj8
         elcnz88s0VSnAaKm7x91otK9upy3KzYJzYa0HZf4=
Date:   Mon, 06 Nov 2023 09:28:07 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, surenb@google.com,
        peterz@infradead.org, npiggin@gmail.com, mst@redhat.com,
        mjguzik@gmail.com, michael.christie@oracle.com,
        mathieu.desnoyers@efficios.com, Liam.Howlett@oracle.com,
        corbet@lwn.net, brauner@kernel.org, zhangpeng.00@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-update-the-documentation-of-maple-tree.patch added to mm-unstable branch
Message-Id: <20231106172808.5CAFDC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: maple_tree: update the documentation of maple tree
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-update-the-documentation-of-maple-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-update-the-documentation-of-maple-tree.patch

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
From: Peng Zhang <zhangpeng.00@bytedance.com>
Subject: maple_tree: update the documentation of maple tree
Date: Fri, 27 Oct 2023 11:38:41 +0800

Introduce the new interface mtree_dup() in the documentation.

Link: https://lkml.kernel.org/r/20231027033845.90608-7-zhangpeng.00@bytedance.com
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/maple_tree.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/core-api/maple_tree.rst~maple_tree-update-the-documentation-of-maple-tree
+++ a/Documentation/core-api/maple_tree.rst
@@ -81,6 +81,9 @@ section.
 Sometimes it is necessary to ensure the next call to store to a maple tree does
 not allocate memory, please see :ref:`maple-tree-advanced-api` for this use case.
 
+You can use mtree_dup() to duplicate an entire maple tree. It is a more
+efficient way than inserting all elements one by one into a new tree.
+
 Finally, you can remove all entries from a maple tree by calling
 mtree_destroy().  If the maple tree entries are pointers, you may wish to free
 the entries first.
@@ -112,6 +115,7 @@ Takes ma_lock internally:
  * mtree_insert()
  * mtree_insert_range()
  * mtree_erase()
+ * mtree_dup()
  * mtree_destroy()
  * mt_set_in_rcu()
  * mt_clear_in_rcu()
_

Patches currently in -mm which might be from zhangpeng.00@bytedance.com are

maple_tree-add-mt_free_one-and-mt_attr-helpers.patch
maple_tree-introduce-mtreemas_lock_nested.patch
maple_tree-introduce-interfaces-__mt_dup-and-mtree_dup.patch
radix-tree-test-suite-align-kmem_cache_alloc_bulk-with-kernel-behavior.patch
maple_tree-add-test-for-mtree_dup.patch
maple_tree-update-the-documentation-of-maple-tree.patch
maple_tree-skip-other-tests-when-bench-is-enabled.patch
maple_tree-update-check_forking-and-bench_forking.patch
maple_tree-preserve-the-tree-attributes-when-destroying-maple-tree.patch
fork-use-__mt_dup-to-duplicate-maple-tree-in-dup_mmap.patch

