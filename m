Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FD91A8412
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160877; cv=none; b=bsVUMMENNVFW7a32P7pQOdZLUusJ0+m7hPvwOSRVsOtOWJz+FI67z+zjU5jJdw9aFNQkwZB0B6lxQ2sA30yeUV2RcXwxnACDtkvW/e61i+JxhbDT1CsW1okrxSpDYCLRuIJU3bCV4YIlQmXpbC/iEvv9GhmILJEJsPTSmokqqUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160877; c=relaxed/simple;
	bh=ErkIKKbd1zMulwOywYDBM17ZHIWUMclxSS+w7/uG+x4=;
	h=Date:To:From:Subject:Message-Id; b=DZAs8kZTBThuRN2q9kETtOGAn6gJZyXwZeOEGfXndGX1PDnvFG1DDpHw8tWNj7sIXdT9nsiYFHwrA6Re21hdSl7oR7k+J5SACeI2pyy0Wo9wTxwia/ImYiMYzIliqB5ACKpFjgFAYDU1k4EH3Zk2q0Ik1CTMN0X2dqhy9mpamNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=apiHBu4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="apiHBu4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F90C4CEEF;
	Sat,  2 Aug 2025 18:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160876;
	bh=ErkIKKbd1zMulwOywYDBM17ZHIWUMclxSS+w7/uG+x4=;
	h=Date:To:From:Subject:From;
	b=apiHBu4u5Ob7ru6RAglbSwF0WxWGPfvj/mnGno7EVT0di4W9/wuWlV+lmO1E35QVw
	 g3f3Eevs7F9F7DTsiANKk7l16VLyRpSsMcxCMdSqKR85x25MZ+GeFxR0iAETUGUDTj
	 xHOGcjmGEEi35PfUiQ++m/eKlus6NiLuW6HTZt84=
Date: Sat, 02 Aug 2025 11:54:35 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,petr.pavlu@suse.com,peterz@infradead.org,mhiramat@kernel.org,da.gomez@samsung.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-ftrace-enable-execmem_rox_cache-for-ftrace-allocations.patch removed from -mm tree
Message-Id: <20250802185436.76F90C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/ftrace: enable EXECMEM_ROX_CACHE for ftrace allocations
has been removed from the -mm tree.  Its filename was
     x86-ftrace-enable-execmem_rox_cache-for-ftrace-allocations.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

kho-add-test-for-kexec-handover.patch
kho-add-test-for-kexec-handover-fix.patch

