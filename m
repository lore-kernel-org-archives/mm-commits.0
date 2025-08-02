Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66211E7C1C
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160868; cv=none; b=YqqlzmaE2xLY3im5YLvAD9l5MSaZ/SdQYvgV+rl9R5XZwAywg87LE8UwaXMi+h1ihFwuvQN8UdmYZ6K+aHhtx9Iu1lMp69QPNZ/FxVQvPM8gxuhd1/63tBtDsg51L/YpstlQsUKjPi2eOZoOAtb2WSmAM6/rSh4SBbmPgRPQC1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160868; c=relaxed/simple;
	bh=oQUxKuakzULfPp0ONEOOkumahTA69LjUYE56O/Zt0Gs=;
	h=Date:To:From:Subject:Message-Id; b=tpCFj94O9aiTFTsC9r4BXpNym7g5k/9X1dQ1qcsSXlJJF7sglH1w5Kc74k1odAOdGXqSEoFhRb0nkOYAlh6iSSIVzDGLMtMYD8Gl0UcNCKLM38Zu8yC9gPpwkLmixJ2Acn+3WOG3OIiTTLgTp+T0Up/JrVrryy3mUmSFQc4JU38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oOA2H8pz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oOA2H8pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B87C4CEEF;
	Sat,  2 Aug 2025 18:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160868;
	bh=oQUxKuakzULfPp0ONEOOkumahTA69LjUYE56O/Zt0Gs=;
	h=Date:To:From:Subject:From;
	b=oOA2H8pzOVfkgDoJtRZb5+CH4QCnBi+aam3tiNT7D68y4XJ4ipM9/o0X73SOP7+KC
	 YcXUniP/QS4GfWRxMcwxj6r9r9G/5pu74XA5wUVdWV7A0zTEFM0h8CXIbodKEBkJ8D
	 7T90hWesD42mVOTAAkIovNcOylYK3+yu8XBVQw8Q=
Date: Sat, 02 Aug 2025 11:54:26 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] execmem-drop-unused-execmem_update_copy.patch removed from -mm tree
Message-Id: <20250802185428.47B87C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: execmem: drop unused execmem_update_copy()
has been removed from the -mm tree.  Its filename was
     execmem-drop-unused-execmem_update_copy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kho-add-test-for-kexec-handover.patch
kho-add-test-for-kexec-handover-fix.patch

