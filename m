Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B35ECAAD4
	for <mm-commits@archiver.kernel.org>; Mon, 29 Aug 2022 20:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiH2UoU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Aug 2022 16:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiH2UoT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2022 16:44:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA86781B00
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 13:44:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D22A6117B
        for <mm-commits@vger.kernel.org>; Mon, 29 Aug 2022 20:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05BCC433D6;
        Mon, 29 Aug 2022 20:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661805857;
        bh=otH6FlGW3HAG6Evjz29/JL2k+jozoZkvny4CVwdtFyI=;
        h=Date:To:From:Subject:From;
        b=SrMcgFETlgsOR2MzEB3RZ7AZBwR0XmwTAdu5rYIV7Cg8kK0pygsPfNIVI51E9RIwp
         9/E4MSpkDARXDZ8iGN/J+fvILkuOFx4VWdddLHlZKKoT8wXLNSNFNbIpLhm7ogP5NY
         EK2zEdOBPJjARjhCabfJVlX6yaj4QCe4Hlb6x2L8=
Date:   Mon, 29 Aug 2022 13:44:16 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        hughd@google.com, david@redhat.com, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch added to mm-unstable branch
Message-Id: <20220829204417.B05BCC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: simplify has_transparent_hugepage by using IS_BUILTIN
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch

This patch will later appear in the mm-unstable branch at
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
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/thp: simplify has_transparent_hugepage by using IS_BUILTIN
Date: Mon, 29 Aug 2022 17:57:09 +0800

Simplify code of has_transparent_hugepage define by using IS_BUILTIN.

No functional change.

Link: https://lkml.kernel.org/r/20220829095709.3287462-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/include/linux/pgtable.h~mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin
+++ a/include/linux/pgtable.h
@@ -1611,11 +1611,7 @@ typedef unsigned int pgtbl_mod_mask;
 #endif
 
 #ifndef has_transparent_hugepage
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define has_transparent_hugepage() 1
-#else
-#define has_transparent_hugepage() 0
-#endif
+#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
 #endif
 
 /*
_

Patches currently in -mm which might be from liushixin2@huawei.com are

revert-frontswap-remove-support-for-multiple-ops.patch
revert-mm-mark-swap_lock-and-swap_active_head-static.patch
revert-frontswap-simplify-frontswap_register_ops.patch
mm-zswap-replace-zswap_init_started-failed-with-zswap_init_state.patch
mm-zswap-delay-the-initializaton-of-zswap-until-the-first-enablement.patch
mm-zswap-skip-confusing-print-info.patch
mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch

