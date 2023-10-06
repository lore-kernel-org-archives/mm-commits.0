Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02ED0E94107
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 19:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbjJFTTG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233410AbjJFTTG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 15:19:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D539E
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 12:19:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3A2C433C9;
        Fri,  6 Oct 2023 19:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696619945;
        bh=jnDcghg4Rp96pW6+lTAln60/NZPzytkTriNfOLjrqcg=;
        h=Date:To:From:Subject:From;
        b=YbEJDSDlsv+GT8Ey7FXwKSANJlj2R9+xttU2OaNcMdZ6WYGvxkyJ/AMXFJwTMT47u
         RmxkrSPvySFZ7x6S+G20Tt7vv/k3sVX8DRo4CAQWb/Q3aHBLHBfuEq5I32g2eI87o/
         xd3Yt6tc9jkr2sVSHk1wgBWRD2SPQ/KweqmatyOw=
Date:   Fri, 06 Oct 2023 12:19:02 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com, oberpar@linux.ibm.com,
        ndesaulniers@google.com, nathan@kernel.org, gustavoars@kernel.org,
        keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gcov-annotate-struct-gcov_iterator-with-__counted_by.patch added to mm-nonmm-unstable branch
Message-Id: <20231006191904.9D3A2C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: annotate struct gcov_iterator with __counted_by
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     gcov-annotate-struct-gcov_iterator-with-__counted_by.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gcov-annotate-struct-gcov_iterator-with-__counted_by.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: gcov: annotate struct gcov_iterator with __counted_by
Date: Fri, 22 Sep 2023 10:52:20 -0700

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute.  Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
(for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

As found with Coccinelle[1], add __counted_by for struct gcov_iterator.

[1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci

Link: https://lkml.kernel.org/r/20230922175220.work.327-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/gcov/fs.c~gcov-annotate-struct-gcov_iterator-with-__counted_by
+++ a/kernel/gcov/fs.c
@@ -99,7 +99,7 @@ struct gcov_iterator {
 	struct gcov_info *info;
 	size_t size;
 	loff_t pos;
-	char buffer[];
+	char buffer[] __counted_by(size);
 };
 
 /**
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-memcg-annotate-struct-mem_cgroup_threshold_ary-with-__counted_by.patch
ocfs2-annotate-struct-ocfs2_replay_map-with-__counted_by.patch
gcov-annotate-struct-gcov_iterator-with-__counted_by.patch

