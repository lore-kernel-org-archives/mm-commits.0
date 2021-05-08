Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C18DC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A5426101D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbhEHWs1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:59992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhEHWsX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FF47613EA;
        Sat,  8 May 2021 22:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514041;
        bh=sipIcDZiJaICS69ZU1Pr+NQ5pqstlJHma/016210bXs=;
        h=Date:From:To:Subject:From;
        b=gMckKnj50JSTnr2d5+klJRmY1y98uT6TCfG6FJt96g5FShwx54A89OszFdopZU/FB
         vFTfls99MpevE/yjtoYM2JVJQ9hVpBcWhdpcP2xUinK43mLDJVvGFdbVp0Bjs+cMgD
         veMSVKTsOLFXTpZchdFrWp3vPN61htxApCL6VUuI=
Date:   Sat, 08 May 2021 15:47:21 -0700
From:   akpm@linux-foundation.org
To:     linfeilong@huawei.com, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-hugeltb-simplify-the-return-code-of-__vma_reservation_common.patch
 removed from -mm tree
Message-ID: <20210508224721.mCljvRRfg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugeltb: simplify the return code of __vma_reservation_common()
has been removed from the -mm tree.  Its filename was
     mm-hugeltb-simplify-the-return-code-of-__vma_reservation_common.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugeltb: simplify the return code of __vma_reservation_common()

It's guaranteed that the vma is associated with a resv_map, i.e.  either
VM_MAYSHARE or HPAGE_RESV_OWNER, when the code reaches here or we would
have returned via !resv check above.  So it's unneeded to check whether
HPAGE_RESV_OWNER is set here.  Simplify the return code to make it more
clear.

Link: https://lkml.kernel.org/r/20210410072348.20437-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/mm/hugetlb.c~mm-hugeltb-simplify-the-return-code-of-__vma_reservation_common
+++ a/mm/hugetlb.c
@@ -2174,27 +2174,26 @@ static long __vma_reservation_common(str
 
 	if (vma->vm_flags & VM_MAYSHARE)
 		return ret;
-	else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) && ret >= 0) {
-		/*
-		 * In most cases, reserves always exist for private mappings.
-		 * However, a file associated with mapping could have been
-		 * hole punched or truncated after reserves were consumed.
-		 * As subsequent fault on such a range will not use reserves.
-		 * Subtle - The reserve map for private mappings has the
-		 * opposite meaning than that of shared mappings.  If NO
-		 * entry is in the reserve map, it means a reservation exists.
-		 * If an entry exists in the reserve map, it means the
-		 * reservation has already been consumed.  As a result, the
-		 * return value of this routine is the opposite of the
-		 * value returned from reserve map manipulation routines above.
-		 */
-		if (ret)
-			return 0;
-		else
-			return 1;
-	}
-	else
-		return ret < 0 ? ret : 0;
+	/*
+	 * We know private mapping must have HPAGE_RESV_OWNER set.
+	 *
+	 * In most cases, reserves always exist for private mappings.
+	 * However, a file associated with mapping could have been
+	 * hole punched or truncated after reserves were consumed.
+	 * As subsequent fault on such a range will not use reserves.
+	 * Subtle - The reserve map for private mappings has the
+	 * opposite meaning than that of shared mappings.  If NO
+	 * entry is in the reserve map, it means a reservation exists.
+	 * If an entry exists in the reserve map, it means the
+	 * reservation has already been consumed.  As a result, the
+	 * return value of this routine is the opposite of the
+	 * value returned from reserve map manipulation routines above.
+	 */
+	if (ret > 0)
+		return 0;
+	if (ret == 0)
+		return 1;
+	return ret;
 }
 
 static long vma_needs_reservation(struct hstate *h,
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


