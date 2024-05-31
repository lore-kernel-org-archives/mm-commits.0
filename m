Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06934C7C;
	Fri, 31 May 2024 00:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717116681; cv=none; b=JEXXaYjpEw8G2IPTX5WAcCoBGWo/GspHK71m5VGF2P9/79ASkH6cAJVSXqPA9JU/gYZOGjvK7PTjweVFzM9ca1oAinB4b4WdGb5mrOpFSeI9rvy7aofgLjGeluza+oC9gqivn+NOQHVRncLja9DbaS/2Cxieg51N3A7thqWDip4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717116681; c=relaxed/simple;
	bh=gqCWN/aKVfEZ8B1AN6RvVSW+jnuyhbKcn96VMyaIAwg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X7tSpFvI91erYJg8IRXuouueaIWO1YSjUA9LRtG1Z9oTpPJH64vP4E2QHZutoBKcNFKAeeVOK1RS0psIHXbCxtDtSB/KzfTjfzbGBn12R01kCu+bvbQ3MM+CuhzXD1DhAvrxmJUyIrDKiKCeQmSMkpNVeQhyCppvQZHdl3oLK2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UL8xyyVS; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UL8xyyVS"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2e3efa18e6aso12672821fa.0;
        Thu, 30 May 2024 17:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717116678; x=1717721478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rbi+3qahX1j8CVQX3MQ8thYDoCnotdr2XCb7Yeowios=;
        b=UL8xyyVS8MZqcGtO83QsPCo4GazU0v3+W02+BGQmxCJK0ouXx5Ex2hruyd9FR0Dv5Q
         qzNVyy+gB/bNXGGEtvCJV6qpdjGReGoWg2DXccru++uA9hS+Kki/e/G8m/0hez2YxEaF
         7spYk0ET+F57RDdvw5OYhlfDX5nG7ZlFLW6svx34u3KRfzQsJNuPYb0UxQOYLY0qgXZk
         v96xB7YmwUl9wokLY3JRITAe0l0B4M/gKckrJ1Y+C6nvbMtLRlWLQ4VzWf+nfR3BtUVW
         0Q/nLPEwI/bhrxAH6oRMFqNNXEF5h2z1SDNuAK1kQnAQD60STBOxjFJDYyulrVU1AMoJ
         5oKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717116678; x=1717721478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rbi+3qahX1j8CVQX3MQ8thYDoCnotdr2XCb7Yeowios=;
        b=Kte01oOxkQ6xGvA34QfWbYHwQlkhI8bfNlO1v/pk5FgjARtnxmzrp7GHMdHtpNfpJ1
         94GoQXODNnaQub49rsekpLA3b3laNUnwOpxan+7sY5358l4JQWnkKJN3knv2+RXoio4Q
         JDXacr71DKSSMUbmeR8W07dRUM/ho8sEZlQKMVR6V1WL1HdbpdcptJNagJCiFY8YLBRB
         u8+XNo1xN9scGwwAcSSN7/NS50L835RaqGt/LZX3UpdY3sN+576fbwKL2z23DsVO85Da
         TZkm/Zyci48zMP/MnaOQATTQB0dOrePDYsjrq/2vLP+FiyySiVnjiJVJAhOFYKeTpnNU
         PihQ==
X-Forwarded-Encrypted: i=1; AJvYcCVF2DFPfipC1DMhlYCma/hFrCF3jd4TEPKD57h6E3EnD/Num5o+hvGb2MNLd075jx4rPmmkmdFBpoSMUWpIiMeecUb54dvc
X-Gm-Message-State: AOJu0YwnlA+h56+QaGzZAL5kbkOnu1RngZDoNTvaUgpGCXtk/PwM7FRy
	KYKkzBuM/PYHC8lZk7RxuOtZ5LRky1gfxVRMEe85tV796NLjbp9ND443aqrocExpiu0ok6IL96d
	+N+vj7xQ30PnQiEQnksYvpN3Ioik=
X-Google-Smtp-Source: AGHT+IE4iE4rNgVNOAhpmw/PEczHZOHfgHZMqP2kxc2wMzFrYxKMe7F7FEaeeNxJSKttbLPOjV+8FZpUUvNAcHGGgQ0=
X-Received: by 2002:a05:651c:b06:b0:2e7:1621:89d0 with SMTP id
 38308e7fff4ca-2ea84c0cad3mr11808521fa.2.1717116677554; Thu, 30 May 2024
 17:51:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530200551.354DFC2BBFC@smtp.kernel.org>
In-Reply-To: <20240530200551.354DFC2BBFC@smtp.kernel.org>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Fri, 31 May 2024 08:51:06 +0800
Message-ID: <CAGWkznHXyyfnu4eo4CdRyDO-Tvo+4eRASvkVyAHqFQ_i6W102Q@mail.gmail.com>
Subject: Re: + mm-vmalloc-fix-vbq-free-breakage.patch added to
 mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com, xiang@kernel.org, 
	urezki@gmail.com, stable@vger.kernel.org, lstoakes@gmail.com, 
	liuhailong@oppo.com, hch@infradead.org, guangye.yang@mediatek.com, 
	21cnbao@gmail.com, hailong.liu@oppo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 4:12=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: mm/vmalloc: fix vbq->free breakage
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mm-vmalloc-fix-vbq-free-breakage.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-vmalloc-fix-vbq-free-breakage.patch
>
> This patch will later appear in the mm-hotfixes-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: "hailong.liu" <hailong.liu@oppo.com>
> Subject: mm/vmalloc: fix vbq->free breakage
> Date: Thu, 30 May 2024 17:31:08 +0800
>
> The function xa_for_each() in _vm_unmap_aliases() loops through all vbs.
> However, since commit 062eacf57ad9 ("mm: vmalloc: remove a global
> vmap_blocks xarray") the vb from xarray may not be on the corresponding
> CPU vmap_block_queue.  Consequently, purge_fragmented_block() might use
> the wrong vbq->lock to protect the free list, leading to vbq->free
> breakage.
>
> Link: https://lkml.kernel.org/r/20240530093108.4512-1-hailong.liu@oppo.co=
m
> Fixes: fc1e0d980037 ("mm/vmalloc: prevent stale TLBs in fully utilized bl=
ocks")
> Signed-off-by: Hailong.Liu <liuhailong@oppo.com>
> Reported-by: Guangye Yang <guangye.yang@mediatek.com>
> Cc: Barry Song <21cnbao@gmail.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Gao Xiang <xiang@kernel.org>
> Cc: Guangye Yang <guangye.yang@mediatek.com>
> Cc: liuhailong <liuhailong@oppo.com>
> Cc: Lorenzo Stoakes <lstoakes@gmail.com>
> Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/vmalloc.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> --- a/mm/vmalloc.c~mm-vmalloc-fix-vbq-free-breakage
> +++ a/mm/vmalloc.c
> @@ -2830,10 +2830,9 @@ static void _vm_unmap_aliases(unsigned l
>         for_each_possible_cpu(cpu) {
>                 struct vmap_block_queue *vbq =3D &per_cpu(vmap_block_queu=
e, cpu);
>                 struct vmap_block *vb;
> -               unsigned long idx;
>
>                 rcu_read_lock();
> -               xa_for_each(&vbq->vmap_blocks, idx, vb) {
> +               list_for_each_entry_rcu(vb, &vbq->free, free_list) {
No, this is wrong as the fully used vb's TLB will be kept since they
are not on the vbq->free. I have sent Patchv2 out.
>                         spin_lock(&vb->lock);
>
>                         /*
> _
>
> Patches currently in -mm which might be from hailong.liu@oppo.com are
>
> mm-vmalloc-fix-vbq-free-breakage.patch
>
>
