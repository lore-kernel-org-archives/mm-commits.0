Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67FB0C43219
	for <mm-commits@archiver.kernel.org>; Wed, 13 Apr 2022 21:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238938AbiDMVNX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Apr 2022 17:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238889AbiDMVNV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Apr 2022 17:13:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEB43A5C1
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 14:10:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90A43B82790
        for <mm-commits@vger.kernel.org>; Wed, 13 Apr 2022 21:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47625C385A3;
        Wed, 13 Apr 2022 21:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649884256;
        bh=jWZpzpCdAED171FGDh5ME1njJc+9k11HcVfvHvkh0OI=;
        h=Date:To:From:Subject:From;
        b=zWJX52M5AhcKVbIcOnTJBKf0Fbz05dC/S0IRJ8Q5GiUAXW/JKzUu6ivXgrGtwTJWt
         KqVIZsyzdZAeNNn2QW5GDz4rViki6pOt4+lqIm/mX83/+ys2+bs9JzpuNaXtpCRcu6
         ozRfgVBm1kBegE/Uyu9mYTQceXkIJvO6ok/tx7kE=
Date:   Wed, 13 Apr 2022 14:10:55 -0700
To:     mm-commits@vger.kernel.org, surenb@google.com, rppt@linux.ibm.com,
        rientjes@google.com, quic_sudaraja@quicinc.com,
        anshuman.khandual@arm.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist-fix.patch removed from -mm tree
Message-Id: <20220413211056.47625C385A3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist-fix.patch

This patch was dropped because it was folded into mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist-fix

add comment, per David

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Sudarshan Rajagopalan <quic_sudaraja@quicinc.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist-fix
+++ a/mm/page_alloc.c
@@ -2522,6 +2522,10 @@ static int move_freepages(struct zone *z
 
 	for (pfn = start_pfn; pfn <= end_pfn;) {
 		if (!pfn_valid(pfn)) {
+			/*
+			 * Pageblock alignment may cause us to try to access
+			 * into a hole
+			 */
 			pfn++;
 			continue;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-fs-binfmt_elf-fix-pt_load-p_align-values-for-loaders.patch
revert-fs-binfmt_elf-use-pt_load-p_align-values-for-static-pie.patch
mm-page_alloc-check-pfn-is-valid-before-moving-to-freelist.patch
mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

