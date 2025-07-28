Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40082165E2
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 22:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753742495; cv=none; b=sl8vnq+SU/8VwuQAOn6JOoPHAh1czFWbVUGMfSgpbNinpPgHujTbw1VfL/ggZhlm2T4niMJaq8b3gD8bVEkaIqbH6FBAUOe1f9Dz7xX88oYRh4JkKPm33coVm0n7JL91dRDFudwz2ON13Rd0/9zAsZlDhvSr6DGCI0ozyn3Ru8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753742495; c=relaxed/simple;
	bh=xuCpi6r4TEeJRbzmeX1mvlD799mdY87cefK0cVQYWXE=;
	h=Date:To:From:Subject:Message-Id; b=cf3K4ifj2Q4h//FzrG46yXCgrW09Coq9gn4W3CN9OzDMcJ9w05Z2ftTpinedDvHD2ogGtDFAscylIXEzhDzBOdi5v0juqHmkiNxMN5I90pl0Qid78GZjYOSS/tsfOhb/+Xu24MAORkL5XPTc10cbMO8pXrNVWAYyseKyF4/eqcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n1OE5ydF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n1OE5ydF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC3CC4CEE7;
	Mon, 28 Jul 2025 22:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753742494;
	bh=xuCpi6r4TEeJRbzmeX1mvlD799mdY87cefK0cVQYWXE=;
	h=Date:To:From:Subject:From;
	b=n1OE5ydF+tTrzQAnOZZJpc3zfuNJnx1DmHTA+elV9i5bJezgq8qbTdt/Fn7TJ98R7
	 TBUDrSoj619Qu4SUINNylpMXMwXpsRVqpjDWKy4hyNschkeDZz/841MzsEbPgd/0sN
	 CvtnwKbT+QKDWzLCxOU9PiQc9OILALvnakGbXkIs=
Date: Mon, 28 Jul 2025 15:41:33 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kprobes-enable-execmem_rox_cache-for-kprobes-allocations.patch added to mm-unstable branch
Message-Id: <20250728224134.6CC3CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/kprobes: enable EXECMEM_ROX_CACHE for kprobes allocations
has been added to the -mm mm-unstable branch.  Its filename is
     x86-kprobes-enable-execmem_rox_cache-for-kprobes-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kprobes-enable-execmem_rox_cache-for-kprobes-allocations.patch

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
Subject: x86/kprobes: enable EXECMEM_ROX_CACHE for kprobes allocations
Date: Sun, 13 Jul 2025 10:17:29 +0300

x86::alloc_insn_page() always allocates ROX memory.

Instead of overriding this method, add EXECMEM_KPROBES entry in
execmem_info with pgprot set to PAGE_KERNEL_ROX and use ROX cache when
configuration and CPU features allow it.

Link: https://lkml.kernel.org/r/20250713071730.4117334-8-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kprobes/core.c |   18 ------------------
 arch/x86/mm/init.c             |    9 ++++++++-
 2 files changed, 8 insertions(+), 19 deletions(-)

--- a/arch/x86/kernel/kprobes/core.c~x86-kprobes-enable-execmem_rox_cache-for-kprobes-allocations
+++ a/arch/x86/kernel/kprobes/core.c
@@ -481,24 +481,6 @@ static int prepare_singlestep(kprobe_opc
 	return len;
 }
 
-/* Make page to RO mode when allocate it */
-void *alloc_insn_page(void)
-{
-	void *page;
-
-	page = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
-	if (!page)
-		return NULL;
-
-	/*
-	 * TODO: Once additional kernel code protection mechanisms are set, ensure
-	 * that the page was not maliciously altered and it is still zeroed.
-	 */
-	set_memory_rox((unsigned long)page, 1);
-
-	return page;
-}
-
 /* Kprobe x86 instruction emulation - only regs->ip or IF flag modifiers */
 
 static void kprobe_emulate_ifmodifiers(struct kprobe *p, struct pt_regs *regs)
--- a/arch/x86/mm/init.c~x86-kprobes-enable-execmem_rox_cache-for-kprobes-allocations
+++ a/arch/x86/mm/init.c
@@ -1098,7 +1098,14 @@ struct execmem_info __init *execmem_arch
 				.pgprot	= pgprot,
 				.alignment = MODULE_ALIGN,
 			},
-			[EXECMEM_KPROBES ... EXECMEM_BPF] = {
+			[EXECMEM_KPROBES] = {
+				.flags	= flags,
+				.start	= start,
+				.end	= MODULES_END,
+				.pgprot	= PAGE_KERNEL_ROX,
+				.alignment = MODULE_ALIGN,
+			},
+			[EXECMEM_FTRACE ... EXECMEM_BPF] = {
 				.flags	= EXECMEM_KASAN_SHADOW,
 				.start	= start,
 				.end	= MODULES_END,
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

