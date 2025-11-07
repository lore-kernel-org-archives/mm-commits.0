Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D12F2BFC73
	for <mm-commits@vger.kernel.org>; Fri,  7 Nov 2025 01:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762477267; cv=none; b=EibIwrGyfC1w/Vjz1dl1/DxH62+J6dwYS94ZDicqZg/eSFhbakAATGnPR477Lcp+HU5IibtlfH4f9l39PnXwMFeEPXi4RLlcZigXza4lxIsPE9YRUiBnFjVGlQ9ouFAu1V2N9YCEqKgULIA2INJSLIracAprV7tV6IjVKGNqgBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762477267; c=relaxed/simple;
	bh=6Vq6xnllNLKddg7S0xjjPzOVqzBWr3NnaXE5Cy1bsT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gdBYFoaL/cC328ccYGQwlPCZyhutGIAKqZ6M0ImJtI6H+JOuoQdpYd6blo60A5ST4pe4Ncg4GX5sLFjutUo+niVe8RydXl58KbDSPnSbPrxPZ0o9IjLfdX3QWyVc3CoHYR5+v6k2jDCldJjXKeocXUbKCbrLNF6tDxe3ZVk55/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KCrDMq93; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=g/heeZRx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KCrDMq93";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="g/heeZRx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762477264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oS0uMhMGdq49DhBi/gfTvr28qD45X58Y+Rz8QovrzNg=;
	b=KCrDMq93SDUV06aOuxIvHv7vTWWphoKXuXJf/R94w8YK9bt0Txiglb+eDzBnGKdi6SVGEr
	w9UkFxNrsxyPghC8ozwU1DS4xunOS6aMDIAPY8MWlgMHXgWYKXK1zeDouZpWNLYhNwReZ/
	Bax6NvnCRPkLHE+QdfBqjmuFjsE1OYg=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563--XMHlkPENIiMgX6N6-bptA-1; Thu, 06 Nov 2025 20:01:02 -0500
X-MC-Unique: -XMHlkPENIiMgX6N6-bptA-1
X-Mimecast-MFC-AGG-ID: -XMHlkPENIiMgX6N6-bptA_1762477262
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b630753cc38so589071a12.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Nov 2025 17:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762477262; x=1763082062; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oS0uMhMGdq49DhBi/gfTvr28qD45X58Y+Rz8QovrzNg=;
        b=g/heeZRxMCgeKQZqgvDm2o0Dsh+iaWGWunoyu5QG9htdrWewWbtxOQuoSlj8YIAwBi
         k/CqAjE57CB43eSn4GuO8L/cTdnvHeZg2QEyg7ByrGvLFJMqxSh1xMxFDr8XOSZXjfvv
         BgRO3eBML8sUD55iDPzyqmv1BMlJJ3CuajFnzAR8pmAGlp8Kf/zyh31Au6TZRj6jBac2
         RTEX3PjO9/7yalADhzKJyl6osFj2dSEjz0JOwE+1RyTmSxI6KQT/jhW3V8xHoQL3CihT
         Um+nQybEoyrFOI8GXdXb1nkWVuWOPLwN/LsYWVLFq0/bIkw9VOLp3BekwdozQT/oaAmJ
         ZI2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762477262; x=1763082062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oS0uMhMGdq49DhBi/gfTvr28qD45X58Y+Rz8QovrzNg=;
        b=dTzG0FDJ2HgAsKbvUvbkxr/jdmF8fpK/bE8UsQjs/25h5eIexyjMB5+mSeRTxEL+Fn
         z37qxyg8q3b5409gtXAxXaxMvg3/pz0KObnYYIaSrzihV2AG22EgnUkGkBgoBPe52NKX
         pt1Qisg1sVqwt1nMl7LBpFtvLFmoPeIcAeg/UvyXYYuSu8BQFtj5O4jNPIjAdC235IqK
         ajJ+3Y373xIyNVOnTI+fJ1Y71UTZRqhOk5vG0ylsAKBZDVsIhxUvv/U319tS7zYOAk8K
         0GqZm4VUYeEVBB1XOI+NfYAa7bgqkVAH2VejIFs8IZHKBOdK7SRkEWrMRx4jQAuwgofH
         4DRQ==
X-Gm-Message-State: AOJu0Yx0sYWLchvIwos7EdUvtZ0NizdSd2zf79Yvg7LhBcGqJ8qm8ANR
	Hd27q+bCptoq1K1WEKc6IbqakxOZDAe1XAqul+G6jy8DUh2mc2QgXJOS/a/6/X1gfQwfqVfkuxr
	nW6TuktkD4XDX+n6nKb7KcRCNEA/HZyJzZRi+LEDzWs2O9CtJ89XdkBJUh5tjLecx9r5B+GjDkV
	uIM/p3+8m0ebav72fHdbH2jcM5m+cnJLlDsUGv7A==
X-Gm-Gg: ASbGnctB2EGuV79JyzO7CotrCJDP/PbmMNiYbImpezJgKFih9WAuc+Ople85FATxsnO
	0RxRDQ1tpD4kJMcH2OY9SN2/XFdtAJOId56vzVqpSFPHWg5bO6fWg2KjIsEui2BzGsV9JO50o1u
	T5AFHacNVPfTeU817rOGhZHuJoEq812XfMa2NBu61cHjsd07n0fAk2WZJV
X-Received: by 2002:a05:6a20:72a5:b0:343:af1:9a5a with SMTP id adf61e73a8af0-352291520b6mr2205556637.5.1762477260176;
        Thu, 06 Nov 2025 17:01:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEGZjYhyU2I/iqThL1SwvIj+q56hy6nUrJ+za+wlQBhGl64lNQqk0EUbiOrhi2GgmjKaUpvt0VIaarghb0tmRU=
X-Received: by 2002:a05:6a20:72a5:b0:343:af1:9a5a with SMTP id
 adf61e73a8af0-352291520b6mr2205498637.5.1762477259683; Thu, 06 Nov 2025
 17:00:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251107003005.107D6C4CEFB@smtp.kernel.org>
In-Reply-To: <20251107003005.107D6C4CEFB@smtp.kernel.org>
From: Pingfan Liu <piliu@redhat.com>
Date: Fri, 7 Nov 2025 09:00:48 +0800
X-Gm-Features: AWmQ_bkXy77GLlQuIcMFJZTYbmotYc5pKuX5_CTlFqpD6b4cIml4CakEu0fWk5w
Message-ID: <CAF+s44QyfTDsXDXaAYtN3Kcf2i8g9J7tQdBnwDc=PtnTV-sM0g@mail.gmail.com>
Subject: Re: [to-be-updated] kernel-kexec-fix-ima-when-allocation-happens-in-cma-area.patch
 removed from -mm tree
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zohar@linux.ibm.com, stable@vger.kernel.org, 
	roberto.sassu@huawei.com, graf@amazon.com, chenste@linux.microsoft.com, 
	bhe@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 7, 2025 at 8:30=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
>
> The quilt patch titled
>      Subject: kernel/kexec: fix IMA when allocation happens in CMA area
> has been removed from the -mm tree.  Its filename was
>      kernel-kexec-fix-ima-when-allocation-happens-in-cma-area.patch
>
> This patch was dropped because an updated version will be issued
>
> ------------------------------------------------------
> From: Pingfan Liu <piliu@redhat.com>
> Subject: kernel/kexec: fix IMA when allocation happens in CMA area
> Date: Wed, 5 Nov 2025 21:09:22 +0800
>
> When I tested kexec with the latest kernel, I ran into the following
> warning:
>
> [   40.712410] ------------[ cut here ]------------
> [   40.712576] WARNING: CPU: 2 PID: 1562 at kernel/kexec_core.c:1001 kima=
ge_map_segment+0x144/0x198
> [...]
> [   40.816047] Call trace:
> [   40.818498]  kimage_map_segment+0x144/0x198 (P)
> [   40.823221]  ima_kexec_post_load+0x58/0xc0
> [   40.827246]  __do_sys_kexec_file_load+0x29c/0x368
> [...]
> [   40.855423] ---[ end trace 0000000000000000 ]---
>
> This is caused by the fact that kexec allocates the destination directly
> in the CMA area.  In that case, the CMA kernel address should be exported
> directly to the IMA component, instead of using the vmalloc'd address.
>
> Link: https://lkml.kernel.org/r/20251105130922.13321-2-piliu@redhat.com
> Fixes: 0091d9241ea2 ("kexec: define functions to map and unmap segments")
> Signed-off-by: Pingfan Liu <piliu@redhat.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Mimi Zohar <zohar@linux.ibm.com>
> Cc: Roberto Sassu <roberto.sassu@huawei.com>
> Cc: Alexander Graf <graf@amazon.com>
> Cc: Steven Chen <chenste@linux.microsoft.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  kernel/kexec_core.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> --- a/kernel/kexec_core.c~kernel-kexec-fix-ima-when-allocation-happens-in=
-cma-area
> +++ a/kernel/kexec_core.c
> @@ -967,6 +967,7 @@ void *kimage_map_segment(struct kimage *
>         kimage_entry_t *ptr, entry;
>         struct page **src_pages;
>         unsigned int npages;
> +       struct page *cma;
>         void *vaddr =3D NULL;
>         int i;
>
> @@ -974,6 +975,9 @@ void *kimage_map_segment(struct kimage *
>         size =3D image->segment[idx].memsz;
>         eaddr =3D addr + size;
>
> +       cma =3D image->segment_cma[idx];
> +       if (cma)
> +               return cma;

It should be " return page_address(cma);" as [PATCHv2 2/2]
kernel/kexec: Fix IMA when allocation happens in CMA area
(https://lore.kernel.org/all/20251106065904.10772-2-piliu@redhat.com/
)


Thanks,

Pingfan

