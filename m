Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742933F58C2
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525364; cv=none; b=kck3JjFJ+hjpGMX0gUV4QvL+NMQWQ+nU9tXjx+fzfHuYR3S9XOAz95U9iuRfcJ1CFYcvFxb/KBLG7Cdcw6RzFTjZDJd2KmK+yO0K4ZVp8nwD4rQ2rMFqBjuwquK9T7pf5TSW37rlg8HslTgUK49Sc1JB0ulJ5wmsltAy0ctN9/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525364; c=relaxed/simple;
	bh=n/rbYC0fbXDMWg60ibiMEgWdfqpK7OH+iyut30O1J2Q=;
	h=Date:To:From:Subject:Message-Id; b=dCGnX80BNwBwlDHQrwjVY9d1gZbuhmON6eCApleKPvwxKz1pQRLismN/0Hny5HCy+lbyyNgKe6OZa0xYj4OR2GndCulH6C72JtGnrCqFvdc23XmRuDmw4ntaAsgk7TZPY+IDuzG7ELUI5nAaAGwOnkPCEUi76OrcnvmYoAGN8zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eGHO1xQs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eGHO1xQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC251F000FF;
	Fri,  9 Oct 2026 05:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525363;
	bh=SI/m5zxk5XuHedQPtOBOme2sZYLGJ2sOnF5BhTjRAs8=;
	h=Date:To:From:Subject;
	b=eGHO1xQsgy2lBajVtjb2M9P6l48jvjvHHRiiCiouN3FGHv3VFL8emkwh0xh/mHLKO
	 QYI7pInIwPn4mfOONwcvYDWNf8+TvRpB8kW+jpKdLo6yKHusHr1AZ5uUCdH2+UtZFl
	 BTv9IGNjg41OL55HwnqP4Cvjib9+tRi8PdEbDTdg=
Date: Thu, 08 Oct 2026 22:56:02 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,zhaomeijing@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-trace-name-protection-key-encoding-bits.patch removed from -mm tree
Message-Id: <20261009055602.DCC251F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: trace: name protection key encoding bits
has been removed from the -mm tree.  Its filename was
     mm-trace-name-protection-key-encoding-bits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
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


