Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44849C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 29 Mar 2022 01:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiC2BWJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Mar 2022 21:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiC2BWA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2022 21:22:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0DA2C660
        for <mm-commits@vger.kernel.org>; Mon, 28 Mar 2022 18:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7305FB815A0
        for <mm-commits@vger.kernel.org>; Tue, 29 Mar 2022 01:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12DC7C340EC;
        Tue, 29 Mar 2022 01:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648516816;
        bh=oMGY1RgnIcClserK+ASxrS1KKoc4pRZBq+/tSGHfv7c=;
        h=Date:To:From:Subject:From;
        b=GuZTcbBy10NKdazzqnmVrmLOketil3Eq5mIsxcFzX9I0YhaQgbXjKyhCO7fQgd8y5
         Qq0cDoeiexEcgqOeFxiVY804eQzyITq7tibEkaa2h3RIvMcPnbbi0M2p5EPSAEylD8
         8tDdN7gYHbe5QjE9S9SXDLei2XPQbCFHAoGsG24U=
Date:   Mon, 28 Mar 2022 18:20:15 -0700
To:     mm-commits@vger.kernel.org, osalvador@suse.de,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch added to -mm tree
Message-Id: <20220329012016.12DC7C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch

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
Subject: mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes

WARNING: 'succesfully' may be misspelled - perhaps 'successfully'?
#6: 
whether the node was succesfully allocated.
                     ^^^^^^^^^^^

WARNING: 'succesfully' may be misspelled - perhaps 'successfully'?
#64: FILE: mm/memory_hotplug.c:1188:
+ * 0 -> Either the node was already online, or we succesfully registered a new
                                                   ^^^^^^^^^^^

WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
#97: FILE: mm/memory_hotplug.c:1206:
+	BUG_ON(ret);

total: 0 errors, 3 warnings, 62 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes
+++ a/mm/memory_hotplug.c
@@ -1185,7 +1185,7 @@ static void hotadd_init_pgdat(int nid)
  *
  * Returns:
  * 1 -> The node has been initialized.
- * 0 -> Either the node was already online, or we succesfully registered a new
+ * 0 -> Either the node was already online, or we successfully registered a new
  *      one.
  * -errno -> register_one_node() failed.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

