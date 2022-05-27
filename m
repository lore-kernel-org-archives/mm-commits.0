Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E28F4C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245051AbiE0QfP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349224AbiE0Qe5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:34:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9DB52523
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C90BB82299
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD8AC385A9;
        Fri, 27 May 2022 16:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669293;
        bh=PjuKDajqzLtjnRxEFvU0Gdapfl5TKLpjqzravYrK4pY=;
        h=Date:To:From:Subject:From;
        b=jcGM8jf7Q10g7VKANrNom71XQ3GSuihvxa1IIiLp97CawWseWkIUXNUfuaMXibjem
         SRfAM0npupJCHa5yDcRG/X82XTHPlB5JfNG7Yo+I2jqUSinvZp/uBmMKu8UVgijOWq
         5Gxih2M54o4iWuH0iG8qUsn/ck1rZvYVfmoBvSOk=
Date:   Fri, 27 May 2022 09:34:53 -0700
To:     mm-commits@vger.kernel.org, vitaly.wool@konsulko.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-fix-possible-null-pointer-dereferencing.patch removed from -mm tree
Message-Id: <20220527163453.BBD8AC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/z3fold: fix possible null pointer dereferencing
has been removed from the -mm tree.  Its filename was
     mm-z3fold-fix-possible-null-pointer-dereferencing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/z3fold: fix possible null pointer dereferencing
Date: Fri, 29 Apr 2022 14:40:43 +0800

alloc_slots could fail to allocate memory under heavy memory pressure.  So
we should check zhdr->slots against NULL to avoid future null pointer
dereferencing.

Link: https://lkml.kernel.org/r/20220429064051.61552-3-linmiaohe@huawei.com
Fixes: fc5488651c7d ("z3fold: simplify freeing slots")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/z3fold.c~mm-z3fold-fix-possible-null-pointer-dereferencing
+++ a/mm/z3fold.c
@@ -940,9 +940,19 @@ lookup:
 		}
 	}
 
-	if (zhdr && !zhdr->slots)
+	if (zhdr && !zhdr->slots) {
 		zhdr->slots = alloc_slots(pool, GFP_ATOMIC);
+		if (!zhdr->slots)
+			goto out_fail;
+	}
 	return zhdr;
+
+out_fail:
+	if (!kref_put(&zhdr->refcount, release_z3fold_page_locked)) {
+		add_to_unbuddied(pool, zhdr);
+		z3fold_page_unlock(zhdr);
+	}
+	return NULL;
 }
 
 /*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


