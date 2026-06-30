Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DB83D7D65
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 03:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782788790; cv=none; b=DfybMzpFFlZpAatJajeuVv46dnZ8dzEy7RADWFwINLi6RZEv2rt5+lbLmX3GY4szG/JelXaQPWr2EIhfV22MZnJedc0DscSQfkCLZNwX32szcRKlH/b06j2XrpTP2DQRsriFh5p2X3SKNglx1sgxUciBbqNihEVG7ctzViCSWqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782788790; c=relaxed/simple;
	bh=mR8DP2XZ/1StzxeHsy2i3aZNjuZlRnSSuFmoACgUkak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H/7tg/zqmXqoCRlgwCOzhEe5y/kecvUj7e4nU+AHBMuTXv01yd6ZMKMguE+YYgUg1ifPOhTqIoA9uSJVomdpIFy1TRA4jtwm5enddRRVv9y7N7axHK5zkmzcBiXKFW5xkLlj+q+709/5lAPoOPFQi+7weUrPZegvB2mTCPNt7q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4G1wMfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4G1wMfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5141F00ACA
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 03:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782788782;
	bh=fzAepXvhPnU3RVO1srqzjPmRiEpd6yJalacgOF/VkH0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=V4G1wMfpqdrFTlqf/mZx519oKTZ/iLrU5sQVvxLgzRVooqRBV2OpUEs2CMcQLGXG8
	 0E3QAwT5brwXlhsrLl+/tcISCSjNRlIosA5w1C2796Kb/vqCd4ZvMO/gb7xsO3iEgY
	 cFhLc32ujpT7Ao96pr5bjIOxCZjC62NSzM7E6svWzhPqfEVh9JHnsO1dwCPGFdTk8F
	 WlCv8hdVZTrkGhWDR1+y/5Tju0/AzpkkKbRov0T051lSuG7N6TiUf3EzHRROV4HXwl
	 C55HBAOdmd9FwmTmabP4maTaKc85Gy112Ea+NsojFpqSW4LhVis7+fgjraqVCnlAAn
	 R1Yveb3sZ1JyQ==
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-475881b9a4bso260418f8f.3
        for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 20:06:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpZm8d+q/8f8ZgdMYalS58JjjbatWn0rJqsind+W5Ev8QbqDuPLdD4b6f9LJ/CxErjSqH7coNGllwes@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2jYS7pxWd/ulsN687hQO8pGdugovpL0VHIOX/mKfcTH0OrCbk
	6HsYcyFtokrg3mA6z9TbNTW53LmHhBnMLSZjJlQijajikayWtQIlDnJA+UpGURKQCh53oVrnAnn
	kIEWJ8ahatBPKfmPlMSCuiqxS70nYMKo=
X-Received: by 2002:a05:6000:3110:b0:475:806:c5e8 with SMTP id
 ffacd0b85a97d-475506e972cmr2367506f8f.9.1782788780671; Mon, 29 Jun 2026
 20:06:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202606291606.9h8aGniQ-lkp@intel.com> <20260629171909.1d6e96dd15a80b8f463bb68a@linux-foundation.org>
In-Reply-To: <20260629171909.1d6e96dd15a80b8f463bb68a@linux-foundation.org>
From: Guo Ren <guoren@kernel.org>
Date: Tue, 30 Jun 2026 11:06:08 +0800
X-Gmail-Original-Message-ID: <CAJF2gTT+Pz51u2ckYQGye_TNbfbvHHiEHb0Ned-k0MFCe4vgEg@mail.gmail.com>
X-Gm-Features: AVVi8CfpjiHAZxpIu9w2olplIGKjchfQBEYO-NTXILWsnMIEoAgT2ud8VKG7C3U
Message-ID: <CAJF2gTT+Pz51u2ckYQGye_TNbfbvHHiEHb0Ned-k0MFCe4vgEg@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 59/142] mm/vmalloc.c:3590:23: warning: unused
 variable 'start'
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, "Barry Song (Xiaomi)" <baohua@kernel.org>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org, 
	Dev Jain <dev.jain@arm.com>, Wen Jiang <jiangwen6@xiaomi.com>, linux-csky@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 30, 2026 at 8:19=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 29 Jun 2026 16:58:34 +0800 kernel test robot <lkp@intel.com> wrot=
e:
>
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-=
new
> > head:   88cefc306c43b58d9bb65c9e96e284306710d961
> > commit: 80c453511b6ee1af0e4db83c3db0020215c4eaf0 [59/142] mm/vmalloc: m=
ap contiguous pages in batches for vmap() if possible
> > config: csky-allnoconfig (https://download.01.org/0day-ci/archive/20260=
629/202606291606.9h8aGniQ-lkp@intel.com/config)
> > compiler: csky-linux-gcc (GCC) 16.1.0
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20260629/202606291606.9h8aGniQ-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-l=
kp@intel.com/
> >
> > All warnings (new ones prefixed by >>):
> >
> >    mm/vmalloc.c: In function 'vmap_batched':
> > >> mm/vmalloc.c:3590:23: warning: unused variable 'start' [-Wunused-var=
iable]
> >     3590 |         unsigned long start =3D addr, map_addr =3D addr;
> >          |                       ^~~~~
>
> Sigh.
>
>         unsigned long start =3D addr, map_addr =3D addr;
>         ...
>         flush_cache_vmap(start, end);
>
> See, this is our punishment for writing kernel code in CPP rather than
> in C.
>
> I'll queue (and test) the below.  It should be OK -
> arch/csky/abiv1/inc/abi/cacheflush.h directly includes asm/cache.h
> which declares cache_wbinv_all().
>
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: csky: implement flush_cache_vmap() in C
> Date: Mon Jun 29 05:07:51 PM PDT 2026
>
> To avoid getting an unused-var warning from
>
>         unsigned long start =3D something;
>         ...
>         flush_cache_vmap(start, ...);
>
> Cc: Guo Ren <guoren@kernel.org>
> Cc: Andrew Donnellan <ajd@linux.ibm.com>
> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
> Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Leo Yan <leo.yan@arm.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Wen Jiang <jiangwen6@xiaomi.com>
> Cc: Wen Jiang <jiangwenxiaomi@gmail.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  arch/csky/abiv1/inc/abi/cacheflush.h |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> --- a/arch/csky/abiv1/inc/abi/cacheflush.h~csky-implement-flush_cache_vma=
p-in-c
> +++ a/arch/csky/abiv1/inc/abi/cacheflush.h
> @@ -42,7 +42,12 @@ static inline void flush_anon_page(struc
>   * Use cache_wbinv_all() here and need to be improved in future.
>   */
>  extern void flush_cache_range(struct vm_area_struct *vma, unsigned long =
start, unsigned long end);
> -#define flush_cache_vmap(start, end)           cache_wbinv_all()
> +
> +static inline void flush_cache_vmap(unsigned long start, unsigned long e=
nd)
> +{
> +       cache_wbinv_all();
> +}
> +
Thx for the fixup.

Reviewed-by: Guo Ren <guoren@kernel.org>

--=20
Best Regards
 Guo Ren
