Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEB24ACC7C
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 22:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788388642; cv=none; b=loxeGCrtnWKw0dS5YpFLnH/Gv5+Izn+yuTnN2afTR4yxReE6NOhgcO1JXm3oN0bb77cokeWNpOgRymaTLT5Lkhz7jmfI5M+BQaHw9AqEqtwU15BxulB6hapq/mluiqtOw3JbHJf/O6efi9cmkP+oh/a0IcBzlJNx0WGu/GTRdoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788388642; c=relaxed/simple;
	bh=9UDbL82qJ1Ds7UsmfZj7PivVVXeQsxT3zscMcsl94xg=;
	h=Date:To:From:Subject:Message-Id; b=kegRWgkLam8nQ51sxO03ME9XL0pY6v+qu6DRmmLShYALW87Qyjc0zhueGXtsvyO8HN4SITCyXEBvhzwi5h0/6q0USQNCJ4pYGeWS8xnD1lyX0aUspR4yx6xe6cUCat8X5LDMYVkTbnlWIJGVPN6RqQNJ3iQPUSFGMFtChtipvoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lX57dPnN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lX57dPnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3727C1F000E9;
	Wed,  2 Sep 2026 22:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788388633;
	bh=2jT8ysj3ybpCLgIh6jQlXrjuU+gRjVHRgmOGvDdQpr4=;
	h=Date:To:From:Subject;
	b=lX57dPnNaL2upiQVVHBkNL/4/H5zM9j32HWaVR+FgyIXmuw0QLHAzbzX54tIwbcPo
	 u3xSn0c7fU+qbNqVRFwHL6odO4JDT2nlcylU1EeFibw/sOiWeIEn1KWWKPkRtUmZAQ
	 3u+LN0go5xBfu1SuieI0xc1KaSu9FOAaYtO6Vnr4=
Date: Wed, 02 Sep 2026 15:37:12 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,ljs@kernel.org,zhaomeijing@lixiang.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-trace-decode-arm64-and-sparc64-vm_arch_1-flags.patch added to mm-new branch
Message-Id: <20260902223713.3727C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: trace: decode arm64 and sparc64 VM_ARCH_1 flags
has been added to the -mm mm-new branch.  Its filename is
     mm-trace-decode-arm64-and-sparc64-vm_arch_1-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-trace-decode-arm64-and-sparc64-vm_arch_1-flags.patch

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
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-trace-decode-arm64-and-sparc64-vm_arch_1-flags.patch
mm-trace-decode-mte-and-shadow-stack-vma-flags.patch
mm-trace-name-protection-key-encoding-bits.patch

