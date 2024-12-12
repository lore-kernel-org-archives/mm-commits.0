Received: from bout3.ijzerbout.nl (bout3.ijzerbout.nl [136.144.140.114])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE40223C7A
	for <mm-commits@vger.kernel.org>; Thu, 12 Dec 2024 18:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.144.140.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734028832; cv=none; b=hbR2OskZS/pGtq/zzNWILwkM6TcvMMCZFsyVDRDNCZU8/ioi+oZCLpRkG7CmUOH6AFYhk7XygJIZQl30D3SBXQ+KAsmQ165BhSbJghT4jatjrZEMPrpIvjwJHKlsgFuf/8uEUlOVd/a5EBvxdCzPa9xyxOvjwAPC9aMVGdkRWiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734028832; c=relaxed/simple;
	bh=qq5TZcvc33ztQZZZZQGj+c1THQtO9HOjUj2lYzsXpUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FC6wsaulJtBl2g0/zMwVy5B73O/7Clbe7+lC7DGcfNVSlV3+Bt7czHHHuLDBblpXoCdJvMmYwhmqY5y53axWo9KfKZLVV/6uEfMkQYFahcJMuqQ7Vgzn7mFQXNPmZxRd+3wzwz0uJnZQuDLcuP9wyRQh9lf4G/E8weX+yfAQJE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ijzerbout.nl; spf=pass smtp.mailfrom=ijzerbout.nl; dkim=pass (4096-bit key) header.d=ijzerbout.nl header.i=@ijzerbout.nl header.b=bejvWSJT; arc=none smtp.client-ip=136.144.140.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ijzerbout.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ijzerbout.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ijzerbout.nl header.i=@ijzerbout.nl header.b="bejvWSJT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ijzerbout.nl; s=key;
	t=1734028825; bh=qq5TZcvc33ztQZZZZQGj+c1THQtO9HOjUj2lYzsXpUc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bejvWSJTC1vC1GzTOhivkNK6BOEdtBA9AS9A5dgWSr3Oh2oT6XutZAjhYVaUZ9W/E
	 1LdYz+7J+5XULJ0lpqREdbFGdd5MdLI/kUcy2181Yoe8HsXVQJQtuTvywAI4yAh8Qi
	 zCtYDryDLumsF8i2XfipYtjSNJMWtzK42JhXKocrcu/u/ojl3EUNkWG42fLN0tm7qN
	 +bVM4HUWyM94psGPWbTsn4RKLyjWU93m75hzIsTNCMhm80GXs5k1vy+R1Nno9hDuUS
	 eI2G7ZJV0C510IGzv5RgYUMTrF4FzhHt64UcaSCTTAh/7HCMtzfNgrVyfE1lVPyDfx
	 VE4UmDOuoO7GOrVwnnKWLJqD59LM9CsWGIOFa6dxXHh/IKb/xWT2w5Fi1nB7vpvl6R
	 Ezg92h1YqZ93q7HNqsa0MEshoevA4QZBhcFoEpm2BH6jLNsWlPyBOQ4kuadCB0lawE
	 27kiDSVZWUqweclDR/7ebgHnO/tqQgXtO14q+/+F1ujD3IZubJb2XBgb0nMbCRAIS/
	 Vt64qiSFKOF8oKqj8UA46NRO0kabtPzRlYzCCMVdhqA/9Yxz2q8hXdmYrUc7M9QZfS
	 Hh0dul3rsYnbxHATyEsElVnC0pgv5o5s0zK3TXKi4Dh9aPt/wtJpsyAc+a75JPsO5T
	 Z5XdIGu4f5BPVZ4MyxhXxrYs=
Received: from [IPV6:2a10:3781:99:1:1ac0:4dff:fea7:ec3a] (racer.ijzerbout.nl [IPv6:2a10:3781:99:1:1ac0:4dff:fea7:ec3a])
	by bout3.ijzerbout.nl (Postfix) with ESMTPSA id 686F518D74A;
	Thu, 12 Dec 2024 19:40:24 +0100 (CET)
Message-ID: <c7b9f0b1-3643-4f0a-bc95-322bd6d24fd4@ijzerbout.nl>
Date: Thu, 12 Dec 2024 19:40:22 +0100
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] zram: panic when use ext4 over zram
To: caiqingfu <baicaiaichibaicai@gmail.com>, akpm@linux-foundation.org,
 senozhatsky@chromium.org, minchan@kernel.org
Cc: mm-commits@vger.kernel.org, caiqingfu <caiqingfu@ruijie.com.cn>
References: <20241129115735.136033-1-baicaiaichibaicai@gmail.com>
Content-Language: en-US
From: Kees Bakker <kees@ijzerbout.nl>
In-Reply-To: <20241129115735.136033-1-baicaiaichibaicai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Op 29-11-2024 om 12:57 schreef caiqingfu:
> From: caiqingfu <caiqingfu@ruijie.com.cn>
>
> [   52.073080 ] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
> [   52.073511 ] Modules linked in:
> [   52.074094 ] CPU: 0 UID: 0 PID: 3825 Comm: a.out Not tainted 6.12.0-07749-g28eb75e178d3-dirty #3
> [   52.074672 ] Hardware name: linux,dummy-virt (DT)
> [   52.075128 ] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   52.075619 ] pc : obj_malloc+0x5c/0x160
> [   52.076402 ] lr : zs_malloc+0x200/0x570
> [   52.076630 ] sp : ffff80008dd335f0
> [   52.076797 ] x29: ffff80008dd335f0 x28: ffff000004104a00 x27: ffff000004dfc400
> [   52.077319 ] x26: 000000000000ca18 x25: ffff00003fcaf0e0 x24: ffff000006925cf0
> [   52.077785 ] x23: 0000000000000c0a x22: ffff0000032ee780 x21: ffff000006925cf0
> [   52.078257 ] x20: 0000000000088000 x19: 0000000000000000 x18: 0000000000fffc18
> [   52.078701 ] x17: 00000000fffffffd x16: 0000000000000803 x15: 00000000fffffffe
> [   52.079203 ] x14: 000000001824429d x13: ffff000006e84000 x12: ffff000006e83fec
> [   52.079711 ] x11: ffff000006e83000 x10: 00000000000002a5 x9 : ffff000006e83ff3
> [   52.080269 ] x8 : 0000000000000001 x7 : 0000000017e80000 x6 : 0000000000017e80
> [   52.080724 ] x5 : 0000000000000003 x4 : ffff00000402a5e8 x3 : 0000000000000066
> [   52.081081 ] x2 : ffff000006925cf0 x1 : ffff00000402a5e8 x0 : ffff000004104a00
> [   52.081595 ] Call trace:
> [   52.081925 ]  obj_malloc+0x5c/0x160 (P)
> [   52.082220 ]  zs_malloc+0x200/0x570 (L)
> [   52.082504 ]  zs_malloc+0x200/0x570
> [   52.082716 ]  zram_submit_bio+0x788/0x9e8
> [   52.083017 ]  __submit_bio+0x1c4/0x338
> [   52.083343 ]  submit_bio_noacct_nocheck+0x128/0x2c0
> [   52.083518 ]  submit_bio_noacct+0x1c8/0x308
> [   52.083722 ]  submit_bio+0xa8/0x14c
> [   52.083942 ]  submit_bh_wbc+0x140/0x1bc
> [   52.084088 ]  __block_write_full_folio+0x23c/0x5f0
> [   52.084232 ]  block_write_full_folio+0x134/0x21c
> [   52.084524 ]  write_cache_pages+0x64/0xd4
> [   52.084778 ]  blkdev_writepages+0x50/0x8c
> [   52.085040 ]  do_writepages+0x80/0x2b0
> [   52.085292 ]  filemap_fdatawrite_wbc+0x6c/0x90
> [   52.085597 ]  __filemap_fdatawrite_range+0x64/0x94
> [   52.085900 ]  filemap_fdatawrite+0x1c/0x28
> [   52.086158 ]  sync_bdevs+0x170/0x17c
> [   52.086374 ]  ksys_sync+0x6c/0xb8
> [   52.086597 ]  __arm64_sys_sync+0x10/0x20
> [   52.086847 ]  invoke_syscall+0x44/0x100
> [   52.087230 ]  el0_svc_common.constprop.0+0x40/0xe0
> [   52.087550 ]  do_el0_svc+0x1c/0x28
> [   52.087690 ]  el0_svc+0x30/0xd0
> [   52.087818 ]  el0t_64_sync_handler+0xc8/0xcc
> [   52.088046 ]  el0t_64_sync+0x198/0x19c
> [   52.088500 ] Code: 110004a5 6b0500df f9401273 54000160 (f9401664)
> [   52.089097 ] ---[ end trace 0000000000000000  ]---
>
> When using ext4 on zram, the following panic occasionally occurs under
> high memory usage
>
> The reason is that when the handle is obtained using the slow path, it
> will be re-compressed. If the data in the page changes, the compressed
> length may exceed the previous one. Overflow occurred when writing to
> zs_object, which then caused the panic.
>
> Comment the fast path and force the slow path. Adding a large number of
> read and write file systems can quickly reproduce it.
>
> The solution is to re-obtain the handle after re-compression if the
> length is different from the previous one.
>
> Signed-off-by: caiqingfu <caiqingfu@ruijie.com.cn>
> ---
>   drivers/block/zram/zram_drv.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 3dee026988dc..0ca6d55c9917 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1633,6 +1633,7 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
>   	unsigned long alloced_pages;
>   	unsigned long handle = -ENOMEM;
>   	unsigned int comp_len = 0;
> +	unsigned int last_comp_len = 0;
Shouldn't this be `static`?
>   	void *src, *dst, *mem;
>   	struct zcomp_strm *zstrm;
>   	unsigned long element = 0;
> @@ -1664,6 +1665,11 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
>   
>   	if (comp_len >= huge_class_size)
>   		comp_len = PAGE_SIZE;
> +
> +	if (last_comp_len && (last_comp_len != comp_len)) {
> +		zs_free(zram->mem_pool, handle);
> +		handle = (unsigned long)ERR_PTR(-ENOMEM);
> +	}
>   	/*
>   	 * handle allocation has 2 paths:
>   	 * a) fast path is executed with preemption disabled (for
> @@ -1692,8 +1698,10 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
>   		if (IS_ERR_VALUE(handle))
>   			return PTR_ERR((void *)handle);
>   
> -		if (comp_len != PAGE_SIZE)
> +		if (comp_len != PAGE_SIZE) {
> +			last_comp_len = comp_len;
>   			goto compress_again;
> +		}
>   		/*
>   		 * If the page is not compressible, you need to acquire the
>   		 * lock and execute the code below. The zcomp_stream_get()

