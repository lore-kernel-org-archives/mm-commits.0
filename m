Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2052FC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 00:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356738AbhK1A0R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 19:26:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38606 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244786AbhK1AYQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 19:24:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F08060F5B
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 00:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33DCC53FBF;
        Sun, 28 Nov 2021 00:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638058861;
        bh=AZTH9B4QUejUGVuTGo5MIEquJARaerkeq6itDU89ZGM=;
        h=Date:From:To:Subject:From;
        b=pPzfi9WzNrLe4kIs4xZmCaIOfL8iGUb41lgPmAcUAffNgcpWVP8wAH6qlgB2wyMmK
         Q4WwCmhlPGT1sAujLlECmbs9oEn6x36pqsM4JqcNq81eEq9BRue1hcbgj85Jcv9ELI
         bQqldCbKrrkbbW8JhPI0Jk0t70O4j4CJZ+RU6Lp0=
Date:   Sat, 27 Nov 2021 16:21:00 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, Kuan-Ying.Lee@mediatek.com,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-base?=
 =?US-ASCII?Q?d-kasan-enable-fix.patch?= added to -mm tree
Message-ID: <20211128002100.pzmIy-LhC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix
has been added to the -mm tree.  Its filename is
     kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix

whitespace tweak

Cc: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kmemleak.c~kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix
+++ a/mm/kmemleak.c
@@ -384,10 +384,10 @@ static struct kmemleak_object *lookup_ob
 	unsigned long untagged_ptr = (unsigned long)kasan_reset_tag((void *)ptr);
 
 	while (rb) {
-		struct kmemleak_object *object =
-			rb_entry(rb, struct kmemleak_object, rb_node);
+		struct kmemleak_object *object;
 		unsigned long untagged_objp;
 
+		object = rb_entry(rb, struct kmemleak_object, rb_node);
 		untagged_objp = (unsigned long)kasan_reset_tag((void *)object->pointer);
 
 		if (untagged_ptr < untagged_objp)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
mm.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-page-table-check-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
proc-make-the-proc_create-stubs-static-inlines-fix.patch
panic-use-error_report_end-tracepoint-on-warnings-fix.patch
linux-next-git-rejects.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

