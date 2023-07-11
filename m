Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EF3EB64DC
	for <mm-commits@archiver.kernel.org>; Tue, 11 Jul 2023 20:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbjGKUHh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Jul 2023 16:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbjGKUHh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2023 16:07:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB051BB
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 13:07:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A305615DC
        for <mm-commits@vger.kernel.org>; Tue, 11 Jul 2023 20:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DBFC433C7;
        Tue, 11 Jul 2023 20:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689106054;
        bh=Xz3i280Q/aulOEulq7P8aonwzO899Xyy0P7T0UxZ2no=;
        h=Date:To:From:Subject:From;
        b=SeoxHQkvV/k9V3chz8AidL4G0aUnn8cyJepxHi02XANiXP6oMbOtHODLAueo21z6z
         Yg9pDO7JvcHtwRQSUE4h+1SKbkb4DkslIbE4Bk/tjShKzAakdgTygC3yvVO+0pTQwE
         ZnpWX+c39Wq3F76TSm4ySymq37jZQItBIU63jFBw=
Date:   Tue, 11 Jul 2023 13:07:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + minmax-add-in_range-macro-fix.patch added to mm-unstable branch
Message-Id: <20230711200734.90DBFC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: minmax-add-in_range-macro-fix
has been added to the -mm mm-unstable branch.  Its filename is
     minmax-add-in_range-macro-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/minmax-add-in_range-macro-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: minmax-add-in_range-macro-fix
Date: Tue Jul 11 01:02:31 PM PDT 2023

fix lib/logic_pio.c

lib/logic_pio.c:24: warning: "in_range" redefined
   24 | #define in_range(b, first, len)        ((b) >= (first) && (b) < (first) + (len))
      | 
In file included from ./include/linux/kernel.h:27,
                 from ./include/linux/cpumask.h:10,
                 from ./include/linux/smp.h:13,
                 from ./include/linux/lockdep.h:14,
                 from ./include/linux/mutex.h:17,
                 from ./include/linux/kernfs.h:11,
                 from ./include/linux/sysfs.h:16,
                 from ./include/linux/kobject.h:20,
                 from ./include/linux/of.h:17,
                 from lib/logic_pio.c:11:
./include/linux/minmax.h:183: note: this is the location of the previous definition
  183 | #define in_range(val, start, len)                                       \
      | 

Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/logic_pio.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/lib/logic_pio.c~minmax-add-in_range-macro-fix
+++ a/lib/logic_pio.c
@@ -12,6 +12,7 @@
 #include <linux/io.h>
 #include <linux/logic_pio.h>
 #include <linux/mm.h>
+#include <linux/minmax.h>
 #include <linux/rculist.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
@@ -20,9 +21,6 @@
 static LIST_HEAD(io_range_list);
 static DEFINE_MUTEX(io_range_mutex);
 
-/* Consider a kernel general helper for this */
-#define in_range(b, first, len)        ((b) >= (first) && (b) < (first) + (len))
-
 /**
  * logic_pio_register_range - register logical PIO range for a host
  * @new_range: pointer to the IO range to be registered.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
swap-stop-add-to-avail-list-is-swap-is-full-checkpatch-fixes.patch
fs-buffer-clean-up-block_commit_write-fix.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info-fix.patch
mm-make-pte_marker_swapin_error-more-general-fix.patch
minmax-add-in_range-macro-fix.patch
minmax-add-in_range-macro-fix-fix.patch
signal-print-comm-and-exe-name-on-fatal-signals-fix.patch

