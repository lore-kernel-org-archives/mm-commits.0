Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8593BC11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6561361D0E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhF2ClX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:41:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230152AbhF2ClV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:41:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBBF661D0B;
        Tue, 29 Jun 2021 02:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934334;
        bh=/VZKpJBEmFMTNXbkQoKCKcpLze0tMUiFBMjwy3SaQ6k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=KYZgsRszoo9HaiGKGJVnvPeIru5E9ssixFJnpljvmuQasGpt0w1BKJiYnzW9mqtcA
         G2uUZSXE4kWDVdKg2UcgMuVVt314eNfFvrMsL9wLV3cJ74oDDo94Dk46WbzXJWtakZ
         fDKv0Sx5zPhV1wk0sVTaYH6GUnIwgnEEOSOvYus8=
Date:   Mon, 28 Jun 2021 19:38:53 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dbueso@suse.de,
        geert@linux-m68k.org, ldufour@linux.ibm.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 106/192] drm/i915/selftests: use vma_lookup() in
 __igt_mmap()
Message-ID: <20210629023853.zKNSc_tqX%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>
Subject: drm/i915/selftests: use vma_lookup() in __igt_mmap()

vma_lookup() will look up the vma at a specific address.  find_vma() will
start the search for a specific address and continue upwards.  This fixes
an issue with the selftest as the returned vma may not be the newly
created vma, but simply the vma at a higher address.

Link: https://lkml.kernel.org/r/20210521174745.2219620-3-Liam.Howlett@Oracle.com
Fixes: 6fedafacae1b (drm/i915/selftests: Wrap vm_mmap() around GEM
objects
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Laurent Dufour <ldufour@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c~drm-i915-selftests-use-vma_lookup-in-__igt_mmap
+++ a/drivers/gpu/drm/i915/gem/selftests/i915_gem_mman.c
@@ -871,7 +871,7 @@ static int __igt_mmap(struct drm_i915_pr
 
 	pr_debug("igt_mmap(%s, %d) @ %lx\n", obj->mm.region->name, type, addr);
 
-	area = find_vma(current->mm, addr);
+	area = vma_lookup(current->mm, addr);
 	if (!area) {
 		pr_err("%s: Did not create a vm_area_struct for the mmap\n",
 		       obj->mm.region->name);
_
