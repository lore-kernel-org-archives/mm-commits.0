Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D3DBC47087
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 23:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E410613EC
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 23:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhEXXxL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 May 2021 19:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229826AbhEXXxL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 May 2021 19:53:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 929F461360;
        Mon, 24 May 2021 23:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621900301;
        bh=wn4sLNqCliAscZVUSchrI9L1mCyFzweA1DINjZkcGCM=;
        h=Date:From:To:Subject:From;
        b=vrVVzDXzbl1S/r5BGQLSUieYIgYZQ5zJ77FsaCvRbwSX/YLw9oH0n8gOITOjKfgfK
         dWquaQbLRCT3CxTZAzHX0ROLtgSrGngY7gYJ1L0SdmIFeSUzVCiehLfO04sHECHKjm
         TVnv8B93W7h1N+oju8y26mp3AGuiFSZKvbXbRYzk=
Date:   Mon, 24 May 2021 16:51:41 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, swboyd@chromium.org,
        vbabka@suse.cz
Subject:  [nacked] slub-actually-use-message-in-restore_bytes.patch
 removed from -mm tree
Message-ID: <20210524235141.TEneIU68o%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: actually use 'message' in restore_bytes()
has been removed from the -mm tree.  Its filename was
     slub-actually-use-message-in-restore_bytes.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: slub: actually use 'message' in restore_bytes()

The message argument isn't used here.  Let's pass the string to the printk
message so that the developer can figure out what's happening, instead of
guessing that a redzone is being restored, etc.

Link: https://lkml.kernel.org/r/20210520013539.3733631-4-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~slub-actually-use-message-in-restore_bytes
+++ a/mm/slub.c
@@ -805,7 +805,7 @@ static void init_object(struct kmem_cach
 static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
 						void *from, void *to)
 {
-	slab_fix(s, "Restoring 0x%px-0x%px=0x%x\n", from, to - 1, data);
+	slab_fix(s, "Restoring %s 0x%px-0x%px=0x%x\n", message, from, to - 1, data);
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

