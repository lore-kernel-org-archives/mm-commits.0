Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F301C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 04:30:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6E83611BD
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 04:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbhETEcO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 00:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229449AbhETEcN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 00:32:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5F73611BE;
        Thu, 20 May 2021 04:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621485052;
        bh=99JoDf3X0vA1riT6sG79gYjojsBS4FmELtH0tAtkx2E=;
        h=Date:From:To:Subject:From;
        b=mpQdnmSObl3nJWJGgbOmsnLLvLV5XjONwQQ6P14FAf/7Mu0dPemeflTdV+22T6imY
         OcpNzYORrlhneLhmTfcM4cSC2HFW0uJNwbe9uyW67q5w/PKJBoIbOCaCxV3fCYTrHE
         WHBId39ISP5t3osiIfzUVAlYqefU3JczlsclPNYY=
Date:   Wed, 19 May 2021 21:30:51 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, swboyd@chromium.org,
        vbabka@suse.cz
Subject:  + slub-actually-use-message-in-restore_bytes.patch added
 to -mm tree
Message-ID: <20210520043051.MghPI5Ioi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: actually use 'message' in restore_bytes()
has been added to the -mm tree.  Its filename is
     slub-actually-use-message-in-restore_bytes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/slub-actually-use-message-in-restore_bytes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/slub-actually-use-message-in-restore_bytes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: slub: actually use 'message' in restore_bytes()

The message argument isn't used here.  Let's pass the string to the printk
message so that the developer can figure out what's happening, instead of
guessing that a redzone is being restored, etc.

Link: https://lkml.kernel.org/r/20210520013539.3733631-4-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

lib-hexdump-add-a-raw-pointer-printing-format-for-slub-debugging.patch
slub-print-raw-pointer-addresses-when-debugging.patch
slub-actually-use-message-in-restore_bytes.patch
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

