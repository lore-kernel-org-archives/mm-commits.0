Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28A2C4743C
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 04:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB57C6138C
	for <mm-commits@archiver.kernel.org>; Wed, 23 Jun 2021 04:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhFWEky (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Jun 2021 00:40:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhFWEky (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Jun 2021 00:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A182E61360;
        Wed, 23 Jun 2021 04:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624423116;
        bh=1t7VAg1wWTDu7RI6t2GKy0BvIAopW0vS1JQ6VcB6f2Q=;
        h=Date:From:To:Subject:From;
        b=1gGLX9qiU3ilCI9OC5rX5VCAMILsCs7UWoC9fgMgSoDTDQJhuEbHcyy2e2o0bSGO2
         +cTReljtoP8hPkIXLL8sP8RBTtwK4AYOKSmSEdDsaRieQ0+B374097rlUOxkBesBvo
         PxIsLNEDPLZyRkb9czX8GaeTr4D8YTYg/njI7VS0=
Date:   Tue, 22 Jun 2021 21:38:36 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, gumingtao1225@gmail.com, gumingtao@xiaomi.com,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  + slab-use-__func__-to-trace-function-name.patch added to
 -mm tree
Message-ID: <20210623043836.zSvNgKSuX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slab: use __func__ to trace function name
has been added to the -mm tree.  Its filename is
     slab-use-__func__-to-trace-function-name.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/slab-use-__func__-to-trace-function-name.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/slab-use-__func__-to-trace-function-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: gumingtao <gumingtao1225@gmail.com>
Subject: slab: use __func__ to trace function name

It is better to use __func__ to trace function name.

Link: https://lkml.kernel.org/r/31fdbad5c45cd1e26be9ff37be321b8586b80fee.1624355507.git.gumingtao@xiaomi.com
Signed-off-by: gumingtao <gumingtao@xiaomi.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
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

slab-use-__func__-to-trace-function-name.patch

