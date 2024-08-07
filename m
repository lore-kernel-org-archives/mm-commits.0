Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A2084A51
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 20:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723062905; cv=none; b=btnYoqlyc8GblqaNDzqluqv4lnWAxAA5mn1n9BKGHB86ioSV6tYp9xOqNCutAR2NN74E8QFLGx8bWYrKx0rijsGyftVP+9HQd8oIk25htPqYT9Y7bwtspve+ib90s3HqeCmURB+xuHdBqYujIpSQb6uGIon1Hf5OL3O7sUxo/U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723062905; c=relaxed/simple;
	bh=7d0/HkAEE2VvRW1z+wsqsOSxbVDYqzBMjxF1Na4RWZs=;
	h=Date:To:From:Subject:Message-Id; b=eepkzOTKF7XDKe0VYjofBErzp5tvAP/jYbVjXQjR2ioWS6WCOpNes96kdVUZ4K5WFxq+2RpWiEc5JHQOsY+dig/Nunt3RoMjSt2fY4bK0nMvmN29QU/libLIq+dt5HnnmNpdUpU5/HdC8qYoQ1izlrQrUVw1c7Mrn/Zt3tXRR+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hnb3+m5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hnb3+m5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20044C32781;
	Wed,  7 Aug 2024 20:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723062905;
	bh=7d0/HkAEE2VvRW1z+wsqsOSxbVDYqzBMjxF1Na4RWZs=;
	h=Date:To:From:Subject:From;
	b=Hnb3+m5fF3t9DSciuf1vk/gYiXQTHqJCnwZSqNf7nu8YeaDqhlS6sWUijAZGO6ojO
	 Wjg3BNavwvQAo75GEvlYeCD3mj0K+fRA1VbMGPsdKY4u+a1ffFIHBeUVMuHVcWDc+o
	 c8p6pnaL/WfT9NNM5TrIV8vBuwlwNbuLPDEhjSRk=
Date: Wed, 07 Aug 2024 13:35:04 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,JonasZhou@zhaoxin.com,dennis@kernel.org,cl@linux.com,912460177@qq.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-remove-pcpu_alloc_size.patch added to mm-unstable branch
Message-Id: <20240807203505.20044C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu: remove pcpu_alloc_size()
has been added to the -mm mm-unstable branch.  Its filename is
     percpu-remove-pcpu_alloc_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu-remove-pcpu_alloc_size.patch

This patch will later appear in the mm-unstable branch at
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
From: Jianhui Zhou <912460177@qq.com>
Subject: percpu: remove pcpu_alloc_size()
Date: Wed, 7 Aug 2024 15:44:48 +0800

pcpu_alloc_size() was added in 7ac5c53e0073 "mm/percpu.c: introduce
pcpu_alloc_size()", which is used to get the allocated memory size in bpf.
However, pcpu_alloc_size() is no longer used in "bpf: Use c->unit_size to
select target cache during free" because its actuall allocated memory size
may change at runtime due to its slab merging mechanism.  Therefore,
pcpu_alloc_size() can be removed.

Link: https://lkml.kernel.org/r/tencent_AD5C50E8D78C07A3CE539BD5F6BF39706507@qq.com
Signed-off-by: Jianhui Zhou <912460177@qq.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: JonasZhou <JonasZhou@zhaoxin.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu.h |    1 -
 mm/percpu.c            |   31 -------------------------------
 2 files changed, 32 deletions(-)

--- a/include/linux/percpu.h~percpu-remove-pcpu_alloc_size
+++ a/include/linux/percpu.h
@@ -135,7 +135,6 @@ extern void __init setup_per_cpu_areas(v
 
 extern void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 				   gfp_t gfp) __alloc_size(1);
-extern size_t pcpu_alloc_size(void __percpu *__pdata);
 
 #define __alloc_percpu_gfp(_size, _align, _gfp)				\
 	alloc_hooks(pcpu_alloc_noprof(_size, _align, false, _gfp))
--- a/mm/percpu.c~percpu-remove-pcpu_alloc_size
+++ a/mm/percpu.c
@@ -2217,37 +2217,6 @@ static void pcpu_balance_workfn(struct w
 }
 
 /**
- * pcpu_alloc_size - the size of the dynamic percpu area
- * @ptr: pointer to the dynamic percpu area
- *
- * Returns the size of the @ptr allocation.  This is undefined for statically
- * defined percpu variables as there is no corresponding chunk->bound_map.
- *
- * RETURNS:
- * The size of the dynamic percpu area.
- *
- * CONTEXT:
- * Can be called from atomic context.
- */
-size_t pcpu_alloc_size(void __percpu *ptr)
-{
-	struct pcpu_chunk *chunk;
-	unsigned long bit_off, end;
-	void *addr;
-
-	if (!ptr)
-		return 0;
-
-	addr = __pcpu_ptr_to_addr(ptr);
-	/* No pcpu_lock here: ptr has not been freed, so chunk is still alive */
-	chunk = pcpu_chunk_addr_search(addr);
-	bit_off = (addr - chunk->base_addr) / PCPU_MIN_ALLOC_SIZE;
-	end = find_next_bit(chunk->bound_map, pcpu_chunk_map_bits(chunk),
-			    bit_off + 1);
-	return (end - bit_off) * PCPU_MIN_ALLOC_SIZE;
-}
-
-/**
  * free_percpu - free percpu area
  * @ptr: pointer to area to free
  *
_

Patches currently in -mm which might be from 912460177@qq.com are

percpu-remove-pcpu_alloc_size.patch

