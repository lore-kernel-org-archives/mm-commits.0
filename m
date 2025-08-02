Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DD2255248
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160875; cv=none; b=kgCxknpO8cTNASKn1X4fGaLb0xAXSQYB3n0HcL5NA/RrSjMqv5sEpMIYHj6eds0sXjPoaYoxRiJfX89fK2dkfryQuK5Z8QXBXtRT/JUzKpMCWS0rNILJoS2jYH0hLJr9l/vRZovEkN8gUJ9JC4J/dPzfw4ygH6GLPW13KxVF0Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160875; c=relaxed/simple;
	bh=WV66Zcqfilwfy8iAbIMWAoBJmfihMjcu1RCMAZdbQh0=;
	h=Date:To:From:Subject:Message-Id; b=T/IF3aJWx5rljr6sVj4qpJ3t8Fz5rGpsz0ACo4U9ugT1txGeh+AwNswmARrhk0yhhVvhkKwStnecYeIsw2y+rbo8TiHT0a8CrqJ9zkIC57lHiRSLVPdaFZn1iPNNWl0zXAxtLl+O4pjpojAHA0+q2V38FdXAe90hzBFsHVrbMNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qicvxhWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qicvxhWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E435C4CEEF;
	Sat,  2 Aug 2025 18:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160875;
	bh=WV66Zcqfilwfy8iAbIMWAoBJmfihMjcu1RCMAZdbQh0=;
	h=Date:To:From:Subject:From;
	b=qicvxhWeXTpG4OPoSIgXymMmcI4wSgts66cUEVdIVC7D7w6syDFw8koUZbQbsGZ24
	 bOdBlDBoaGsofpmq7Zh8D8KKT7LRHa/xodlLsuH2A4GMH47pdO2orU25Cc/qCYNslP
	 Ys3jh/WR8OBKqcR/kmkR4uFlXjqWCrx6ochC18WY=
Date: Sat, 02 Aug 2025 11:54:34 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-kprobes-enable-execmem_rox_cache-for-kprobes-allocations.patch removed from -mm tree
Message-Id: <20250802185435.4E435C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/kprobes: enable EXECMEM_ROX_CACHE for kprobes allocations
has been removed from the -mm tree.  Its filename was
     x86-kprobes-enable-execmem_rox_cache-for-kprobes-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kho-add-test-for-kexec-handover.patch
kho-add-test-for-kexec-handover-fix.patch

