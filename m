Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3846C155A24
	for <mm-commits@vger.kernel.org>; Sat, 26 Oct 2024 04:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729916549; cv=none; b=P7RwzEzHZTI9N1jL5grSnD3rTT5LuiGYiz4FQ1Y2X6l+zHOJ5owreW7p1vC9RVnyBWqs0m0kS+dxtHIfdaZi/4vq03Ydn8Gw3nr2WXjB8W6O1jx8GMP8aINK25OnmOJaKD8eOagoZs7j1cnoBWZIfj3P3w12rjTzPIjj4wtCIdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729916549; c=relaxed/simple;
	bh=+XPMJpttImxvGVRx8aCzrFg+EMc/vShVdWmiZwmHBZ0=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=cwFaMs2vDGzBBbUmbEnG3z6cqD4NQk/yIhh8PjjuzgGOSwtT3cXEPMMUMZoYqGAinX5X0NsxykR4l5HUHCTS4ErN5hgT/HrSzncgAQcWpNVXx7zj50JmxCzlVVbAV2VIFL+PUPlapZZBnjcyWhknmAXdnNjiAGGaebsUfPcZSQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mxem4ugq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mxem4ugq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0DD4C4CEC6;
	Sat, 26 Oct 2024 04:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729916545;
	bh=+XPMJpttImxvGVRx8aCzrFg+EMc/vShVdWmiZwmHBZ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Mxem4ugqx7QWAB8uPp2u9Iz9a06OxzkaXLNc3e6Vv1lD9DUl9+nxGa6q/MmwLs2V8
	 SAyy7fbEvflzIOu6Hu78JZZOCATsRG78VXPfdvi0cfvbLEk9gBuWmtVga4YmM2aH0D
	 4hysrr07KpX1izsy0YmFfcjS8L0fNZ63EhWBwBr8=
Date: Fri, 25 Oct 2024 21:22:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: mm-commits@vger.kernel.org, vbabka@suse.cz, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, jannh@google.com
Subject: Re: + mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
 added to mm-unstable branch
Message-Id: <20241025212224.c03b14a7d658edb9ca09aa07@linux-foundation.org>
In-Reply-To: <20241026033436.hfb73whfbeypxj5r@master>
References: <20241026024123.B621BC4CEC3@smtp.kernel.org>
	<20241026033436.hfb73whfbeypxj5r@master>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 26 Oct 2024 03:34:36 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> >------------------------------------------------------
> >From: Andrew Morton <akpm@linux-foundation.org>
> >Subject: mm-vma-the-pgoff-is-correct-if-can_merge_right-fix
> >Date: Fri Oct 25 07:39:41 PM PDT 2024
> >
> >remove now-unused local
> >
> >mm/vma.c: In function 'vma_merge_new_range':
> >mm/vma.c:965:23: error: unused variable 'start' [-Werror=unused-variable]
> >  965 |         unsigned long start = vmg->start;
> >      |                       ^~~~~
> 
> Andrew
> 
> The removal of start usage maybe come from another patch.
> 
> If my understanding is correct, 'start' would be used to restore the state on
> expansion failure.

I don't think so.  This patch did

> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -915,7 +915,6 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
>  	unsigned long start = vmg->start;
>  	unsigned long end = vmg->end;
>  	pgoff_t pgoff = vmg->pgoff;
> -	pgoff_t pglen = PHYS_PFN(end - start);
>  	bool can_merge_left, can_merge_right;
>  
>  	mmap_assert_write_locked(vmg->mm);

which was the only usage of `start' in vma_merge_new_range().
