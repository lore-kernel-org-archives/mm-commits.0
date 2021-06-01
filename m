Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A35FDC47080
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 20:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AD0D613CE
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 20:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbhFAUDT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 16:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233853AbhFAUDT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 1 Jun 2021 16:03:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B53B60C3E;
        Tue,  1 Jun 2021 20:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622577697;
        bh=bfOHNgSOclDjfHzV2R3maqsXwJqQBTw4V2xBrGlnbQ0=;
        h=Date:From:To:Subject:From;
        b=0bA6L9HEIk0qlqImRgUNXYjP0BcSx5s6+FGmMZrV1hPUl523dv+fRVQvJ9nriSR7+
         GIZ8IHbGScNc+5OpbeeKxhzoE58LCGb2ytUdS0dLJpX8nF0wa7XmcV5VSiu71VbWLq
         11crVFDECVtp2mYyooAiETfoc/xBklzSEUa5AJlw=
Date:   Tue, 01 Jun 2021 13:01:36 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, joe@perches.com,
        mm-commits@vger.kernel.org, penberg@kernel.org, pmladek@suse.com,
        rientjes@google.com, songmuchun@bytedance.com, swboyd@chromium.org,
        vbabka@suse.cz
Subject:  +
 slub-force-on-no_hash_pointers-when-slub_debug-is-enabled.patch added to
 -mm tree
Message-ID: <20210601200136.HLN5EQ7Om%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: force on no_hash_pointers when slub_debug is enabled
has been added to the -mm tree.  Its filename is
     slub-force-on-no_hash_pointers-when-slub_debug-is-enabled.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/slub-force-on-no_hash_pointers-when-slub_debug-is-enabled.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/slub-force-on-no_hash_pointers-when-slub_debug-is-enabled.patch

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
Subject: slub: force on no_hash_pointers when slub_debug is enabled

Obscuring the pointers that slub shows when debugging makes for some
confusing slub debug messages:

 Padding overwritten. 0x0000000079f0674a-0x000000000d4dce17

Those addresses are hashed for kernel security reasons.  If we're trying
to be secure with slub_debug on the commandline we have some big problems
given that we dump whole chunks of kernel memory to the kernel logs. 
Let's force on the no_hash_pointers commandline flag when slub_debug is on
the commandline.  This makes slub debug messages more meaningful and if by
chance a kernel address is in some slub debug object dump we will have a
better chance of figuring out what went wrong.

Note that we don't use %px in the slub code because we want to reduce the
number of places that %px is used in the kernel.  This also nicely prints
a big fat warning at kernel boot if slub_debug is on the commandline so
that we know that this kernel shouldn't be used on production systems.

Link: https://lkml.kernel.org/r/20210601182202.3011020-5-swboyd@chromium.org
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Cc: Joe Perches <joe@perches.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 ++
 lib/vsprintf.c         |    2 +-
 mm/slub.c              |    4 ++++
 3 files changed, 7 insertions(+), 1 deletion(-)

--- a/include/linux/kernel.h~slub-force-on-no_hash_pointers-when-slub_debug-is-enabled
+++ a/include/linux/kernel.h
@@ -357,6 +357,8 @@ int sscanf(const char *, const char *, .
 extern __scanf(2, 0)
 int vsscanf(const char *, const char *, va_list);
 
+extern int no_hash_pointers_enable(char *str);
+
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
--- a/lib/vsprintf.c~slub-force-on-no_hash_pointers-when-slub_debug-is-enabled
+++ a/lib/vsprintf.c
@@ -2186,7 +2186,7 @@ char *fwnode_string(char *buf, char *end
 bool no_hash_pointers __ro_after_init;
 EXPORT_SYMBOL_GPL(no_hash_pointers);
 
-static int __init no_hash_pointers_enable(char *str)
+int __init no_hash_pointers_enable(char *str)
 {
 	if (no_hash_pointers)
 		return 0;
--- a/mm/slub.c~slub-force-on-no_hash_pointers-when-slub_debug-is-enabled
+++ a/mm/slub.c
@@ -4492,6 +4492,10 @@ void __init kmem_cache_init(void)
 	if (debug_guardpage_minorder())
 		slub_max_order = 0;
 
+	/* Print slub debugging pointers without hashing */
+	if (static_branch_unlikely(&slub_debug_enabled))
+		no_hash_pointers_enable(NULL);
+
 	kmem_cache_node = &boot_kmem_cache_node;
 	kmem_cache = &boot_kmem_cache;
 
_

Patches currently in -mm which might be from swboyd@chromium.org are

slub-restore-slub_debug=-behavior.patch
slub-actually-use-message-in-restore_bytes.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled.patch
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

