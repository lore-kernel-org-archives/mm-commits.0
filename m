Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325ADFC0B
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 01:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610216; cv=none; b=N8O1aafA4En2vSyzzZL7TfcH2Wvtdv+GFc4nJNJm/cV6KCpaHw+t/3SdVjJ+GkBfiKcU86n69FeF53uWAqHd6LZaQEcBvmHxgTfmhphuyMfOs9y5wPufuc+fOCkIoh0eL3EO57/xOYOAmuJ1lYxPFclvYcAnJacKmDoT6PqS8V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610216; c=relaxed/simple;
	bh=g45EqcNGPxAqkd4z8F2M2u8yIgu+huUUn5u/aYneNVc=;
	h=Date:To:From:Subject:Message-Id; b=S82P49sK9EqYHjeZ7WCBBTBEqlgXWmBH3q7vk7dlI0XcAUqWKlNPlhI6jBR7VHcHand24aKJOHBdBH663pG6HpAUXwwr56x84yJNXd8V7KE6HG4P6AsiBs3LcXZSZIcuwxIocKRy+VymOLiOVTjcBqY2cfAjpQZLvLNocfY7QWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mzbSZmkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mzbSZmkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AADD3C4CED2;
	Tue, 31 Dec 2024 01:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610215;
	bh=g45EqcNGPxAqkd4z8F2M2u8yIgu+huUUn5u/aYneNVc=;
	h=Date:To:From:Subject:From;
	b=mzbSZmkdHFQSm1BWoETBdH8Ol+Wjqz+xTvINnr30cVoQJyb74EOWGlpx8qqGY1RjK
	 6uSu4mqpT4/zRjui/FKczx3qTwM+x11DGl/Qs/PM5Px7secRT+r84MkS116x670vV6
	 A/FNwk4Y3MUTgOJ8NTXTuyP9hnbVbB2VlLcSp/nk=
Date: Mon, 30 Dec 2024 17:56:55 -0800
To: mm-commits@vger.kernel.org,ubizjak@gmail.com,tj@kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,gal@nvidia.com,dennis@kernel.org,cl@linux.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] percpu-remove-intermediate-variable-in-percpu_ptr-fix.patch removed from -mm tree
Message-Id: <20241231015655.AADD3C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu-remove-intermediate-variable-in-percpu_ptr-fix
has been removed from the -mm tree.  Its filename was
     percpu-remove-intermediate-variable-in-percpu_ptr-fix.patch

This patch was dropped because it was folded into percpu-remove-intermediate-variable-in-percpu_ptr.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: percpu-remove-intermediate-variable-in-percpu_ptr-fix
Date: Thu Dec 19 02:46:23 PM PST 2024

simplification, per Uros

Cc: Gal Pressman <gal@nvidia.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu-defs.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/percpu-defs.h~percpu-remove-intermediate-variable-in-percpu_ptr-fix
+++ a/include/linux/percpu-defs.h
@@ -221,9 +221,7 @@ do {									\
 } while (0)
 
 #define PERCPU_PTR(__p)							\
-({									\
-	(typeof(*(__p)) __force __kernel *)((__force unsigned long)(__p)); \
-})
+	(typeof(*(__p)) __force __kernel *)((__force unsigned long)(__p))
 
 #ifdef CONFIG_SMP
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

percpu-remove-intermediate-variable-in-percpu_ptr.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
replace-free-hugepage-folios-after-migration-fix.patch
xarray-port-tests-to-kunit-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

