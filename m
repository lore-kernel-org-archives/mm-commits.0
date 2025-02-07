Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F49FDDA9
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 00:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738888222; cv=none; b=mCC4jkyEnzjH4OIwXY1ab7SE9c2fUoTwT01K0a57ahvXQhqgPQpNd5HIgNzH/qjzwK6ZQF3F7A2s6gMB1pxhIp5xjMSdCeFl4ehrj2gDL5H3du1RmTjShN1CZSd2UHGRqBaCWn59s9eu9Q+qX+2MNwIDwMmEZSTNRIstRfIEyIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738888222; c=relaxed/simple;
	bh=hC2RfObrPER5I+7YD0Ns/07Gs5qj4MFnN/2EcLveOOc=;
	h=Date:To:From:Subject:Message-Id; b=EtZ0hxONCqmuucZUs7pXP3XNf+adNMk56gg1gaXigU9ASBlZdA5ur5mfeGtWqohBUisugJhJJoG2y4kmQQt+kAZc6de0nuBRw31U8rrqc7HwAT5wvmbO53y57VbIeT4kITL+W6+FQYDzBVwLk8eQo7w3bqAJhUfnhxTvLikZBBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oXbZr0XL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oXbZr0XL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DAAC4CEDD;
	Fri,  7 Feb 2025 00:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738888222;
	bh=hC2RfObrPER5I+7YD0Ns/07Gs5qj4MFnN/2EcLveOOc=;
	h=Date:To:From:Subject:From;
	b=oXbZr0XL74QF17unugmE6fUSzJIgnFc+1A8QSXP2jbpr6dLiQ5hJ8kq2l7WTqvlJH
	 AhA92Zw7eEirv2Pr5j6JG1opnQvOXZuKcVY3xdif1ZsfUxdxaknAbHK/kTdDq0IABs
	 phCONU3U+5mfulCIiTngO1sV5g0zGtbvZKOaCwC8=
Date: Thu, 06 Feb 2025 16:30:21 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,usama.arif@bytedance.com,thomas.lendacky@amd.com,tglx@linutronix.de,skinsburskii@linux.microsoft.com,saravanak@google.com,rppt@kernel.org,rostedt@goodmis.org,robh@kernel.org,robh+dt@kernel.org,ptyadav@amazon.de,peterz@infradead.org,pbonzini@redhat.com,pasha.tatashin@soleen.com,mingo@redhat.com,mark.rutland@arm.com,luto@kernel.org,krzk@kernel.org,jgowans@amazon.com,hpa@zytor.com,ebiederm@xmission.com,dwmw2@infradead.org,dave.hansen@linux.intel.com,corbet@lwn.net,catalin.marinas@arm.com,bp@alien8.de,benh@kernel.crashing.org,ashish.kalra@amd.com,arnd@arndb.de,anthony.yznaga@oracle.com,graf@amazon.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memblock-add-kho-support-for-reserve_mem.patch added to mm-nonmm-unstable branch
Message-Id: <20250207003022.69DAAC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memblock: add KHO support for reserve_mem
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     memblock-add-kho-support-for-reserve_mem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memblock-add-kho-support-for-reserve_mem.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Alexander Graf <graf@amazon.com>
Subject: memblock: add KHO support for reserve_mem
Date: Thu, 6 Feb 2025 15:27:53 +0200

Linux has recently gained support for "reserve_mem": A mechanism to
allocate a region of memory early enough in boot that we can cross our
fingers and hope it stays at the same location during most boots, so we
can store for example ftrace buffers into it.

Thanks to KASLR, we can never be really sure that "reserve_mem"
allocations are static across kexec.  Let's teach it KHO awareness so that
it serializes its reservations on kexec exit and deserializes them again
on boot, preserving the exact same mapping across kexec.

This is an example user for KHO in the KHO patch set to ensure we have at
least one (not very controversial) user in the tree before extending KHO's
use to more subsystems.

Link: https://lkml.kernel.org/r/20250206132754.2596694-14-rppt@kernel.org
Signed-off-by: Alexander Graf <graf@amazon.com>
Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ashish Kalra <ashish.kalra@amd.com>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Gowans <jgowans@amazon.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Pratyush Yadav <ptyadav@amazon.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Usama Arif <usama.arif@bytedance.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |  131 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

--- a/mm/memblock.c~memblock-add-kho-support-for-reserve_mem
+++ a/mm/memblock.c
@@ -16,6 +16,9 @@
 #include <linux/kmemleak.h>
 #include <linux/seq_file.h>
 #include <linux/memblock.h>
+#include <linux/kexec_handover.h>
+#include <linux/kexec.h>
+#include <linux/libfdt.h>
 
 #include <asm/sections.h>
 #include <linux/io.h>
@@ -2423,6 +2426,70 @@ int reserve_mem_find_by_name(const char
 }
 EXPORT_SYMBOL_GPL(reserve_mem_find_by_name);
 
+static bool __init reserve_mem_kho_revive(const char *name, phys_addr_t size,
+					  phys_addr_t align)
+{
+	const void *fdt = kho_get_fdt();
+	const char *path = "/reserve_mem";
+	int node, child, err;
+
+	if (!IS_ENABLED(CONFIG_KEXEC_HANDOVER))
+		return false;
+
+	if (!fdt)
+		return false;
+
+	node = fdt_path_offset(fdt, "/reserve_mem");
+	if (node < 0)
+		return false;
+
+	err = fdt_node_check_compatible(fdt, node, "reserve_mem-v1");
+	if (err) {
+		pr_warn("Node '%s' has unknown compatible", path);
+		return false;
+	}
+
+	fdt_for_each_subnode(child, fdt, node) {
+		const struct kho_mem *mem;
+		const char *child_name;
+		int len;
+
+		/* Search for old kernel's reserved_mem with the same name */
+		child_name = fdt_get_name(fdt, child, NULL);
+		if (strcmp(name, child_name))
+			continue;
+
+		err = fdt_node_check_compatible(fdt, child, "reserve_mem_map-v1");
+		if (err) {
+			pr_warn("Node '%s/%s' has unknown compatible", path, name);
+			continue;
+		}
+
+		mem = fdt_getprop(fdt, child, "mem", &len);
+		if (!mem || len != sizeof(*mem))
+			continue;
+
+		if (mem->addr & (align - 1)) {
+			pr_warn("KHO reserved_mem '%s' has wrong alignment (0x%lx, 0x%lx)",
+				name, (long)align, (long)mem->addr);
+			continue;
+		}
+
+		if (mem->size != size) {
+			pr_warn("KHO reserved_mem '%s' has wrong size (0x%lx != 0x%lx)",
+				name, (long)mem->size, (long)size);
+			continue;
+		}
+
+		reserved_mem_add(mem->addr, mem->size, name);
+		pr_info("Revived memory reservation '%s' from KHO", name);
+
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Parse reserve_mem=nn:align:name
  */
@@ -2478,6 +2545,11 @@ static int __init reserve_mem(char *p)
 	if (reserve_mem_find_by_name(name, &start, &tmp))
 		return -EBUSY;
 
+	/* Pick previous allocations up from KHO if available */
+	if (reserve_mem_kho_revive(name, size, align))
+		return 1;
+
+	/* TODO: Allocation must be outside of scratch region */
 	start = memblock_phys_alloc(size, align);
 	if (!start)
 		return -ENOMEM;
@@ -2488,6 +2560,65 @@ static int __init reserve_mem(char *p)
 }
 __setup("reserve_mem=", reserve_mem);
 
+static int reserve_mem_kho_write_map(void *fdt, struct reserve_mem_table *map)
+{
+	int err = 0;
+	const char compatible[] = "reserve_mem_map-v1";
+	struct kho_mem mem = {
+		.addr = map->start,
+		.size = map->size,
+	};
+
+	err |= fdt_begin_node(fdt, map->name);
+	err |= fdt_property(fdt, "compatible", compatible, sizeof(compatible));
+	err |= fdt_property(fdt, "mem", &mem, sizeof(mem));
+	err |= fdt_end_node(fdt);
+
+	return err;
+}
+
+static int reserve_mem_kho_notifier(struct notifier_block *self,
+				    unsigned long cmd, void *v)
+{
+	const char compatible[] = "reserve_mem-v1";
+	void *fdt = v;
+	int err = 0;
+	int i;
+
+	switch (cmd) {
+	case KEXEC_KHO_ABORT:
+		return NOTIFY_DONE;
+	case KEXEC_KHO_DUMP:
+		/* Handled below */
+		break;
+	default:
+		return NOTIFY_BAD;
+	}
+
+	if (!reserved_mem_count)
+		return NOTIFY_DONE;
+
+	err |= fdt_begin_node(fdt, "reserve_mem");
+	err |= fdt_property(fdt, "compatible", compatible, sizeof(compatible));
+	for (i = 0; i < reserved_mem_count; i++)
+		err |= reserve_mem_kho_write_map(fdt, &reserved_mem_table[i]);
+	err |= fdt_end_node(fdt);
+
+	return err ? NOTIFY_BAD : NOTIFY_DONE;
+}
+
+static struct notifier_block reserve_mem_kho_nb = {
+	.notifier_call = reserve_mem_kho_notifier,
+};
+
+static int __init reserve_mem_init(void)
+{
+	register_kho_notifier(&reserve_mem_kho_nb);
+
+	return 0;
+}
+core_initcall(reserve_mem_init);
+
 #if defined(CONFIG_DEBUG_FS) && defined(CONFIG_ARCH_KEEP_MEMBLOCK)
 static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_HOTPLUG)] = "HOTPLUG",
_

Patches currently in -mm which might be from graf@amazon.com are

memblock-add-support-for-scratch-memory.patch
kexec-add-kexec-handover-kho-generation-helpers.patch
kexec-add-kho-parsing-support.patch
kexec-add-kho-support-to-kexec-file-loads.patch
kexec-add-config-option-for-kho.patch
kexec-add-documentation-for-kho.patch
arm64-add-kho-support.patch
x86-add-kho-support.patch
memblock-add-kho-support-for-reserve_mem.patch

