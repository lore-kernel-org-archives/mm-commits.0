Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119CB3BB38;
	Tue, 19 Mar 2024 20:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710880858; cv=none; b=S2AJzlK2vISBhb+MDHfmg70HZ3yVNRdLyJliF34x9jttVh6Wh6T57EjMTN1Kbg19BbDj+0f2bjUFSZKfcemjSK3YU0ze5e4Ftmm9YAZdNKpUnTPCwg59sCunZ/MmMJ1IDy//2A6YGLw8lmV4g0J7jWxWTH8mqkwdLT6Mc870agA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710880858; c=relaxed/simple;
	bh=FhjUv8R08x0lyavuhDiOv6USYmofO5j5AEGxPy57ZZ0=;
	h=Date:To:From:Subject:Message-Id; b=VfCRXflxVu6U+iBSnELFOEheAPELI0+fVcgZ+ln6Q85+kF5G3DxzXflzW4iR6RwPv8h/wOFTqPP0mpwxjgucL2SnM02X2XhnNRMZ0IJM0U1o0Grz8KTW7y/4kWOlFQPk4D4vcIU5eF3GsXRH5sWCtfRsVYiGT4TIIlO0R0rAPRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iADVvPD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iADVvPD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782C2C433C7;
	Tue, 19 Mar 2024 20:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710880857;
	bh=FhjUv8R08x0lyavuhDiOv6USYmofO5j5AEGxPy57ZZ0=;
	h=Date:To:From:Subject:From;
	b=iADVvPD3BLLq9iqxLUgNl3tHpbXfQ4UQbFw+xPk5n1FHsvDKgPy6qKFWuzRW5ykAX
	 kJIcrqD7qMn2P4kpbkjXQgE90+XaavC5NrS79j3qgoK9C3YbZ4a/aD2RGMDOZWxXAU
	 TCwo0gNrdomJn9fAH4KrD3FHz3qt4QvHe2mefeqc=
Date: Tue, 19 Mar 2024 13:40:56 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,stable@vger.kernel.org,shr@devkernel.io,sam@gentoo.org,rppt@kernel.org,rick.p.edgecombe@intel.com,revest@chromium.org,omosnace@redhat.com,oleg@redhat.com,ojeda@kernel.org,linux@armlinux.org.uk,keescook@chromium.org,josh@joshtriplett.org,James.Bottomley@HansenPartnership.com,fengwei.yin@intel.com,deller@gmx.de,david@redhat.com,bp@alien8.de,zev@bewilderbeest.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + prctl-generalize-pr_set_mdwe-support-check-to-be-per-arch.patch added to mm-hotfixes-unstable branch
Message-Id: <20240319204057.782C2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: prctl: generalize PR_SET_MDWE support check to be per-arch
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     prctl-generalize-pr_set_mdwe-support-check-to-be-per-arch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/prctl-generalize-pr_set_mdwe-support-check-to-be-per-arch.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Zev Weiss <zev@bewilderbeest.net>
Subject: prctl: generalize PR_SET_MDWE support check to be per-arch
Date: Mon, 26 Feb 2024 17:35:41 -0800

Patch series "ARM: prctl: Reject PR_SET_MDWE where not supported".

I noticed after a recent kernel update that my ARM926 system started
segfaulting on any execve() after calling prctl(PR_SET_MDWE).  After some
investigation it appears that ARMv5 is incapable of providing the
appropriate protections for MDWE, since any readable memory is also
implicitly executable.

The prctl_set_mdwe() function already had some special-case logic added
disabling it on PARISC (commit 793838138c15, "prctl: Disable
prctl(PR_SET_MDWE) on parisc"); this patch series (1) generalizes that
check to use an arch_*() function, and (2) adds a corresponding override
for ARM to disable MDWE on pre-ARMv6 CPUs.

With the series applied, prctl(PR_SET_MDWE) is rejected on ARMv5 and
subsequent execve() calls (as well as mmap(PROT_READ|PROT_WRITE)) can
succeed instead of unconditionally failing; on ARMv6 the prctl works as it
did previously.

[0] https://lore.kernel.org/all/2023112456-linked-nape-bf19@gregkh/


This patch (of 2):

There exist systems other than PARISC where MDWE may not be feasible to
support; rather than cluttering up the generic code with additional
arch-specific logic let's add a generic function for checking MDWE support
and allow each arch to override it as needed.

Link: https://lkml.kernel.org/r/20240227013546.15769-4-zev@bewilderbeest.net
Link: https://lkml.kernel.org/r/20240227013546.15769-5-zev@bewilderbeest.net
Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Acked-by: Helge Deller <deller@gmx.de>	[parisc]
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Florent Revest <revest@chromium.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Russell King (Oracle) <linux@armlinux.org.uk>
Cc: Sam James <sam@gentoo.org>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: <stable@vger.kernel.org>	[6.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/mman.h |   14 ++++++++++++++
 include/linux/mman.h           |    8 ++++++++
 kernel/sys.c                   |    7 +++++--
 3 files changed, 27 insertions(+), 2 deletions(-)

--- /dev/null
+++ a/arch/parisc/include/asm/mman.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_MMAN_H__
+#define __ASM_MMAN_H__
+
+#include <uapi/asm/mman.h>
+
+/* PARISC cannot allow mdwe as it needs writable stacks */
+static inline bool arch_memory_deny_write_exec_supported(void)
+{
+	return false;
+}
+#define arch_memory_deny_write_exec_supported arch_memory_deny_write_exec_supported
+
+#endif /* __ASM_MMAN_H__ */
--- a/include/linux/mman.h~prctl-generalize-pr_set_mdwe-support-check-to-be-per-arch
+++ a/include/linux/mman.h
@@ -162,6 +162,14 @@ calc_vm_flag_bits(unsigned long flags)
 
 unsigned long vm_commit_limit(void);
 
+#ifndef arch_memory_deny_write_exec_supported
+static inline bool arch_memory_deny_write_exec_supported(void)
+{
+	return true;
+}
+#define arch_memory_deny_write_exec_supported arch_memory_deny_write_exec_supported
+#endif
+
 /*
  * Denies creating a writable executable mapping or gaining executable permissions.
  *
--- a/kernel/sys.c~prctl-generalize-pr_set_mdwe-support-check-to-be-per-arch
+++ a/kernel/sys.c
@@ -2408,8 +2408,11 @@ static inline int prctl_set_mdwe(unsigne
 	if (bits & PR_MDWE_NO_INHERIT && !(bits & PR_MDWE_REFUSE_EXEC_GAIN))
 		return -EINVAL;
 
-	/* PARISC cannot allow mdwe as it needs writable stacks */
-	if (IS_ENABLED(CONFIG_PARISC))
+	/*
+	 * EOPNOTSUPP might be more appropriate here in principle, but
+	 * existing userspace depends on EINVAL specifically.
+	 */
+	if (!arch_memory_deny_write_exec_supported())
 		return -EINVAL;
 
 	current_bits = get_current_mdwe();
_

Patches currently in -mm which might be from zev@bewilderbeest.net are

prctl-generalize-pr_set_mdwe-support-check-to-be-per-arch.patch
arm-prctl-reject-pr_set_mdwe-on-pre-armv6.patch

