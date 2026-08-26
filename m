Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099903B4EA2;
	Wed, 26 Aug 2026 10:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787740283; cv=none; b=oec9tD8eWfNAHUe0rwPIE691bzprXYwldzPnd7qbKAGTKXP3Bixcoib2IidAgjHsi4erOEC/jDAs6IK0W+ey0nKhaz8jXcY9V0j9MFkeumROa85i8hKiYbxWu9dQ4djudVQyw6d+1BGQ3ooGv3t7Rh82/dzBXwfBP1JDU39e27M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787740283; c=relaxed/simple;
	bh=hqqdGo1QDEs15Pab4lVVBgzRxePexxJRTLJY75HB0yQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HsnYIP1TEZjD2mSyvHaO0BC59Hs2jr8TDWeMrxodPvjlmjzSBDljzG8CydmXQ0WEo8FSBJvBkq8inM3JtfWy3m6z4Pu8kd8LRXipc1/xTG34n9PePde3HEtFPZV9G7SS1FgyJOGU6lmGs2enOA3AxXThMopwoGViETmzDVVgAg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n120gcAi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n120gcAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539261F000E9;
	Wed, 26 Aug 2026 10:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787740281;
	bh=73vonPPn9IO9l5a62vQPbZUrMDKufTNvKRsL8E3ZvdA=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=n120gcAiR+u2j7jVxV4NxRIpm7w5qFPF2f2z4vbFzeOiQvkaCJnjH0kFQystMDfFG
	 J6VZK7szZ3U8k+U0O4GfFYGYuZMVZdgzmThwnfYDxt8GUWdPWq9ua8p0hy3/18hlQH
	 lZyhuDslQzugbc9AG3j17hjlNFu0+Ez4ENck7eC2OfffBZURkenVzSW4Bjtgm0W8xq
	 4E7L89rqPWAEWJgsv/LZa5+zXNsX1o+AumJe+0REhQEDVWh5n54tDuiTereWIDLTef
	 ZITRRPISSc6soak2q04W318xMEokmkXqhe/FqkJRmlH2g2fporH6jWABksM5F+FjZB
	 vYPnA8XHiGILw==
Message-ID: <2b1371f7-b099-4ce4-a685-89783d0187ba@kernel.org>
Date: Wed, 26 Aug 2026 12:31:18 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch
 added to mm-nonmm-unstable branch
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 stern@rowland.harvard.edu, stable@vger.kernel.org,
 gregkh@linuxfoundation.org, ziy@nvidia.com
References: <20260820223719.A4A3C1F000E9@smtp.kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260820223719.A4A3C1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/21/26 00:37, Andrew Morton wrote:
> The patch titled
>      Subject: USB: gadgetfs: do not WARN about excessively large memory allocations
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch
> 
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: Zi Yan <ziy@nvidia.com>
> Subject: USB: gadgetfs: do not WARN about excessively large memory allocations
> Date: Thu, 20 Aug 2026 09:19:12 -0400
> 
> GadgetFS passes an excessively large user input len to kmalloc and kmalloc
> gives a WARN (see below for details).  Suppress it by passing __GFP_NOWARN
> to kmalloc used by both ep_write_iter() and ep_read_iter().  Follow the
> same method as commit 4f2629ea67e72 ("USB: usbfs: Don't WARN about
> excessively large memory allocations").
> 
> kmalloc is used to allocate physically contiguous memory for kernel
> allocations.  For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc
> uses the page allocator and can only support up to KMALLOC_MAX_SIZE.  For
> request sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a
> WARN because kmalloc allocates an order greater than MAX_PAGE_ORDER.
> 
> Link: https://lore.kernel.org/DKTTMAS94IMH.2C6ERY0ZIVWVZ@nvidia.com
> Fixes: b3c466ce5129 ("page allocator: do not sanity check order in the fast=
>  path")
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@googl=
> e.com/
> Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> 
>  drivers/usb/gadget/legacy/inode.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/drivers/usb/gadget/legacy/inode.c~usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations
> +++ a/drivers/usb/gadget/legacy/inode.c
> @@ -604,7 +604,7 @@ ep_read_iter(struct kiocb *iocb, struct
>  		return -EBADMSG;
>  	}
>  
> -	buf = kmalloc(len, GFP_KERNEL);
> +	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
>  	if (unlikely(!buf)) {
>  		mutex_unlock(&epdata->lock);
>  		return -ENOMEM;
> @@ -666,7 +666,7 @@ ep_write_iter(struct kiocb *iocb, struct
>  		return -EBADMSG;
>  	}
>  
> -	buf = kmalloc(len, GFP_KERNEL);
> +	buf = kmalloc(len, GFP_KERNEL | __GFP_NOWARN);
>  	if (unlikely(!buf)) {
>  		mutex_unlock(&epdata->lock);
>  		return -ENOMEM;
> _
> 
> Patches currently in -mm which might be from ziy@nvidia.com are
> 
> mm-huge_memory-use-folios-memcg-inside-__folio_split.patch
> xarray-honor-xa_flags_account-in-xas_split_alloc.patch
> usb-gadgetfs-do-not-warn-about-excessively-large-memory-allocations.patch
> 

