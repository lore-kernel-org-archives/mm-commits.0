Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E6B448B9A
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 22:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788388644; cv=none; b=SEMpnJ3X2OTv2JN2TdXiCPEY22pgnKnSpM8hyyPd7FuYGDOFx2cnNw2qTeyKBRQpcYxk3nrhRGn0wA5PUf9hpQcYybAKrXzcFo1zcenBprrJQlqGQ0Ys+7gwli0R+GiIiYWSUkw2OArSGhKyHEnyJbgM1j3TAGJajsnuFFpzA8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788388644; c=relaxed/simple;
	bh=PdYvm+PFI+uPS3nTijpMcyGwDZfi9314HTGDcuwGViY=;
	h=Date:To:From:Subject:Message-Id; b=DPV6y9ntxLkuvu9WmAV7kh+R0a4O5GWrBy23ZU78KauKmeT6/yY+fhJ4IdnTXWTX5hDqYx7uPLreq5IidE9aa5ungO9YtTHobnvnrYzacgFtBAhat+49RH0CcO943pLZlsXAjEa0Zsvf33KKyadX5NNKO7aFPjDtgmj151gy9KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OMMIeLtJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OMMIeLtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F6E1F00A3A;
	Wed,  2 Sep 2026 22:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788388635;
	bh=78Yz6A8tFcjMoIkp+MKWY6/6uX3kg1nrYKnV8BPOzSQ=;
	h=Date:To:From:Subject;
	b=OMMIeLtJVVBTJN5hNDFDCFL/15rBqcXZhKoE2VMe6lkfd7H1sWY+5LiCK6udmNCxr
	 v0OA3zBLR+rJ4O+ga4AiHaDySUfZnla5BIeeIQaU0mtqEyPnpkjm2y+JvqekHzJo57
	 OyM2FYlfPX4ljRAset/0VYHlE/nYV2FrYg7oFPF8=
Date: Wed, 02 Sep 2026 15:37:14 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,zhaomeijing@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-trace-decode-mte-and-shadow-stack-vma-flags.patch added to mm-new branch
Message-Id: <20260902223715.35F6E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: trace: decode MTE and shadow stack VMA flags
has been added to the -mm mm-new branch.  Its filename is
     mm-trace-decode-mte-and-shadow-stack-vma-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-trace-decode-mte-and-shadow-stack-vma-flags.patch

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
Subject: mm: trace: decode MTE and shadow stack VMA flags
Date: Wed, 2 Sep 2026 14:45:09 +0800

show_vma_flags(), which is used by VMA tracepoints and %pGv, leaves
architecture-specific HIGH_ARCH_* bits unnamed.  Arm64 MTE flags and user
shadow stack flags are therefore printed as raw hexadecimal values.

These bit positions are shared between architectures.  For example, bit 37
represents VM_MTE_ALLOWED on arm64 but VM_SHADOW_STACK on x86, so a shared
HIGH_ARCH_* bit cannot be given an unconditional name.

Add conditionally compiled names for VM_MTE, VM_MTE_ALLOWED and
VM_SHADOW_STACK.  Keep the configuration guards aligned with the
definitions of these aliases so each shared bit position is decoded
according to the target architecture.

For example, an arm64 VMA containing VM_MTE_ALLOWED is now printed as:

  ...|account|mte_allowed|...

instead of:

  ...|account|0x2000000000

Link: https://lore.kernel.org/1c7f7003cff8d00209baa8498f1efee113f5b5a4.1788330432.git.zhaomeijing@lixiang.com
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmflags.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/include/trace/events/mmflags.h~mm-trace-decode-mte-and-shadow-stack-vma-flags
+++ a/include/trace/events/mmflags.h
@@ -202,6 +202,19 @@ IF_HAVE_PG_ARCH_3(arch_3)
 # define IF_HAVE_VM_DROPPABLE(flag, name)
 #endif
 
+#ifdef CONFIG_ARM64_MTE
+# define IF_HAVE_VM_MTE(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_MTE(flag, name)
+#endif
+
+#if defined(CONFIG_X86_USER_SHADOW_STACK) || defined(CONFIG_RISCV_USER_CFI) || \
+	defined(CONFIG_ARM64_GCS)
+# define IF_HAVE_VM_SHADOW_STACK(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_SHADOW_STACK(flag, name)
+#endif
+
 #define __def_vmaflag_names						\
 	{VM_READ,			"read"		},		\
 	{VM_WRITE,			"write"		},		\
@@ -237,6 +250,9 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"soft
 	{VM_HUGEPAGE,			"hugepage"	},		\
 	{VM_NOHUGEPAGE,			"nohugepage"	},		\
 IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,	"droppable"	)		\
+IF_HAVE_VM_MTE(VM_MTE,			"mte")			\
+IF_HAVE_VM_MTE(VM_MTE_ALLOWED,		"mte_allowed")		\
+IF_HAVE_VM_SHADOW_STACK(VM_SHADOW_STACK, "shadow_stack")	\
 	{VM_MERGEABLE,			"mergeable"	}		\
 
 #define show_vma_flags(flags)						\
_

Patches currently in -mm which might be from zhaomeijing@lixiang.com are

mm-trace-decode-arm64-and-sparc64-vm_arch_1-flags.patch
mm-trace-decode-mte-and-shadow-stack-vma-flags.patch
mm-trace-name-protection-key-encoding-bits.patch

