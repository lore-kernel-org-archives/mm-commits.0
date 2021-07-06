Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862B3C07E9B
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E6C261C87
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhGFTLc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhGFTLc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:11:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FAED61C82;
        Tue,  6 Jul 2021 19:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598532;
        bh=3ZIHtQS40KjcHiNL+XbXZKLL5Hr2zKjIaSm8QBNfF74=;
        h=Date:From:To:Subject:From;
        b=0L2nJqSf1EllUknKwjh5Sxbh2Js3z7crvwY4gy5abLYQg1ESgNXzf5UmYgHGuUA3v
         UGhx3W58oRv4Jh2CGcYlekbrip3K5zZ83w36WBIlGdLlDHPdTTZsjWFibN4qKkE24p
         qoOCyugRFjh3uQLBW9KJIy+hzRi0lmebhA6zWElg=
Date:   Tue, 06 Jul 2021 12:08:52 -0700
From:   akpm@linux-foundation.org
To:     atomlin@redhat.com, cl@linux.com, gumingtao1225@gmail.com,
        gumingtao@xiaomi.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [merged] slab-use-__func__-to-trace-function-name.patch
 removed from -mm tree
Message-ID: <20210706190852.F43qi2LhY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slab: use __func__ to trace function name
has been removed from the -mm tree.  Its filename was
     slab-use-__func__-to-trace-function-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: gumingtao <gumingtao1225@gmail.com>
Subject: slab: use __func__ to trace function name

It is better to use __func__ to trace function name.

Link: https://lkml.kernel.org/r/31fdbad5c45cd1e26be9ff37be321b8586b80fee.1624355507.git.gumingtao@xiaomi.com
Signed-off-by: gumingtao <gumingtao@xiaomi.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/slab_common.c~slab-use-__func__-to-trace-function-name
+++ a/mm/slab_common.c
@@ -377,11 +377,11 @@ out_unlock:
 
 	if (err) {
 		if (flags & SLAB_PANIC)
-			panic("kmem_cache_create: Failed to create slab '%s'. Error %d\n",
-				name, err);
+			panic("%s: Failed to create slab '%s'. Error %d\n",
+				__func__, name, err);
 		else {
-			pr_warn("kmem_cache_create(%s) failed with error %d\n",
-				name, err);
+			pr_warn("%s(%s) failed with error %d\n",
+				__func__, name, err);
 			dump_stack();
 		}
 		return NULL;
@@ -508,8 +508,8 @@ void kmem_cache_destroy(struct kmem_cach
 
 	err = shutdown_cache(s);
 	if (err) {
-		pr_err("kmem_cache_destroy %s: Slab cache still has objects\n",
-		       s->name);
+		pr_err("%s %s: Slab cache still has objects\n",
+		       __func__, s->name);
 		dump_stack();
 	}
 out_unlock:
_

Patches currently in -mm which might be from gumingtao1225@gmail.com are


