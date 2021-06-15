Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0015C2B9F4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 02:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76FD6613F9
	for <mm-commits@archiver.kernel.org>; Tue, 15 Jun 2021 02:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbhFOCdi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 22:33:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229728AbhFOCdg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 22:33:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C729A61424;
        Tue, 15 Jun 2021 02:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623722826;
        bh=urx5UUNMFZi6dCiaSwJxE6aZcPH9MMI8siyZ24L8yIY=;
        h=Date:From:To:Subject:From;
        b=0ECJIIhPA3a3SalGYUYSLQO+oNaFQlat5T7TJMvSZVjPFDmEzRTA11IYL52UTq8V8
         Je+QmjuZhhwBl2fTIdEF3lYQa3ytHnZ6++j2nvA43L6/ZiQrk/H1jMUDED0WZVHR2s
         kKEmZ7QWIAvt8aPE0xDPTBxwfyM2oMVVM/FP/3Yo=
Date:   Mon, 14 Jun 2021 19:07:05 -0700
From:   akpm@linux-foundation.org
To:     42.hyeyoo@gmail.com, cl@linux.com, elver@google.com,
        iamjoonsoo.kim@lge.com, lkp@intel.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-slub-change-run-time-assertion-in-kmalloc=5Findex-to-comp?=
 =?US-ASCII?Q?ile-time-fix-3.patch?= added to -mm tree
Message-ID: <20210615020705._l_WB1lEM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix-3
has been added to the -mm tree.  Its filename is
     mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix-3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix-3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix-3

Kernel test robot reports a false-positive compile-time assert while compiling
kernel/bpf/local_storage.c

   In file included from <command-line>:
   In function 'kmalloc_index',
       inlined from 'kmalloc_node' at include/linux/slab.h:572:20,
       inlined from 'bpf_map_kmalloc_node.isra.0.part.0' at include/linux/bpf.h:1319:9:
>> >> include/linux/compiler_types.h:328:38: error: call to '__compiletime_assert_183' declared with attribute error: unexpected size in kmalloc_index()
     328 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                      ^
   include/linux/compiler_types.h:309:4: note: in definition of macro '__compiletime_assert'
     309 |    prefix ## suffix();    \
         |    ^~~~~~
   include/linux/compiler_types.h:328:2: note: in expansion of macro '_compiletime_assert'
     328 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/slab.h:389:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     389 |  BUILD_BUG_ON_MSG(1, "unexpected size in kmalloc_index()");
         |  ^~~~~~~~~~~~~~~~

This only happens with CONFIG_PROFILE_ALL_BRANCHES enabled.  Informal
conversation with gcc developers suggest that this config pushes the
optimizer to a corner case where in kmalloc_node() the 'size' is
considered a builtin-constant and thus kmalloc_index() is chosen, but
later in kmalloc_index() the notion of compile-time constant is lost and
thus the compiletime assert becomes reachable.

While there's plan to submit a proper gcc bug report with reduced
testcase, for now add CONFIG_PROFILE_ALL_BRANCHES to the list of
situations where we keep using the runtime BUG_ON() instead of
compile-time assert.

This is a 3rd fix for mmotm patch
mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time.patch

[1] https://lore.kernel.org/linux-mm/202106051442.G1VJubTz-lkp@intel.com/

Link: https://lkml.kernel.org/r/bea97388-01df-8eac-091b-a3c89b4a4a09@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/slab.h~mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix-3
+++ a/include/linux/slab.h
@@ -389,7 +389,8 @@ static __always_inline unsigned int __km
 	if (size <=  16 * 1024 * 1024) return 24;
 	if (size <=  32 * 1024 * 1024) return 25;
 
-	if ((IS_ENABLED(CONFIG_CC_IS_GCC) || CONFIG_CLANG_VERSION >= 110000) && size_is_constant)
+	if ((IS_ENABLED(CONFIG_CC_IS_GCC) || CONFIG_CLANG_VERSION >= 110000)
+	    && !IS_ENABLED(CONFIG_PROFILE_ALL_BRANCHES) && size_is_constant)
 		BUILD_BUG_ON_MSG(1, "unexpected size in kmalloc_index()");
 	else
 		BUG();
_

Patches currently in -mm which might be from vbabka@suse.cz are

kunit-make-test-lock-irq-safe.patch
mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix-3.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix.patch
mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix-2.patch

