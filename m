Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D389283FDF
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 20:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766520833; cv=none; b=EdCGeYdMgmsc8qA0YJuDzUyTVB79XW1fScahhO6kEUn9RXD58rkMC/aV2p9QQKoWx17SQ8ZrYzxpq1CoE1MVZD10sJ0YqooorXIMhgXSO7rLKmj7XkSaW+Pqe+1C0gEF7G7VSaAerNANYi+qwzxwe1c6fm2albdwvp0HXNWS/oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766520833; c=relaxed/simple;
	bh=aWn6tb/2XTgEv8SlcEh5g5BQHjIYXzXywSO6vpskj1g=;
	h=Date:To:From:Subject:Message-Id; b=V0y39ZrvK8nfRMxEnTY6fjOuPFVnygCzgsgtfexwlBBcP/uZ8e6DXnIHUNUUOPGs3F8PqoX09rFtConCnEUzy2WxVjEqGbIYF77AE4iu/bjjkugG2in+2uxQMyGDafAmZ3BnV7JBWfs9Dqbxr2sveNlIkquZ3RPlzj/OAWfdux0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NCPRVFqT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NCPRVFqT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DADC113D0;
	Tue, 23 Dec 2025 20:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766520833;
	bh=aWn6tb/2XTgEv8SlcEh5g5BQHjIYXzXywSO6vpskj1g=;
	h=Date:To:From:Subject:From;
	b=NCPRVFqT4B0Kp+pjv62z20y5Y/ANfALOs9TIKcvLorKrrY6MZgvuDzlTbZSiqUUJO
	 e4vkmPdADe3EoAUABNk1LykPOe7Jae4j2UcHviNvgg5nS4bt7ASH9V4NDG7cfW9pNY
	 8Z57DleQ1RoKJqzJ29ldJ6BpSAFApbUrRGViCszg=
Date: Tue, 23 Dec 2025 12:13:52 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,jgg@nvidia.com,david@redhat.com,baolu.lu@linux.intel.com,yuan1.liu@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-fix-huge-page-table-not-free-after-memory-unplug.patch removed from -mm tree
Message-Id: <20251223201353.27DADC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix huge page table not free after memory unplug
has been removed from the -mm tree.  Its filename was
     mm-fix-huge-page-table-not-free-after-memory-unplug.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Yuan Liu <yuan1.liu@intel.com>
Subject: mm: fix huge page table not free after memory unplug
Date: Sun, 21 Dec 2025 23:11:17 -0500

Newly plugged memory is marked as prot_sethuge via phys_pmd_init without
setting PG_head.  During memory unplug, free_hugepage_table frees the page
table as 2M, but pagetable_free handles it as 4K.

The following test case of memory unplug for a VM [1], tested in the
environment [2], show that results.

+-----------------------+------+------+
|Check System Memory    |Plug  |Unplug|
|via free -h            |256GB |256GB |
+-----------------------+------+------+
| Free 4K page table    |257GB |5.6GB |
+-----------------------+------+------+
| Free 2M page table    |257GB |1.7GB |
+-----------------------+------+------+

[1] Qemu commands to unhotplug 256G memory for a VM:
    object_add memory-backend-ram,id=hotmem0,size=256G,share=on
    device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
    qom-set vmem1 requested-size 256G (Plug Memory)
    qom-set vmem1 requested-size 0G (Unplug Memory)

[2] Hardware     : Intel Icelake server
    Guest Kernel : v6.19-rc1
    Qemu         : v9.0.0

Launch VM:
    qemu-system-x86_64 -accel kvm -cpu host \
    -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
    -drive file=./seed.img,format=raw,if=virtio \
    -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
    -m 2G,slots=10,maxmem=2052472M \
    -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
    -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
    -nographic -machine q35 \
    -nic user,hostfwd=tcp::3000-:22

   Guest kernel auto-onlines newly added memory blocks:
   echo online > /sys/devices/system/memory/auto_online_blocks

Link: https://lkml.kernel.org/r/20251222041117.44865-1-yuan1.liu@intel.com
Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/mm/init_64.c~mm-fix-huge-page-table-not-free-after-memory-unplug
+++ a/arch/x86/mm/init_64.c
@@ -1028,7 +1028,7 @@ static void __meminit free_pagetable(str
 		free_reserved_pages(page, nr_pages);
 #endif
 	} else {
-		pagetable_free(page_ptdesc(page));
+		__free_pages(page, order);
 	}
 }
 
_

Patches currently in -mm which might be from yuan1.liu@intel.com are


