Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74702C6FA8A
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbiILDeG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiILDc3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:32:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BE727CED
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A5286116F
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF09C433D6;
        Mon, 12 Sep 2022 03:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953414;
        bh=hfa3tDl7+Xi60sMpcLu/kf/4MLaKOuKkq9mNLJm77Dw=;
        h=Date:To:From:Subject:From;
        b=ydeRgWQeLnH5Xw9uf3weWKIVX1uTVnvweZ4bSm9k4NlFiTZl+yhywx88t/kz0764U
         L2JYJNBJYKYHXV22CL0hRHSNiEjMxOXzzaoKdIEtFRnP0/5AioYQO/C+p9XLUEj/32
         QIDvJQS4ZST7HmyjlvPzuL1c13/7kLEL4NnEfoEA=
Date:   Sun, 11 Sep 2022 20:30:13 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        hughd@google.com, david@redhat.com, liushixin2@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch removed from -mm tree
Message-Id: <20220912033013.EBF09C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/thp: simplify has_transparent_hugepage by using IS_BUILTIN
has been removed from the -mm tree.  Its filename was
     mm-thp-simplify-has_transparent_hugepage-by-using-is_builtin.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1598,11 +1598,7 @@ typedef unsigned int pgtbl_mod_mask;
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

mm-shuffle-convert-module_param_call-to-module_param_cb.patch
mm-kfence-convert-to-define_seq_attribute.patch
mm-huge_memory-prevent-thp_zero_page_alloc-increased-twice.patch

