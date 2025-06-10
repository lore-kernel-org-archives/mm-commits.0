Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18A3634
	for <mm-commits@vger.kernel.org>; Tue, 10 Jun 2025 00:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749513859; cv=none; b=mmdK4Ty1MxWMYC0GGYIs3JlR2si7HjU2PRn23UPOebu/B/VsoPLhIBPUkTNVDb0ec8NoHXaVNWQvR023owveuiUJ/mWQsX7wLLRvOwb/fJ4KJO2ydyb94VLoPjsR5/+wBB84xgTzv7Dpfbby/ybkM/lXGprCmNENWqaM1I1WGes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749513859; c=relaxed/simple;
	bh=HcaADfabKkUwLAgVNg0xd9/qqLfFHctRJOccz3Qu3OI=;
	h=Date:To:From:Subject:Message-Id; b=kOQ8vrf0PhU7DseNxVusRibHa8wvUBE80Sa4c1toIhtkTuihpPL5ttB6SHlmqWLUj4TN5gsSIT5niA7UAWEZCMUqw71yfrrd2GzKztsvxOVZi1bHcWDU81Qo2WRbUTKPj8rblwKSJl8CuhTa91Db1BUsPXcKKXSApXuITDTJbzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CEtKD6ML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CEtKD6ML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BF9C4CEEB;
	Tue, 10 Jun 2025 00:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749513857;
	bh=HcaADfabKkUwLAgVNg0xd9/qqLfFHctRJOccz3Qu3OI=;
	h=Date:To:From:Subject:From;
	b=CEtKD6MLow8nkbIIAELcrad/O3SYM3qkj7W0+4W5PrYxiamNQBDmHslWf9KcLvwS4
	 SxhzlixSm5wH34ySczlu9x7dWrx911kZenMM5dh44k8VH4gwO6TvVe9bHdqPjQ8110
	 4h6fkUzTFsL5PESw2Jd3Vu0ELtxRCf50M5IMiqFY=
Date: Mon, 09 Jun 2025 17:04:16 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,kent.overstreet@linux.dev,gehao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-alloc_tag-add-the-arch_needs_weak_per_cpu-macro-when-statically-defining-the-percpu-variable-alloc_tag_counters.patch removed from -mm tree
Message-Id: <20250610000417.31BF9C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/alloc_tag: add the ARCH_NEEDS_WEAK_PER_CPU macro when statically defining the percpu variable alloc_tag_counters
has been removed from the -mm tree.  Its filename was
     mm-alloc_tag-add-the-arch_needs_weak_per_cpu-macro-when-statically-defining-the-percpu-variable-alloc_tag_counters.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hao Ge <gehao@kylinos.cn>
Subject: mm/alloc_tag: add the ARCH_NEEDS_WEAK_PER_CPU macro when statically defining the percpu variable alloc_tag_counters
Date: Thu, 29 May 2025 15:35:37 +0800

Recently discovered this entry while checking kallsyms on ARM64:
ffff800083e509c0 D _shared_alloc_tag

If ARCH_NEEDS_WEAK_PER_CPU is not defined,there's no need to statically
define the percpu variable alloc_tag_counters.

Therefore, add the relevant macro guards at the appropriate location.

Link: https://lkml.kernel.org/r/20250529073537.563107-1-hao.ge@linux.dev
Fixes: 22d407b164ff ("lib: add allocation tagging support for memory allocation profiling")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/alloc_tag.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/alloc_tag.c~mm-alloc_tag-add-the-arch_needs_weak_per_cpu-macro-when-statically-defining-the-percpu-variable-alloc_tag_counters
+++ a/lib/alloc_tag.c
@@ -24,8 +24,10 @@ static bool mem_profiling_support;
 
 static struct codetag_type *alloc_tag_cttype;
 
+#ifdef ARCH_NEEDS_WEAK_PER_CPU
 DEFINE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
 EXPORT_SYMBOL(_shared_alloc_tag);
+#endif /* ARCH_NEEDS_WEAK_PER_CPU */
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
_

Patches currently in -mm which might be from gehao@kylinos.cn are


