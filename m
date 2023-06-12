Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94382C7EE2F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 21:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbjFLVdN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 17:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjFLVdN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 17:33:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3819690
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 14:33:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C89196175D
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 21:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C1FC433EF;
        Mon, 12 Jun 2023 21:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686605591;
        bh=ic3TgJZS0X5SZ5+KvZR5OThIIgJdJwALD1D1efRj2ww=;
        h=Date:To:From:Subject:From;
        b=kc6G9S3hBdbE2R0VCMPfE7UX2/tjTXOsqEcr1i+2mhqTSCg1Qf3CSTXM5/paAYbbe
         yMxWjXhW7lWS3wB4S9Xn3rt9cdMa1HC989sF4lTDKUJYquD2m0PNpisyXE1eh9ZZrL
         R+whPm266J+mFE+cenphi94dRjJyDRM6HhRdcclQ=
Date:   Mon, 12 Jun 2023 14:33:10 -0700
To:     mm-commits@vger.kernel.org, baolin.wang@linux.alibaba.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-mark-kcompactd_run-and-kcompactd_stop-__meminit.patch added to mm-unstable branch
Message-Id: <20230612213311.29C1FC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: mark kcompactd_run() and kcompactd_stop() __meminit
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-mark-kcompactd_run-and-kcompactd_stop-__meminit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-mark-kcompactd_run-and-kcompactd_stop-__meminit.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: compaction: mark kcompactd_run() and kcompactd_stop() __meminit
Date: Sat, 10 Jun 2023 11:46:15 +0800

Add __meminit to kcompactd_run() and kcompactd_stop() to ensure they're
default to __init when memory hotplug is not enabled.

Link: https://lkml.kernel.org/r/20230610034615.997813-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    4 ++--
 mm/compaction.c            |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/compaction.h~mm-compaction-mark-kcompactd_run-and-kcompactd_stop-__meminit
+++ a/include/linux/compaction.h
@@ -98,8 +98,8 @@ extern void compaction_defer_reset(struc
 bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 					int alloc_flags);
 
-extern void kcompactd_run(int nid);
-extern void kcompactd_stop(int nid);
+extern void __meminit kcompactd_run(int nid);
+extern void __meminit kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int highest_zoneidx);
 
 #else
--- a/mm/compaction.c~mm-compaction-mark-kcompactd_run-and-kcompactd_stop-__meminit
+++ a/mm/compaction.c
@@ -3050,7 +3050,7 @@ static int kcompactd(void *p)
  * This kcompactd start function will be called by init and node-hot-add.
  * On node-hot-add, kcompactd will moved to proper cpus if cpus are hot-added.
  */
-void kcompactd_run(int nid)
+void __meminit kcompactd_run(int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
 
@@ -3068,7 +3068,7 @@ void kcompactd_run(int nid)
  * Called by memory hotplug when all memory in a node is offlined. Caller must
  * be holding mem_hotplug_begin/done().
  */
-void kcompactd_stop(int nid)
+void __meminit kcompactd_stop(int nid)
 {
 	struct task_struct *kcompactd = NODE_DATA(nid)->kcompactd;
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-remove-obsolete-alloc_migrate_target.patch
mm-vmscan-mark-kswapd_run-and-kswapd_stop-__meminit.patch
memory-tier-remove-unneeded-disable_all_demotion_targets-when-config_migration.patch
mm-compaction-mark-kcompactd_run-and-kcompactd_stop-__meminit.patch

