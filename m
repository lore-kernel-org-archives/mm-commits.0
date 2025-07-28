Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014DA2327A3
	for <mm-commits@vger.kernel.org>; Mon, 28 Jul 2025 22:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753742496; cv=none; b=jIB+YyEhOcBOkJLBgDsGriytOjKAic5lRXBS/awvWtdumyWTZWKvfLEO8OKZgXL/qog3ESry4KFoX2CWZMQEin5m0ZdiMpQq/fVd4VOIxYbh6zjwkeyQ1wFPXSL9Dcox5zjsACm/B9pYtTwt8o5+gpMvmAL/++Rp3rpf3yPeUHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753742496; c=relaxed/simple;
	bh=ivkoWus3BP0oqUpLaliqpNNQ5jF+yGdpaNMjvNrFNo4=;
	h=Date:To:From:Subject:Message-Id; b=NuejvEKW7DzqfMDvUr/NdwMbvDkCospAzpIJdLHIVjCJEvfYXuoCNLjW3MXkd9UUN/W8ky3eERjnHAo304mFrcAQrQVm+VGfroIgxBp7XEGf3Sx9hS6ahDexiCyLK0UkitiD5Q7ptnKzYfJwibCP53LL1IL5VmITbHuX3kC591k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kblpjrgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kblpjrgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87B1C4CEE7;
	Mon, 28 Jul 2025 22:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753742495;
	bh=ivkoWus3BP0oqUpLaliqpNNQ5jF+yGdpaNMjvNrFNo4=;
	h=Date:To:From:Subject:From;
	b=kblpjrgNg7hDegp1Eyf5t4+/mdhdF6e4jUenDNsdybdRSPhKI3ebh010CkEfohGCb
	 +tSw44UTybghfr+VKZV+lsCJz5UZbd8W0+kZwdO5CHuRKhpNvun4p/BpWC+nw9IEW2
	 smQiYX+iJ7Xkm01TF1hxnEIM/c8LW/yiLrx0/9dY=
Date: Mon, 28 Jul 2025 15:41:35 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-ftrace-enable-execmem_rox_cache-for-ftrace-allocations.patch added to mm-unstable branch
Message-Id: <20250728224135.C87B1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/ftrace: enable EXECMEM_ROX_CACHE for ftrace allocations
has been added to the -mm mm-unstable branch.  Its filename is
     x86-ftrace-enable-execmem_rox_cache-for-ftrace-allocations.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-ftrace-enable-execmem_rox_cache-for-ftrace-allocations.patch

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
Subject: x86/ftrace: enable EXECMEM_ROX_CACHE for ftrace allocations
Date: Sun, 13 Jul 2025 10:17:30 +0300

For the most part ftrace uses text poking and can handle ROX memory.  The
only place that requires writable memory is create_trampoline() that
updates the allocated memory and in the end makes it ROX.

Use execmem_alloc_rw() in x86::ftrace::alloc_tramp() and enable ROX cache
for EXECMEM_FTRACE when configuration and CPU features allow that.

Link: https://lkml.kernel.org/r/20250713071730.4117334-9-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/ftrace.c |    2 +-
 arch/x86/mm/init.c       |    9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/ftrace.c~x86-ftrace-enable-execmem_rox_cache-for-ftrace-allocations
+++ a/arch/x86/kernel/ftrace.c
@@ -263,7 +263,7 @@ void arch_ftrace_update_code(int command
 
 static inline void *alloc_tramp(unsigned long size)
 {
-	return execmem_alloc(EXECMEM_FTRACE, size);
+	return execmem_alloc_rw(EXECMEM_FTRACE, size);
 }
 static inline void tramp_free(void *tramp)
 {
--- a/arch/x86/mm/init.c~x86-ftrace-enable-execmem_rox_cache-for-ftrace-allocations
+++ a/arch/x86/mm/init.c
@@ -1105,7 +1105,14 @@ struct execmem_info __init *execmem_arch
 				.pgprot	= PAGE_KERNEL_ROX,
 				.alignment = MODULE_ALIGN,
 			},
-			[EXECMEM_FTRACE ... EXECMEM_BPF] = {
+			[EXECMEM_FTRACE] = {
+				.flags	= flags,
+				.start	= start,
+				.end	= MODULES_END,
+				.pgprot	= pgprot,
+				.alignment = MODULE_ALIGN,
+			},
+			[EXECMEM_BPF] = {
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

