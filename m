Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17728C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 02:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbiELCJv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 May 2022 22:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237316AbiELCJu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2022 22:09:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C036D4E5
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 19:09:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D350160DF0
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 02:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C69C340EE;
        Thu, 12 May 2022 02:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652321389;
        bh=NZo2MsqTqkcMuT6oLof2XF/4Sp0avBylB1lk6GkHTGs=;
        h=Date:To:From:Subject:From;
        b=Kxi7VrncA7Wwc9rH3ZQtKyG7OfBQIJKdKiKj0jt5re0JE941t/HzGu3pf9rvX3AVD
         ItPIEkol48uEY6389IoJQEfbSYoyTr+LbsbqDxm61ws7tFyVRa+K9c0UacVkGpvghb
         WxFoamgLqql1z16QFv6Ms2XIgETgpT40fNnZ/+ZE=
Date:   Wed, 11 May 2022 19:09:48 -0700
To:     mm-commits@vger.kernel.org, stephen.s.brennan@oracle.com,
        len.baker@gmx.com, gustavoars@kernel.org, dhowells@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + assoc_array-fix-bug_on-during-garbage-collect-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20220512020949.35C69C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: assoc_array-fix-bug_on-during-garbage-collect-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     assoc_array-fix-bug_on-during-garbage-collect-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/assoc_array-fix-bug_on-during-garbage-collect-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: assoc_array-fix-bug_on-during-garbage-collect-fix

fix typo in printk

Cc: David Howells <dhowells@redhat.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Len Baker <len.baker@gmx.com>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/assoc_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/assoc_array.c~assoc_array-fix-bug_on-during-garbage-collect-fix
+++ a/lib/assoc_array.c
@@ -1610,7 +1610,7 @@ retry_compress:
 	}
 
 	if (retained && new_n->nr_leaves_on_branch < ASSOC_ARRAY_FAN_OUT) {
-		pr_devel("internal nodes remain despite neough space, retrying\n");
+		pr_devel("internal nodes remain despite enough space, retrying\n");
 		goto retry_compress;
 	}
 	pr_devel("after: %lu\n", new_n->nr_leaves_on_branch);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

assoc_array-fix-bug_on-during-garbage-collect-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
lib-kstrtoxc-add-false-true-support-to-kstrtobool-fix.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-rmap-fix-cont-pte-pmd-size-hugetlb-issue-when-migration-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

