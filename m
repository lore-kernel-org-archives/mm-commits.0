Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5A0C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64C17610FB
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhJRWXM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 18:23:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRWXK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 18:23:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7703660F6E;
        Mon, 18 Oct 2021 22:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634595658;
        bh=giEoj8bJ46DketplTyTNiXwH7ZGT25byiAfBGis/WlI=;
        h=Date:From:To:Subject:From;
        b=2B9pLSTToTFfo6nqdNQc7Yp06XcEZ1Vid8X4sOGqa6XPkxcG4xp87aY3bGxerVn1y
         Qwhe30NNp+u4CjjU1ei4xdwW9yZou0reflTmkjvm6iO9xKkbifq9H1PnDrJH8ttgeF
         b71RDi9YkJKz9OPE9nJtpqgcQ3EY/uAujLbTkIiA=
Date:   Mon, 18 Oct 2021 15:20:57 -0700
From:   akpm@linux-foundation.org
To:     keescook@chromium.org, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au, willy@infradead.org
Subject:  [merged]
 compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch
 removed from -mm tree
Message-ID: <20211018222057.pZlADQjt-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts: kernel-doc: Ignore __alloc_size() attribute
has been removed from the -mm tree.  Its filename was
     compiler-attributes-add-__alloc_size-for-better-bounds-checking-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
slab-clean-up-function-prototypes.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-kvmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
maintainers-add-exec-binfmt-section-with-myself-and-eric.patch
binfmt_elf-reintroduce-using-map_fixed_noreplace.patch

