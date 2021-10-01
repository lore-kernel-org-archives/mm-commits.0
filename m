Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B35EFC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AC3261AA4
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 23:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhJAX5Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Oct 2021 19:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhJAX5X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 1 Oct 2021 19:57:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 245BF61AA9;
        Fri,  1 Oct 2021 23:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633132538;
        bh=lBZDN4Sxg/+vraNANhJeKqJ4ZBprGTnn5rUKZjS2oLc=;
        h=Date:From:To:Subject:From;
        b=pZs477C8AR//IKtLWYZR6JujL0sCB8z/k2X7LpWZ83vyE7opzCabsSxVTiwQuHXtf
         kL3Y2UXoHighNt1hpYfBjBt+3/47OBByeN2U+xajV2Gpp12lLzz5+ZxzWX1mssfUkt
         BNZa4gc3L+rG+FU3aldSo3UWWuEHevwyhjXnDyS0=
Date:   Fri, 01 Oct 2021 16:55:37 -0700
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
Subject:  +
 mm-kvmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
 added to -mm tree
Message-ID: <20211001235537.dL6WTRJa6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kvmalloc: add __alloc_size attributes for better bounds checking
has been added to the -mm tree.  Its filename is
     mm-kvmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-kvmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-kvmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm/kvmalloc: add __alloc_size attributes for better bounds checking

As already done in GrapheneOS, add the __alloc_size attribute for regular
kvmalloc interfaces, to provide additional hinting for better bounds
checking, assisting CONFIG_FORTIFY_SOURCE and other compiler
optimizations.

Link: https://lkml.kernel.org/r/20210930222704.2631604-6-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Co-developed-by: Daniel Micay <danielmicay@gmail.com>
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
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

 include/linux/slab.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/slab.h~mm-kvmalloc-add-__alloc_size-attributes-for-better-bounds-checking
+++ a/include/linux/slab.h
@@ -737,21 +737,21 @@ static inline __alloc_size(1) void *kzal
 	return kmalloc_node(size, flags | __GFP_ZERO, node);
 }
 
-extern void *kvmalloc_node(size_t size, gfp_t flags, int node);
-static inline void *kvmalloc(size_t size, gfp_t flags)
+extern void *kvmalloc_node(size_t size, gfp_t flags, int node) __alloc_size(1);
+static inline __alloc_size(1) void *kvmalloc(size_t size, gfp_t flags)
 {
 	return kvmalloc_node(size, flags, NUMA_NO_NODE);
 }
-static inline void *kvzalloc_node(size_t size, gfp_t flags, int node)
+static inline __alloc_size(1) void *kvzalloc_node(size_t size, gfp_t flags, int node)
 {
 	return kvmalloc_node(size, flags | __GFP_ZERO, node);
 }
-static inline void *kvzalloc(size_t size, gfp_t flags)
+static inline __alloc_size(1) void *kvzalloc(size_t size, gfp_t flags)
 {
 	return kvmalloc(size, flags | __GFP_ZERO);
 }
 
-static inline void *kvmalloc_array(size_t n, size_t size, gfp_t flags)
+static inline __alloc_size(1, 2) void *kvmalloc_array(size_t n, size_t size, gfp_t flags)
 {
 	size_t bytes;
 
@@ -761,13 +761,13 @@ static inline void *kvmalloc_array(size_
 	return kvmalloc(bytes, flags);
 }
 
-static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
+static inline __alloc_size(1, 2) void *kvcalloc(size_t n, size_t size, gfp_t flags)
 {
 	return kvmalloc_array(n, size, flags | __GFP_ZERO);
 }
 
-extern void *kvrealloc(const void *p, size_t oldsize, size_t newsize,
-		gfp_t flags);
+extern void *kvrealloc(const void *p, size_t oldsize, size_t newsize, gfp_t flags)
+		      __alloc_size(3);
 extern void kvfree(const void *addr);
 extern void kvfree_sensitive(const void *addr, size_t len);
 
_

Patches currently in -mm which might be from keescook@chromium.org are

rapidio-avoid-bogus-__alloc_size-warning.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
slab-clean-up-function-prototypes.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-kvmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
binfmt_elf-reintroduce-using-map_fixed_noreplace.patch

