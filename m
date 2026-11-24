Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795547342;
	b=kuKrd8LD2VlCu+Fkp371G/szNKJnW6iuPtO3wmqMUG7i/My9ZFjHfXjXVsqrlNr8SPza
	 uzAamavYBT2jU+YzP3CvXkpWnVrtFadirA65IixQ8oAYV5ZXUou03XxnDQde0yFVYBf7u
	 qtPtcvP/DjAxnKy1qjWxerqeTW2w/fI7msRgkor7jAQoFhmkOew0NvOZw5C/jO+uWgG2F
	 bh37t/Ux07UJmMzcqGY7MC0xc82aHEBaE9eGq7iXs3/qPvR64kDWhMhWQ2/LZCw15eIbv
	 7t259n4sFJTx31o5B2hhONKawgrDtyz7o78LNdpEMShUIbRFBS3ZmEBx8LE/VqMsRMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795547342;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Gi9pD5i53puE/lMKx3b0NUaEYFknAOuYUU20fljwxFQ=;
	b=2gSW1ahMDgpxiTp4NcztsEcwFTtQjcCcBreW5LIGsXP0U5GAsDXB+QwN28idnhVqF8BJ
	 4DlKsd4OxexVVGzkSLwDFVtJaP5HGgvtDqp2eJWE0eq3qWlnfe38m1n+uKYW2BwPOg1zo
	 pQS3RoqfGzcBnA6wcBJHXcoI4kNerF4E/ig6TBZoHkn0DA3FTscNPLR1GVjHpvHpvXFEf
	 czaBjbcfwL8+PQAp77C/juKus4moroU21K1JryBVxWdvyEeA+JBdJD50NDNwupbT7Lf5z
	 U5tVNOld+j23h+6A/f2yYNt86twI/earjsQd61HRTxOQDtPUzjbuTqt8M36jRlivjDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=X26GaPrz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19820606A326
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 19:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=X26GaPrz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600741F000CA;
	Tue, 24 Nov 2026 19:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795547341;
	bh=Gi9pD5i53puE/lMKx3b0NUaEYFknAOuYUU20fljwxFQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=X26GaPrzHGsRo1RTgkoqtzsqWKhyGNmIId02yj2nR6LKUrNyix4vF0SDFtJR2epv7
	 +GL4rtYzz/eUKg4rdXevnYEMkz19M8WG+vOaCsVsMMdgrjOHHkoUpPSrdWdiu/MGEz
	 vl36lPEO2JDpDw5UzLc6Q9qSenEhwP9vTpHEpC0c=
Date: Tue, 24 Nov 2026 11:09:00 -0800
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
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-6-0b0d99d655f9@kernel.org>
References: <20261124-late-2026-mmap_prepare-v2-6-0b0d99d655f9@kernel.org>
Subject: + selinuxfs-convert-mmap-hooks-to-mmap_prepare.patch added to mm-new branch
Message-Id: <20261124190901.600741F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selinuxfs: convert mmap hooks to mmap_prepare
has been added to the -mm mm-new branch.  Its filename is
     selinuxfs-convert-mmap-hooks-to-mmap_prepare.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selinuxfs-convert-mmap-hooks-to-mmap_prepare.patch

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
Subject: selinuxfs: convert mmap hooks to mmap_prepare
Date: Tue, 24 Nov 2026 14:02:49 +0000

Move from the deprecated mmap hook to the new mmap_prepare hook for the
policy and status files.

The policy file only sets VMA flags and operations. The status file remaps
a single page, so use the PFN remap mmap action to do so.

Link: https://patch.msgid.link/20261124-late-2026-mmap_prepare-v2-6-0b0d99d655f9@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Paul Moore <paul@paul-moore.com>
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

 security/selinux/selinuxfs.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/security/selinux/selinuxfs.c~selinuxfs-convert-mmap-hooks-to-mmap_prepare
+++ a/security/selinux/selinuxfs.c
@@ -236,27 +236,25 @@ static ssize_t sel_read_handle_status(st
 				       sizeof(struct selinux_kernel_status));
 }
 
-static int sel_mmap_handle_status(struct file *filp,
-				  struct vm_area_struct *vma)
+static int sel_mmap_prepare_handle_status(struct vm_area_desc *desc)
 {
-	struct page    *status = filp->private_data;
-	unsigned long	size = vma->vm_end - vma->vm_start;
+	struct page    *status = desc->file->private_data;
 
 	BUG_ON(!status);
 
 	/* only allows one page from the head */
-	if (vma->vm_pgoff > 0 || size != PAGE_SIZE)
+	if (desc->pgoff > 0 || vma_desc_size(desc) != PAGE_SIZE)
 		return -EIO;
 
-	return remap_pfn_range(vma, vma->vm_start,
-			       page_to_pfn(status),
-			       size, vma->vm_page_prot);
+	mmap_action_remap_full(desc, page_to_pfn(status));
+
+	return 0;
 }
 
 static const struct file_operations sel_handle_status_ops = {
 	.open		= sel_open_handle_status,
 	.read		= sel_read_handle_status,
-	.mmap		= sel_mmap_handle_status,
+	.mmap_prepare	= sel_mmap_prepare_handle_status,
 	.llseek		= generic_file_llseek,
 };
 
@@ -419,10 +417,10 @@ static const struct vm_operations_struct
 	.page_mkwrite = sel_mmap_policy_fault,
 };
 
-static int sel_mmap_policy(struct file *filp, struct vm_area_struct *vma)
+static int sel_mmap_prepare_policy(struct vm_area_desc *desc)
 {
-	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_ops = &sel_mmap_policy_ops;
+	vma_desc_set_flags(desc, VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT);
+	desc->vm_ops = &sel_mmap_policy_ops;
 
 	return 0;
 }
@@ -430,7 +428,7 @@ static int sel_mmap_policy(struct file *
 static const struct file_operations sel_policy_ops = {
 	.open		= sel_open_policy,
 	.read		= sel_read_policy,
-	.mmap		= sel_mmap_policy,
+	.mmap_prepare	= sel_mmap_prepare_policy,
 	.release	= sel_release_policy,
 	.llseek		= generic_file_llseek,
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

