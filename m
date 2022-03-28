Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25FFC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 28 Mar 2022 21:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiC1V2d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 17:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiC1V2c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 17:28:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE5C3A5CB
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 14:26:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 528016151F
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 21:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C07C340F0;
        Mon, 28 Mar 2022 21:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648502798;
        bh=ECe3iDBNWkWjJR4C/aGejivcf2bFnUoDbXOjpxGyn8A=;
        h=Date:To:From:Subject:From;
        b=emMfV2zokq27nMJXnSoiLhhJZQPyel0yqc7D8Kax/XLkfVPqpGmmu3hErTYnAbiZ4
         UAqaQT62/CRf62yrCTF/5TbWM4wCdBpuvdZuuCAjD12gkpP87kGhZ7eXj/jxGX5DOI
         gA44v9Ry9H1GUwkhOkWrZxQ5aSWh6ZUbf+XARnIY=
Date:   Mon, 28 Mar 2022 14:26:37 -0700
To:     mm-commits@vger.kernel.org, xiyuyang19@fudan.edu.cn,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch removed from -mm tree
Message-Id: <20220328212638.A8C07C340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch

This patch was dropped because it was folded into mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix

fix warnings

mm/mempolicy.c:125:42: warning: missing braces around initializer [-Wmissing-braces]
  125 | static struct mempolicy default_policy = {
      |                                          ^
mm/mempolicy.c:125:42: warning: missing braces around initializer [-Wmissing-braces]
mm/mempolicy.c: In function 'numa_policy_init':
mm/mempolicy.c:2815:32: warning: missing braces around initializer [-Wmissing-braces]
 2815 |   preferred_node_policy[nid] = (struct mempolicy) {
      |                                ^
mm/mempolicy.c:2815:32: warning: missing braces around initializer [-Wmissing-braces]

Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix
+++ a/mm/mempolicy.c
@@ -123,7 +123,7 @@ enum zone_type policy_zone = 0;
  * run-time system-wide default policy => local allocation
  */
 static struct mempolicy default_policy = {
-	.refcnt = ATOMIC_INIT(1), /* never free it */
+	.refcnt = { ATOMIC_INIT(1), }, /* never free it */
 	.mode = MPOL_LOCAL,
 };
 
@@ -2891,7 +2891,7 @@ void __init numa_policy_init(void)
 
 	for_each_node(nid) {
 		preferred_node_policy[nid] = (struct mempolicy) {
-			.refcnt = ATOMIC_INIT(1),
+			.refcnt = { ATOMIC_INIT(1), },
 			.mode = MPOL_PREFERRED,
 			.flags = MPOL_F_MOF | MPOL_F_MORON,
 			.nodes = nodemask_of_node(nid),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-shmem-make-shmem_init-return-void-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

