Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814CAC4320E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 23:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6130061130
	for <mm-commits@archiver.kernel.org>; Wed, 18 Aug 2021 23:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhHRXTk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Aug 2021 19:19:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234771AbhHRXTk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Aug 2021 19:19:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7C276109F;
        Wed, 18 Aug 2021 23:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629328745;
        bh=2N3yOoHgX39M8h7dssH7tyHVXgEFFf4fz+BwmXye7sk=;
        h=Date:From:To:Subject:From;
        b=YbZWMeforR1Ol6FTrNcnWlBVI11CRGNHwPfvtGYuPBzaa4ZGrEKOnhPpiQa9Kv5sT
         N5eRWTai1DuG07j8UVHFav5rHOfmiVnKQ+hnxzHtrnQCNvZNTdfRIIIu1+Lg5yQnr0
         g1Ndvz6bpYu9RTnC0siJrV6OQunQ1Rzg0flikFwg=
Date:   Wed, 18 Aug 2021 16:19:04 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tj@kernel.org,
        rientjes@google.com, penberg@kernel.org, ojeda@kernel.org,
        ndesaulniers@google.com, nathan@kernel.org,
        lukas.bulwahn@gmail.com, joe@perches.com, iamjoonsoo.kim@lge.com,
        dwaipayanray1@gmail.com, dennis@kernel.org, danielmicay@gmail.com,
        cl@linux.com, apw@canonical.com, keescook@chromium.org
Subject:  + checkpatch-add-__alloc_size-to-known-attribute.patch
 added to -mm tree
Message-ID: <20210818231904.sqjpz%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add __alloc_size() to known $Attribute
has been added to the -mm tree.  Its filename is
     checkpatch-add-__alloc_size-to-known-attribute.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-__alloc_size-to-known-attribute.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-__alloc_size-to-known-attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: checkpatch: add __alloc_size() to known $Attribute

Make sure checkpatch.pl doesn't get confused about finding the
__alloc_size attribute on functions.

Link: https://lkml.kernel.org/r/20210818214021.2476230-3-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-add-__alloc_size-to-known-attribute
+++ a/scripts/checkpatch.pl
@@ -489,7 +489,8 @@ our $Attribute	= qr{
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
 			____cacheline_internodealigned_in_smp|
-			__weak
+			__weak|
+			__alloc_size\s*\(\s*\d+\s*(?:,\s*\d+\s*)?\)
 		  }x;
 our $Modifier;
 our $Inline	= qr{inline|__always_inline|noinline|__inline|__inline__};
_

Patches currently in -mm which might be from keescook@chromium.org are

compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
checkpatch-add-__alloc_size-to-known-attribute.patch
slab-clean-up-function-declarations.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch

