Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FCD2C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Feb 2022 21:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbiBGVAw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Feb 2022 16:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231625AbiBGVAi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Feb 2022 16:00:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7887BC0401E7
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 13:00:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C2FAB81702
        for <mm-commits@vger.kernel.org>; Mon,  7 Feb 2022 21:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3098C340EF;
        Mon,  7 Feb 2022 21:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644267628;
        bh=vPFECpFKOlzL8oRh5kPcytUuYny0L7Lybm/iageRz8s=;
        h=Date:To:From:Subject:From;
        b=BY7roEk+fF/ROWjLM1k2S43Q+G8xxaynPZPsgX5iZiJPVDjZQwjAXMTGlDNqkHNou
         tTR3kmuThUOQ8niOohXm6MtWFbMJTkCJsrBaFa+sDkZ11GaKBIlsHr7kuY18ZfR4gh
         scvPpqVFfcjkIGRuVp9RenHYp4Yz5rNdAjHT5Yqg=
Date:   Mon, 07 Feb 2022 13:00:28 -0800
To:     mm-commits@vger.kernel.org, steve@sk2.org, linmiaohe@huawei.com,
        keescook@chromium.org, christophe.leroy@csgroup.eu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-usercopy_warn.patch added to -mm tree
Message-Id: <20220207210028.D3098C340EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove usercopy_warn()
has been added to the -mm tree.  Its filename is
     mm-remove-usercopy_warn.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-usercopy_warn.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-usercopy_warn.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm: remove usercopy_warn()

Users of usercopy_warn() were removed by commit 53944f171a89 ("mm: remove
HARDENED_USERCOPY_FALLBACK")

Remove it.

Link: https://lkml.kernel.org/r/5f26643fc70b05f8455b60b99c30c17d635fa640.1644231910.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Stephen Kitt <steve@sk2.org>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/uaccess.h |    2 --
 mm/usercopy.c           |   11 -----------
 2 files changed, 13 deletions(-)

--- a/include/linux/uaccess.h~mm-remove-usercopy_warn
+++ a/include/linux/uaccess.h
@@ -401,8 +401,6 @@ static inline void user_access_restore(u
 #endif
 
 #ifdef CONFIG_HARDENED_USERCOPY
-void usercopy_warn(const char *name, const char *detail, bool to_user,
-		   unsigned long offset, unsigned long len);
 void __noreturn usercopy_abort(const char *name, const char *detail,
 			       bool to_user, unsigned long offset,
 			       unsigned long len);
--- a/mm/usercopy.c~mm-remove-usercopy_warn
+++ a/mm/usercopy.c
@@ -70,17 +70,6 @@ static noinline int check_stack_object(c
  * kmem_cache_create_usercopy() function to create the cache (and
  * carefully audit the whitelist range).
  */
-void usercopy_warn(const char *name, const char *detail, bool to_user,
-		   unsigned long offset, unsigned long len)
-{
-	WARN_ONCE(1, "Bad or missing usercopy whitelist? Kernel memory %s attempt detected %s %s%s%s%s (offset %lu, size %lu)!\n",
-		 to_user ? "exposure" : "overwrite",
-		 to_user ? "from" : "to",
-		 name ? : "unknown?!",
-		 detail ? " '" : "", detail ? : "", detail ? "'" : "",
-		 offset, len);
-}
-
 void __noreturn usercopy_abort(const char *name, const char *detail,
 			       bool to_user, unsigned long offset,
 			       unsigned long len)
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-remove-usercopy_warn.patch
mm-outline-copy_overflow.patch
ilog2-force-inlining-of-__ilog2_u32-and-__ilog2_u64.patch

