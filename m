Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832329;
	b=ldTc4hz9AIflbQWaic9vKP0rK7aJovzHoStKRmj4X+X51bThAKswTa1T9uKq34xFnA6n
	 RxpwiBE25qDCIy3FuHLRcxep6+TDBd/QxL+M4AvG6OJ6r6Qs1gn/+c+LZeEcFBGklkre1
	 MWnHAmURafxlLSAWJ55HV400cdeQzvIQJORYuqmB43l00MO8IIPLhfOj+gwdkl3xMfFMX
	 T7BzSHpg/XNQr+vF8ppFEKJI+BVKmHSQ7MfANuk6Y2roducKt0XAHFVaEGkmRXriiFBvN
	 nBe47aUPEuU5LPglrTT0+CHOCOjTdz4ej/eQtdcUDs4yWLEOCi04/8NcA9OvosV20Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832329;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=YixFqRqOkyFUpZiF9qJ9CW8UI1XCw62NRS+LJXW++pc=;
	b=oty8UeicDNahLgAHMWC5w0TLjIFtvOnJSskXGuwiD7OjB6DVBTgC7rQDBHQuMSUVznSG
	 /1+JEOQizGxgRwlO914qN69xtPSEq5/AmdFUwOo181JabywUctpB87xkZqEivQbSGFJLg
	 NCA2dqxcvgNxIQp8NYw6xxLQOxgXqyuLTiiMk4n0m8Kfi+2otb5glVsAVY2jhuPybveRF
	 FDbLHZvAudE7legUaa8pPdcPLHn231qwm6wh/8seaHEDxezkZLUWoin3vBtGVa5F2zgDw
	 awIvE+pJx+RFbTCFuhOrkg4zxR56QIGvUmi72G10EesEt333Nfa3eqlTAAVS1MM07yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Jf5dxL9e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5E0606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Jf5dxL9e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD021F01828;
	Sat, 24 Oct 2026 08:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832329;
	bh=YixFqRqOkyFUpZiF9qJ9CW8UI1XCw62NRS+LJXW++pc=;
	h=Date:To:From:Subject;
	b=Jf5dxL9ewl5w6dN/9y0woztd2Kd2WpG4bDqWuhmejCNJWxPwB/vLXw1pB73oFvppF
	 YHcnG3RYn3Av6XdDJOpxNFMkdP0C5BhNGzwMObf9AymQtR54miVYVMEIYj8L5ZoW1V
	 ZIQJNw4mrNWINlnDa46R1NcuhHI3P3II2PS5hXZ4=
Date: Sat, 24 Oct 2026 01:58:48 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,glaubitz@physik.fu-berlin.de,dalias@libc.org,arnd@arndb.de,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-drop-dead-code-guarded-by-ifdef-config_numa.patch removed from -mm tree
Message-Id: <20261024085848.DCD021F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: sh: drop dead code guarded by #ifdef CONFIG_NUMA
has been removed from the -mm tree.  Its filename was
     sh-drop-dead-code-guarded-by-ifdef-config_numa.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: sh: drop dead code guarded by #ifdef CONFIG_NUMA
Date: Sun, 10 May 2026 16:55:41 +0300

and NUMA-related comments.

Link: https://lore.kernel.org/20260510135546.13554-6-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---

 arch/sh/include/asm/topology.h |   13 -------------
 arch/sh/kernel/setup.c         |    1 -
 arch/sh/kernel/topology.c      |   12 ------------
 arch/sh/kernel/vmcore_info.c   |    4 ----
 arch/sh/mm/sram.c              |    3 +--
 5 files changed, 1 insertion(+), 32 deletions(-)

--- a/arch/sh/include/asm/topology.h~sh-drop-dead-code-guarded-by-ifdef-config_numa
+++ a/arch/sh/include/asm/topology.h
@@ -2,19 +2,6 @@
 #ifndef _ASM_SH_TOPOLOGY_H
 #define _ASM_SH_TOPOLOGY_H
 
-#ifdef CONFIG_NUMA
-
-#define cpu_to_node(cpu)	((void)(cpu),0)
-
-#define cpumask_of_node(node)	((void)node, cpu_online_mask)
-
-#define pcibus_to_node(bus)	((void)(bus), -1)
-#define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ? \
-					cpu_all_mask : \
-					cpumask_of_node(pcibus_to_node(bus)))
-
-#endif
-
 #define mc_capable()    (1)
 
 const struct cpumask *cpu_coregroup_mask(int cpu);
--- a/arch/sh/kernel/setup.c~sh-drop-dead-code-guarded-by-ifdef-config_numa
+++ a/arch/sh/kernel/setup.c
@@ -227,7 +227,6 @@ void __init __add_active_range(unsigned
 	/*
 	 * Also make sure that there is a PMB mapping that covers this
 	 * range before we attempt to activate it, to avoid reset by MMU.
-	 * We can hit this path with NUMA or memory hot-add.
 	 */
 	pmb_bolt_mapping((unsigned long)__va(start), start, end - start,
 			 PAGE_KERNEL);
--- a/arch/sh/kernel/topology.c~sh-drop-dead-code-guarded-by-ifdef-config_numa
+++ a/arch/sh/kernel/topology.c
@@ -57,18 +57,6 @@ static int __init topology_init(void)
 			       __func__, i, ret);
 	}
 
-#if defined(CONFIG_NUMA) && !defined(CONFIG_SMP)
-	/*
-	 * In the UP case, make sure the CPU association is still
-	 * registered under each node. Without this, sysfs fails
-	 * to make the connection between nodes other than node0
-	 * and cpu0.
-	 */
-	for_each_online_node(i)
-		if (i != numa_node_id())
-			register_cpu_under_node(raw_smp_processor_id(), i);
-#endif
-
 	return 0;
 }
 subsys_initcall(topology_init);
--- a/arch/sh/kernel/vmcore_info.c~sh-drop-dead-code-guarded-by-ifdef-config_numa
+++ a/arch/sh/kernel/vmcore_info.c
@@ -5,10 +5,6 @@
 
 void arch_crash_save_vmcoreinfo(void)
 {
-#ifdef CONFIG_NUMA
-	VMCOREINFO_SYMBOL(node_data);
-	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
-#endif
 #ifdef CONFIG_X2TLB
 	VMCOREINFO_CONFIG(X2TLB);
 #endif
--- a/arch/sh/mm/sram.c~sh-drop-dead-code-guarded-by-ifdef-config_numa
+++ a/arch/sh/mm/sram.c
@@ -16,8 +16,7 @@
  * This provides a standard SRAM pool for tiny memories that can be
  * added either by the CPU or the platform code. Typical SRAM sizes
  * to be inserted in to the pool will generally be less than the page
- * size, with anything more reasonably sized handled as a NUMA memory
- * node.
+ * size.
  */
 struct gen_pool *sram_pool;
 
_

Patches currently in -mm which might be from rppt@kernel.org are


