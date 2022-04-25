Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6019AC43219
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 22:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbiDYWYi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 18:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343514AbiDYVaU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 17:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08120220CE
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 14:27:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98BCC61348
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 21:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4FFC385A9;
        Mon, 25 Apr 2022 21:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650922034;
        bh=KK+sSN7HCUkk8uPATCgMpo+9J9Dfnho3J9XyvgMY5r0=;
        h=Date:To:From:Subject:From;
        b=pcGq/RFX66+PXyHYmK+wEZHjAy0Jf29FfLsOA6tZNPY6uCay+AnkqcntY0rYvLFdN
         AZ2aqVqt5dkoe3SugXwum0CTSa7mF5wnecgEiuGTxS7RItQ3kwUswK5KC2yk3tViNR
         mxZHliyilOzzy/evROWHqKEIT1YyknoqSjPcItIc=
Date:   Mon, 25 Apr 2022 14:27:13 -0700
To:     mm-commits@vger.kernel.org, sudipm.mukherjee@gmail.com,
        song@kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-nommuc-provide-vmalloc_huge-for-config_mmu=n.patch added to -mm tree
Message-Id: <20220425212713.ED4FFC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu.c: provide vmalloc_huge() for CONFIG_MMU=n
has been added to the -mm tree.  Its filename is
     mm-nommuc-provide-vmalloc_huge-for-config_mmu=n.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-nommuc-provide-vmalloc_huge-for-config_mmu=n.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-nommuc-provide-vmalloc_huge-for-config_mmu=n.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/nommu.c: provide vmalloc_huge() for CONFIG_MMU=n

Fixes: f2edd118d02dd ("page_alloc: use vmalloc_huge for large system hash")
Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Song Liu <song@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/nommu.c~mm-nommuc-provide-vmalloc_huge-for-config_mmu=n
+++ a/mm/nommu.c
@@ -226,6 +226,12 @@ void *vmalloc(unsigned long size)
 }
 EXPORT_SYMBOL(vmalloc);
 
+void *vmalloc_huge(unsigned long size, gfp_t gfp_mask)
+{
+	return vmalloc(size);
+}
+EXPORT_SYMBOL(vmalloc_huge);
+
 /*
  *	vzalloc - allocate virtually contiguous memory with zero fill
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-prevent-cpu_quarantine-corruption-when-cpu-offline-and-cache-shrink-occur-at-same-time-fix.patch
mm-nommuc-provide-vmalloc_huge-for-config_mmu=n.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

