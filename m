Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCBD1E7C1C
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160873; cv=none; b=IGAh/on2W5Iwg5oWDNbRfQ115dTrA2+YqKmVQ3L5cvO3MOe0FnrJ5wgDbRw45xd+hG5lKbIjws9hppjLecOSoDLK7k2ArF2iaE/eNqIxmLh3MlsE6oYepXv3BcEEQh3BIXsnDXmTPyJfCkYhS1zAfthMgp6JH1Vbtkv+ORW7wBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160873; c=relaxed/simple;
	bh=O2zRPLCSPrMtuaqhSpBf5izikkqZlIrQGXOB4AZRfA0=;
	h=Date:To:From:Subject:Message-Id; b=BTCTnHtlGHRFI5z/0/h8s9TbamPwplJ0eWZrWQalrISBwk4D7O1ejfyh9vo/sfzTnp3n9r41+hLnX1hVRBUrhbG58hAYgpCYHBtTSLxeU69k6HnCi6EWf6cQAv8z6Wpkbf3q+lAswVykN23T3Uo8yR1KOPEfy2lRdSG9LX4+Lyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KBC9EaMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KBC9EaMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15A7C4CEEF;
	Sat,  2 Aug 2025 18:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160873;
	bh=O2zRPLCSPrMtuaqhSpBf5izikkqZlIrQGXOB4AZRfA0=;
	h=Date:To:From:Subject:From;
	b=KBC9EaMdgIQgMgx5R/QG3HUwSeB19iRiUgyua/DXutl0XwKaE/RRb2KdxYBvcncBY
	 oLz+dbC6YhFz40aq7BpeJJ0lYvjJMASLuCBdNaQlP5FqfKzgojxugNWCs+gOnD0zXS
	 X2w2MCZTXMvpu/QPtXUhndQ6MCPTAaDaqRiOHIjU=
Date: Sat, 02 Aug 2025 11:54:32 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] execmem-add-fallback-for-failures-in-vmallocvm_allow_huge_vmap.patch removed from -mm tree
Message-Id: <20250802185432.F15A7C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: execmem: add fallback for failures in vmalloc(VM_ALLOW_HUGE_VMAP)
has been removed from the -mm tree.  Its filename was
     execmem-add-fallback-for-failures-in-vmallocvm_allow_huge_vmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: execmem: add fallback for failures in vmalloc(VM_ALLOW_HUGE_VMAP)
Date: Sun, 13 Jul 2025 10:17:27 +0300

When execmem populates ROX cache it uses vmalloc(VM_ALLOW_HUGE_VMAP). 
Although vmalloc falls back to allocating base pages if high order
allocation fails, it may happen that it still cannot allocate enough
memory.

Right now ROX cache is only used by modules and in majority of cases the
allocations happen at boot time when there's plenty of free memory, but
upcoming enabling ROX cache for ftrace and kprobes would mean that execmem
allocations can happen when the system is under memory pressure and a
failure to allocate large page worth of memory becomes more likely.

Fallback to regular vmalloc() if vmalloc(VM_ALLOW_HUGE_VMAP) fails.

Link: https://lkml.kernel.org/r/20250713071730.4117334-6-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/execmem.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/execmem.c~execmem-add-fallback-for-failures-in-vmallocvm_allow_huge_vmap
+++ a/mm/execmem.c
@@ -291,6 +291,11 @@ static int execmem_cache_populate(struct
 
 	alloc_size = round_up(size, PMD_SIZE);
 	p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
+	if (!p) {
+		alloc_size = size;
+		p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
+	}
+
 	if (!p)
 		return err;
 
@@ -462,7 +467,7 @@ void *execmem_alloc(enum execmem_type ty
 	bool use_cache = range->flags & EXECMEM_ROX_CACHE;
 	vm_flags_t vm_flags = VM_FLUSH_RESET_PERMS;
 	pgprot_t pgprot = range->pgprot;
-	void *p;
+	void *p = NULL;
 
 	size = PAGE_ALIGN(size);
 
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-add-test-for-kexec-handover.patch
kho-add-test-for-kexec-handover-fix.patch

