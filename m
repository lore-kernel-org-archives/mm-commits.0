Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8503F106D
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525363; cv=none; b=e4dLG2Bb2lsCcy2fYN+jaIyemKPYVL+M6Ya6WeKhnGcy3tY8+986YW9ehHk/cSsCXWJh1Akmp+p4B1hKdJsdny9Fv2cfbZO4JBLneTB6JlNhksA5FAPsbr38Ay7ra51fGeV2Dct8LMchbIfPzN2ghUICT4WHE2vVslkoHgyzPSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525363; c=relaxed/simple;
	bh=28pF0FqD56TIgJCGP1Q4XgaB61202NmAQsrGXsT5Zi0=;
	h=Date:To:From:Subject:Message-Id; b=fBoG2nO84nwjpalkYQ/hi/0IqnMQI7wgapPgRho5kPdPwnxd9SgEQeFU0pZEizBGmdA+ulhebRUgpouGlZsfNWOnNF0eHxYBCD9ri6PGZhBVeS2cTC74Re4QENuUClaqa/64YhGE+YHQOGuMC/y4kuq2OBHfL1gI6yBG3Ehm3C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jvtnJ7ej; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jvtnJ7ej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AB91F00893;
	Fri,  9 Oct 2026 05:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525361;
	bh=0KsrZ5DAPqup+Jrd9dS+YUgkS0FITuAA/RKiis//1dE=;
	h=Date:To:From:Subject;
	b=jvtnJ7ejIfwOM/E1wmg2mipVmkXeZfIB5n3L1Qv/sjNwazwnqBc/D9AFIR9QPNrK4
	 XHwJq57a8WkTxOaGAQLoGuAC6oq6M3OMUTzz+q8AkgWJak3Gu/0elYzsSDYudVNzcl
	 vGl7a1OyBHnxVlwU9t43oDHNz+nN1gdyBGPi3rtY=
Date: Thu, 08 Oct 2026 22:56:01 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,zhaomeijing@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-trace-decode-mte-and-shadow-stack-vma-flags.patch removed from -mm tree
Message-Id: <20261009055601.B3AB91F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: trace: decode MTE and shadow stack VMA flags
has been removed from the -mm tree.  Its filename was
     mm-trace-decode-mte-and-shadow-stack-vma-flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
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


