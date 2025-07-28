Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3652165E2
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 22:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753742487; cv=none; b=cbcmpYneI1BBrERybkcki6V5SWPZ8IRo1cEtFL+sqP7+3Y9nxoVHmqmUZ2Z2ecGkf2ZAzIlISwoiZ4slxzoOX7rQ8KHHC2P1lzZ2VUrgcZ4YBlXyzt6eAK+G7aHNA2ztxJYQtU7EeGt+NocHvGFVfk0MwNSpmfSpRaX5vUaVj5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753742487; c=relaxed/simple;
	bh=MhkCl9+sP9n5Ki0CJBm5n8RSSvCQtq4LvpX11/OEtCE=;
	h=Date:To:From:Subject:Message-Id; b=l0/YF5WONo7s1TqZz+4QxZT/87GbvbIuAn9EyIvItDoedXvt8m6yq9CGvdFgLbdCciwtVROfsU8cf3QRNV7tFrMzYAHArktyFT7UXhvUSEZe2i/sfWKFqnwi+BPOVMU4FwyIBIJzEYFsZoUK/lu42r2f4UVvZRE25RmVrlLDa30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=E8pnaqh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="E8pnaqh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CABC4CEE7;
	Mon, 28 Jul 2025 22:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753742486;
	bh=MhkCl9+sP9n5Ki0CJBm5n8RSSvCQtq4LvpX11/OEtCE=;
	h=Date:To:From:Subject:From;
	b=E8pnaqh1yaS+F8MxPXsLKVceC2Nz4j7je07r7URpI6of5Z5m1gtLmNFYxqNzetc2g
	 +XIBm5nP0nich7rciQXxrcsGslnRjdAvo+gs2yQ/fk11I+3NmOx6BdSYa5Szkhi6yY
	 ThTLgvbRANT6yuUrg8dAOC/nzoJGMr/pHS4ydCc4=
Date: Mon, 28 Jul 2025 15:41:25 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + execmem-drop-unused-execmem_update_copy.patch added to mm-unstable branch
Message-Id: <20250728224126.72CABC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: execmem: drop unused execmem_update_copy()
has been added to the -mm mm-unstable branch.  Its filename is
     execmem-drop-unused-execmem_update_copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/execmem-drop-unused-execmem_update_copy.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: execmem: drop unused execmem_update_copy()
Date: Sun, 13 Jul 2025 10:17:23 +0300

Patch series "x86: enable EXECMEM_ROX_CACHE for ftrace and kprobes", v3.

These patches enable use of EXECMEM_ROX_CACHE for ftrace and kprobes
allocations on x86.

They also include some ground work in execmem.

Since the execmem model for caching large ROX pages changed from the
initial assumption that the memory that is allocated from ROX cache is
always ROX to the current state where memory can be temporarily made RW
and then restored to ROX, we can stop using text poking to update it. 
This also saves the hassle of trying lock text_mutex in
execmem_cache_free() when kprobes already hold that mutex.


This patch (of 8):

The execmem_update_copy() that used text poking was required when memory
allocated from ROX cache was always read-only.  Since now its permissions
can be switched to read-write there is no need in a function that updates
memory with text poking.

Remove it.

Link: https://lkml.kernel.org/r/20250713071730.4117334-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20250713071730.4117334-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/execmem.h |   13 -------------
 mm/execmem.c            |    5 -----
 2 files changed, 18 deletions(-)

--- a/include/linux/execmem.h~execmem-drop-unused-execmem_update_copy
+++ a/include/linux/execmem.h
@@ -186,19 +186,6 @@ struct vm_struct *execmem_vmap(size_t si
 #endif
 
 /**
- * execmem_update_copy - copy an update to executable memory
- * @dst:  destination address to update
- * @src:  source address containing the data
- * @size: how many bytes of memory shold be copied
- *
- * Copy @size bytes from @src to @dst using text poking if the memory at
- * @dst is read-only.
- *
- * Return: a pointer to @dst or NULL on error
- */
-void *execmem_update_copy(void *dst, const void *src, size_t size);
-
-/**
  * execmem_is_rox - check if execmem is read-only
  * @type - the execmem type to check
  *
--- a/mm/execmem.c~execmem-drop-unused-execmem_update_copy
+++ a/mm/execmem.c
@@ -399,11 +399,6 @@ void execmem_free(void *ptr)
 		vfree(ptr);
 }
 
-void *execmem_update_copy(void *dst, const void *src, size_t size)
-{
-	return text_poke_copy(dst, src, size);
-}
-
 bool execmem_is_rox(enum execmem_type type)
 {
 	return !!(execmem_info->ranges[type].flags & EXECMEM_ROX_CACHE);
_

Patches currently in -mm which might be from rppt@kernel.org are

execmem-drop-unused-execmem_update_copy.patch
execmem-introduce-execmem_alloc_rw.patch
execmem-rework-execmem_cache_free.patch
execmem-move-execmem_force_rw-and-execmem_restore_rox-before-use.patch
execmem-add-fallback-for-failures-in-vmallocvm_allow_huge_vmap.patch
execmem-drop-writable-parameter-from-execmem_fill_trapping_insns.patch
x86-kprobes-enable-execmem_rox_cache-for-kprobes-allocations.patch
x86-ftrace-enable-execmem_rox_cache-for-ftrace-allocations.patch
kho-add-test-for-kexec-handover.patch

