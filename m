Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6036AC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40CFA61CF6
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhF2AUJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhF2AUJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38C4261CED;
        Tue, 29 Jun 2021 00:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624925863;
        bh=z6AQoUYLAcFted6xgSuBlq1rBbEdKKI+a0XgF6Oj6g4=;
        h=Date:From:To:Subject:From;
        b=uffoUbYZhLEshohMESd1XFEbQYLiCjNzARL6yuSDifOo8mrV0tP02Rwb0/VOFOkJh
         8yRxDvqO5e/7Lml1eW1qST3uDfXH8E+BcFRpsrVrv7R+Hm4lQ4Nuo8vAeCTZjsDnHZ
         ZDpOlBcrXXnQima3PEYEeh38KxKDiA2a0npwb7OY=
Date:   Mon, 28 Jun 2021 17:17:42 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, faiyazm@codeaurora.org, gregkh@linuxfoundation.org,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  [folded-merged]
 mm-slub-move-sysfs-slab-alloc-free-interfaces-to-debugfs-fix.patch removed
 from -mm tree
Message-ID: <20210629001742.9090iYjIA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: slub: fix the leak of alloc/free traces debugfs interface
has been removed from the -mm tree.  Its filename was
     mm-slub-move-sysfs-slab-alloc-free-interfaces-to-debugfs-fix.patch

This patch was dropped because it was folded into mm-slub-move-sysfs-slab-alloc-free-interfaces-to-debugfs.patch

------------------------------------------------------
From: Faiyaz Mohammed <faiyazm@codeaurora.org>
Subject: mm: slub: fix the leak of alloc/free traces debugfs interface

Fix the leak of alloc/free traces debugfs interface, reported by kmemleak
like below,

unreferenced object 0xffff00091ae1b540 (size 64):
  comm "lsbug", pid 1607, jiffies 4294958291 (age 1476.340s)
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b  ........kkkkkkkk
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
  backtrace:
    [<ffff8000106b06b8>] slab_post_alloc_hook+0xa0/0x418
    [<ffff8000106b5c7c>] kmem_cache_alloc_trace+0x1e4/0x378
    [<ffff8000106b5e40>] slab_debugfs_start+0x30/0x50
    slab_debugfs_start at mm/slub.c:5831
    [<ffff8000107b3dbc>] seq_read_iter+0x214/0xd50
    [<ffff8000107b4b84>] seq_read+0x28c/0x418
    [<ffff8000109560b4>] full_proxy_read+0xdc/0x148
    [<ffff800010738f24>] vfs_read+0x104/0x340
    [<ffff800010739ee0>] ksys_read+0xf8/0x1e0
    [<ffff80001073a03c>] __arm64_sys_read+0x74/0xa8

Link: https://lkml.kernel.org/r/1624248060-30286-1-git-send-email-faiyazm@codeaurora.org
Fixes: 3589836402ca ("mm: slub: move sysfs slab alloc/free interfaces to debugfs")
Link: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/mm/slub.c?h=next-20210617&id=84a2bdb1b458fc968d6d9e07dab388dc679bd747
Signed-off-by: Faiyaz Mohammed <faiyazm@codeaurora.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- a/mm/slub.c~mm-slub-move-sysfs-slab-alloc-free-interfaces-to-debugfs-fix
+++ a/mm/slub.c
@@ -5781,31 +5781,23 @@ static int slab_debugfs_show(struct seq_
 
 static void slab_debugfs_stop(struct seq_file *seq, void *v)
 {
-	kfree(v);
 }
 
 static void *slab_debugfs_next(struct seq_file *seq, void *v, loff_t *ppos)
 {
-	loff_t *spos = v;
 	struct loc_track *t = seq->private;
 
-	if (*ppos < t->count) {
-		*ppos = ++*spos;
-		return spos;
-	}
-	*ppos = ++*spos;
+	v = ppos;
+	++*ppos;
+	if (*ppos <= t->count)
+		return v;
+
 	return NULL;
 }
 
 static void *slab_debugfs_start(struct seq_file *seq, loff_t *ppos)
 {
-	loff_t *spos = kmalloc(sizeof(loff_t), GFP_KERNEL);
-
-	if (!spos)
-		return NULL;
-
-	*spos = *ppos;
-	return spos;
+	return ppos;
 }
 
 static const struct seq_operations slab_debugfs_sops = {
_

Patches currently in -mm which might be from faiyazm@codeaurora.org are

mm-slub-move-sysfs-slab-alloc-free-interfaces-to-debugfs.patch

