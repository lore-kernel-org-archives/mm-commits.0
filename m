Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3279C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 03:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244600AbiDADiD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 23:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243912AbiDADiC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 23:38:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194FBF3A79
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 20:36:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A63C460DBD
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 03:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A47C2BBE4;
        Fri,  1 Apr 2022 03:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648784172;
        bh=AInadizoGL7/sRVMbv/80jGte1gPCgVMj5sG/1lOfQU=;
        h=Date:To:From:Subject:From;
        b=Hmqkyid5E2CPSsyRv86j/FQhCpqqVxENYdIU/Q8GzM+qTkGiXy0EecT/+H+fCAFJp
         CE9R9x0PcKGI2abmyzu5Ij9FUWqV/2zb1nPZzlyxNImFsk9eFtuFljoK9MijrJ7Pxn
         6XPapqLktZP4dH92JWiNDVE/PaMi/f8GMANAxvO0=
Date:   Thu, 31 Mar 2022 20:36:11 -0700
To:     mm-commits@vger.kernel.org, trond.myklebust@hammerspace.com,
        neilb@suse.de, mgorman@techsingularity.net, hughd@google.com,
        hch@lst.de, dhowells@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-create-new-mm-swaph-header-file-fix.patch added to -mm tree
Message-Id: <20220401033612.02A47C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-create-new-mm-swaph-header-file-fix
has been added to the -mm tree.  Its filename is
     mm-create-new-mm-swaph-header-file-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-create-new-mm-swaph-header-file-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-create-new-mm-swaph-header-file-fix.patch

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
Subject: mm-create-new-mm-swaph-header-file-fix

mm/memory-failure.c needs mm/swap.h

Cc: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: NeilBrown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory-failure.c~mm-create-new-mm-swaph-header-file-fix
+++ a/mm/memory-failure.c
@@ -59,6 +59,7 @@
 #include <linux/page-isolation.h>
 #include <linux/pagewalk.h>
 #include <linux/shmem_fs.h>
+#include "swap.h"
 #include "internal.h"
 #include "ras/ras_event.h"
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node.patch
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

