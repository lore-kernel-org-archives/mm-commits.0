Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D4CEB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjFSX0L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbjFSXYW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:24:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD0C19AE
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19D7660FB7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71972C433C0;
        Mon, 19 Jun 2023 23:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216978;
        bh=P8C98mD2TeYRkTnLJTdrgrtCmxgthXGuwExfX+hEJmU=;
        h=Date:To:From:Subject:From;
        b=A796ArwvDwGZk5mwKlTR1DZz5itODmPG2ZWleNDFtpljJ/u0AqGerPKQDBZMBEDbn
         4kg5ojanldsEp+BWBvOHikp4PkijkzWLC8uInbwJ/53OFp1QrAHLGDFVUOIswcS1Z0
         cSUnE3uFYIItNG5NVdoRt8oMv1Y2fYQcGCuBIHHk=
Date:   Mon, 19 Jun 2023 16:22:57 -0700
To:     mm-commits@vger.kernel.org, baolin.wang@linux.alibaba.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-mark-kcompactd_run-and-kcompactd_stop-__meminit.patch removed from -mm tree
Message-Id: <20230619232258.71972C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: compaction: mark kcompactd_run() and kcompactd_stop() __meminit
has been removed from the -mm tree.  Its filename was
     mm-compaction-mark-kcompactd_run-and-kcompactd_stop-__meminit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


