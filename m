Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 644E2C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357504AbiCYBhR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357519AbiCYBf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C01C3A5D7
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A373860A1C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02FBEC340EE;
        Fri, 25 Mar 2022 01:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172052;
        bh=hxTSYUovnFMPl5iQG89z4pHd/x1F1+HYzSvPg0fyzS0=;
        h=Date:To:From:Subject:From;
        b=pXp1A5ODeWLriy+bvk+zR/t72qACpO6xQkZ1btlLHwjt3Ui2hx6IVNxDwpznk3xv/
         y/fW2nPlX/Rm/MB0tpgduCA1b2y3SGNA1wXxzt0gS8ZeL9z7lQxY3Dg3jFtxQeMKy0
         D9LGUZXDIkPwlUA5Kipg9Mhl35I6qg2fdBfqXa5E=
Date:   Thu, 24 Mar 2022 18:34:11 -0700
To:     mm-commits@vger.kernel.org, ryabinin.a.a@gmail.com,
        lixuefeng@loongson.cn, elver@google.com, corbet@lwn.net,
        bhe@redhat.com, yangtiezhu@loongson.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] ubsan-no-need-to-unset-panic_on_warn-in-ubsan_epilogue.patch removed from -mm tree
Message-Id: <20220325013412.02FBEC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ubsan: no need to unset panic_on_warn in ubsan_epilogue()
has been removed from the -mm tree.  Its filename was
     ubsan-no-need-to-unset-panic_on_warn-in-ubsan_epilogue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: ubsan: no need to unset panic_on_warn in ubsan_epilogue()

panic_on_warn is unset inside panic(), so no need to unset it before
calling panic() in ubsan_epilogue().

Link: https://lkml.kernel.org/r/1644324666-15947-5-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Xuefeng Li <lixuefeng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/ubsan.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/lib/ubsan.c~ubsan-no-need-to-unset-panic_on_warn-in-ubsan_epilogue
+++ a/lib/ubsan.c
@@ -154,16 +154,8 @@ static void ubsan_epilogue(void)
 
 	current->in_ubsan--;
 
-	if (panic_on_warn) {
-		/*
-		 * This thread may hit another WARN() in the panic path.
-		 * Resetting this prevents additional WARN() from panicking the
-		 * system on this thread.  Other threads are blocked by the
-		 * panic_mutex in panic().
-		 */
-		panic_on_warn = 0;
+	if (panic_on_warn)
 		panic("panic_on_warn set ...\n");
-	}
 }
 
 void __ubsan_handle_divrem_overflow(void *_data, void *lhs, void *rhs)
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are


