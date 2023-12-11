Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57997493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jRsahAig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA21C433C9;
	Mon, 11 Dec 2023 01:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257793;
	bh=VyK0zPZbAZXpVHkqRe5CPfxdTL+ll/0Micd7rNjIV3Y=;
	h=Date:To:From:Subject:From;
	b=jRsahAigS0mR0WvDmSlOZhWZivKl3zEAJWkLNc+o7kTAAKUAx74UCv9c5vqleOxWd
	 nqjZpLahTMcQ4qfJ8cGgrSxkMjtjiwEiWcveyR98T6tyYW5qXMLbdUulRIvxzt6zuP
	 UDKh/3Enk1URzKA8Je9f4SwjMJyksr2q2yC9+FHQ=
Date: Sun, 10 Dec 2023 17:23:13 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-smp-mark-handle_ipi-and-start_secondary-as-static.patch removed from -mm tree
Message-Id: <20231211012313.AFA21C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: smp: mark handle_ipi() and start_secondary() as static
has been removed from the -mm tree.  Its filename was
     hexagon-smp-mark-handle_ipi-and-start_secondary-as-static.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: smp: mark handle_ipi() and start_secondary() as static
Date: Thu, 30 Nov 2023 15:58:17 -0700

Clang warns:

  arch/hexagon/kernel/smp.c:82:13: warning: no previous prototype for function 'handle_ipi' [-Wmissing-prototypes]
     82 | irqreturn_t handle_ipi(int irq, void *desc)
        |             ^
  arch/hexagon/kernel/smp.c:82:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     82 | irqreturn_t handle_ipi(int irq, void *desc)
        | ^
        | static
  arch/hexagon/kernel/smp.c:127:6: warning: no previous prototype for function 'start_secondary' [-Wmissing-prototypes]
    127 | void start_secondary(void)
        |      ^
  arch/hexagon/kernel/smp.c:127:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    127 | void start_secondary(void)
        | ^
        | static
  2 warnings generated.

These functions are not used outside of this translation unit, so mark
them as static.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-4-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/smp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/hexagon/kernel/smp.c~hexagon-smp-mark-handle_ipi-and-start_secondary-as-static
+++ a/arch/hexagon/kernel/smp.c
@@ -79,7 +79,7 @@ void smp_vm_unmask_irq(void *info)
  * Specifically, first arg is irq, second is the irq_desc.
  */
 
-irqreturn_t handle_ipi(int irq, void *desc)
+static irqreturn_t handle_ipi(int irq, void *desc)
 {
 	int cpu = smp_processor_id();
 	struct ipi_data *ipi = &per_cpu(ipi_data, cpu);
@@ -124,7 +124,7 @@ void __init smp_prepare_boot_cpu(void)
  * to point to current thread info
  */
 
-void start_secondary(void)
+static void start_secondary(void)
 {
 	unsigned long thread_ptr;
 	unsigned int cpu, irq;
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

