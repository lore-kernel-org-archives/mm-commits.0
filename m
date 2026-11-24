Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795547359;
	b=SSMZHPQPvtj6h86uW0aTOaXrWZUhRREXJsoPjHvzRkwxm/IZzwUgenqNx8IhUeLKjsSw
	 oiDYg39TvLfx7rytA6lAFk+M69oJbfNoGsFpWbqqZEi3qAKDY2JC93cCc/QN+xOdPwjkW
	 NqWOBodaXlkOcxZm6iwmgZCjTyPkXt11fYvF+GN9Ex/GIB9NNvmR2YOF5IrESOu6sG4a8
	 cm5k2FbC5zCZVTZAWPnwnoKoHVs9BQnMSrVNRpHRKYgr53pgmzAfLC8tiKUkpzS1bLw2U
	 ZFrrMQBb4GG+5Pj1GjwqwyaoHtRSAuVOo/E96PwfeQ+tsyrIiAiVIvPVu19tuD2D7Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795547359;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=JBefsFVGyW2Wk4HfIbv6VCtD0PQkosGnL5rpCarJVZI=;
	b=sdbc4drAjXUWuRF8EsqqX4nIBkmVuywirla/XFvpser4fbEc1uk/I2LAfgZ1FXjuNl7j
	 Rgyx8GrOTeEY/Y2F3PCMoUb/fGC2DSuCOZkjtMrEKfWOvyZU3ojjvUUC/ON2WaohQhTnP
	 ZprTRV4wxcDOFK9PiqEDDcArvaUcgaLQhGShcHXJupWspP4/unVRoUfykfjXonrA5tkol
	 EIbGlt2QlJ5q4MzxanWoyQ6ZgS46Y8A+WmMDSKWNHcoE7a+E14bbA9Nm42QGrNyBB9j7F
	 WwfDQ+Cms+d9FaG8NSQ8/AffEZkqU4IXtxb2iEEdfxyA60jpcgSvl7s8z9fiCS4R7Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=r10aOBuA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB628606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 19:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=r10aOBuA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12531F000C6;
	Tue, 24 Nov 2026 19:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795547359;
	bh=JBefsFVGyW2Wk4HfIbv6VCtD0PQkosGnL5rpCarJVZI=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=r10aOBuASk7zPcfdeXynbpuvGLFGVioVzvWG2DZWZZH2KcB27BI/4M+vttbOKojBu
	 i8GpOlB3Yk2RtxVprYGiFMhMJTtQch3exeSPtI3qTPllq4KHE7nbbm4I04OR8Ofvbf
	 EgZ/37eusPufTIXfFiXTk+K5GSMKxVWm7meGXQFQ=
Date: Tue, 24 Nov 2026 11:09:18 -0800
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
	dwmw2@infradead.org,decui@microsoft.com,davem@davemloft.net,
	dave.hansen@linux.intel.com,chleroy@kernel.org,bp@alien8.de,
	billy_tsai@aspeedtech.com,arnd@arndb.de,andrew+netdev@lunn.ch,
	andrew@codeconstruct.com.au,andersson@kernel.org,abel.vesa@oss.qualcomm.com,
	ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-12-0b0d99d655f9@kernel.org>
References: <20261124-late-2026-mmap_prepare-v2-12-0b0d99d655f9@kernel.org>
Subject: + ptp-vmclock-convert-mmap-hook-to-mmap_prepare.patch added to mm-new branch
Message-Id: <20261124190918.F12531F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: ptp: vmclock: convert mmap hook to mmap_prepare
has been added to the -mm mm-new branch.  Its filename is
     ptp-vmclock-convert-mmap-hook-to-mmap_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ptp-vmclock-convert-mmap-hook-to-mmap_prepare.patch

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
Subject: ptp: vmclock: convert mmap hook to mmap_prepare
Date: Tue, 24 Nov 2026 14:02:55 +0000

Move from the deprecated mmap hook to the new mmap_prepare hook, using the
I/O PFN remap mmap action to map the clock page and retaining the -EAGAIN
error on failure via the action error override.

Link: https://patch.msgid.link/20261124-late-2026-mmap_prepare-v2-12-0b0d99d655f9@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Woodhouse <dwmw@amazon.co.uk>
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
Cc: David Woodhouse <dwmw2@infradead.org>
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

 drivers/ptp/ptp_vmclock.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/ptp/ptp_vmclock.c~ptp-vmclock-convert-mmap-hook-to-mmap_prepare
+++ a/drivers/ptp/ptp_vmclock.c
@@ -364,27 +364,26 @@ struct vmclock_file_state {
 	atomic_t seq;
 };
 
-static int vmclock_miscdev_mmap(struct file *fp, struct vm_area_struct *vma)
+static int vmclock_miscdev_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct vmclock_file_state *fst = fp->private_data;
+	struct vmclock_file_state *fst = desc->file->private_data;
 	struct vmclock_state *st = fst->st;
 
-	if ((vma->vm_flags & (VM_READ|VM_WRITE)) != VM_READ)
+	if (!vma_desc_test(desc, VMA_READ_BIT) ||
+	    vma_desc_test(desc, VMA_WRITE_BIT))
 		return -EROFS;
 
 	/*
 	 * Restrict the read-only mapping so it cannot be upgraded to
 	 * writable later with mprotect().
 	 */
-	vm_flags_clear(vma, VM_MAYWRITE);
+	vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
 
-	if (vma->vm_end - vma->vm_start != PAGE_SIZE || vma->vm_pgoff)
+	if (vma_desc_size(desc) != PAGE_SIZE || desc->pgoff)
 		return -EINVAL;
 
-	if (io_remap_pfn_range(vma, vma->vm_start,
-			       st->res.start >> PAGE_SHIFT, PAGE_SIZE,
-			       vma->vm_page_prot))
-		return -EAGAIN;
+	mmap_action_ioremap_full(desc, st->res.start >> PAGE_SHIFT);
+	desc->action.error_override = -EAGAIN;
 
 	return 0;
 }
@@ -484,7 +483,7 @@ static const struct file_operations vmcl
 	.owner = THIS_MODULE,
 	.open = vmclock_miscdev_open,
 	.release = vmclock_miscdev_release,
-	.mmap = vmclock_miscdev_mmap,
+	.mmap_prepare = vmclock_miscdev_mmap_prepare,
 	.read = vmclock_miscdev_read,
 	.poll = vmclock_miscdev_poll,
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

