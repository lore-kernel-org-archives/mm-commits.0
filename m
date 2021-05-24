Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE04C47086
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 23:51:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43B926141B
	for <mm-commits@archiver.kernel.org>; Mon, 24 May 2021 23:51:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhEXXxF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 May 2021 19:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229598AbhEXXxF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 May 2021 19:53:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7A4A61004;
        Mon, 24 May 2021 23:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621900296;
        bh=hPZK2HBhs9O6bssfwfVmWtyl4fNIno5+y/3fRqdIlTU=;
        h=Date:From:To:Subject:From;
        b=bEk0fj7Vfi224KSkK7+qPbzX1Iy8jSLdJpxA9weVtKjB0FwVobi+8gtxPgWmwyse0
         LR33gRW4DhXmzhAbJFPNC5ZSwJmG85uUKZ+cfjO/yeooji8Yz0fZBmMw8uL6sVnsWz
         3Fzgr/NckKXrO71Xbhbax7GFMo1T8BXiShhM8Ylg=
Date:   Mon, 24 May 2021 16:51:35 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, swboyd@chromium.org,
        vbabka@suse.cz
Subject:  [nacked]
 lib-hexdump-add-a-raw-pointer-printing-format-for-slub-debugging.patch
 removed from -mm tree
Message-ID: <20210524235135.Uc5KPkJ6f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/hexdump: add a raw pointer printing format for slub debugging
has been removed from the -mm tree.  Its filename was
     lib-hexdump-add-a-raw-pointer-printing-format-for-slub-debugging.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Stephen Boyd <swboyd@chromium.org>
Subject: lib/hexdump: add a raw pointer printing format for slub debugging

Patch series "slub: Print non-hashed pointers in slub debugging".

I was doing some debugging recently and noticed that my pointers were
being hashed while slub_debug was on the kernel commandline.  Let's make
the prints in here meaningful in that case by pushing %px throughout.

Alternatively, we could force on no_hash_pointers if slub_debug is on the
commandline.  Maybe that would be better?

The final patch is just something else I noticed while looking at the
code.  The message argument is never used so the debugging messages are
not as clear as they could be.


This patch (of 3):

We want to get actual pointer addresses when we're looking at slub
debugging reports.  Add another prefix format specifier that says we want
raw pointer addresses, i.e.  %px, in the printk format.

Link: https://lkml.kernel.org/r/20210520013539.3733631-1-swboyd@chromium.org
Link: https://lkml.kernel.org/r/20210520013539.3733631-2-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |    1 +
 lib/hexdump.c          |   12 ++++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/include/linux/printk.h~lib-hexdump-add-a-raw-pointer-printing-format-for-slub-debugging
+++ a/include/linux/printk.h
@@ -567,6 +567,7 @@ extern const struct file_operations kmsg
 enum {
 	DUMP_PREFIX_NONE,
 	DUMP_PREFIX_ADDRESS,
+	DUMP_PREFIX_RAW_ADDRESS,
 	DUMP_PREFIX_OFFSET
 };
 extern int hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
--- a/lib/hexdump.c~lib-hexdump-add-a-raw-pointer-printing-format-for-slub-debugging
+++ a/lib/hexdump.c
@@ -211,8 +211,12 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  * @level: kernel log level (e.g. KERN_DEBUG)
  * @prefix_str: string to prefix each line with;
  *  caller supplies trailing spaces for alignment if desired
- * @prefix_type: controls whether prefix of an offset, address, or none
- *  is printed (%DUMP_PREFIX_OFFSET, %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_NONE)
+ * @prefix_type: controls how prefix is printed
+ *   %DUMP_PREFIX_OFFSET - offset prefix
+ *   %DUMP_PREFIX_ADDRESS - hashed address prefix
+ *   %DUMP_PREFIX_RAW_ADDRESS - non-hashed address prefix
+ *   %DUMP_PREFIX_NONE - no prefix
+ *
  * @rowsize: number of bytes to print per line; must be 16 or 32
  * @groupsize: number of bytes to print at a time (1, 2, 4, 8; default = 1)
  * @buf: data blob to dump
@@ -260,6 +264,10 @@ void print_hex_dump(const char *level, c
 			printk("%s%s%p: %s\n",
 			       level, prefix_str, ptr + i, linebuf);
 			break;
+		case DUMP_PREFIX_RAW_ADDRESS:
+			printk("%s%s%px: %s\n",
+			       level, prefix_str, ptr + i, linebuf);
+			break;
 		case DUMP_PREFIX_OFFSET:
 			printk("%s%s%.8x: %s\n", level, prefix_str, i, linebuf);
 			break;
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

