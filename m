Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795547327;
	b=pTASpKSuFFaz3iGVt66yL8yALBjOhoF5Fdpy1znmXXGzY7rMWB+hqZ+ajJbgJ9dcF+5L
	 fkald5jCXN3MqPqe/FP1RrahJPJ3Fson100BdAtO3y2cD4EQ0YX66QF1LCTCcBC0mpwiw
	 JXROvLV2zgNR1DR9yEfqIRfUdhroxHD1ed7iqDcFNT+Mo1mSLt9+CDxYeKRYW9fR/hpOe
	 0vclrNAEImsZY6zFeKoOAf+Eq+86TJ8EhtfA79FOkIaxuhwRwxkCq9tcL/cUglsllM9/H
	 0OpaGgi7R+KtLF97DONp1I5q7W6D3R4vabPjKm/rEZFOZGkCf3Ayic/KvzlYqXBRvyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795547327;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=41gyaxHgiKIzx6v97O8PoiA7qBgUHK8/BCwoyD5dvFk=;
	b=Wt/q464aYUlD0iw1eEW/Ek4tzmhLPCfu5vgKMiNYHFLoHm6l1sj+h/DohImFUjcoqbHh
	 vX3gxWYIRBPM7kABGYyoUe68wf/ESn5Z27am4fKDazIYBpxbBIdpdM+uyGpBIs1KkgJ2j
	 coBTzlc47cG8Cjyqn47+R8SUzHnMH1ucZyPI4Ixe32rjuicm/2Iv+DijVQhrjpzYgVPuO
	 /ox4mRF37MgBcS5AbMCWdnPNlv/mu8txGLa7/Lj/0d4TqQSGG827uc0HdB0nhrQEfeevl
	 Jxf4jdQsrsWLFNTHYTjYM2wKIvmCE/L6RAsecMvWfdlGUlsmrscHk1JfHXhw+f0AluQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Nt3pL33i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76067606A329
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 19:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Nt3pL33i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550041F000D0;
	Tue, 24 Nov 2026 19:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795547326;
	bh=41gyaxHgiKIzx6v97O8PoiA7qBgUHK8/BCwoyD5dvFk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=Nt3pL33ixZPEsd1YNGFXzPwFwCtkPC0Ck2vW5bZXyaK/H3TT3UgkOdn47yOJawHQA
	 sdkUuPRrNizVIO1hgX4kbjF5DA91dCwbW+RFYIXSjyIKzGZonfl3688GeOps7Ehrj9
	 TEiVWIoflWyfT7KehIvB0iwbLZLuC8Y/tJgUydYc=
Date: Tue, 24 Nov 2026 11:08:45 -0800
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
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-1-0b0d99d655f9@kernel.org>
References: <20261124-late-2026-mmap_prepare-v2-1-0b0d99d655f9@kernel.org>
Subject: + xen-privcmd-convert-mmap-hook-to-mmap_prepare.patch added to mm-new branch
Message-Id: <20261124190846.550041F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: xen/privcmd: convert mmap hook to mmap_prepare
has been added to the -mm mm-new branch.  Its filename is
     xen-privcmd-convert-mmap-hook-to-mmap_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xen-privcmd-convert-mmap-hook-to-mmap_prepare.patch

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
Subject: xen/privcmd: convert mmap hook to mmap_prepare
Date: Tue, 24 Nov 2026 14:02:44 +0000

Patch series "mm: convert further simple mmap hooks to mmap_prepare", v2.

Continue the conversion of users of the deprecated f_op->mmap callback to
f_op->mmap_prepare. Keep things gentle this cycle by targeting simple
cases.

No functional change intended.


This patch (of 13):

Move from the deprecated mmap hook to the new mmap_prepare hook.

The hook only sets VMA flags and operations. The VMA private data is
already NULL at this point, so we no longer explicitly clear it.

Link: https://lore.kernel.org/20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org
Link: https://patch.msgid.link/20261124-late-2026-mmap_prepare-v2-1-0b0d99d655f9@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Juergen Gross <jgross@suse.com>
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

 drivers/xen/privcmd.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/xen/privcmd.c~xen-privcmd-convert-mmap-hook-to-mmap_prepare
+++ a/drivers/xen/privcmd.c
@@ -1645,14 +1645,13 @@ static const struct vm_operations_struct
 	.fault = privcmd_fault
 };
 
-static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
+static int privcmd_mmap_prepare(struct vm_area_desc *desc)
 {
 	/* DONTCOPY is essential for Xen because copy_page_range doesn't know
 	 * how to recreate these mappings */
-	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTCOPY |
-			 VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_ops = &privcmd_vm_ops;
-	vma->vm_private_data = NULL;
+	vma_desc_set_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTCOPY_BIT,
+			   VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->vm_ops = &privcmd_vm_ops;
 
 	return 0;
 }
@@ -1681,7 +1680,7 @@ const struct file_operations xen_privcmd
 	.unlocked_ioctl = privcmd_ioctl,
 	.open = privcmd_open,
 	.release = privcmd_release,
-	.mmap = privcmd_mmap,
+	.mmap_prepare = privcmd_mmap_prepare,
 };
 EXPORT_SYMBOL_GPL(xen_privcmd_fops);
 
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

