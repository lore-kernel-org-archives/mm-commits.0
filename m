Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795547348;
	b=38noVY9uJUHlYIA9ApGWZkVreTxbZTxDJ3NfWkUQD4I1hfEGwM1dpHuX/Weiehjm5zCO
	 bt2MojA4SHIz4mpJehXaKYrXAr7eauE5YE1qtJ1KCpkB4XRcOWdf5NFU/Ug8ViwcPHUNF
	 q1V/Et2T122X/6hUZDA/OavG5QWvgc8IxChlpYGWYy0OFagdp8wySatxnRPIjt3DKPlGs
	 +Z5Pt/wxfSlFzJJs+dACem6LgTarhNnicGgmuzKVUDyh+MfX/rnlzxyOxIx/6vbBtHExN
	 ALIkJj6GrY+Fk86KZCCeUWvN2XuiNGKQzwvAc/RUfYfLEq4+9RI+VTwXZWHu7+BiMfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795547348;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=g1V0rv313k8k0f5rGbXeZi+bmmYs6UFfRvVJBiak/VM=;
	b=0R8WdLzQRlKoGOcsBOlza3eeQzbqTbpxXkt21xwcg3GFS9KEyWoiqN85tO/67K1V8EWZ
	 HgnYNdqPm8d6vhHE4kwNBOeFStbznb9s3cj+8BOfE2BTeBCDDE7chIBozJ02Ikd0lg4Go
	 gLhzvRqzTN6RiTtUZHGFztaYPCnKviZXtnuV//UgrHETBPCe+SU7Lr5oNrUkjcFg2xFuU
	 0akiuBnJRWS8Kc4s1X7shL17i3ViXHEm5vY06FdRyNIApU9kpBF/m+O1pCYmxQFMdWECN
	 AnhQ4E3fuc7hlB8ZDpbDFT0jAO3E9XCujK8q9XTRx9OqAInxCbb+H9aEqXB5EpBo9kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xjdqfhTI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444F6606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 19:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=xjdqfhTI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744771F000C4;
	Tue, 24 Nov 2026 19:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795547347;
	bh=g1V0rv313k8k0f5rGbXeZi+bmmYs6UFfRvVJBiak/VM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=xjdqfhTIj45CLSNUXpS4d8HxBNnApYC2Ios6uvIGYuxFKfLhIrqNkoq4AxsWldPYm
	 d+wMW3k2qn1Vr4Ehj8wnxMBEc7aafNxePrY2fDG7EtE1lfrABWLsO+iWkwJB1WxLoq
	 Vt88mysrPfdMN2OABbIJvE43iorCIczDn/kPrF3I=
Date: Tue, 24 Nov 2026 11:09:07 -0800
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
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-8-0b0d99d655f9@kernel.org>
References: <20261124-late-2026-mmap_prepare-v2-8-0b0d99d655f9@kernel.org>
Subject: + soc-aspeed-convert-lpc-and-p2a-control-mmap-hooks-to-mmap_prepare.patch added to mm-new branch
Message-Id: <20261124190907.744771F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: soc: aspeed: convert LPC and P2A control mmap hooks to mmap_prepare
has been added to the -mm mm-new branch.  Its filename is
     soc-aspeed-convert-lpc-and-p2a-control-mmap-hooks-to-mmap_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/soc-aspeed-convert-lpc-and-p2a-control-mmap-hooks-to-mmap_prepare.patch

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
Subject: soc: aspeed: convert LPC and P2A control mmap hooks to mmap_prepare
Date: Tue, 24 Nov 2026 14:02:51 +0000

Move from the deprecated mmap hook to the new mmap_prepare hook for both
the LPC control and P2A control drivers.

Both remap a range of their reserved memory region, so use the PFN remap
mmap action to do so, retaining the -EAGAIN error on failure via the action
error override.

Link: https://patch.msgid.link/20261124-late-2026-mmap_prepare-v2-8-0b0d99d655f9@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Acked-by: Arnd Bergmann <arnd@arndb.de>
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
Cc: Ryan Chen <ryan_chen@aspeedtech.com>
Cc: Billy Tsai <billy_tsai@aspeedtech.com>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Jens Wiklander <jenswi@kernel.org>
Cc: Sumit Garg <sumit.garg@kernel.org>
Cc: Scott Branden <scott.branden@broadcom.com>
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

 drivers/soc/aspeed/aspeed-lpc-ctrl.c |   20 +++++++++-----------
 drivers/soc/aspeed/aspeed-p2a-ctrl.c |   22 ++++++++--------------
 2 files changed, 17 insertions(+), 25 deletions(-)

--- a/drivers/soc/aspeed/aspeed-lpc-ctrl.c~soc-aspeed-convert-lpc-and-p2a-control-mmap-hooks-to-mmap_prepare
+++ a/drivers/soc/aspeed/aspeed-lpc-ctrl.c
@@ -47,22 +47,20 @@ static struct aspeed_lpc_ctrl *file_aspe
 			miscdev);
 }
 
-static int aspeed_lpc_ctrl_mmap(struct file *file, struct vm_area_struct *vma)
+static int aspeed_lpc_ctrl_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct aspeed_lpc_ctrl *lpc_ctrl = file_aspeed_lpc_ctrl(file);
-	unsigned long vsize = vma->vm_end - vma->vm_start;
-	pgprot_t prot = vma->vm_page_prot;
+	struct aspeed_lpc_ctrl *lpc_ctrl = file_aspeed_lpc_ctrl(desc->file);
 
-	if (vma->vm_pgoff + vma_pages(vma) > lpc_ctrl->mem_size >> PAGE_SHIFT)
+	if (desc->pgoff + vma_desc_pages(desc) >
+	    lpc_ctrl->mem_size >> PAGE_SHIFT)
 		return -EINVAL;
 
 	/* ast2400/2500 AHB accesses are not cache coherent */
-	prot = pgprot_noncached(prot);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
 
-	if (remap_pfn_range(vma, vma->vm_start,
-		(lpc_ctrl->mem_base >> PAGE_SHIFT) + vma->vm_pgoff,
-		vsize, prot))
-		return -EAGAIN;
+	mmap_action_remap_full(desc,
+		(lpc_ctrl->mem_base >> PAGE_SHIFT) + desc->pgoff);
+	desc->action.error_override = -EAGAIN;
 
 	return 0;
 }
@@ -216,7 +214,7 @@ static long aspeed_lpc_ctrl_ioctl(struct
 
 static const struct file_operations aspeed_lpc_ctrl_fops = {
 	.owner		= THIS_MODULE,
-	.mmap		= aspeed_lpc_ctrl_mmap,
+	.mmap_prepare	= aspeed_lpc_ctrl_mmap_prepare,
 	.unlocked_ioctl	= aspeed_lpc_ctrl_ioctl,
 };
 
--- a/drivers/soc/aspeed/aspeed-p2a-ctrl.c~soc-aspeed-convert-lpc-and-p2a-control-mmap-hooks-to-mmap_prepare
+++ a/drivers/soc/aspeed/aspeed-p2a-ctrl.c
@@ -97,29 +97,23 @@ static void aspeed_p2a_disable_bridge(st
 	regmap_update_bits(p2a_ctrl->regmap, SCU180, SCU180_ENP2A, 0);
 }
 
-static int aspeed_p2a_mmap(struct file *file, struct vm_area_struct *vma)
+static int aspeed_p2a_mmap_prepare(struct vm_area_desc *desc)
 {
-	unsigned long vsize;
-	pgprot_t prot;
-	struct aspeed_p2a_user *priv = file->private_data;
+	struct aspeed_p2a_user *priv = desc->file->private_data;
 	struct aspeed_p2a_ctrl *ctrl = priv->parent;
 
 	if (ctrl->mem_base == 0 && ctrl->mem_size == 0)
 		return -EINVAL;
 
-	vsize = vma->vm_end - vma->vm_start;
-	prot = vma->vm_page_prot;
-
-	if (vma->vm_pgoff + vma_pages(vma) > ctrl->mem_size >> PAGE_SHIFT)
+	if (desc->pgoff + vma_desc_pages(desc) > ctrl->mem_size >> PAGE_SHIFT)
 		return -EINVAL;
 
 	/* ast2400/2500 AHB accesses are not cache coherent */
-	prot = pgprot_noncached(prot);
+	desc->page_prot = pgprot_noncached(desc->page_prot);
 
-	if (remap_pfn_range(vma, vma->vm_start,
-		(ctrl->mem_base >> PAGE_SHIFT) + vma->vm_pgoff,
-		vsize, prot))
-		return -EAGAIN;
+	mmap_action_remap_full(desc,
+		(ctrl->mem_base >> PAGE_SHIFT) + desc->pgoff);
+	desc->action.error_override = -EAGAIN;
 
 	return 0;
 }
@@ -308,7 +302,7 @@ static int aspeed_p2a_release(struct ino
 
 static const struct file_operations aspeed_p2a_ctrl_fops = {
 	.owner = THIS_MODULE,
-	.mmap = aspeed_p2a_mmap,
+	.mmap_prepare = aspeed_p2a_mmap_prepare,
 	.unlocked_ioctl = aspeed_p2a_ioctl,
 	.open = aspeed_p2a_open,
 	.release = aspeed_p2a_release,
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

