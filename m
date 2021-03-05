Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F98C433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 01:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A2186500D
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 01:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhCEBcZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Mar 2021 20:32:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:49866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhCEBcZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Mar 2021 20:32:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC79964E6B;
        Fri,  5 Mar 2021 01:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614907945;
        bh=Gf+u7HI3OJSD3mS8ek2+MlqGYw4Oja0hHMD17sb3GDU=;
        h=Date:From:To:Subject:From;
        b=KX6MlBTEJryld9Kfy4KQmlsTfFg4LeDT4yLS33cv8bzzjp44PWGxE97JWttjES0Ln
         6NbXWJkF6eaJ/M3l8XZyRM+TkTHmia5pWsadUk9B+LfdnwRL8S68bWXcvp8Jv+12Sc
         LIRE7/rqqjH5ikbnk7QyNFedF5Hh9bkp0fZBIfLo=
Date:   Thu, 04 Mar 2021 17:32:24 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        glider@google.com, jannh@google.com, mm-commits@vger.kernel.org
Subject:  +
 kfence-slab-fix-cache_alloc_debugcheck_after-for-bulk-allocations.patch
 added to -mm tree
Message-ID: <20210305013224.QgV9sJkRk%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence, slab: fix cache_alloc_debugcheck_after() for bulk allocations
has been added to the -mm tree.  Its filename is
     kfence-slab-fix-cache_alloc_debugcheck_after-for-bulk-allocations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kfence-slab-fix-cache_alloc_debugcheck_after-for-bulk-allocations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kfence-slab-fix-cache_alloc_debugcheck_after-for-bulk-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence, slab: fix cache_alloc_debugcheck_after() for bulk allocations

cache_alloc_debugcheck_after() performs checks on an object, including
adjusting the returned pointer.  None of this should apply to KFENCE
objects.  While for non-bulk allocations, the checks are skipped when we
allocate via KFENCE, for bulk allocations cache_alloc_debugcheck_after()
is called via cache_alloc_debugcheck_after_bulk().

Fix it by skipping cache_alloc_debugcheck_after() for KFENCE objects.

Link: https://lkml.kernel.org/r/20210304205256.2162309-1-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.c~kfence-slab-fix-cache_alloc_debugcheck_after-for-bulk-allocations
+++ a/mm/slab.c
@@ -2992,7 +2992,7 @@ static void *cache_alloc_debugcheck_afte
 				gfp_t flags, void *objp, unsigned long caller)
 {
 	WARN_ON_ONCE(cachep->ctor && (flags & __GFP_ZERO));
-	if (!objp)
+	if (!objp || is_kfence_address(objp))
 		return objp;
 	if (cachep->flags & SLAB_POISON) {
 		check_poison_obj(cachep, objp);
_

Patches currently in -mm which might be from elver@google.com are

kfence-fix-printk-format-for-ptrdiff_t.patch
kfence-slab-fix-cache_alloc_debugcheck_after-for-bulk-allocations.patch

