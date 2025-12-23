Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800F531A558
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 08:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766478478; cv=none; b=Y51+8lUfbt7SqCJXuGnZXNPN7Z5CFBmgw9tPHbg4+NHCHM2NBNg0xfdZwi18S6eIcBWINDOrLbqpfb7E7fMZxdXOen5RYwHKziG7129/QotP1bIN3pEod6lQviCAOdUn6zj89epye5nACoGhHgAiqHxQv384vg6uS6sN68ftvfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766478478; c=relaxed/simple;
	bh=WXw5fq2wYKphRPWis1VVKLaNz+q5czAAjdTID29mkAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GcE3RKnsk6hCHTnU8igCdS8igVtYO/lXJo3gBmMASQiCTaSQjUQgG7fSp7D8Vx9Vv9uiX5csbSJPvKeQx455u3ELo1e5BPZm/9hCmKn/qEp1oM38URqHHosrar6miz4MPkNqtKfEC3r5pFpecb8ZVtLr2zc+XR4P3+qfbGSzAVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BlCa9uOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BlCa9uOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA383C113D0;
	Tue, 23 Dec 2025 08:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766478478;
	bh=WXw5fq2wYKphRPWis1VVKLaNz+q5czAAjdTID29mkAE=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=BlCa9uOdcxekjHBdA3niK1I391fTQZq+fmJYiuC+98KrsNI8NlZEhDYXLdzzH2Ryc
	 NYb6n2vKJO4pLIGE1a4FRX18xztfH8oPat7q3dtny3qv8CZwsKsWjIHbJO7U0j6Sc1
	 KKlMfA8u9bKsHYgbBwCsjbDTQB+NrlCjD66/ULLJRrsbtQWcfDAy0PKyblRaH826M6
	 ExfkCCwrw3cabxYqqK+E+UsxkOFEaCXx3ELaaAitMr4WyeNG2veoD4IhWjzEieHnqh
	 QplWf6+SX43StEjlJjuxlXNAHFSt3tSor0TgcfoanyJGxmuXbKDpdlL/6PRHfHLztf
	 xWZSpz9JjmiXQ==
Message-ID: <8f111584-51ab-4df2-a7f4-966ec400139d@kernel.org>
Date: Tue, 23 Dec 2025 09:27:52 +0100
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + mm-fix-huge-page-table-not-free-after-memory-unplug.patch added
 to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 rppt@kernel.org, jgg@nvidia.com, baolu.lu@linux.intel.com,
 yuan1.liu@intel.com, Dave Hansen <dave.hansen@linux.intel.com>
References: <20251223011522.BA78DC4CEF1@smtp.kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251223011522.BA78DC4CEF1@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/23/25 02:15, Andrew Morton wrote:
> The patch titled
>       Subject: mm: fix huge page table not free after memory unplug
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       mm-fix-huge-page-table-not-free-after-memory-unplug.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-huge-page-table-not-free-after-memory-unplug.patch
> 
> This patch will later appear in the mm-hotfixes-unstable branch at
>      git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>     a) Consider who else should be cc'ed
>     b) Prefer to cc a suitable mailing list as well
>     c) Ideally: find the original patch on the mailing list and do a
>        reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Yuan Liu <yuan1.liu@intel.com>
> Subject: mm: fix huge page table not free after memory unplug
> Date: Sun, 21 Dec 2025 23:11:17 -0500
> 
> Newly plugged memory is marked as prot_sethuge via phys_pmd_init without
> setting PG_head.  During memory unplug, free_hugepage_table frees the page
> table as 2M, but pagetable_free handles it as 4K.
> 
> The following test case of memory unplug for a VM [1], tested in the
> environment [2], show that results.
> 
> +-----------------------+------+------+
> |Check System Memory    |Plug  |Unplug|
> |via free -h            |256GB |256GB |
> +-----------------------+------+------+
> | Free 4K page table    |257GB |5.6GB |
> +-----------------------+------+------+
> | Free 2M page table    |257GB |1.7GB |
> +-----------------------+------+------+
> 
> [1] Qemu commands to unhotplug 256G memory for a VM:
>      object_add memory-backend-ram,id=hotmem0,size=256G,share=on
>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>      qom-set vmem1 requested-size 256G (Plug Memory)
>      qom-set vmem1 requested-size 0G (Unplug Memory)
> 
> [2] Hardware     : Intel Icelake server
>      Guest Kernel : v6.19-rc1
>      Qemu         : v9.0.0
> 
> Launch VM:
>      qemu-system-x86_64 -accel kvm -cpu host \
>      -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>      -drive file=./seed.img,format=raw,if=virtio \
>      -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>      -m 2G,slots=10,maxmem=2052472M \
>      -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>      -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>      -nographic -machine q35 \
>      -nic user,hostfwd=tcp::3000-:22
> 
>     Guest kernel auto-onlines newly added memory blocks:
>     echo online > /sys/devices/system/memory/auto_online_blocks
> 
> Link: https://lkml.kernel.org/r/20251222041117.44865-1-yuan1.liu@intel.com
> Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Baolu Lu <baolu.lu@linux.intel.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>   arch/x86/mm/init_64.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/arch/x86/mm/init_64.c~mm-fix-huge-page-table-not-free-after-memory-unplug
> +++ a/arch/x86/mm/init_64.c
> @@ -1028,7 +1028,7 @@ static void __meminit free_pagetable(str
>   		free_reserved_pages(page, nr_pages);
>   #endif
>   	} else {
> -		pagetable_free(page_ptdesc(page));
> +		__free_pages(page, order);

Hm, but this way we are skipping deconstructors, no?

In particular, clearing the kernel flag (ptdesc_clear_kernel()) and not 
handling ASYNC_KERNEL_PGTABLE_FREE correctly.

-- 
Cheers

David
