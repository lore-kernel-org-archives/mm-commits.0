Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED68C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 12 Oct 2021 20:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61B2860E90
	for <mm-commits@archiver.kernel.org>; Tue, 12 Oct 2021 20:56:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhJLU6N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhJLU6N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Oct 2021 16:58:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF6CD60E09;
        Tue, 12 Oct 2021 20:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634072171;
        bh=LYawYXntKC1i5BzSDBXUwR27LEtaEszuI2/xv81jT4M=;
        h=Date:From:To:Subject:From;
        b=piSKYEqmuGy+vVlD7nZkaBabDs5ANASX/gD/F5ieAFDLBC9YoXKg6M3A75Afb51rv
         5vjO0BbROaTT0E8iDMYtlu0/hQyBD/wUAQrpt8XyPQvIz/In13kNcqHZvpFx2Ob7Xx
         hcuvj5zSybNk6NgAjrSyVyuO0rEgGU2oqGbSPQwA=
Date:   Tue, 12 Oct 2021 13:56:10 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au, willy@infradead.org
Subject:  +
 compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
 added to -mm tree
Message-ID: <20211012205610.Os8RABpiO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts: kernel-doc: Ignore __alloc_size() attribute
has been added to the -mm tree.  Its filename is
     compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch

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
Subject: scripts: kernel-doc: Ignore __alloc_size() attribute

Fixes "Compiler Attributes: add __alloc_size() for better bounds checking"
so that the __alloc_size() macro is ignored for function prototypes when
generating kerndoc. Avoids warnings like:

./include/linux/slab.h:662: warning: Function parameter or member '1' not described in '__alloc_size'
./include/linux/slab.h:662: warning: Function parameter or member '2' not described in '__alloc_size'
./include/linux/slab.h:662: warning: expecting prototype for kcalloc().  Prototype was for __alloc_size() instead

Link: https://lkml.kernel.org/r/20211011180650.3603988-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/kernel-doc~compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix
+++ a/scripts/kernel-doc
@@ -1789,6 +1789,7 @@ sub dump_function($$) {
     $prototype =~ s/__weak +//;
     $prototype =~ s/__sched +//;
     $prototype =~ s/__printf\s*\(\s*\d*\s*,\s*\d*\s*\) +//;
+    $prototype =~ s/__alloc_size\s*\(\s*\d+\s*(?:,\s*\d+\s*)?\) +//;
     my $define = $prototype =~ s/^#\s*define\s+//; #ak added
     $prototype =~ s/__attribute_const__ +//;
     $prototype =~ s/__attribute__\s*\(\(
_

Patches currently in -mm which might be from keescook@chromium.org are

kasan-test-bypass-__alloc_size-checks.patch
rapidio-avoid-bogus-__alloc_size-warning.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
slab-clean-up-function-prototypes.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-kvmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
maintainers-add-exec-binfmt-section-with-myself-and-eric.patch
binfmt_elf-reintroduce-using-map_fixed_noreplace.patch

