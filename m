Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C21E23FC6B
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160874; cv=none; b=t5+u62vP6kvgcldoWzuE+vfLhmptU1LPGVenHwn0LIjzcCH0C3TbRtLLlYeCS/BBbZLiBDpVz+hGo5R/ST0nTsDNp+UD2q8E3vNCTwBewq5q3SoC/2FMUg3ScMd+VeaDE66bN4VbXM/l1mfZxJI+TIVyehhQ1JPQLDv7CWN6Frg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160874; c=relaxed/simple;
	bh=+Wtgl2AJd5DT0g01dzSxlZKhTGk6r1gXY7C2Qp0GnP4=;
	h=Date:To:From:Subject:Message-Id; b=YL8jtoqkwGAgZAM1x0uWC2BA/x0Rq6F/av+jdEuWTFwngrWmhnAYI7R4GIZ8nLJfchCGHjn9PzLamNETa6kmUbyUt3NAEQLWghyocoXWAOjxyrCX1+HTmaACc/jD6QT2cXUCedhcpiqGg5d9C8WeS6JuV2Lge/ypVlD+L5FpQ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bmXZxICw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bmXZxICw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21ED9C4CEEF;
	Sat,  2 Aug 2025 18:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160874;
	bh=+Wtgl2AJd5DT0g01dzSxlZKhTGk6r1gXY7C2Qp0GnP4=;
	h=Date:To:From:Subject:From;
	b=bmXZxICwiQbXRvHSIjXA++m66e89tUXYiTq2THXFmLVwLLQAoWUXXQsi2NG81+lwU
	 FExtMbVcIoesB1lB1E/Kt3/x81YYcYd2r6mta6ZAwm7cqyTBXa79M8ozUe6JaiIrEF
	 IbHIrhk/1BCsnSwUYspus9crG2O2qdg+FSpKYyYw=
Date: Sat, 02 Aug 2025 11:54:33 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] execmem-drop-writable-parameter-from-execmem_fill_trapping_insns.patch removed from -mm tree
Message-Id: <20250802185434.21ED9C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: execmem: drop writable parameter from execmem_fill_trapping_insns()
has been removed from the -mm tree.  Its filename was
     execmem-drop-writable-parameter-from-execmem_fill_trapping_insns.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: execmem: drop writable parameter from execmem_fill_trapping_insns()
Date: Sun, 13 Jul 2025 10:17:28 +0300

After update of execmem_cache_free() that made memory writable before
updating it, there is no need to update read only memory, so the writable
parameter to execmem_fill_trapping_insns() is not needed.  Drop it.

Link: https://lkml.kernel.org/r/20250713071730.4117334-7-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c      |    8 ++------
 include/linux/execmem.h |    3 +--
 mm/execmem.c            |    4 ++--
 3 files changed, 5 insertions(+), 10 deletions(-)

--- a/arch/x86/mm/init.c~execmem-drop-writable-parameter-from-execmem_fill_trapping_insns
+++ a/arch/x86/mm/init.c
@@ -1063,13 +1063,9 @@ unsigned long arch_max_swapfile_size(voi
 static struct execmem_info execmem_info __ro_after_init;
 
 #ifdef CONFIG_ARCH_HAS_EXECMEM_ROX
-void execmem_fill_trapping_insns(void *ptr, size_t size, bool writeable)
+void execmem_fill_trapping_insns(void *ptr, size_t size)
 {
-	/* fill memory with INT3 instructions */
-	if (writeable)
-		memset(ptr, INT3_INSN_OPCODE, size);
-	else
-		text_poke_set(ptr, INT3_INSN_OPCODE, size);
+	memset(ptr, INT3_INSN_OPCODE, size);
 }
 #endif
 
--- a/include/linux/execmem.h~execmem-drop-writable-parameter-from-execmem_fill_trapping_insns
+++ a/include/linux/execmem.h
@@ -60,12 +60,11 @@ enum execmem_range_flags {
  *				 will trap
  * @ptr:	pointer to memory to fill
  * @size:	size of the range to fill
- * @writable:	is the memory poited by @ptr is writable or ROX
  *
  * A hook for architecures to fill execmem ranges with invalid instructions.
  * Architectures that use EXECMEM_ROX_CACHE must implement this.
  */
-void execmem_fill_trapping_insns(void *ptr, size_t size, bool writable);
+void execmem_fill_trapping_insns(void *ptr, size_t size);
 
 /**
  * execmem_restore_rox - restore read-only-execute permissions
--- a/mm/execmem.c~execmem-drop-writable-parameter-from-execmem_fill_trapping_insns
+++ a/mm/execmem.c
@@ -304,7 +304,7 @@ static int execmem_cache_populate(struct
 		goto err_free_mem;
 
 	/* fill memory with instructions that will trap */
-	execmem_fill_trapping_insns(p, alloc_size, /* writable = */ true);
+	execmem_fill_trapping_insns(p, alloc_size);
 
 	err = set_memory_rox((unsigned long)p, vm->nr_pages);
 	if (err)
@@ -363,7 +363,7 @@ static int __execmem_cache_free(struct m
 	if (err)
 		return err;
 
-	execmem_fill_trapping_insns(ptr, size, /* writable = */ true);
+	execmem_fill_trapping_insns(ptr, size);
 	execmem_restore_rox(ptr, size);
 
 	err = execmem_cache_add_locked(ptr, size, gfp_mask);
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-add-test-for-kexec-handover.patch
kho-add-test-for-kexec-handover-fix.patch

