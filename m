Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FDF6BB4B
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423431; cv=none; b=LfBNmMxh54Lmg69CzSXm23KYjNCt3j+yLhDG5hMnFwMlGCJtWWP2ICz+9rex2CvyQIATogMBFt10UJ4CTUlzbdj3bDBhIpp8DQD/bR4mX6+Iec/mqZtjS2amyEvxwvAyzM0boiMHrrDRuY+iMWfvbrhCYixwxvTB0KcKj5rq0D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423431; c=relaxed/simple;
	bh=mhjJsc/3UY2XxPx7gANrqFRT3WMQO2xB3S8RyeVHeZA=;
	h=Date:To:From:Subject:Message-Id; b=fx6peH2jdwWAtaUAomJ67jufgGZXzs4S6uIP9wNJAH7z0A6MqzQFJoIUexkGX00M58lWFCY0eKv4jDtqyW4R01KNKpOLd18oS7h9TtQ1DT9OgcEKt+58jx26K/TkP91FMcBnqSDUft6ZBchm9ZQmFmhY7eO2RB0p4ITAFoXrGvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ch/FtGY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ch/FtGY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D834C4CEC2;
	Wed,  4 Sep 2024 04:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423431;
	bh=mhjJsc/3UY2XxPx7gANrqFRT3WMQO2xB3S8RyeVHeZA=;
	h=Date:To:From:Subject:From;
	b=ch/FtGY+3Gjz5hk2odfYNJ84adH8pya1vAsO8M+huSmdpm0zRzGtT7Aq/8poCFKZP
	 cmAPLJTPvXP5gUxbAXJsHC4GlY6DXFd2+bCEy1z/x0RCQrbxJIkmMOszr/kAnPZZVJ
	 EW1po7OVQOPUCRcQEUanr5lvEah8FaoNMo7fCchs=
Date: Tue, 03 Sep 2024 21:17:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,samuel.holland@sifive.com,robh@kernel.org,rafael@kernel.org,palmer@dabbelt.com,mpe@ellerman.id.au,mingo@redhat.com,Jonathan.Cameron@huawei.com,jiaxun.yang@flygoat.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,david@redhat.com,dave@stgolabs.net,davem@davemloft.net,dave.hansen@linux.intel.com,dan.j.williams@intel.com,corbet@lwn.net,christophe.leroy@csgroup.eu,chenhuacai@kernel.org,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-numa-move-fake_node_-defines-to-numa_emu.patch removed from -mm tree
Message-Id: <20240904041711.6D834C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/numa: move FAKE_NODE_* defines to numa_emu
has been removed from the -mm tree.  Its filename was
     x86-numa-move-fake_node_-defines-to-numa_emu.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: x86/numa: move FAKE_NODE_* defines to numa_emu
Date: Wed, 7 Aug 2024 09:40:56 +0300

The definitions of FAKE_NODE_MIN_SIZE and FAKE_NODE_MIN_HASH_MASK are only
used by numa emulation code, make them local to
arch/x86/mm/numa_emulation.c

Link: https://lkml.kernel.org/r/20240807064110.1003856-13-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Zi Yan <ziy@nvidia.com> # for x86_64 and arm64
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> [arm64 + CXL via QEMU]
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Rob Herring (Arm) <robh@kernel.org>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/numa.h  |    2 --
 arch/x86/mm/numa_emulation.c |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/numa.h~x86-numa-move-fake_node_-defines-to-numa_emu
+++ a/arch/x86/include/asm/numa.h
@@ -71,8 +71,6 @@ void debug_cpumask_set_cpu(int cpu, int
 #endif
 
 #ifdef CONFIG_NUMA_EMU
-#define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
-#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
 int numa_emu_cmdline(char *str);
 #else /* CONFIG_NUMA_EMU */
 static inline int numa_emu_cmdline(char *str)
--- a/arch/x86/mm/numa_emulation.c~x86-numa-move-fake_node_-defines-to-numa_emu
+++ a/arch/x86/mm/numa_emulation.c
@@ -10,6 +10,9 @@
 
 #include "numa_internal.h"
 
+#define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
+#define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
+
 static int emu_nid_to_phys[MAX_NUMNODES];
 static char *emu_cmdline __initdata;
 
_

Patches currently in -mm which might be from rppt@kernel.org are


