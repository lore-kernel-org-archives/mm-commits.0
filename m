Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2D32165E2
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 22:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753742493; cv=none; b=dglQHRAmwYKjjfYjTL1DzPclPCtRIEndy1iCf4d5Ns0wM62BWauVX3Vpiutkn2ABtjs9GV4KNttU8P6yJTVxZzxayp0EH7AEe8haLG28+8ThAEOdnEy/GG13OI30C1NRMo60tDv40dJ6Te3VHOmA4zTKzk8XtQU7RhlljwI9/+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753742493; c=relaxed/simple;
	bh=48Ma2MmhHEkbYSL1m/Vk4zgK603PaeSI8ibpE0xaCy4=;
	h=Date:To:From:Subject:Message-Id; b=N52rje34W5lgxgTW3PqrRjJgpmBPGy3qq/yZKw1U2t65I1G6mUJL6/8Ix0HUWA/Fj96WEY/1RXY2r9E0xSPKz/pAAJO5hng93T7jIcMybg7c6IZfo1V0pNEwN/5NGdhKXSiC6xdN1sOEAIiAB4AkF89WP3NJHU4+RM/CCnpfgMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WoJ3fsBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WoJ3fsBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065DDC4CEE7;
	Mon, 28 Jul 2025 22:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753742493;
	bh=48Ma2MmhHEkbYSL1m/Vk4zgK603PaeSI8ibpE0xaCy4=;
	h=Date:To:From:Subject:From;
	b=WoJ3fsBRjQ3HFPHPAK1+K3g11tiLLmHi43Uirl1lPdru6ZCeuMIhrmkrZgFTzaW/A
	 99oSWdEWZx3OGO1zIBM+EtBW4O0Nz2/rEPy/Py2INS8OhIgigyqBnvIfBBHCzBPjnO
	 BHPiIiwFqYSW7woC8pI8QMZUnsw+Gv0TAOzX/g+A=
Date: Mon, 28 Jul 2025 15:41:32 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + execmem-drop-writable-parameter-from-execmem_fill_trapping_insns.patch added to mm-unstable branch
Message-Id: <20250728224133.065DDC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: execmem: drop writable parameter from execmem_fill_trapping_insns()
has been added to the -mm mm-unstable branch.  Its filename is
     execmem-drop-writable-parameter-from-execmem_fill_trapping_insns.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/execmem-drop-writable-parameter-from-execmem_fill_trapping_insns.patch

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

execmem-drop-unused-execmem_update_copy.patch
execmem-introduce-execmem_alloc_rw.patch
execmem-rework-execmem_cache_free.patch
execmem-move-execmem_force_rw-and-execmem_restore_rox-before-use.patch
execmem-add-fallback-for-failures-in-vmallocvm_allow_huge_vmap.patch
execmem-drop-writable-parameter-from-execmem_fill_trapping_insns.patch
x86-kprobes-enable-execmem_rox_cache-for-kprobes-allocations.patch
x86-ftrace-enable-execmem_rox_cache-for-ftrace-allocations.patch
kho-add-test-for-kexec-handover.patch

