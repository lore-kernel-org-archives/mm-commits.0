Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218DA3BB38;
	Tue, 19 Mar 2024 20:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710880861; cv=none; b=pa8kWLQeGe4CaVXzxCjB/60AFht1tgLaf++OTbh/EQZ+sTfWEg7eUEVwTI7HPVoHTEdJyHhTkbtrAlSoM2CGvQ6eqJz7lsm2bGdkWhbOgWZLabg6/bDMSCJvvKiQlgfsF/9bQ4JA9NQI0q0VQwO+dvz9MYRArhgMMvu+KCaNStc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710880861; c=relaxed/simple;
	bh=rFkVijGyWTlc3II8gfa9QNHrFY6cORFkW5KVIBqabFY=;
	h=Date:To:From:Subject:Message-Id; b=stafmuagKY7SqVGinEFH47OocuK56qUPoFmLXJDf2NEFE9YbDsaAonawqEaxRi+4s+n13uocUAPR2RQxDBIQ6K5zxoSpMU1nqtxQvYeoswC0nyJtcaPFEwY46bJ0+2D/yMu9gNUrqQ282gl9iCjdIaxuav3kV+Q9VY7M9/agMvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pRcvDC8h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pRcvDC8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7918C433C7;
	Tue, 19 Mar 2024 20:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710880860;
	bh=rFkVijGyWTlc3II8gfa9QNHrFY6cORFkW5KVIBqabFY=;
	h=Date:To:From:Subject:From;
	b=pRcvDC8hOAMKqNgtjoBoVZGqrDbiBlyjcKibnEAcrEFbCtkApwvUYpe33JLKJZXPQ
	 pV+a38N2Ub65wTvNMh2XI6siy/uPqAvhADp9rlm4EKJbdxIhk/m50BZy1AaczbhCIy
	 cGK3rOugJDU1qUs5luUHAzsL9uiqTg3QAsJSBFNk=
Date: Tue, 19 Mar 2024 13:41:00 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,stable@vger.kernel.org,shr@devkernel.io,sam@gentoo.org,rppt@kernel.org,rick.p.edgecombe@intel.com,revest@chromium.org,omosnace@redhat.com,oleg@redhat.com,ojeda@kernel.org,linux@armlinux.org.uk,keescook@chromium.org,josh@joshtriplett.org,James.Bottomley@HansenPartnership.com,fengwei.yin@intel.com,deller@gmx.de,david@redhat.com,bp@alien8.de,zev@bewilderbeest.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm-prctl-reject-pr_set_mdwe-on-pre-armv6.patch added to mm-hotfixes-unstable branch
Message-Id: <20240319204100.C7918C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ARM: prctl: reject PR_SET_MDWE on pre-ARMv6
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     arm-prctl-reject-pr_set_mdwe-on-pre-armv6.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm-prctl-reject-pr_set_mdwe-on-pre-armv6.patch

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
Subject: ARM: prctl: reject PR_SET_MDWE on pre-ARMv6
Date: Mon, 26 Feb 2024 17:35:42 -0800

On v5 and lower CPUs we can't provide MDWE protection, so ensure we fail
any attempt to enable it via prctl(PR_SET_MDWE).

Previously such an attempt would misleadingly succeed, leading to any
subsequent mmap(PROT_READ|PROT_WRITE) or execve() failing unconditionally
(the latter somewhat violently via force_fatal_sig(SIGSEGV) due to
READ_IMPLIES_EXEC).

Link: https://lkml.kernel.org/r/20240227013546.15769-6-zev@bewilderbeest.net
Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Cc: <stable@vger.kernel.org>	[6.3+]
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Florent Revest <revest@chromium.org>
Cc: Helge Deller <deller@gmx.de>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/mman.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- /dev/null
+++ a/arch/arm/include/asm/mman.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_MMAN_H__
+#define __ASM_MMAN_H__
+
+#include <asm/system_info.h>
+#include <uapi/asm/mman.h>
+
+static inline bool arch_memory_deny_write_exec_supported(void)
+{
+	return cpu_architecture() >= CPU_ARCH_ARMv6;
+}
+#define arch_memory_deny_write_exec_supported arch_memory_deny_write_exec_supported
+
+#endif /* __ASM_MMAN_H__ */
_

Patches currently in -mm which might be from zev@bewilderbeest.net are

prctl-generalize-pr_set_mdwe-support-check-to-be-per-arch.patch
arm-prctl-reject-pr_set_mdwe-on-pre-armv6.patch

