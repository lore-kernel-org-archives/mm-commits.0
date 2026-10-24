Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832328;
	b=th42E+qrJiasBEltVZUqwjRYX2UjHek53g7avsMy3jKk/7uZ13gly9RvEsl7Ds4td2oU
	 2i1oFbJfRudy3lRM4Xw9zKITQSUgxhs3CeJcDauctvOFoaQzn0vpZFXVVZk+fZnlecFwy
	 1h5g6vwgFdMYS9IcBbmt8fzRTyDYEYgR3By8ZOo6stK+CM+cGGzV6uKvHLuI3cub6LeWT
	 5KeyEIrH4E/xApQSxxas4XvnWW3W1codBcAOZkuLWtVbXrW8TjEx/itSnEtfrvnyy7LpA
	 drf9g+PIT+6AZpmCw0BeB7KUW6ykA4ddqgiJDCVfhRYrT/Nx4+ZPqlw2quKqW+Z1HWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832328;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=i8U3kPVh+ekqsEyx1H8odXGqp8E1dFnu4kEk1hA54/4=;
	b=zMiuPbJk9knnpQLzzX1jU9N2mqkL2hQYELgGbRXPBJI52WZK4vj1467uWunkrGJosWnf
	 C5atIrrbk16uLNJ1TZvjMnpuS0Pr+ek/NJj9b6/A7u6ySXxYlQfLGok72eyFMYNBmYB1P
	 uwqOLdp5qBONMSm8OyhLsHU1j/F2Bl7IlIiSxjlUkMq8ttUU2x7ZFHnKuS4WmW0SjB0CC
	 EEs6s3J1tLUGuVQNnwvkCtp8xk/yzzPIr9GHzevyWJH7Yyj/htaJcK7QE3aAqzEB6uekV
	 gp6O/PxWxOqQuY7Y4pmCzM4Zk07EBSheqHWQjo8UfiOGDV1GrSHZJSP5SA7GqrUQngw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=z98wBvEy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149BF606A31E
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=z98wBvEy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F5F1F01825;
	Sat, 24 Oct 2026 08:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832327;
	bh=i8U3kPVh+ekqsEyx1H8odXGqp8E1dFnu4kEk1hA54/4=;
	h=Date:To:From:Subject;
	b=z98wBvEyF+J57FGF9EzAmCuP8Qt1aR1Pk2pU73l3KFdm0YqyeRolT2lzePzu2d3qw
	 bPM/7jyLChY+xljzwqWvFBDEM393OkLP1JzxrkZv3cK8LabKEauv0zto8xe7GY4KRk
	 Dk3bJHYAvkus/cmwoqTsu1m7sV3zr34oRSxUUq7Y=
Date: Sat, 24 Oct 2026 01:58:47 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-remove-setup_bootmem_node-and-plat_mem_setup.patch removed from -mm tree
Message-Id: <20261024085847.D2F5F1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: sh: remove setup_bootmem_node() and plat_mem_setup()
has been removed from the -mm tree.  Its filename was
     sh-remove-setup_bootmem_node-and-plat_mem_setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: remove setup_bootmem_node() and plat_mem_setup()
Date: Sun, 10 May 2026 16:55:40 +0300

setup_bootmem_node() and plat_mem_setup() were needed to setup NUMA
"nodes" for URAM memory ranges.  Since there is no NUMA support anymore,
these functions are not needed.

Remove them.

Link: https://lore.kernel.org/20260510135546.13554-5-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---

 arch/sh/kernel/cpu/sh4a/setup-sh7366.c |    5 -----
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |    6 ------
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c |    4 ----
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c |    6 ------
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c |    4 ----
 arch/sh/kernel/cpu/sh4a/setup-shx3.c   |   17 -----------------
 arch/sh/mm/init.c                      |    7 -------
 7 files changed, 49 deletions(-)

--- a/arch/sh/kernel/cpu/sh4a/setup-sh7366.c~sh-remove-setup_bootmem_node-and-plat_mem_setup
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7366.c
@@ -381,8 +381,3 @@ void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
 }
-
-void __init plat_mem_setup(void)
-{
-	/* TODO: Register Node 1 */
-}
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c~sh-remove-setup_bootmem_node-and-plat_mem_setup
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7722.c
@@ -658,9 +658,3 @@ void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
 }
-
-void __init plat_mem_setup(void)
-{
-	/* Register the URAM space as Node 1 */
-	setup_bootmem_node(1, 0x055f0000, 0x05610000);
-}
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c~sh-remove-setup_bootmem_node-and-plat_mem_setup
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7757.c
@@ -1239,7 +1239,3 @@ void __init plat_irq_setup_pins(int mode
 		BUG();
 	}
 }
-
-void __init plat_mem_setup(void)
-{
-}
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7785.c~sh-remove-setup_bootmem_node-and-plat_mem_setup
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7785.c
@@ -600,9 +600,3 @@ void __init plat_irq_setup_pins(int mode
 		BUG();
 	}
 }
-
-void __init plat_mem_setup(void)
-{
-	/* Register the URAM space as Node 1 */
-	setup_bootmem_node(1, 0xe55f0000, 0xe5610000);
-}
--- a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c~sh-remove-setup_bootmem_node-and-plat_mem_setup
+++ a/arch/sh/kernel/cpu/sh4a/setup-sh7786.c
@@ -783,10 +783,6 @@ void __init plat_irq_setup_pins(int mode
 	}
 }
 
-void __init plat_mem_setup(void)
-{
-}
-
 static int __init sh7786_devices_setup(void)
 {
 	int ret, irq;
--- a/arch/sh/kernel/cpu/sh4a/setup-shx3.c~sh-remove-setup_bootmem_node-and-plat_mem_setup
+++ a/arch/sh/kernel/cpu/sh4a/setup-shx3.c
@@ -377,20 +377,3 @@ void __init plat_irq_setup(void)
 {
 	register_intc_controller(&intc_desc);
 }
-
-void __init plat_mem_setup(void)
-{
-	unsigned int nid = 1;
-
-	/* Register CPU#0 URAM space as Node 1 */
-	setup_bootmem_node(nid++, 0x145f0000, 0x14610000);	/* CPU0 */
-
-#if 0
-	/* XXX: Not yet.. */
-	setup_bootmem_node(nid++, 0x14df0000, 0x14e10000);	/* CPU1 */
-	setup_bootmem_node(nid++, 0x155f0000, 0x15610000);	/* CPU2 */
-	setup_bootmem_node(nid++, 0x15df0000, 0x15e10000);	/* CPU3 */
-#endif
-
-	setup_bootmem_node(nid++, 0x16000000, 0x16020000);	/* CSM */
-}
--- a/arch/sh/mm/init.c~sh-remove-setup_bootmem_node-and-plat_mem_setup
+++ a/arch/sh/mm/init.c
@@ -38,11 +38,6 @@ void __init generic_mem_init(void)
 	memblock_add(__MEMORY_START, __MEMORY_SIZE);
 }
 
-void __init __weak plat_mem_setup(void)
-{
-	/* Nothing to see here, move along. */
-}
-
 #ifdef CONFIG_MMU
 static pte_t *__get_pte_phys(unsigned long addr)
 {
@@ -211,8 +206,6 @@ static void __init do_init_bootmem(void)
 		__add_active_range(0, start_pfn, end_pfn);
 
 	node_set_online(0);
-
-	plat_mem_setup();
 }
 
 static void __init early_reserve_mem(void)
_

Patches currently in -mm which might be from rppt@kernel.org are


