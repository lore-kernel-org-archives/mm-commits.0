Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E88C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF3EA20723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026880;
	bh=rtcql+fhcwCg5L2NCLlG1UAlzAnpJmVKv5P0GeB8LBI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=bdUG8v5kHg3pD9AP8eU7mvtEzhHBYE/vag1YOqMkNEMWxnUjOnCWS3FjH2eJFg45B
	 xK/SWg8muyLkNaMZWSVBaYAzWy1T0qX5gzDqH1XY+vLpqotMbSbACunCtw9c8sKDwC
	 uDDEnBIJMQZ3/3nlgFWyorHtApfY85jWClL8+CgU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgHJCej (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726469AbgHJCei (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8541A206C3;
        Mon, 10 Aug 2020 02:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026877;
        bh=rtcql+fhcwCg5L2NCLlG1UAlzAnpJmVKv5P0GeB8LBI=;
        h=Date:From:To:Subject:From;
        b=cB/ttUTolw4wN2ipBNU0IduFrtRVdyMWvsOlKdU7SzxrjywFqunXDp79qS0sF3/XB
         mW4fl6bnZBwXJ6FAy8NxppNNxiIr/ZG7p7jqevzIiaaKf3t46+oPVDsesuD8PQ6IVw
         B1Q6fwl/1EucsyeppW4C1Y8OKaI/8n12tZxvFkdY=
Date:   Sun, 09 Aug 2020 19:34:37 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, david@redhat.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, william.kucharski@oracle.com,
        willy@infradead.org
Subject:  [merged]
 mm-ksize-should-silently-accept-a-null-pointer.patch removed from -mm tree
Message-ID: <20200810023437.IT_jGVkbm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ksize() should silently accept a NULL pointer
has been removed from the -mm tree.  Its filename was
     mm-ksize-should-silently-accept-a-null-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from william.kucharski@oracle.com are


