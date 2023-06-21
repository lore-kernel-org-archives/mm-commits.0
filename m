Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12501EB64D8
	for <mm-commits@archiver.kernel.org>; Wed, 21 Jun 2023 20:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjFUUPT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Jun 2023 16:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjFUUOw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2023 16:14:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0261BD3
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 13:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AF06616C5
        for <mm-commits@vger.kernel.org>; Wed, 21 Jun 2023 20:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4B3C433C8;
        Wed, 21 Jun 2023 20:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687378477;
        bh=o6N0+wSkRlWOEOlEUeTlFYJfE0ViLVH499/1fUkLKEM=;
        h=Date:To:From:Subject:From;
        b=GgJ1VQRgFwoAEji2B/1PvQLR/wqfR4RYCMyrjLjiuwOnWyZGzl46AFiD2MUty/Ak5
         9coon5kAj07wTD24I5+Gk3JxPLBZEcDdyX81y+hu3FOTFp9ugX8WKB5afadh/Zk/yU
         GsHQ2tHx43xcqDXMPGQFvhXy8//Q9Ik5rK6JC0jw=
Date:   Wed, 21 Jun 2023 13:14:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-unnecessary-pagevec-includes.patch added to mm-unstable branch
Message-Id: <20230621201437.9E4B3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unnecessary pagevec includes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-unnecessary-pagevec-includes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-unnecessary-pagevec-includes.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove unnecessary pagevec includes
Date: Wed, 21 Jun 2023 17:45:57 +0100

These files no longer need pagevec.h, mostly due to function declarations
being moved out of it.

Link: https://lkml.kernel.org/r/20230621164557.3510324-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/fadvise.c        |    1 -
 mm/memory_hotplug.c |    1 -
 mm/migrate.c        |    1 -
 mm/readahead.c      |    1 -
 mm/swap_state.c     |    1 -
 5 files changed, 5 deletions(-)

--- a/mm/fadvise.c~mm-remove-unnecessary-pagevec-includes
+++ a/mm/fadvise.c
@@ -14,7 +14,6 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/backing-dev.h>
-#include <linux/pagevec.h>
 #include <linux/fadvise.h>
 #include <linux/writeback.h>
 #include <linux/syscalls.h>
--- a/mm/memory_hotplug.c~mm-remove-unnecessary-pagevec-includes
+++ a/mm/memory_hotplug.c
@@ -13,7 +13,6 @@
 #include <linux/pagemap.h>
 #include <linux/compiler.h>
 #include <linux/export.h>
-#include <linux/pagevec.h>
 #include <linux/writeback.h>
 #include <linux/slab.h>
 #include <linux/sysctl.h>
--- a/mm/migrate.c~mm-remove-unnecessary-pagevec-includes
+++ a/mm/migrate.c
@@ -21,7 +21,6 @@
 #include <linux/buffer_head.h>
 #include <linux/mm_inline.h>
 #include <linux/nsproxy.h>
-#include <linux/pagevec.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/topology.h>
--- a/mm/readahead.c~mm-remove-unnecessary-pagevec-includes
+++ a/mm/readahead.c
@@ -120,7 +120,6 @@
 #include <linux/export.h>
 #include <linux/backing-dev.h>
 #include <linux/task_io_accounting_ops.h>
-#include <linux/pagevec.h>
 #include <linux/pagemap.h>
 #include <linux/psi.h>
 #include <linux/syscalls.h>
--- a/mm/swap_state.c~mm-remove-unnecessary-pagevec-includes
+++ a/mm/swap_state.c
@@ -16,7 +16,6 @@
 #include <linux/pagemap.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
-#include <linux/pagevec.h>
 #include <linux/migrate.h>
 #include <linux/vmalloc.h>
 #include <linux/swap_slots.h>
_

Patches currently in -mm which might be from willy@infradead.org are

afs-convert-pagevec-to-folio_batch-in-afs_extend_writeback.patch
mm-add-__folio_batch_release.patch
scatterlist-add-sg_set_folio.patch
i915-convert-shmem_sg_free_table-to-use-a-folio_batch.patch
drm-convert-drm_gem_put_pages-to-use-a-folio_batch.patch
mm-remove-check_move_unevictable_pages.patch
pagevec-rename-fbatch_count.patch
i915-convert-i915_gpu_error-to-use-a-folio_batch.patch
net-convert-sunrpc-from-pagevec-to-folio_batch.patch
mm-remove-struct-pagevec.patch
mm-rename-invalidate_mapping_pagevec-to-mapping_try_invalidate.patch
mm-remove-references-to-pagevec.patch
mm-remove-unnecessary-pagevec-includes.patch

