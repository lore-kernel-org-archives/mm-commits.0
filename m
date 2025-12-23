Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941D6481DD
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 01:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766452523; cv=none; b=DvW9gxBOkYFQs5SfTw7gh9lySwGG2VxH/mNtFveY+rY2nFL3l6YavZQt4Suf3AOhIfInhIF1THOjO+stZ0oaOjjibGq3gE5lz5R11dny9TDKXNam/FRkrbVjQpiqneGIZg4JVzew0OkEdaFz3ETmIDcPqAHm+kUjpNt9DjoQ8q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766452523; c=relaxed/simple;
	bh=B6aNXnLm3KbN3VNN7rw4C8ud0G7dW3SNRxDT4d0Zs5c=;
	h=Date:To:From:Subject:Message-Id; b=lRKM4qIHt6zwRDjUbAmgnPr48N3FaKeOdA2hfbRaYXJ4j5Wkn357Sw8tkyMtfK6xLVU2Vbe+fy4Rfa8s+4MIjTEzS0KFJ9803T/e3Q4Yj7i3MPoxYDNIEKCox68KflXX8oQEqoKT+6wfFojqXap0YidcG8r2g/vrrONtEKsL3hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yl9yiZhl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yl9yiZhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA78DC4CEF1;
	Tue, 23 Dec 2025 01:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766452522;
	bh=B6aNXnLm3KbN3VNN7rw4C8ud0G7dW3SNRxDT4d0Zs5c=;
	h=Date:To:From:Subject:From;
	b=yl9yiZhl+qEWVwbjb5z8BkudvrmjCiygQSb+sTcWugBCaUr8vibprOHToKKP1litQ
	 VXivSlnpLcun8rXY90l+siMooGxNG/dmey+eBL8D6OQQDD1aV0qXIgwO3fIoKu+vk9
	 oWT4wXXgDQ1gsavJHR/2xVm/7J0DLI2UOzae/i20=
Date: Mon, 22 Dec 2025 17:15:22 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,jgg@nvidia.com,david@redhat.com,baolu.lu@linux.intel.com,yuan1.liu@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-huge-page-table-not-free-after-memory-unplug.patch added to mm-hotfixes-unstable branch
Message-Id: <20251223011522.BA78DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix huge page table not free after memory unplug
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-huge-page-table-not-free-after-memory-unplug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-huge-page-table-not-free-after-memory-unplug.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-fix-huge-page-table-not-free-after-memory-unplug.patch

