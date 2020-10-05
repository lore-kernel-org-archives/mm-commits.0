Return-Path: <SRS0=fIDE=DM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79357C4363A
	for <mm-commits@archiver.kernel.org>; Mon,  5 Oct 2020 23:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ADEC206B5
	for <mm-commits@archiver.kernel.org>; Mon,  5 Oct 2020 23:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601940150;
	bh=GZbsr+2NrK0RQbbJFyB+eeIXN4A9hyCd25Wus/EArus=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BlyFuMeIyGkJzEVGyEaM9bnfRELMAlMtDaNL4vWBt0obzNCAaeYfwaxegvJ7YeX01
	 CVsvknyhv3XY+UHhfnH+V14aWsLuV64sLGAsFBDp3m0h52tXuznIGXb/Z4+uedeQVR
	 5nHuoBXcETWEl5n+sIJn/++5k1Y/BZP8f0Sej5yQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgJEXV6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 5 Oct 2020 19:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbgJEXVi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 5 Oct 2020 19:21:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E288E206B5;
        Mon,  5 Oct 2020 23:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601940098;
        bh=GZbsr+2NrK0RQbbJFyB+eeIXN4A9hyCd25Wus/EArus=;
        h=Date:From:To:Subject:From;
        b=pV02xVRuHpM32ABo0KA4tj6pMIO3E8eBs1LAUZk5Gy05OB7sRuyinine2C+Z0Yg25
         yk5sD6club46jxgz0qU2NGBhGLcW5BAKL6r82CgxmCgWoRg75h+oXT91TCFGb02J04
         ZaysZTG+9LpmJLxRTYRw3yGCUvnZnRkkbGUDu/Zk=
Date:   Mon, 05 Oct 2020 16:21:37 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, farman@linux.ibm.com, iamjoonsoo.kim@lge.com,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  [merged] mm-slub-restore-initial-kmem_cache-flags.patch
 removed from -mm tree
Message-ID: <20201005232137.JP0Kkv677%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: restore initial kmem_cache flags
has been removed from the -mm tree.  Its filename was
     mm-slub-restore-initial-kmem_cache-flags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Farman <farman@linux.ibm.com>
Subject: mm, slub: restore initial kmem_cache flags

The routine that applies debug flags to the kmem_cache slabs inadvertantly
prevents non-debug flags from being applied to those same objects.  That
is, if slub_debug=<flag>,<slab> is specified, non-debugged slabs will end
up having flags of zero, and the slabs may be unusable.

Fix this by including the input flags for non-matching slabs with the
contents of slub_debug, so that the caches are created as expected
alongside any debugging options that may be requested.  With this, we can
remove the check for a NULL slub_debug_string, since it's covered by the
loop itself.

Link: https://lkml.kernel.org/r/20200930161931.28575-1-farman@linux.ibm.com
Fixes: e17f1dfba37b ("mm, slub: extend slub_debug syntax for multiple blocks")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/slub.c~mm-slub-restore-initial-kmem_cache-flags
+++ a/mm/slub.c
@@ -1413,10 +1413,6 @@ slab_flags_t kmem_cache_flags(unsigned i
 	char *next_block;
 	slab_flags_t block_flags;
 
-	/* If slub_debug = 0, it folds into the if conditional. */
-	if (!slub_debug_string)
-		return flags | slub_debug;
-
 	len = strlen(name);
 	next_block = slub_debug_string;
 	/* Go through all blocks of debug options, see if any matches our slab's name */
@@ -1450,7 +1446,7 @@ slab_flags_t kmem_cache_flags(unsigned i
 		}
 	}
 
-	return slub_debug;
+	return flags | slub_debug;
 }
 #else /* !CONFIG_SLUB_DEBUG */
 static inline void setup_object_debug(struct kmem_cache *s,
_

Patches currently in -mm which might be from farman@linux.ibm.com are


