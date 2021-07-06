Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A33C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFAB761C84
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:09:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhGFTLq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231702AbhGFTLp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:11:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99AD461C82;
        Tue,  6 Jul 2021 19:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598546;
        bh=Ij7q0gHiAE5/G3f/3AD2kSjoGXKZMc6IF4ZTf745JzQ=;
        h=Date:From:To:Subject:From;
        b=zu8cJdBbfvPHSGb6rVZpDAt2UJXoZTXYrKK017Jn7ZgeUQ7hcXJ/BjF8uy3goKSEJ
         F9o15MwnYZXuoFXb2v5/OHt5u2ozt0uQXs/ajl9IeJ/BBWjC5osMheDgxaI8UDh3h5
         zTX0mWuH9y6QKEWEXpN20MBb13/oJj+u3LQCRgAw=
Date:   Tue, 06 Jul 2021 12:09:06 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, joe@perches.com,
        mm-commits@vger.kernel.org, penberg@kernel.org, pmladek@suse.com,
        rientjes@google.com, songmuchun@bytedance.com, swboyd@chromium.org,
        vbabka@suse.cz
Subject:  [merged] slub-restore-slub_debug=-behavior.patch removed
 from -mm tree
Message-ID: <20210706190906.azXYQok70%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: restore slub_debug=- behavior
has been removed from the -mm tree.  Its filename was
     slub-restore-slub_debug=-behavior.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1429,6 +1429,8 @@ static int __init setup_slub_debug(char
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

