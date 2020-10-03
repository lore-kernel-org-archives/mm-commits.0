Return-Path: <SRS0=eNRM=DK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D27CDC4363D
	for <mm-commits@archiver.kernel.org>; Sat,  3 Oct 2020 05:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89B69206C3
	for <mm-commits@archiver.kernel.org>; Sat,  3 Oct 2020 05:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601702503;
	bh=LqPFWMuvmziHKpIsL+9D4QhvpQHwJOYmXyAmfi7MNaE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=gdZvEnCSg3NfDHCaAewCjw2dLBM5C/rFiS+Ndsv65EDkKH8GcEj1XzMc5cBxweur9
	 p+PK+g5UODwICX3bQJzNsHV7qCl7izJt/Z4sU8q/UGJF7VsLQsJfD0mYm3+k98yK5w
	 aj9J15j8RYSzU2iPVfEAfQ7CnccpZeA8LWG/SHfE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725601AbgJCFVn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgJCFVn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 3 Oct 2020 01:21:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16CA0206A1;
        Sat,  3 Oct 2020 05:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601702502;
        bh=LqPFWMuvmziHKpIsL+9D4QhvpQHwJOYmXyAmfi7MNaE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Erb1j+Uz7jZ09q2xboQJAY3lzT8MY75RUkGHg3sZ1uk3JMz1AgIQByR6gcrQcJtBh
         5N2sW0/iDO1PVUp2ABAGSwKR3hYFNOQ+vai6bubyAAkIJbgHkX2XTCCvbxywR0RW9R
         IuKWAXjF3/FdTZrr6AIUfx7Yh+fMeVZKXMlhZdnA=
Date:   Fri, 02 Oct 2020 22:21:41 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, farman@linux.ibm.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 1/3] mm, slub: restore initial kmem_cache flags
Message-ID: <20201003052141.rFsR3bpL-%akpm@linux-foundation.org>
In-Reply-To: <20201002222038.4f81529dcd31eb8328d562a6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
