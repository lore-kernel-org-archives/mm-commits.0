Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F08C433E3
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9635620723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026882;
	bh=HYLUWVNKJBO0L5nwsSHkJlguGzGoAJKzHwDoOj5v91I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=BbA34/ewyRymyfbEnOSzWr7ZOa0rc9cz/LkmJyiQn4gzPBZQfmvP5ZS82c6c0tzyh
	 bHP+pL3JIyHXGqMEVFJzK3XU5KY9kvnjVd2PwwYPgXV+JDQ7+/dxkDUC7VEO+BkTYn
	 USyFZHs/uDx+uXBF+bGah7BYVrv8oOKJtHDjXa1k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgHJCem (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCem (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:42 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFA6B2073E;
        Mon, 10 Aug 2020 02:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026881;
        bh=HYLUWVNKJBO0L5nwsSHkJlguGzGoAJKzHwDoOj5v91I=;
        h=Date:From:To:Subject:From;
        b=LUhlvGOIjDqqj6pKBDbH+9F9TyYh3d7obue7hpg/Q66VmxUMtJsEegjjUy5cuHgmZ
         4joL/vFPz/xM4lqwmlAjvT5hmDWkrFp+m1Pf0HjO0YVGFoOYoU1RqDcqjeWM1vh1yG
         g1GJa3nBq+RazITOTJCySLnHmudlUeVHAWm1R5ts=
Date:   Sun, 09 Aug 2020 19:34:40 -0700
From:   akpm@linux-foundation.org
To:     alex.popov@linux.com, cl@linux.com, guro@fb.com,
        iamjoonsoo.kim@lge.com, jannh@google.com, keescook@chromium.org,
        mjg59@google.com, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vinmenon@codeaurora.org,
        vjitta@codeaurora.org
Subject:  [merged]
 mm-expand-config_slab_freelist_hardened-to-include-slab.patch removed from
 -mm tree
Message-ID: <20200810023440.W9yvpaKxv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: expand CONFIG_SLAB_FREELIST_HARDENED to include SLAB
has been removed from the -mm tree.  Its filename was
     mm-expand-config_slab_freelist_hardened-to-include-slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm/slab: expand CONFIG_SLAB_FREELIST_HARDENED to include SLAB

Patch series "mm: Expand CONFIG_SLAB_FREELIST_HARDENED to include SLAB"

In reviewing Vlastimil Babka's latest slub debug series, I realized[1]
that several checks under CONFIG_SLAB_FREELIST_HARDENED weren't being
applied to SLAB.  Fix this by expanding the Kconfig coverage, and adding a
simple double-free test for SLAB.


This patch (of 2):

Include SLAB caches when performing kmem_cache pointer verification.  A
defense against such corruption[1] should be applied to all the
allocators.  With this added, the "SLAB_FREE_CROSS" and "SLAB_FREE_PAGE"
LKDTM tests now pass on SLAB:

  lkdtm: Performing direct entry SLAB_FREE_CROSS
  lkdtm: Attempting cross-cache slab free ...
  ------------[ cut here ]------------
  cache_from_obj: Wrong slab cache. lkdtm-heap-b but object is from lkdtm-heap-a
  WARNING: CPU: 2 PID: 2195 at mm/slab.h:530 kmem_cache_free+0x8d/0x1d0
  ...
  lkdtm: Performing direct entry SLAB_FREE_PAGE
  lkdtm: Attempting non-Slab slab free ...
  ------------[ cut here ]------------
  virt_to_cache: Object is not a Slab page!
  WARNING: CPU: 1 PID: 2202 at mm/slab.h:489 kmem_cache_free+0x196/0x1d0

Additionally clean up neighboring Kconfig entries for clarity,
readability, and redundant option removal.

[1] https://github.com/ThomasKing2014/slides/raw/master/Building%20universal%20Android%20rooting%20with%20a%20type%20confusion%20vulnerability.pdf

Link: http://lkml.kernel.org/r/20200625215548.389774-1-keescook@chromium.org
Link: http://lkml.kernel.org/r/20200625215548.389774-2-keescook@chromium.org
Fixes: 598a0717a816 ("mm/slab: validate cache membership under freelist hardening")
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Popov <alex.popov@linux.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/init/Kconfig~mm-expand-config_slab_freelist_hardened-to-include-slab
+++ a/init/Kconfig
@@ -1913,9 +1913,8 @@ config SLAB_MERGE_DEFAULT
 	  command line.
 
 config SLAB_FREELIST_RANDOM
-	default n
+	bool "Randomize slab freelist"
 	depends on SLAB || SLUB
-	bool "SLAB freelist randomization"
 	help
 	  Randomizes the freelist order used on creating new pages. This
 	  security feature reduces the predictability of the kernel slab
@@ -1923,12 +1922,14 @@ config SLAB_FREELIST_RANDOM
 
 config SLAB_FREELIST_HARDENED
 	bool "Harden slab freelist metadata"
-	depends on SLUB
+	depends on SLAB || SLUB
 	help
 	  Many kernel heap attacks try to target slab cache metadata and
 	  other infrastructure. This options makes minor performance
 	  sacrifices to harden the kernel slab allocator against common
-	  freelist exploit methods.
+	  freelist exploit methods. Some slab implementations have more
+	  sanity-checking than others. This option is most effective with
+	  CONFIG_SLUB.
 
 config SHUFFLE_PAGE_ALLOCATOR
 	bool "Page allocator randomization"
_

Patches currently in -mm which might be from keescook@chromium.org are

exec-change-uselib2-is_sreg-failure-to-eacces.patch
exec-move-s_isreg-check-earlier.patch
exec-move-path_noexec-check-earlier.patch

