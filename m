Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82116C07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C1361C89
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhGFTLt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231702AbhGFTLt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:11:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92C3A61C84;
        Tue,  6 Jul 2021 19:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598549;
        bh=aQT4vMC12IZWFCPjGSRAljzxsPFqZwSAdp4g4vUdn+A=;
        h=Date:From:To:Subject:From;
        b=tETd3OtcH6aldWV7/C2Zhlipidmt83AsmZqHqd0csnEWwCbXkdlbdQ4AGoZrRsFhR
         /iKq8Ole3CNttoTr5d8jNgorfSdRf4Mus1KVBjhQ3ebzSdZdFzoFRvoGI3eDb0yuwE
         jx2aNEH7M55zmQ94i5RAuEZMqOtS10D5UfcndWRo=
Date:   Tue, 06 Jul 2021 12:09:09 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, joe@perches.com,
        mm-commits@vger.kernel.org, penberg@kernel.org, pmladek@suse.com,
        rientjes@google.com, songmuchun@bytedance.com, swboyd@chromium.org,
        vbabka@suse.cz
Subject:  [merged] slub-actually-use-message-in-restore_bytes.patch
 removed from -mm tree
Message-ID: <20210706190909.T6UZDzTz8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: actually use 'message' in restore_bytes()
has been removed from the -mm tree.  Its filename was
     slub-actually-use-message-in-restore_bytes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: slub: actually use 'message' in restore_bytes()

The message argument isn't used here.  Let's pass the string to the printk
message so that the developer can figure out what's happening, instead of
guessing that a redzone is being restored, etc.

Link: https://lkml.kernel.org/r/20210601182202.3011020-3-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joe Perches <joe@perches.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~slub-actually-use-message-in-restore_bytes
+++ a/mm/slub.c
@@ -806,7 +806,7 @@ static void init_object(struct kmem_cach
 static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
 						void *from, void *to)
 {
-	slab_fix(s, "Restoring 0x%p-0x%p=0x%x\n", from, to - 1, data);
+	slab_fix(s, "Restoring %s 0x%p-0x%p=0x%x\n", message, from, to - 1, data);
 	memset(from, data, to - from);
 }
 
_

Patches currently in -mm which might be from swboyd@chromium.org are

buildid-only-consider-gnu-notes-for-build-id-parsing.patch
buildid-add-api-to-parse-build-id-out-of-buffer.patch
buildid-stash-away-kernels-build-id-on-init.patch
buildid-stash-away-kernels-build-id-on-init-fix.patch
dump_stack-add-vmlinux-build-id-to-stack-traces.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces.patch
arm64-stacktrace-use-%psb-for-backtrace-printing.patch
x86-dumpstack-use-%psb-%pbb-for-backtrace-printing.patch
scripts-decode_stacktracesh-support-debuginfod.patch
scripts-decode_stacktracesh-silence-stderr-messages-from-addr2line-nm.patch
scripts-decode_stacktracesh-indicate-auto-can-be-used-for-base-path.patch
buildid-mark-some-arguments-const.patch
buildid-fix-kernel-doc-notation.patch
kdump-use-vmlinux_build_id-to-simplify.patch

