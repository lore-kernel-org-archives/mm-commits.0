Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF9B3F54CB
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525362; cv=none; b=uuVBxfuji67yNkZ7L76j+k8FaHMZ30ciJo37XCtaQhMdh8wZM/XVPeN+GWR7SutFECd3dINn4K9kl/nsQhZHW5yJF3huZc3iIQpqOAYdnLrfzHwYKhTISbjTow6R+ZcgMjobqeI+LYrG+78S74F58NFmRHE8tf+65etcbqZ7ge0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525362; c=relaxed/simple;
	bh=yHSUUbuJoTc4IwuP83G9j8K0YFYRSH3mrD4rE5fZ9W4=;
	h=Date:To:From:Subject:Message-Id; b=T5E2Ju8at/J0eZ/TvrCoUgXnj+V0KWdsXzWKYa2P/U+JfFKucOhi6SkSMFujfzjERudZ9q3EgeZvsiKzk0S4i+b8wWizf+6d1IzbSDtlcmFldnRd8O6CO/ZkJ8loIhLCLcHU5J9ky/SHnv4xzshlDNglmeKmatlAWm1hJywUsNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gl4lT3uo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gl4lT3uo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4D31F000FF;
	Fri,  9 Oct 2026 05:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525360;
	bh=OQ5Zw1dYzMY7P1E/P3j9LTQbSTNC1yX3CRdKaX8Nmns=;
	h=Date:To:From:Subject;
	b=Gl4lT3uoZO+vGDNFBm3iVChVYgB1PKCHQYwbP7A4lP1dVFsaHZClXcYH8GcWzK7gz
	 WnFZ61K6JkQ/IJ8ZOte+hPMcV5yo5vZsh6WBlSapDcRyQl0D7CtdMWTwcDn8vJnqIi
	 7g/9tgU6pFX4VfgubzqysoHqmTz8Nfh0H6FwoNI8=
Date: Thu, 08 Oct 2026 22:56:00 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,zhaomeijing@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-trace-decode-arm64-and-sparc64-vm_arch_1-flags.patch removed from -mm tree
Message-Id: <20261009055600.9F4D31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: trace: decode arm64 and sparc64 VM_ARCH_1 flags
has been removed from the -mm tree.  Its filename was
     mm-trace-decode-arm64-and-sparc64-vm_arch_1-flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Meijing Zhao <zhaomeijing@lixiang.com>
Subject: mm: trace: decode arm64 and sparc64 VM_ARCH_1 flags
Date: Wed, 2 Sep 2026 14:45:08 +0800

Patch series "mm: trace: decode architecture-specific VMA flags", v2.

show_vma_flags(), which is used by VMA tracepoints and %pGv, names generic
VM_* bits but does not fully decode architecture-specific flag positions. 
As a result, trace output and VMA dumps can show a generic "arch_1" name
or a raw hexadecimal value instead of the meaning assigned by the target
architecture.

This series adds symbolic names for the arm64 and sparc64 meanings of
VM_ARCH_1, arm64 MTE flags, user shadow stack flags, and protection-key
encoding bits under their corresponding configuration guards.


This patch (of 3):

The VM_ARCH_1 bit has architecture-specific meanings.  show_vma_flags(),
which is used by VMA tracepoints and %pGv, already reports the powerpc,
parisc and no-MMU meanings, but falls back to the generic "arch_1" name on
arm64 and sparc64.

Report VM_ARM64_BTI as "bti" and VM_SPARC_ADI as "adi" so trace output and
%pGv dumps expose the actual architecture-specific state.

Link: https://lore.kernel.org/cover.1788330432.git.zhaomeijing@lixiang.com
Link: https://lore.kernel.org/bcf0fea58240c4b6daa253739683ed7709e42fbb.1788330432.git.zhaomeijing@lixiang.com
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---

 include/trace/events/mmflags.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/trace/events/mmflags.h~mm-trace-decode-arm64-and-sparc64-vm_arch_1-flags
+++ a/include/trace/events/mmflags.h
@@ -168,6 +168,10 @@ IF_HAVE_PG_ARCH_3(arch_3)
 #define __VM_ARCH_SPECIFIC_1 {VM_SAO,     "sao"           }
 #elif defined(CONFIG_PARISC)
 #define __VM_ARCH_SPECIFIC_1 {VM_GROWSUP,	"growsup"	}
+#elif defined(CONFIG_SPARC64)
+#define __VM_ARCH_SPECIFIC_1 {VM_SPARC_ADI, "adi"		}
+#elif defined(CONFIG_ARM64)
+#define __VM_ARCH_SPECIFIC_1 {VM_ARM64_BTI, "bti"		}
 #elif !defined(CONFIG_MMU)
 #define __VM_ARCH_SPECIFIC_1 {VM_MAPPED_COPY,"mappedcopy"	}
 #else
_

Patches currently in -mm which might be from zhaomeijing@lixiang.com are


