Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB1EECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiILDcF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiILDaD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:30:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE8C38F
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3BE76116D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16194C433C1;
        Mon, 12 Sep 2022 03:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953367;
        bh=o4dFkzs3BQ4/JAvi07ih9IaB73Dkz/lkoozlqZ82d4I=;
        h=Date:To:From:Subject:From;
        b=gGJlaCggesg2ldX6es9g7cXS0s/4Q5Bj3reDOxrWkq/8UCaBC98NAJAfDuIncVulR
         N4XlyH1iswris2IpvxIwQpfv/Hhi0efKZ6K6PhHfaTL0OKOMXkljnDkYaRM0FupQOG
         dioL7sBXIAMAJxPLvBhkXtp9bJS0xEU3CuYCI6Xc=
Date:   Sun, 11 Sep 2022 20:29:26 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs-v2.patch removed from -mm tree
Message-Id: <20220912032927.16194C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: fix possible use-after-free in mf_dax_kill_procs()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs-v2.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, hwpoison: fix possible use-after-free in mf_dax_kill_procs()
Date: Tue, 23 Aug 2022 11:23:44 +0800

After kill_procs(), tk will be freed without being removed from the
to_kill list.  In the next iteration, the freed list entry in the to_kill
list will be accessed, thus leading to use-after-free issue.  Adding
list_del() in kill_procs() to fix the issue.

Link: https://lkml.kernel.org/r/20220823032346.4260-5-linmiaohe@huawei.com
Fixes: c36e20249571 ("mm: introduce mf_dax_kill_procs() for fsdax case")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-possible-use-after-free-in-mf_dax_kill_procs-v2
+++ a/mm/memory-failure.c
@@ -413,7 +413,7 @@ static void kill_procs(struct list_head
 {
 	struct to_kill *tk, *next;
 
-	list_for_each_entry_safe (tk, next, to_kill, nd) {
+	list_for_each_entry_safe(tk, next, to_kill, nd) {
 		if (forcekill) {
 			/*
 			 * In case something went wrong with munmapping
@@ -437,6 +437,7 @@ static void kill_procs(struct list_head
 				pr_err("%#lx: Cannot send advisory machine check signal to %s:%d\n",
 				       pfn, tk->tsk->comm, tk->tsk->pid);
 		}
+		list_del(&tk->nd);
 		put_task_struct(tk->tsk);
 		kfree(tk);
 	}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

