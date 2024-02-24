Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8D74A07
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738967; cv=none; b=Ayf47QyxwOuHV0OfN9IOFA1zrKuFvEe5lY7IjHr6gWDXbzxxmKCzygq/jcugxBZfIMiilOR3AKYy9Ge0XTxUI1SjQi4tPrlfFAjfqix/ukoFQ3wr617t565aUk1HJWIPvxuvi6E0d9VnDVG+bVp7SkR3XHCYQ5tj06lEhJkF1zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738967; c=relaxed/simple;
	bh=kJSZZTBo6A230bSenoF2PPRIJ7fcekA/k80beSmWwYg=;
	h=Date:To:From:Subject:Message-Id; b=RlTspAM71u8xg/17H7FeW1Z+LsmN+39ljSf1AhqUY73JVnIQl/bbIE5EUo62N/NCtrOXo0pdwegbAJOz7eJJ9dLaeoOOKl6liUKcse6IGTcscfOF4SQfyCaUxA8DvznlhPsGb4iYrByRLz3XE09u9yy6njX46qmd/wPWryXjn40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ORp28kZ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ORp28kZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF07C433F1;
	Sat, 24 Feb 2024 01:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708738967;
	bh=kJSZZTBo6A230bSenoF2PPRIJ7fcekA/k80beSmWwYg=;
	h=Date:To:From:Subject:From;
	b=ORp28kZ8yRA/ZwlxGs+pPiuuSC46qt9qjQL5WFRT222U1CScHpiLPCwb1EeLh5g7e
	 0EY8zg9q7R0uJo/2MvV7wG1a8WgukasHYz3nuhBNHlU4B9jQA8f5QAK/owQzWQpEhE
	 dellTrmTOXyHS2gF/PxppyIEY7sZWgYufqrx3ZPM=
Date: Fri, 23 Feb 2024 17:42:46 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch removed from -mm tree
Message-Id: <20240224014247.1EF07C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: crash: fix building error in generic codes
has been removed from the -mm tree.  Its filename was
     arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch

This patch was dropped because it was folded into arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: crash: fix building error in generic codes
Date: Mon, 29 Jan 2024 21:50:32 +0800

Nathan reported some building errors on arm64 as below:

==========
$ curl -LSso .config https://github.com/archlinuxarm/PKGBUILDs/raw/master/core/linux-aarch64/config
$ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux- olddefconfig all
..
aarch64-linux-ld: kernel/kexec_file.o: in function `kexec_walk_memblock.constprop.0':
kexec_file.c:(.text+0x314): undefined reference to `crashk_res'
..
aarch64-linux-ld: drivers/of/kexec.o: in function `of_kexec_alloc_and_setup_fdt':
kexec.c:(.text+0x580): undefined reference to `crashk_res'
..
aarch64-linux-ld: kexec.c:(.text+0x5c0): undefined reference to `crashk_low_res'
==========

On the provided config, it has:
===
CONFIG_VMCORE_INFO=y
CONFIG_KEXEC_CORE=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
===

For these crash related code blocks, they need put inside CONFIG_CRASH_DUMP
ifdeffery scope to avoid building erorr when CONFIG_CRASH_DUMP is not
set.

Link: https://lkml.kernel.org/r/20240129135033.157195-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/all/20240126045551.GA126645@dev-arch.thelio-3990X/T/#u
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/of/kexec.c  |    2 ++
 kernel/kexec_file.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/of/kexec.c~arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix
+++ a/drivers/of/kexec.c
@@ -395,6 +395,7 @@ void *of_kexec_alloc_and_setup_fdt(const
 		if (ret)
 			goto out;
 
+#ifdef CONFIG_CRASH_DUMP
 		/* add linux,usable-memory-range */
 		ret = fdt_appendprop_addrrange(fdt, 0, chosen_node,
 				"linux,usable-memory-range", crashk_res.start,
@@ -410,6 +411,7 @@ void *of_kexec_alloc_and_setup_fdt(const
 			if (ret)
 				goto out;
 		}
+#endif
 	}
 
 	/* add bootargs */
--- a/kernel/kexec_file.c~arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix
+++ a/kernel/kexec_file.c
@@ -540,8 +540,10 @@ static int kexec_walk_memblock(struct ke
 	phys_addr_t mstart, mend;
 	struct resource res = { };
 
+#ifdef CONFIG_CRASH_DUMP
 	if (kbuf->image->type == KEXEC_TYPE_CRASH)
 		return func(&crashk_res, kbuf);
+#endif
 
 	/*
 	 * Using MEMBLOCK_NONE will properly skip MEMBLOCK_DRIVER_MANAGED. See
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmalloc-remove-vmap_area_list.patch
kexec-split-crashkernel-reservation-code-out-from-crash_corec.patch
crash-split-vmcoreinfo-exporting-code-out-from-crash_corec.patch
crash-remove-dependency-of-fa_dump-on-crash_dump.patch
crash-split-crash-dumping-code-out-from-kexec_corec.patch
crash-clean-up-kdump-related-config-items.patch
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix.patch
s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc.patch

