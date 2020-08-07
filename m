Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51692C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D8F722CF6
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781099;
	bh=KtulRCauuG00kNqKhgECuMBgp5+EX5wRaB63o6XwEFo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=G8Lj624AgFyaDrxmYgirme5nDVV0GLzWCJ/CUa7z54W2ziRzbn/d4H2WfEGO9bAjt
	 6KTssIR5sy9mBr6KinJp/tLf214JGWYHa1gyZ4MOZrpt4nAHHxDtOzrC0BRKM7Ii/4
	 WdvxkpRGGm0LfzlHkk6l7jLIR9W4vOpCv0aauNG8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgHGGSS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGGSS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:18:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A71342177B;
        Fri,  7 Aug 2020 06:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781098;
        bh=KtulRCauuG00kNqKhgECuMBgp5+EX5wRaB63o6XwEFo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jdwyvxu7Dk2wgnbvWKMVwjJyXfdxghRSKFppexYcnmnJy0dvYj5B96FFgeME8m79g
         GBt+Y4rJp4hWH9bovddFpfHgT9LuOWAUYJ4urvE+OuljZBa7kke8uPdadQk2J9aBUY
         2bNk69MDlFimbiyMd+5Ty03215N0Ce7P1cg2K8bo=
Date:   Thu, 06 Aug 2020 23:18:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, david@redhat.com,
        iamjoonsoo.kim@lge.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [patch 023/163] mm: ksize() should silently accept a NULL
 pointer
Message-ID: <20200807061817._fTyXX7M0%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: William Kucharski <william.kucharski@oracle.com>
Subject: mm: ksize() should silently accept a NULL pointer

Other mm routines such as kfree() and kzfree() silently do the right thing
if passed a NULL pointer, so ksize() should do the same.

Link: http://lkml.kernel.org/r/20200616225409.4670-1-william.kucharski@oracle.com
Signed-off-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/mm/slab_common.c~mm-ksize-should-silently-accept-a-null-pointer
+++ a/mm/slab_common.c
@@ -1681,10 +1681,9 @@ static __always_inline void *__do_kreall
 					   gfp_t flags)
 {
 	void *ret;
-	size_t ks = 0;
+	size_t ks;
 
-	if (p)
-		ks = ksize(p);
+	ks = ksize(p);
 
 	if (ks >= new_size) {
 		p = kasan_krealloc((void *)p, new_size, flags);
@@ -1744,10 +1743,9 @@ void kfree_sensitive(const void *p)
 	size_t ks;
 	void *mem = (void *)p;
 
-	if (unlikely(ZERO_OR_NULL_PTR(mem)))
-		return;
 	ks = ksize(mem);
-	memzero_explicit(mem, ks);
+	if (ks)
+		memzero_explicit(mem, ks);
 	kfree(mem);
 }
 EXPORT_SYMBOL(kfree_sensitive);
@@ -1770,8 +1768,6 @@ size_t ksize(const void *objp)
 {
 	size_t size;
 
-	if (WARN_ON_ONCE(!objp))
-		return 0;
 	/*
 	 * We need to check that the pointed to object is valid, and only then
 	 * unpoison the shadow memory below. We use __kasan_check_read(), to
@@ -1785,7 +1781,7 @@ size_t ksize(const void *objp)
 	 * We want to perform the check before __ksize(), to avoid potentially
 	 * crashing in __ksize() due to accessing invalid metadata.
 	 */
-	if (unlikely(objp == ZERO_SIZE_PTR) || !__kasan_check_read(objp, 1))
+	if (unlikely(ZERO_OR_NULL_PTR(objp)) || !__kasan_check_read(objp, 1))
 		return 0;
 
 	size = __ksize(objp);
_
