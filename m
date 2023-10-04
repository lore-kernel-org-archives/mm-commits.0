Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A24E936E1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245056AbjJDUXh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244241AbjJDUXM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214B9C9
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B69C433CB;
        Wed,  4 Oct 2023 20:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450988;
        bh=F4r7ZBgN8aF5A82m7i2J9CIqQybQyqrvObvcVKz+0pw=;
        h=Date:To:From:Subject:From;
        b=iYuLZyuNGOb2PNrIY7SqirOFaUncth2apO92aC5HRsrdIdnoJJtb/7fLMhyRmabI0
         frRhjDU/ZF5ViRkC19ptHQUCXa/zDLZKb6CQAQ9atqgt5G3iLagySfg6fK7kR7KGFb
         7C8RFFMJjjl53vLgo6rLOXBdQB8rnpWbZK801wXI=
Date:   Wed, 04 Oct 2023 13:23:07 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        agruenba@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kthread-add-kthread_stop_put-v2-fix.patch removed from -mm tree
Message-Id: <20231004202308.85B69C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kthread-add-kthread_stop_put-v2-fix
has been removed from the -mm tree.  Its filename was
     kthread-add-kthread_stop_put-v2-fix.patch

This patch was dropped because it was folded into kthread-add-kthread_stop_put.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kthread-add-kthread_stop_put-v2-fix
Date: Tue Sep 12 10:41:17 AM PDT 2023

document kthread_stop_put()'s argument

Cc: Andreas Gruenbacher <agruenba@redhat.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lkml.kernel.org/r/20230912152030.34e9ac3d@canb.auug.org.au

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/kthread.c~kthread-add-kthread_stop_put-v2-fix
+++ a/kernel/kthread.c
@@ -717,6 +717,7 @@ EXPORT_SYMBOL(kthread_stop);
 
 /**
  * kthread_stop_put - stop a thread and put its task struct
+ * @k: thread created by kthread_create().
  *
  * Stops a thread created by kthread_create() and put its task_struct.
  * Only use when holding an extra task struct reference obtained by
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-ksm-add-smart-page-scanning-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix-2.patch
mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap-fix.patch
mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files-fix.patch
kthread-add-kthread_stop_put.patch

