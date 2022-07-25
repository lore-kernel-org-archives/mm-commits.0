Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9348BC433EF
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jul 2022 19:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbiGYTU5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jul 2022 15:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiGYTU5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2022 15:20:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C3D558D
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 12:20:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34FC761011
        for <mm-commits@vger.kernel.org>; Mon, 25 Jul 2022 19:20:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0C0C341C6;
        Mon, 25 Jul 2022 19:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658776855;
        bh=UQIkZDfNTPWHl4eZ5saP1rNi72j8Upd9JayqknGix5E=;
        h=Date:To:From:Subject:From;
        b=iChKFUsPpDatfu6FrKlgYJFp/HkmK/q2yP7GkVf1cwZpMVly3VmU6hrEhpHuQnOjm
         xej9PPIOPE9K8a+pJtxNGWVYaIKv5SLWzIXgZpArP/8bBZr6DkMUNZXCxLNGD3gknG
         rOGmsdetsqL0Ey3iqFhlv8/AjiCOSi5vq16I2W/Q=
Date:   Mon, 25 Jul 2022 12:20:54 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        Liam.Howlett@oracle.com, liam.howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-fork-use-maple-tree-for-dup_mmap-during-forking-fix.patch added to mm-unstable branch
Message-Id: <20220725192055.8A0C0C341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/fork: detect mas_store() failure in dup_mmap()
has been added to the -mm mm-unstable branch.  Its filename is
     kernel-fork-use-maple-tree-for-dup_mmap-during-forking-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-fork-use-maple-tree-for-dup_mmap-during-forking-fix.patch

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
From: Liam Howlett <liam.howlett@oracle.com>
Subject: kernel/fork: detect mas_store() failure in dup_mmap()
Date: Fri, 22 Jul 2022 16:06:03 +0000

mas_store() should not fail, but protect against potential failures by
checking the maple state for mas_is_err().

Link: https://lkml.kernel.org/r/20220722160546.1478722-3-Liam.Howlett@oracle.com
Fixes: 57579b57de57 (kernel/fork: use maple tree for dup_mmap() during forking)
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/fork.c~kernel-fork-use-maple-tree-for-dup_mmap-during-forking-fix
+++ a/kernel/fork.c
@@ -709,6 +709,8 @@ static __latent_entropy int dup_mmap(str
 		mas.index = tmp->vm_start;
 		mas.last = tmp->vm_end - 1;
 		mas_store(&mas, tmp);
+		if (mas_is_err(&mas))
+			goto fail_nomem_mas_store;
 
 		mm->map_count++;
 		if (!(tmp->vm_flags & VM_WIPEONFORK))
@@ -732,6 +734,9 @@ out:
 fail_uprobe_end:
 	uprobe_end_dup_mmap();
 	return retval;
+
+fail_nomem_mas_store:
+	unlink_anon_vmas(tmp);
 fail_nomem_anon_vma_fork:
 	mpol_put(vma_policy(tmp));
 fail_nomem_policy:
_

Patches currently in -mm which might be from liam.howlett@oracle.com are

android-binder-fix-lockdep-check-on-clearing-vma.patch
maple-tree-add-new-data-structure-fix.patch
kernel-fork-use-maple-tree-for-dup_mmap-during-forking-fix.patch
mm-mlock-drop-dead-code-in-count_mm_mlocked_page_nr.patch

