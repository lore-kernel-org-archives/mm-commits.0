Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5BA7C47080
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 20:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0436613D0
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 20:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbhFAUDG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Jun 2021 16:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233853AbhFAUDG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 1 Jun 2021 16:03:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AA6E613C1;
        Tue,  1 Jun 2021 20:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622577683;
        bh=5Jqg2oxXUQL0pyRbHtC6vbKAtiTuJcYQzMMyZ1WqdXk=;
        h=Date:From:To:Subject:From;
        b=Q353aS9vq2aVK9T6IpjCYlUfiqGpfzgpz5rK2jQfatt0WgMabnni8uGwjVroOtVz3
         UxcPdjKMRYXfVSBEP5E6WCV1xaCmyOrKhBaSL61FRnCfOUJ4cWIjV3XzosGYHvd58z
         wZWYDtuTQ4b9gQw8q32WwknSAXhXBVmf3HANxMi4=
Date:   Tue, 01 Jun 2021 13:01:22 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, joe@perches.com,
        mm-commits@vger.kernel.org, penberg@kernel.org, pmladek@suse.com,
        rientjes@google.com, songmuchun@bytedance.com, swboyd@chromium.org,
        vbabka@suse.cz
Subject:  + slub-restore-slub_debug=-behavior.patch added to -mm
 tree
Message-ID: <20210601200122.NSOxeXl4p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: restore slub_debug=- behavior
has been added to the -mm tree.  Its filename is
     slub-restore-slub_debug=-behavior.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/slub-restore-slub_debug%3D-behavior.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/slub-restore-slub_debug%3D-behavior.patch

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
Subject: slub: restore slub_debug=- behavior

Petch series "slub: Print non-hashed pointers in slub debugging", v3.

I was doing some debugging recently and noticed that my pointers were
being hashed while slub_debug was on the kernel commandline.  Let's force
on the no hash pointer option when slub_debug is on the kernel commandline
so that the prints are more meaningful.

The first two patches are something else I noticed while looking at the
code.  The message argument is never used so the debugging messages are
not as clear as they could be and the slub_debug=- behavior seems to be
busted.  Then there's a printf fixup from Joe and the final patch is the
one that force disables pointer hashing.


This patch (of 4):

Passing slub_debug=- on the kernel commandline is supposed to disable slub
debugging.  This is especially useful with CONFIG_SLUB_DEBUG_ON where the
default is to have slub debugging enabled in the build.  Due to some code
reorganization this behavior was dropped, but the code to make it work
mostly stuck around.  Restore the previous behavior by disabling the
static key when we parse the commandline and see that we're trying to
disable slub debugging.

Link: https://lkml.kernel.org/r/20210601182202.3011020-1-swboyd@chromium.org
Link: https://lkml.kernel.org/r/20210601182202.3011020-2-swboyd@chromium.org
Fixes: ca0cab65ea2b ("mm, slub: introduce static key for slub_debug()")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/slub.c~slub-restore-slub_debug=-behavior
+++ a/mm/slub.c
@@ -1428,6 +1428,8 @@ static int __init setup_slub_debug(char
 out:
 	if (slub_debug != 0 || slub_debug_string)
 		static_branch_enable(&slub_debug_enabled);
+	else
+		static_branch_disable(&slub_debug_enabled);
 	if ((static_branch_unlikely(&init_on_alloc) ||
 	     static_branch_unlikely(&init_on_free)) &&
 	    (slub_debug & SLAB_POISON))
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

