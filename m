Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06AF2AD14
	for <mm-commits@vger.kernel.org>; Fri, 13 Dec 2024 03:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734059260; cv=none; b=A2pqfgacXsv/Phunyvyl92kbmEbO7jEl/rOEiN94CEWXXR52KldsZCcPwQgz5xtnN/PvyvVFquH4xdx2Z+jUDrsbvXPfmpwm0sahntmjQuGz/Qo27Hlh0jdymXPiXFVIIGQVTlG4ucPiuLQa6yhYwax6VmuIU9Yg23igYSmEUzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734059260; c=relaxed/simple;
	bh=OLJfyirchoIqNYBFebGGPhcupDS3yIzPCs4RkWEQEsk=;
	h=Date:To:From:Subject:Message-Id; b=otclpey/uAAgK+PdZfGg7+cavGZC7Wf7foYxgb55f8B6KdxjW8rv1t456LtrDL3x2QBbdNTxccfJ7ABmYL+yYLpRRUN1JgSzp1xugvmakJ8tRVWkeCfRDmDbrY/mgI2Gt1fHfh2KukMdLAT1rjAkfB8NVJzhBKOqBg+15YNvMws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W74koKA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W74koKA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D611C4CECE;
	Fri, 13 Dec 2024 03:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734059259;
	bh=OLJfyirchoIqNYBFebGGPhcupDS3yIzPCs4RkWEQEsk=;
	h=Date:To:From:Subject:From;
	b=W74koKA99hXhLcxmxu9I7WmKgF4JeEDKmrbcr3vuHzYSxfPVOV8oUpuu/BkXyqOrK
	 jU4AE47BjJZu0pX1FC2jcxviLGw+88VbEuMk2HQpI3z2ri3qJzHTaUcIbF2gOTuD61
	 YHH+BSijaNj1Z5NxxcQX/RD8H0CK1jAyx70G2dMk=
Date: Thu, 12 Dec 2024 19:07:38 -0800
To: mm-commits@vger.kernel.org,xin@zytor.com,tglx@linutronix.de,rafael@kernel.org,rafael.j.wysocki@intel.com,mingo@redhat.com,mingo@kernel.org,lenb@kernel.org,kevinloughlin@google.com,julian.stecklina@cyberus-technology.de,Jason@zx2c4.com,hpa@zytor.com,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,arnd@arndb.de,ardb@kernel.org,guoweikang.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-early_ioremap-add-null-pointer-checks-to-prevent-null-pointer-dereference.patch added to mm-unstable branch
Message-Id: <20241213030739.4D611C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/early_ioremap: add null pointer checks to prevent NULL-pointer dereference
has been added to the -mm mm-unstable branch.  Its filename is
     mm-early_ioremap-add-null-pointer-checks-to-prevent-null-pointer-dereference.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-early_ioremap-add-null-pointer-checks-to-prevent-null-pointer-dereference.patch

This patch will later appear in the mm-unstable branch at
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
From: Guo Weikang <guoweikang.kernel@gmail.com>
Subject: mm/early_ioremap: add null pointer checks to prevent NULL-pointer dereference
Date: Thu, 12 Dec 2024 18:10:00 +0800

The early_ioremap interface can fail and return NULL in certain cases.  To
prevent NULL-pointer dereference crashes, fixed issues in the acpi_extlog
and copy_early_mem interfaces, improving robustness when handling early
memory.

Link: https://lkml.kernel.org/r/20241212101004.1544070-1-guoweikang.kernel@gmail.com
Signed-off-by: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Julian Stecklina <julian.stecklina@cyberus-technology.de>
Cc: Kevin Loughlin <kevinloughlin@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c             |    5 ++++-
 drivers/acpi/acpi_extlog.c          |   14 ++++++++++++++
 include/asm-generic/early_ioremap.h |    2 +-
 mm/early_ioremap.c                  |    8 +++++++-
 4 files changed, 26 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/setup.c~mm-early_ioremap-add-null-pointer-checks-to-prevent-null-pointer-dereference
+++ a/arch/x86/kernel/setup.c
@@ -259,6 +259,7 @@ static void __init relocate_initrd(void)
 	u64 ramdisk_image = get_ramdisk_image();
 	u64 ramdisk_size  = get_ramdisk_size();
 	u64 area_size     = PAGE_ALIGN(ramdisk_size);
+	int ret = 0;
 
 	/* We need to move the initrd down into directly mapped mem */
 	u64 relocated_ramdisk = memblock_phys_alloc_range(area_size, PAGE_SIZE, 0,
@@ -272,7 +273,9 @@ static void __init relocate_initrd(void)
 	printk(KERN_INFO "Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
 	       relocated_ramdisk, relocated_ramdisk + ramdisk_size - 1);
 
-	copy_from_early_mem((void *)initrd_start, ramdisk_image, ramdisk_size);
+	ret = copy_from_early_mem((void *)initrd_start, ramdisk_image, ramdisk_size);
+	if (ret)
+		panic("Copy RAMDISK failed\n");
 
 	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
 		" [mem %#010llx-%#010llx]\n",
--- a/drivers/acpi/acpi_extlog.c~mm-early_ioremap-add-null-pointer-checks-to-prevent-null-pointer-dereference
+++ a/drivers/acpi/acpi_extlog.c
@@ -251,6 +251,10 @@ static int __init extlog_init(void)
 	}
 
 	extlog_l1_hdr = acpi_os_map_iomem(l1_dirbase, l1_hdr_size);
+	if (!extlog_l1_hdr) {
+		rc = -ENOMEM;
+		goto err_release_l1_hdr;
+	}
 	l1_head = (struct extlog_l1_head *)extlog_l1_hdr;
 	l1_size = l1_head->total_len;
 	l1_percpu_entry = l1_head->entries;
@@ -268,6 +272,10 @@ static int __init extlog_init(void)
 		goto err;
 	}
 	extlog_l1_addr = acpi_os_map_iomem(l1_dirbase, l1_size);
+	if (!extlog_l1_addr) {
+		rc = -ENOMEM;
+		goto err_release_l1_dir;
+	}
 	l1_entry_base = (u64 *)((u8 *)extlog_l1_addr + l1_hdr_size);
 
 	/* remap elog table */
@@ -279,6 +287,10 @@ static int __init extlog_init(void)
 		goto err_release_l1_dir;
 	}
 	elog_addr = acpi_os_map_iomem(elog_base, elog_size);
+	if (!elog_addr) {
+		rc = -ENOMEM;
+		goto err_release_elog;
+	}
 
 	rc = -ENOMEM;
 	/* allocate buffer to save elog record */
@@ -300,6 +312,8 @@ err_release_l1_dir:
 	if (extlog_l1_addr)
 		acpi_os_unmap_iomem(extlog_l1_addr, l1_size);
 	release_mem_region(l1_dirbase, l1_size);
+err_release_l1_hdr:
+	release_mem_region(l1_dirbase, l1_hdr_size);
 err:
 	pr_warn(FW_BUG "Extended error log disabled because of problems parsing f/w tables\n");
 	return rc;
--- a/include/asm-generic/early_ioremap.h~mm-early_ioremap-add-null-pointer-checks-to-prevent-null-pointer-dereference
+++ a/include/asm-generic/early_ioremap.h
@@ -35,7 +35,7 @@ extern void early_ioremap_reset(void);
 /*
  * Early copy from unmapped memory to kernel mapped memory.
  */
-extern void copy_from_early_mem(void *dest, phys_addr_t src,
+extern int copy_from_early_mem(void *dest, phys_addr_t src,
 				unsigned long size);
 
 #else
--- a/mm/early_ioremap.c~mm-early_ioremap-add-null-pointer-checks-to-prevent-null-pointer-dereference
+++ a/mm/early_ioremap.c
@@ -245,7 +245,10 @@ early_memremap_prot(resource_size_t phys
 
 #define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
 
-void __init copy_from_early_mem(void *dest, phys_addr_t src, unsigned long size)
+/*
+ * If no empty slot, handle that and return -ENOMEM.
+ */
+int __init copy_from_early_mem(void *dest, phys_addr_t src, unsigned long size)
 {
 	unsigned long slop, clen;
 	char *p;
@@ -256,12 +259,15 @@ void __init copy_from_early_mem(void *de
 		if (clen > MAX_MAP_CHUNK - slop)
 			clen = MAX_MAP_CHUNK - slop;
 		p = early_memremap(src & PAGE_MASK, clen + slop);
+		if (!p)
+			return -ENOMEM;
 		memcpy(dest, p + slop, clen);
 		early_memunmap(p, clen + slop);
 		dest += clen;
 		src += clen;
 		size -= clen;
 	}
+	return 0;
 }
 
 #else /* CONFIG_MMU */
_

Patches currently in -mm which might be from guoweikang.kernel@gmail.com are

mm-shmem-refactor-to-reuse-vfs_parse_monolithic_sep-for-option-parsing.patch
mm-early_ioremap-add-null-pointer-checks-to-prevent-null-pointer-dereference.patch

