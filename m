Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB3B7C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A85F261872
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhKKCn6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:43:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233954AbhKKCn5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:43:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF9FC6187A;
        Thu, 11 Nov 2021 02:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598469;
        bh=xc9zdLr174v4NOtYe8eBqbdJx951m9DUQsji5Fyawyk=;
        h=Date:From:To:Subject:From;
        b=SZrdH7meX+uky2fdTJRrZMkMA5Jx+vZsmLhEpaiAOYFW7w2/a6k2/Mzo0Wunixj/a
         E+zVcqeYN588SHBjqiCxttk2zqXj8Tbs1vLXO2XLYX1QdQa2YZS9B908CIPtBDqXEj
         41YflT9Z7xZWYlkamu21L2P9J4sF118ixoD/QM7g=
Date:   Wed, 10 Nov 2021 18:41:08 -0800
From:   akpm@linux-foundation.org
To:     alex.bou9@gmail.com, apw@canonical.com, cl@linux.com,
        danielmicay@gmail.com, dennis@kernel.org, dwaipayanray1@gmail.com,
        gustavoars@kernel.org, iamjoonsoo.kim@lge.com, ira.weiny@intel.com,
        jhubbard@nvidia.com, jingxiangfeng@huawei.com, joe@perches.com,
        jrdr.linux@gmail.com, keescook@chromium.org, lkp@intel.com,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        mporter@kernel.crashing.org, nathan@kernel.org,
        ndesaulniers@google.com, ojeda@kernel.org, penberg@kernel.org,
        rdunlap@infradead.org, rientjes@google.com, tj@kernel.org,
        vbabka@suse.cz
Subject:  [merged]
 mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
 removed from -mm tree
Message-ID: <20211111024108.yeZmkPTQG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: add __alloc_size attributes for better bounds checking
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm/page_alloc: add __alloc_size attributes for better bounds checking

As already done in GrapheneOS, add the __alloc_size attribute for
appropriate page allocator interfaces, to provide additional hinting for
better bounds checking, assisting CONFIG_FORTIFY_SOURCE and other compiler
optimizations.

Link: https://lkml.kernel.org/r/20210930222704.2631604-8-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Co-developed-by: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/gfp.h~mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking
+++ a/include/linux/gfp.h
@@ -608,9 +608,9 @@ static inline struct page *alloc_pages(g
 extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
 extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 
-void *alloc_pages_exact(size_t size, gfp_t gfp_mask);
+void *alloc_pages_exact(size_t size, gfp_t gfp_mask) __alloc_size(1);
 void free_pages_exact(void *virt, size_t size);
-void * __meminit alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask);
+__meminit void *alloc_pages_exact_nid(int nid, size_t size, gfp_t gfp_mask) __alloc_size(1);
 
 #define __get_free_page(gfp_mask) \
 		__get_free_pages((gfp_mask), 0)
_

Patches currently in -mm which might be from keescook@chromium.org are

kasan-test-consolidate-workarounds-for-unwanted-__alloc_size-protection.patch

