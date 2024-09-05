Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83596189514;
	Thu,  5 Sep 2024 21:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725573174; cv=none; b=CaeRCZzQEakpvkHomnwK06e/jIHlchwOcoEhW1MtPQwSCWfEohSzvnPRJD1OATjiO1k8ChPpZ7nNK/tSkOvoTjAoLXcuUzl6Jk6k2AYH1M+XhTGZLhD/bkzL3sd6MaN/ZDVtzSfmHmVCDOGlxYjulsH20DgskEDiPK6kmFlxcLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725573174; c=relaxed/simple;
	bh=nx/iJgxxx0/pA0d+J8S09Hv5j2xaCkOx69nmjGjcuck=;
	h=Date:To:From:Subject:Message-Id; b=a4qjx/RtpudBFPvVjKwcp4LW2z1YQZuZ1WUTB8afe2s4vuzDOct/kI8GHbYew5So/jYv0RTOl9E9F26/B5zpN2S/8mFtsHSlRcQDqvn39ka7F3Hfkc1XnCra5E8TnlirSdypHLfiHwDS7TqTd/6WEFCUDaKNDUBeg4Pcw2gzIeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lXSMGYYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lXSMGYYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF582C4CEC3;
	Thu,  5 Sep 2024 21:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725573174;
	bh=nx/iJgxxx0/pA0d+J8S09Hv5j2xaCkOx69nmjGjcuck=;
	h=Date:To:From:Subject:From;
	b=lXSMGYYb71wJJSTok2dmpLiFKRHVvSZpFj9sdJap5YX9fBUH4xMTdcKOfPFlAeG0G
	 YSgorX74ujZFxyVpXuZFxT8xqzv8Cly3irpz/ZuTmv2x9sKHcWF3wDoxGjxfumi0GQ
	 S/o6tZrgWa4nxsV0cB6uQbDwsHWxPm9+UNds8mTY=
Date: Thu, 05 Sep 2024 14:52:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-unique-zsmalloc-caches-names.patch added to mm-hotfixes-unstable branch
Message-Id: <20240905215253.DF582C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use unique zsmalloc caches names
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-use-unique-zsmalloc-caches-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-unique-zsmalloc-caches-names.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: mm: use unique zsmalloc caches names
Date: Thu, 5 Sep 2024 15:47:23 +0900

Each zsmalloc pool maintains several named kmem-caches for zs_handle-s and
zspage-s.  On a system with multiple zsmalloc pools and CONFIG_DEBUG_VM
this triggers kmem_cache_sanity_check():

  kmem_cache of name 'zspage' already exists
  WARNING: at mm/slab_common.c:108 do_kmem_cache_create_usercopy+0xb5/0x310
  ...

  kmem_cache of name 'zs_handle' already exists
  WARNING: at mm/slab_common.c:108 do_kmem_cache_create_usercopy+0xb5/0x310
  ...

We provide zram device name when init its zsmalloc pool, so we can
use that same name for zsmalloc caches and, hence, create unique
names that can easily be linked to zram device that has created
them.

So instead of having this

cat /proc/slabinfo
slabinfo - version: 2.1
zspage                46     46    ...
zs_handle            128    128    ...
zspage             34270  34270    ...
zs_handle          34816  34816    ...
zspage                 0      0    ...
zs_handle              0      0    ...

We now have this

cat /proc/slabinfo
slabinfo - version: 2.1
zspage-zram2          46     46    ...
zs_handle-zram2      128    128    ...
zspage-zram0       34270  34270    ...
zs_handle-zram0    34816  34816    ...
zspage-zram1           0      0    ...
zs_handle-zram1        0      0    ...

Link: https://lkml.kernel.org/r/20240905064736.2250735-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c~mm-use-unique-zsmalloc-caches-names
+++ a/mm/zsmalloc.c
@@ -293,13 +293,17 @@ static void SetZsPageMovable(struct zs_p
 
 static int create_cache(struct zs_pool *pool)
 {
-	pool->handle_cachep = kmem_cache_create("zs_handle", ZS_HANDLE_SIZE,
-					0, 0, NULL);
+	char name[32];
+
+	snprintf(name, sizeof(name), "zs_handle-%s", pool->name);
+	pool->handle_cachep = kmem_cache_create(name, ZS_HANDLE_SIZE,
+						0, 0, NULL);
 	if (!pool->handle_cachep)
 		return 1;
 
-	pool->zspage_cachep = kmem_cache_create("zspage", sizeof(struct zspage),
-					0, 0, NULL);
+	snprintf(name, sizeof(name), "zspage-%s", pool->name);
+	pool->zspage_cachep = kmem_cache_create(name, sizeof(struct zspage),
+						0, 0, NULL);
 	if (!pool->zspage_cachep) {
 		kmem_cache_destroy(pool->handle_cachep);
 		pool->handle_cachep = NULL;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

mm-use-unique-zsmalloc-caches-names.patch
lib-zstd-export-api-needed-for-dictionary-support.patch
lib-lz4hc-export-lz4_resetstreamhc-symbol.patch
lib-zstd-fix-null-deref-in-zstd_createcdict_advanced2.patch
zram-introduce-custom-comp-backends-api.patch
zram-add-lzo-and-lzorle-compression-backends-support.patch
zram-add-lz4-compression-backend-support.patch
zram-add-lz4hc-compression-backend-support.patch
zram-add-zstd-compression-backend-support.patch
zram-pass-estimated-src-size-hint-to-zstd.patch
zram-add-zlib-compression-backend-support.patch
zram-add-842-compression-backend-support.patch
zram-check-that-backends-array-has-at-least-one-backend.patch
zram-introduce-zcomp_params-structure.patch
zram-recalculate-zstd-compression-params-once.patch
zram-introduce-algorithm_params-device-attribute.patch
zram-add-support-for-dict-comp-config.patch
zram-introduce-zcomp_req-structure.patch
zram-introduce-zcomp_ctx-structure.patch
zram-move-immutable-comp-params-away-from-per-cpu-context.patch
zram-add-dictionary-support-to-lz4.patch
zram-add-dictionary-support-to-lz4hc.patch
zram-add-dictionary-support-to-zstd-backend.patch
documentation-zram-add-documentation-for-algorithm-parameters.patch
documentation-zram-add-documentation-for-algorithm-parameters-fix.patch
zram-support-priority-parameter-in-recompression.patch
mm-kconfig-fixup-zsmalloc-configuration.patch

