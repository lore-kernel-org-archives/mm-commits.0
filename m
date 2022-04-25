Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 811B4C43217
	for <mm-commits@archiver.kernel.org>; Mon, 25 Apr 2022 22:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiDYWYh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Apr 2022 18:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343703AbiDYWQ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2022 18:16:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD5333340
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 15:13:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A16B61357
        for <mm-commits@vger.kernel.org>; Mon, 25 Apr 2022 22:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B027C385A9;
        Mon, 25 Apr 2022 22:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650924800;
        bh=PK9JMRUEEVpgZPP4dnxFWc0nut0cihTOarsBUqAbkys=;
        h=Date:To:From:Subject:From;
        b=XfW4HEexRCfBp7h4Y95DqX9QxnmNEawNrhydJdgLqGU0VAzLFeH46HtnBGMB0f5TU
         Fabv+lkyfZPbsUqQGZdpMrza4wpbqACsf03LyHYZH+tQnF4BKmnd5ffVa82doGFHTE
         D7vd1Xfh4CLnhtr4tYHBURCF0xBN36G77KAQM/bU=
Date:   Mon, 25 Apr 2022 15:13:19 -0700
To:     mm-commits@vger.kernel.org, sudipm.mukherjee@gmail.com,
        song@kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] mm-nommuc-provide-vmalloc_huge-for-config_mmu=n.patch removed from -mm tree
Message-Id: <20220425221320.7B027C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu.c: provide vmalloc_huge() for CONFIG_MMU=n
has been removed from the -mm tree.  Its filename was
     mm-nommuc-provide-vmalloc_huge-for-config_mmu=n.patch

This patch was dropped because an alternative patch was merged

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

