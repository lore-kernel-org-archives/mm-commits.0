Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF4179DC
	for <mm-commits@vger.kernel.org>; Sun,  4 Feb 2024 07:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707031236; cv=none; b=YWkCi1xJL7xsH1GSxm2htMubk44nisGvRLgn4OXdffke+603//WCLVrpPIXYDbVtPVXN6VrAVZDIg8/u2pfZwEJes8pussqPW8Gixe4Me3m6ajpQW4pVWLWTtKqhTHupBUZn5/a9NqlWyuOhrjXggyDUs8BcfSxMpiI1QXn0DDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707031236; c=relaxed/simple;
	bh=X2asLiB82cizBXQJK7UAeQfl1Dszhrj5maeq2Vh32iU=;
	h=Date:To:From:Subject:Message-Id; b=HDwvr4yZBZ3BK4+X58izOLnmAu64wJc7X7umGDDHaq1LPN8lbmD7+EWagNknG2Fz9W4M54RDfynVcnCnasNZXNBuQOA7rLzup95b/fKWfMbEYgn8TzzJG9E+4z5v8ZDkjOy1gHNDQ7vTnw9xSpndzYWe1WccDfGyFXZ5B7qD40o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i5BJgD9r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i5BJgD9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E591FC433C7;
	Sun,  4 Feb 2024 07:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707031236;
	bh=X2asLiB82cizBXQJK7UAeQfl1Dszhrj5maeq2Vh32iU=;
	h=Date:To:From:Subject:From;
	b=i5BJgD9rvfTHKgZHI8x1z0fRFoV/qMPK4f/Jq+7sqVtON6PdkX7pftrDC8RiY4jbn
	 63maySIf+Re1CKH2FdRAp03HoVS9fdV9jIu7R9KicwWvY1/pErsjsUkDRzqoXEdRf9
	 CObT+SAMr1U+BsKgdNF/TkM4VMoRTqCMSnRbPMg8=
Date: Sat, 03 Feb 2024 23:20:35 -0800
To: mm-commits@vger.kernel.org,yang.lee@linux.alibaba.com,viro@zeniv.linux.org.uk,sfr@canb.auug.org.au,piliu@redhat.com,nathan@kernel.org,mhklinux@outlook.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch added to mm-unstable branch
Message-Id: <20240204072035.E591FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash: fix building error in generic codes
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch

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
x86-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm64-crash-wrap-crash-dumping-code-into-crash-related-ifdefs-fix.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump.patch
ppc-crash-enforce-kexec-and-kexec_file-to-select-crash_dump-fix.patch
s390-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
sh-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
mips-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
riscv-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arm-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
loongarch-crash-wrap-crash-dumping-code-into-crash-related-ifdefs.patch
arch-crash-move-arch_crash_save_vmcoreinfo-out-to-file-vmcore_infoc.patch
panic-suppress-gnu_printf-warning.patch

