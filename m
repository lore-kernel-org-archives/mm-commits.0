Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B5E7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lCqAcXkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746B1C433C7;
	Mon, 11 Dec 2023 01:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257806;
	bh=PDT124KPDR8mXGgaN70MtLNQHxaA0OhQa2q65/z1Y0E=;
	h=Date:To:From:Subject:From;
	b=lCqAcXkWIehpRiyjeMl9aNSN/KXRqDjxgM+UxP9K5dYPJnUypqxjBaTnNX3hNwBzu
	 pfuwAnZvhy0oIBNT966SaarEkoPjigk4fLmjOQZg4Qx057YqZlOng//5lK52Di9Rma
	 wMShaltfypoC5EZeVoQ3D+hB6kF+dEyEMDntUW+k=
Date: Sun, 10 Dec 2023 17:23:26 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-irq-add-prototype-for-arch_do_irq.patch removed from -mm tree
Message-Id: <20231211012326.746B1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: irq: add prototype for arch_do_IRQ()
has been removed from the -mm tree.  Its filename was
     hexagon-irq-add-prototype-for-arch_do_irq.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: irq: add prototype for arch_do_IRQ()
Date: Thu, 30 Nov 2023 15:58:30 -0700

Clang warns:

  arch/hexagon/kernel/vm_events.c:83:6: warning: no previous prototype for function 'arch_do_IRQ' [-Wmissing-prototypes]
     83 | void arch_do_IRQ(struct pt_regs *regs)
        |      ^
  arch/hexagon/kernel/vm_events.c:83:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     83 | void arch_do_IRQ(struct pt_regs *regs)
        | ^
        | static

This function is only called from assembly but the irq header is a
reasonable place to put a prototype to silence the warning.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-17-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/include/asm/irq.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/hexagon/include/asm/irq.h~hexagon-irq-add-prototype-for-arch_do_irq
+++ a/arch/hexagon/include/asm/irq.h
@@ -20,4 +20,7 @@
 
 #include <asm-generic/irq.h>
 
+struct pt_regs;
+void arch_do_IRQ(struct pt_regs *);
+
 #endif
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

