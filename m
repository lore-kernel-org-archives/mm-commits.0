Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C148C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353136AbiCYBgy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357475AbiCYBew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C70BC12F0
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C911A60AD1
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C76DC340EC;
        Fri, 25 Mar 2022 01:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171973;
        bh=6sFBC/C+RRTPmTV5rXatLhgpe1+SkYVO2A+37r+2HWQ=;
        h=Date:To:From:Subject:From;
        b=t2SXhBip6j2c7XMUpg2Pvkdk2RMrhfGfqgR6Ns4ayHBUtwqiY5xpIyDNgUCCXvip8
         oHRU+5QggKn8qe+HFUbrLa47S/lpc6rT6Y2iRH70TMYDvZd10mR+L2aGvTakVHduEL
         howqdjBXnvJ162sKkDEB8ghTUM9DurQyfa6KkEPE=
Date:   Thu, 24 Mar 2022 18:32:52 -0700
To:     mm-commits@vger.kernel.org, steve@sk2.org,
        songmuchun@bytedance.com, linmiaohe@huawei.com,
        keescook@chromium.org, christophe.leroy@csgroup.eu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-remove-usercopy_warn.patch removed from -mm tree
Message-Id: <20220325013253.2C76DC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove usercopy_warn()
has been removed from the -mm tree.  Its filename was
     mm-remove-usercopy_warn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
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


