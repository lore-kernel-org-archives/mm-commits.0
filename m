Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA38C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  1 Jun 2022 22:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbiFAWK7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Jun 2022 18:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbiFAWKu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2022 18:10:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8336A5676F
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 15:10:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15939614B5
        for <mm-commits@vger.kernel.org>; Wed,  1 Jun 2022 22:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6959FC385A5;
        Wed,  1 Jun 2022 22:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654121444;
        bh=SvuLs7nFwlneq4PWEEMx+VzJDzGF49ZEfRRaTFpha6o=;
        h=Date:To:From:Subject:From;
        b=pXHRGWRE0/OXweBvUlOqAunarIwSMabeqo4cA3ldAFKJcFAlv9/RVCEvAEsGJVMjc
         uyu288iGfyehswuJg8W2xrH/c+VZt/6ppIBR5YUrdY6pWoY1g1/Jg2n7XEub3ih0M9
         ULUWVynt85aq2fzimLrFdsHPdqqgvrbAc/AcsWPE=
Date:   Wed, 01 Jun 2022 15:10:43 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org,
        linux@roeck-us.net, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-list_debugc-detect-uninitialized-lists.patch added to mm-nonmm-unstable branch
Message-Id: <20220601221044.6959FC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/list_debug.c: Detect uninitialized lists
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-list_debugc-detect-uninitialized-lists.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-list_debugc-detect-uninitialized-lists.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Guenter Roeck <linux@roeck-us.net>
Subject: lib/list_debug.c: Detect uninitialized lists
Date: Tue, 31 May 2022 15:29:51 -0700

In some circumstances, attempts are made to add entries to or to remove
entries from an uninitialized list.  A prime example is
amdgpu_bo_vm_destroy(): It is indirectly called from
ttm_bo_init_reserved() if that function fails, and tries to remove an
entry from a list.  However, that list is only initialized in
amdgpu_bo_create_vm() after the call to ttm_bo_init_reserved() returned
success.  This results in crashes such as

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 1 PID: 1479 Comm: chrome Not tainted 5.10.110-15768-g29a72e65dae5
 Hardware name: Google Grunt/Grunt, BIOS Google_Grunt.11031.149.0 07/15/2020
 RIP: 0010:__list_del_entry_valid+0x26/0x7d
 ...
 Call Trace:
  amdgpu_bo_vm_destroy+0x48/0x8b
  ttm_bo_init_reserved+0x1d7/0x1e0
  amdgpu_bo_create+0x212/0x476
  ? amdgpu_bo_user_destroy+0x23/0x23
  ? kmem_cache_alloc+0x60/0x271
  amdgpu_bo_create_vm+0x40/0x7d
  amdgpu_vm_pt_create+0xe8/0x24b
 ...

Check if the list's prev and next pointers are NULL to catch such problems.

Link: https://lkml.kernel.org/r/20220531222951.92073-1-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_debug.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/lib/list_debug.c~lib-list_debugc-detect-uninitialized-lists
+++ a/lib/list_debug.c
@@ -20,7 +20,11 @@
 bool __list_add_valid(struct list_head *new, struct list_head *prev,
 		      struct list_head *next)
 {
-	if (CHECK_DATA_CORRUPTION(next->prev != prev,
+	if (CHECK_DATA_CORRUPTION(prev == NULL,
+			"list_add corruption. prev is NULL.\n") ||
+	    CHECK_DATA_CORRUPTION(next == NULL,
+			"list_add corruption. next is NULL.\n") ||
+	    CHECK_DATA_CORRUPTION(next->prev != prev,
 			"list_add corruption. next->prev should be prev (%px), but was %px. (next=%px).\n",
 			prev, next->prev, next) ||
 	    CHECK_DATA_CORRUPTION(prev->next != next,
@@ -42,7 +46,11 @@ bool __list_del_entry_valid(struct list_
 	prev = entry->prev;
 	next = entry->next;
 
-	if (CHECK_DATA_CORRUPTION(next == LIST_POISON1,
+	if (CHECK_DATA_CORRUPTION(next == NULL,
+			"list_del corruption, %px->next is NULL\n", entry) ||
+	    CHECK_DATA_CORRUPTION(prev == NULL,
+			"list_del corruption, %px->prev is NULL\n", entry) ||
+	    CHECK_DATA_CORRUPTION(next == LIST_POISON1,
 			"list_del corruption, %px->next is LIST_POISON1 (%px)\n",
 			entry, LIST_POISON1) ||
 	    CHECK_DATA_CORRUPTION(prev == LIST_POISON2,
_

Patches currently in -mm which might be from linux@roeck-us.net are

lib-list_debugc-detect-uninitialized-lists.patch

