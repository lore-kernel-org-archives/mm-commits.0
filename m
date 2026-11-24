Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795547356;
	b=wb9Jh8/uHYzjs9ZOUP4SDUrDaMiYaqEVV1HuqypXCsO1sci3pG2MOUGMrcUtpqfiZ3Sh
	 QP2AXUx1RUdfZh/pxfFPpuq0UWMP4/LQs5EjF2vXInbIgxvG4tmKA1n7gnC+5/JHt8ati
	 yVt0T3YJWmVp8i2xA4Z5crlN7YwdDutTlLy216Mp9wgkgx70pgsmjpcL7knRiHLoHKSR5
	 C9cyVhRaGpnnzMnu+oLXq5775VlK8uey6/dighCZMmhpoXHWPN1OUkFvpaFk5oItNcqtA
	 nZU0WRwGVFqyg7nwfdFfPeeP5WuO2bmlK1YhILfGZ1REG5rKlLsn3ocQV0RUl0T0XxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795547356;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=DjklhRT2LsCPuTRZhxLdmjDCjzu0JHr0xSBzs4YMOqE=;
	b=K//UokQhnwqsv1SBq1GdQDVqXjReyJCQv0j42RBytU99bwXbOwIpFrSxd1LwhbjkwXKy
	 G6Sj2UkUuTe4ck/EFfH8KU1Liaaf1wBin7a8fIBgxBT7IXRNfkEZfko5F4Zfup8/wX6IM
	 xBlMrkDiXXpSksTC/Pjq8p2OvYWtTnefsxM1asL8/w1AHymefbqd2IS41dqQXDYKmyBWW
	 9dG9tacYyNPUVE2+0Sq3gXZBNgaoxodQn4NXRtvR/d+M9jOCGciJ9hZ3cb+BcFn8ADUvF
	 nZhF8ESNKIOEp4NxULfPEwAbGrlgBIpa1oXcIaWWJj+Zb2UnaDorpUEggGmjTCcoIfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pHXOBfCa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEA9606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 19:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pHXOBfCa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C75F1F000C4;
	Tue, 24 Nov 2026 19:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795547356;
	bh=DjklhRT2LsCPuTRZhxLdmjDCjzu0JHr0xSBzs4YMOqE=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=pHXOBfCaFVkV5DNA5bnYYJHWXyWKC5LRt6GTgs5Oqxht8abcf32FMkAJmKEZ8+3JC
	 ZEdhBvO2nuq5+P2FprsbNlpy57kHqCbEkEHEFfPSECgzO1TWjjXVgHjD+ujPGiy1xs
	 vk2dT8Ud47k8qZkw9QxYhJsIttc60hagBMF+7v54=
Date: Tue, 24 Nov 2026 11:09:16 -0800
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,
	tglx@kernel.org,sumit.garg@kernel.org,stephen.smalley.work@gmail.com,
	sstabellini@kernel.org,sshegde@linux.ibm.com,scott.branden@broadcom.com,
	ryan_chen@aspeedtech.com,ritesh.list@gmail.com,richardcochran@gmail.com,
	paul@paul-moore.com,pabeni@redhat.com,omosnacek@gmail.com,
	oleksandr_tyshchenko@epam.com,npiggin@gmail.com,mst@redhat.com,
	mpe@ellerman.id.au,mingo@redhat.com,mhklinux@outlook.com,maddy@linux.ibm.com,
	kuba@kernel.org,konradybcio@kernel.org,kameroncarr@linux.microsoft.com,
	joel@jms.id.au,jgross@suse.com,jens.wiklander@oss.qualcomm.com,
	jenswi@kernel.org,jasowangio@gmail.com,jarkko@kernel.org,jack@suse.cz,
	hpa@zytor.com,haiyangz@microsoft.com,gregkh@linuxfoundation.org,
	eperezma@redhat.com,edumazet@kernel.org,dwmw@amazon.co.uk,
	decui@microsoft.com,davem@davemloft.net,dave.hansen@linux.intel.com,
	chleroy@kernel.org,bp@alien8.de,billy_tsai@aspeedtech.com,arnd@arndb.de,
	andrew+netdev@lunn.ch,andrew@codeconstruct.com.au,andersson@kernel.org,
	abel.vesa@oss.qualcomm.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-11-0b0d99d655f9@kernel.org>
References: <20261124-late-2026-mmap_prepare-v2-11-0b0d99d655f9@kernel.org>
Subject: + misc-bcm-vk-convert-mmap-hook-to-mmap_prepare.patch added to mm-new branch
Message-Id: <20261124190916.7C75F1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: misc: bcm-vk: convert mmap hook to mmap_prepare
has been added to the -mm mm-new branch.  Its filename is
     misc-bcm-vk-convert-mmap-hook-to-mmap_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/misc-bcm-vk-convert-mmap-hook-to-mmap_prepare.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: misc: bcm-vk: convert mmap hook to mmap_prepare
Date: Tue, 24 Nov 2026 14:02:54 +0000

Move from the deprecated mmap hook to the new mmap_prepare hook, using the
I/O PFN remap mmap action to map the BAR.

Link: https://patch.msgid.link/20261124-late-2026-mmap_prepare-v2-11-0b0d99d655f9@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowangio@gmail.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Ondrej Mosnáček <omosnacek@gmail.com>
Cc: Joel Stanley <joel@jms.id.au>
Cc: Andrew Jeffery <andrew@codeconstruct.com.au>
Cc: Ryan Chen <ryan_chen@aspeedtech.com>
Cc: Billy Tsai <billy_tsai@aspeedtech.com>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Jens Wiklander <jenswi@kernel.org>
Cc: Sumit Garg <sumit.garg@kernel.org>
Cc: Scott Branden <scott.branden@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: Kameron Carr <kameroncarr@linux.microsoft.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>

 drivers/misc/bcm-vk/bcm_vk_dev.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/misc/bcm-vk/bcm_vk_dev.c~misc-bcm-vk-convert-mmap-hook-to-mmap_prepare
+++ a/drivers/misc/bcm-vk/bcm_vk_dev.c
@@ -1201,9 +1201,9 @@ err_exit:
 	return ret;
 }
 
-static int bcm_vk_mmap(struct file *file, struct vm_area_struct *vma)
+static int bcm_vk_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct bcm_vk_ctx *ctx = file->private_data;
+	struct bcm_vk_ctx *ctx = desc->file->private_data;
 	struct bcm_vk *vk = container_of(ctx->miscdev, struct bcm_vk, miscdev);
 	unsigned long pg_size;
 
@@ -1212,16 +1212,16 @@ static int bcm_vk_mmap(struct file *file
 
 	pg_size = ((pci_resource_len(vk->pdev, VK_MMAPABLE_BAR) - 1)
 		    >> PAGE_SHIFT) + 1;
-	if (vma->vm_pgoff + vma_pages(vma) > pg_size)
+	if (desc->pgoff + vma_desc_pages(desc) > pg_size)
 		return -EINVAL;
 
-	vma->vm_pgoff += (pci_resource_start(vk->pdev, VK_MMAPABLE_BAR)
-			  >> PAGE_SHIFT);
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-
-	return io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
-				  vma->vm_end - vma->vm_start,
-				  vma->vm_page_prot);
+	desc->pgoff += (pci_resource_start(vk->pdev, VK_MMAPABLE_BAR)
+			>> PAGE_SHIFT);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
+
+	mmap_action_ioremap_full(desc, desc->pgoff);
+
+	return 0;
 }
 
 static long bcm_vk_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
@@ -1262,7 +1262,7 @@ static const struct file_operations bcm_
 	.write = bcm_vk_write,
 	.poll = bcm_vk_poll,
 	.release = bcm_vk_release,
-	.mmap = bcm_vk_mmap,
+	.mmap_prepare = bcm_vk_mmap_prepare,
 	.unlocked_ioctl = bcm_vk_ioctl,
 };
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-msync-return-enomem-if-page-aligned-length-overflows.patch
mm-vma-drop-mm-asynchronously-in-vma_start_read.patch
mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch
mm-mmap-free-gathered-pages-before-mmf_oom_skip.patch
percpu-fix-contig-hints-that-are-too-low.patch
percpu-search-the-whole-reserved-chunk.patch
mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t.patch
mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t.patch
mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t.patch
fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch
fs-coredump-convert-vma_dump_size-to-use-vma_flags_t.patch
uprobes-convert-vma-flag-tests-to-use-vma_flags_t.patch
perf-convert-vma-flag-tests-to-use-vma_flags_t.patch
selinux-convert-vma-flag-tests-to-use-vma_flags_t.patch
apparmor-convert-vma-flag-tests-to-use-vma_flags_t.patch
ima-convert-vma-flag-tests-to-use-vma_flags_t.patch
ipe-convert-vma-flag-tests-to-use-vma_flags_t.patch
xen-privcmd-convert-mmap-hook-to-mmap_prepare.patch
kvm-ppc-book3s-convert-spapr-tce-mmap-hook-to-mmap_prepare.patch
mshv_vtl-convert-mmap-hooks-to-mmap_prepare.patch
x86-sgx-convert-vepc-mmap-hook-to-mmap_prepare.patch
udf-convert-mmap-hook-to-mmap_prepare.patch
selinuxfs-convert-mmap-hooks-to-mmap_prepare.patch
xen-convert-xenstore-interface-mmap-hooks-to-mmap_prepare.patch
soc-aspeed-convert-lpc-and-p2a-control-mmap-hooks-to-mmap_prepare.patch
soc-qcom-rmtfs_mem-convert-mmap-hook-to-mmap_prepare.patch
tee-convert-shm-mmap-hook-to-mmap_prepare.patch
misc-bcm-vk-convert-mmap-hook-to-mmap_prepare.patch
ptp-vmclock-convert-mmap-hook-to-mmap_prepare.patch
vhost-vdpa-convert-mmap-hook-to-mmap_prepare.patch

