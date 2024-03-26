Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA6084D11;
	Tue, 26 Mar 2024 18:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476502; cv=none; b=QoSmAIgS9E1rskW18wV2DVBiQOEWmzuFnJeh00ipYXZxmvb53V1Z0Ahy7XajxS7H6fT16r9DTdEYRgXl6zjA+YjQi9D6zWQvS+DE7zeykFSJ1rgL+baGG/VkKc/tTaiHr7BhFTXjAtciWbw//qE+xy3VvuknWUg1QsOOh8DqQn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476502; c=relaxed/simple;
	bh=2KqROH7vzSI+Bi7pqDiHxES3G3QesV3e/fO4GFCOSsE=;
	h=Date:To:From:Subject:Message-Id; b=Vu4PSPH9xl8xmxYZR2qCceRa0hy6yjdAQz9KeBadp1msqwrJRIQTkRUeSh2Cr9eV9jc5Qic6HFExAzd6OlBJEybECJLxMduRB34MhgdyCblaTmuOX4MtFO01u3q/ohQpI8dfDcTm9BsBziDoux7OwYn3FGrvWUrOt6mF5RBXp34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i7xYEfmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i7xYEfmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF06BC433C7;
	Tue, 26 Mar 2024 18:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476501;
	bh=2KqROH7vzSI+Bi7pqDiHxES3G3QesV3e/fO4GFCOSsE=;
	h=Date:To:From:Subject:From;
	b=i7xYEfmcW+IBxXiLhQLUvcGUwtabI7dY2sZjocvv+gOzkyOdlCRY88POxS0XDK+Lo
	 WVmt0XY6kFHI9dERpy7Jt+AT/oMDt3I/1Y5sCgNKgu8LIHbH2uoW5ZHnLPm6GeQ7oT
	 KCg0SRytsr/OExrWIvYHi/tsnUmj6ygctNuEATl0=
Date: Tue, 26 Mar 2024 11:08:21 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,stable@vger.kernel.org,shr@devkernel.io,sam@gentoo.org,rppt@kernel.org,rick.p.edgecombe@intel.com,revest@chromium.org,omosnace@redhat.com,oleg@redhat.com,ojeda@kernel.org,linux@armlinux.org.uk,keescook@chromium.org,josh@joshtriplett.org,James.Bottomley@HansenPartnership.com,fengwei.yin@intel.com,deller@gmx.de,david@redhat.com,bp@alien8.de,zev@bewilderbeest.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] arm-prctl-reject-pr_set_mdwe-on-pre-armv6.patch removed from -mm tree
Message-Id: <20240326180821.BF06BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ARM: prctl: reject PR_SET_MDWE on pre-ARMv6
has been removed from the -mm tree.  Its filename was
     arm-prctl-reject-pr_set_mdwe-on-pre-armv6.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


