Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4F44AF667
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 22:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788388645; cv=none; b=Cfc8Dy8+HMjbdbGdWX2OYkI/bZA/YpAlibG8wEbu0KdCtaxCLd7/pUDX4W3SRe0iDTvAdDjPvEaG9rAQSjma12T6cDWBYJVN6vJJm4/fOKa5gzuh0ObZKbHkAf9s3te71YKxuCnIU8UZwbgcG6+kI7bytNoq7BHkQcF84u6+F0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788388645; c=relaxed/simple;
	bh=ptQiJ3xBJ1OgvN9eMF8BC9kBeusf2KJkJ8OdQRRN2VM=;
	h=Date:To:From:Subject:Message-Id; b=bFaudPdzj2X/15dsQt5LHrxVl3eJeYTCv1ApCds4IVBWO3Tz496jTZpcvz9Q1G3yd0u4PnOCwOIY24+N1i/1qCY2WLQ5yi0O+CDBYH43d0DrPlRE0PySgshJCNRdFOUL/jFOJL9rZn8F7QT3abeRWC4etiYUZi4XCpuiDzjLrqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdP49C0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdP49C0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2937E1F00A3D;
	Wed,  2 Sep 2026 22:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788388637;
	bh=uXh6gQBz1zR9CZliVxjshLUuUyNpEMOTp+WqbujcUkU=;
	h=Date:To:From:Subject;
	b=gdP49C0mkYQF5bt0VbWC5GjoFDWPjrqQGXfGtvAbym3PLxStMmuovW/nj18gIlmHw
	 Zzc/FfXrgc/54zeoMAjsxnJipkATXRHJQ67q8/SgypJmXCdsmegEnRMC1zPrsEd8JI
	 K5gAE2OW8s4kBF9JyXi4FU/LLiEGjq4DOKa58g+A=
Date: Wed, 02 Sep 2026 15:37:16 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,zhaomeijing@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-trace-name-protection-key-encoding-bits.patch added to mm-new branch
Message-Id: <20260902223717.2937E1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: trace: name protection key encoding bits
has been added to the -mm mm-new branch.  Its filename is
     mm-trace-name-protection-key-encoding-bits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-trace-name-protection-key-encoding-bits.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Meijing Zhao <zhaomeijing@lixiang.com>
Subject: mm: trace: name protection key encoding bits
Date: Wed, 2 Sep 2026 14:45:10 +0800

Protection keys are encoded in architecture-specific HIGH_ARCH_* VMA flag
bits.  show_vma_flags(), which is used by VMA tracepoints and %pGv, does
not name those bits, leaving them as raw hexadecimal values.

Name the protection-key encoding bits pkey_bit0 through pkey_bit4 under
CONFIG_ARCH_HAS_PKEYS.  The names make clear that these are bits of one
protection-key value rather than independent protection keys.  For
example, protection key 3 is represented as:

  pkey_bit0|pkey_bit1

Honor CONFIG_ARCH_PKEY_BITS when exposing bit 3 and bit 4 so only bits
provided by the architecture are included.

Link: https://lore.kernel.org/1871da32001243b37147bac5af02d2f2ec64304e.1788330432.git.zhaomeijing@lixiang.com
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmflags.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/include/trace/events/mmflags.h~mm-trace-name-protection-key-encoding-bits
+++ a/include/trace/events/mmflags.h
@@ -202,6 +202,24 @@ IF_HAVE_PG_ARCH_3(arch_3)
 # define IF_HAVE_VM_DROPPABLE(flag, name)
 #endif
 
+#ifdef CONFIG_ARCH_HAS_PKEYS
+# define IF_HAVE_VM_PKEY(flag, name) {flag, name},
+#if CONFIG_ARCH_PKEY_BITS > 3
+# define IF_HAVE_VM_PKEY3(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_PKEY3(flag, name)
+#endif
+#if CONFIG_ARCH_PKEY_BITS > 4
+# define IF_HAVE_VM_PKEY4(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_PKEY4(flag, name)
+#endif
+#else
+# define IF_HAVE_VM_PKEY(flag, name)
+# define IF_HAVE_VM_PKEY3(flag, name)
+# define IF_HAVE_VM_PKEY4(flag, name)
+#endif
+
 #ifdef CONFIG_ARM64_MTE
 # define IF_HAVE_VM_MTE(flag, name) {flag, name},
 #else
@@ -250,6 +268,11 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"soft
 	{VM_HUGEPAGE,			"hugepage"	},		\
 	{VM_NOHUGEPAGE,			"nohugepage"	},		\
 IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,	"droppable"	)		\
+IF_HAVE_VM_PKEY(VM_PKEY_BIT0,		"pkey_bit0")		\
+IF_HAVE_VM_PKEY(VM_PKEY_BIT1,		"pkey_bit1")		\
+IF_HAVE_VM_PKEY(VM_PKEY_BIT2,		"pkey_bit2")		\
+IF_HAVE_VM_PKEY3(VM_PKEY_BIT3,		"pkey_bit3")		\
+IF_HAVE_VM_PKEY4(VM_PKEY_BIT4,		"pkey_bit4")		\
 IF_HAVE_VM_MTE(VM_MTE,			"mte")			\
 IF_HAVE_VM_MTE(VM_MTE_ALLOWED,		"mte_allowed")		\
 IF_HAVE_VM_SHADOW_STACK(VM_SHADOW_STACK, "shadow_stack")	\
_

Patches currently in -mm which might be from zhaomeijing@lixiang.com are

mm-trace-decode-arm64-and-sparc64-vm_arch_1-flags.patch
mm-trace-decode-mte-and-shadow-stack-vma-flags.patch
mm-trace-name-protection-key-encoding-bits.patch

