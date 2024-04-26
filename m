Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AE975816
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714100703; cv=none; b=hsORjwI7TFoxIVwOnpqCA9DQmCn9I2dZV/p4yflABMNBq+UgKCFoNs2PX2tP3VKkO+rse3uLFkbpdBzb0ESPRyMo8XZCq1j/+Scfpagzegm9OA4p3CALcDJEu3FVxvD39CCQmYUpAQvOZ+vzvoQ8pXpMx+utZsR4yYABj0jEf08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714100703; c=relaxed/simple;
	bh=Fa6z0X9kVMjeF8HeLVwhUKt1YLerCwp4p4V2g3dGWXU=;
	h=Date:To:From:Subject:Message-Id; b=U1uhQzIW8UmerGIsp6slhV5nS2WbjGahqsOVCgM0y8NYLvz5qenLDqMwptitSNWc0x4fSt2U1QIbyfTLH6JNBzYbyTg6v7OPQFkS2oSMEes7G7aK84A6x1qTXAmSzvWZ4Yt8u4ePb61sAqyeIHkEJr2rXsMEMY9VQ6hRVWj2BFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gNO/Wlwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gNO/Wlwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FABC113CC;
	Fri, 26 Apr 2024 03:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714100703;
	bh=Fa6z0X9kVMjeF8HeLVwhUKt1YLerCwp4p4V2g3dGWXU=;
	h=Date:To:From:Subject:From;
	b=gNO/WlwdKL0sO2gWSPZ+a0Bu8sypqG5vavNr6R+C7xh0/6G/Wt+zin9v8nOF+Uc/X
	 HEVtimajPNSbj0lj7HM+VIBatS1/dxr8vKgbrLdqRBnpq4r+HtKkNNjtwWSY8oSjIR
	 XZNtmIU0ac2b7wRb0BxbJNx/k44zvkw66MORf1ac=
Date: Thu, 25 Apr 2024 20:05:02 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] fix-missing-vmalloch-includes-fix.patch removed from -mm tree
Message-Id: <20240426030502.F2FABC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fixup! fix missing vmalloc.h includes
has been removed from the -mm tree.  Its filename was
     fix-missing-vmalloch-includes-fix.patch

This patch was dropped because it was folded into fix-missing-vmalloch-includes.patch

------------------------------------------------------
From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: fixup! fix missing vmalloc.h includes
Date: Tue, 26 Mar 2024 20:21:52 -0400

The previous patch added string.h to arch/alpha/lib/memcpy.c to fix a
warning about a missing forward declaration - but this breaks with -
presumably - some fortify source shenanigans that redefine memcpy as a
macro.

Link: https://lkml.kernel.org/r/20240327002152.3339937-1-kent.overstreet@linux.dev
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/lib/memcpy.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/alpha/lib/memcpy.c~fix-missing-vmalloch-includes-fix
+++ a/arch/alpha/lib/memcpy.c
@@ -18,7 +18,6 @@
 
 #include <linux/types.h>
 #include <linux/export.h>
-#include <linux/string.h>
 
 /*
  * This should be done in one go with ldq_u*2/mask/stq_u. Do it
_

Patches currently in -mm which might be from kent.overstreet@linux.dev are

fix-missing-vmalloch-includes.patch
fix-missing-vmalloch-includes-fix-4.patch
asm-generic-ioh-kill-vmalloch-dependency.patch
mm-slub-mark-slab_free_freelist_hook-__always_inline.patch
scripts-kallysms-always-include-__start-and-__stop-symbols.patch
fs-convert-alloc_inode_sb-to-a-macro.patch
rust-add-a-rust-helper-for-krealloc.patch
mempool-hook-up-to-memory-allocation-profiling.patch
mm-percpu-introduce-pcpuobj_ext.patch
mm-percpu-add-codetag-reference-into-pcpuobj_ext.patch
mm-vmalloc-enable-memory-allocation-profiling.patch
rhashtable-plumb-through-alloc-tag.patch
maintainers-add-entries-for-code-tagging-and-memory-allocation-profiling.patch
memprofiling-documentation.patch

