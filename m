Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82C5C43470
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99C8E61413
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhEEBf3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:38386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231650AbhEEBf3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:35:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 521C06140F;
        Wed,  5 May 2021 01:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178473;
        bh=ClT2d2mUcqvy/RPrGU6sQfG4RR/uoBaJv4sR3ZIhqN4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YPMZgQWrx9ybHYIu0SXHLDqabrOkeDbWLpboZwhmnbvrGZiiBGe9iJef1VPLLGq0D
         Akc/7iQBrcAND+P4oNrQGYTuUZ+aF0gg/sK4xqBWKZv9R9MPX79w7vfvnaibsrjCga
         1uym77LnFw6bgI67r49xVB5CjgPoNaiv6VzGv7Pc=
Date:   Tue, 04 May 2021 18:34:32 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linfeilong@huawei.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 035/143] mm/hugeltb: simplify the return code of
 __vma_reservation_common()
Message-ID: <20210505013432.-qe5Xrmmy%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
