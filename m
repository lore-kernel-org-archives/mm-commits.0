Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83626C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  2 Nov 2022 22:28:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiKBW22 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Nov 2022 18:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiKBW22 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Nov 2022 18:28:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A192BD0
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 15:28:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53061B8252C
        for <mm-commits@vger.kernel.org>; Wed,  2 Nov 2022 22:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CB1C433D6;
        Wed,  2 Nov 2022 22:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667428103;
        bh=FSDr2+vNloyQuRwDxkQlvGLLD7wGh7KXPiJzsbkr8DY=;
        h=Date:To:From:Subject:From;
        b=Yc77l392Q9oaWqA/eWOZVDOjNIwcRFalJwbxHRfwNmUfrt2DmFlwwRjBntIPyGC5U
         taSHhTaUOvOOv+HwYlWStMlhXzKVIxZ3G8t+OU/Q0oQATg0RoqTxsSnQoNZYqXGXZb
         X2w+NjOzoHugVaInNjxaXr1/w1P5r2lNfbNEcYVg=
Date:   Wed, 02 Nov 2022 15:28:21 -0700
To:     mm-commits@vger.kernel.org, wuqiang.matt@bytedance.com,
        sander@svanheule.net, rostedt@goodmis.org, peterz@infradead.org,
        naveen.n.rao@linux.ibm.com, mhiramat@kernel.org,
        jpoimboe@kernel.org, ebiggers@google.com, davem@davemloft.net,
        dan.j.williams@intel.com, anil.s.keshavamurthy@intel.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kprobeslib-kretprobe-scalability-improvement-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20221102222822.E6CB1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kprobeslib-kretprobe-scalability-improvement-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kprobeslib-kretprobe-scalability-improvement-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kprobeslib-kretprobe-scalability-improvement-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kprobeslib-kretprobe-scalability-improvement-fix
Date: Wed Nov  2 03:25:47 PM PDT 2022

fix build with -Werror=designated-init

lib/test_objpool.c:509:10: error: positional initialization of field in 'struct' declared with 'designated_init' attribute [-Werror=designated-init]
  509 |         {ot_init_sync_m0, ot_fini_sync_m0},
      |          ^~~~~~~~~~~~~~~
lib/test_objpool.c:509:10: note: (near initialization for 'g_ot_sync_ops[0]')
lib/test_objpool.c:509:10: error: invalid initializer
lib/test_objpool.c:509:10: note: (near initialization for 'g_ot_sync_ops[0].<anonymous>')

Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sander Vanheule <sander@svanheule.net>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: wuqiang <wuqiang.matt@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_objpool.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/lib/test_objpool.c~kprobeslib-kretprobe-scalability-improvement-fix
+++ a/lib/test_objpool.c
@@ -506,10 +506,10 @@ struct {
 	struct ot_context * (*init)(void);
 	void (*fini)(struct ot_context *sop);
 } g_ot_sync_ops[4] = {
-	{ot_init_sync_m0, ot_fini_sync_m0},
-	{ot_init_sync_m1, ot_fini_sync_m1},
-	{ot_init_sync_m2, ot_fini_sync_m2},
-	{ot_init_sync_m3, ot_fini_sync_m3},
+	{.init = ot_init_sync_m0, .fini = ot_fini_sync_m0},
+	{.init = ot_init_sync_m1, .fini = ot_fini_sync_m1},
+	{.init = ot_init_sync_m2, .fini = ot_fini_sync_m2},
+	{.init = ot_init_sync_m3, .fini = ot_fini_sync_m3},
 };
 
 /*
@@ -810,10 +810,10 @@ struct {
 	struct ot_context * (*init)(void);
 	void (*fini)(struct ot_context *sop);
 } g_ot_async_ops[4] = {
-	{ot_init_async_m0, ot_fini_async},
-	{ot_init_async_m1, ot_fini_async},
-	{ot_init_async_m2, ot_fini_async},
-	{ot_init_async_m3, ot_fini_async},
+	{.init = ot_init_async_m0, .fini = ot_fini_async},
+	{.init = ot_init_async_m1, .fini = ot_fini_async},
+	{.init = ot_init_async_m2, .fini = ot_fini_async},
+	{.init = ot_init_async_m3, .fini = ot_fini_async},
 };
 
 static void ot_nod_recycle(struct ot_node *on, struct objpool_head *pool,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maple_tree-reorganize-testing-to-restore-module-testing-fix.patch
maple_tree-reorganize-testing-to-restore-module-testing-fix-2.patch
mm-memremap_pages-replace-zone_device_page_init-with-pgmap_request_folios-fix.patch
vmalloc-add-reviewers-for-vmalloc-code-checkpatch-fixes.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix.patch
mm-memremap-introduce-pgmap_request_folio-using-pgmap-offsets-fix-2.patch
mm-gup-remove-foll_migration-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-checkpatch-fixes.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-fix.patch
mm-use-stack_depot-for-recording-kmemleaks-backtrace-v3-fix.patch
kasan-allow-sampling-page_alloc-allocations-for-hw_tags-fix.patch
mm-hugetlb-convert-move_hugetlb_state-to-folios-fix.patch
powerpc-ptrace-user_regset_copyin_ignore-always-returns-0-fix.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes.patch
minmax-sanity-check-constant-bounds-when-clamping-checkpatch-fixes-fix.patch
proc-report-open-files-as-size-in-stat-for-proc-pid-fd-v3-fix.patch
kprobeslib-kretprobe-scalability-improvement-fix.patch

