Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C233839A0
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 15:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789053430; cv=pass; b=m+eRan9YmPxAILemiJN79Njimz8gc+MA7hPYNdH29/nWrQbkz5XxhGJeyyWetligCYhfeHr+kv9swZXg67iiA8WqEV9VcbzUObsR6PJ3x4kS6zPXb6NEQrqvHYAWXoQcuhahS6cnIDikZaSTxAhqQBFwJrI2LWr71uQVGDKPAds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789053430; c=relaxed/simple;
	bh=PT3l9D+qk1J02erub6zKKk8YnIDPLs+7rSgPTIxwn1Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bQgxGvA8hqdriIYeiUpeayxJ6r1Y9fvVDRk0h4NvNwVi1z/dFvQfLiF+eHEBfm/x8bJ+BjmyGPTkJbjQzSgi2iVCOjVPy55StQNJqaY0bZ8PZBHy8MwQPP5DIerA9v94MXMSR0yCQ/OQhP0X3Ju91Bhotk6qyKxkpOTsXXPcsLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V+u3fMuS; arc=pass smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V+u3fMuS"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5306706e89dso312191cf.1
        for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 08:17:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789053424; cv=none;
        d=google.com; s=arc-20260327;
        b=dpNMIo6hK/y2+Y/Te4y25d3t55Vlk/1XCckHi5s9z7Vj1eX3AQfgFVvHxNAwwdJhV5
         uIs4nrJMNoaLLiXe4U3lxinw+XzPrSVC51Y7k9GJlJbJ541TOrPxjMGj83WBx7+/1eQG
         OSRzsahHNYh6pUFHDK1+Qx7ipP+eHsOVMcDe5E59kf4ZFm5O7YiTGDOU6gKE1s+qiMc7
         BViyzbHk0bJux4b3aQgEQrUVzvACwH6ZMjvNtsA6mPmLoUJJ7+W2t2aJ6JWoE7jwFzSH
         NKTKdTQF7q9e2zpgmwaaqO/sHSfP40oYEGZuNKZ4IAw2parMkz81INipmOmFiJLR5g1y
         M0RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xDN/YUpPOFz+Kdvzz1//obMcefb85ZenH94zRZ152w8=;
        fh=1DHSuQYACpLStYECCl5jZHmvzKuVEEOgmBdvaAPZloM=;
        b=Fr/CVp5SLxRhldkyASP6K22rWyH79Ay6Ud3tXBlihCRrx+kYBrIwrrv0SS2uZJH2Kq
         omSwN1U9XZEU4RYaPWkyrmOXe7vkZF2LSkaSuv0xAcR2ev5+Obd2XrAd8XSjgWN4toMO
         ZhvY4Lo50A72bzo2bGoQ/XgcWQy0OKFAyTWtcAGoTDAvLBC7Hbn4AdLAYWQSL+p5I+/Z
         w7SrkruRs1uyTViRJ/NCXfwRPdGjSJ0q0lEeaJvW39ZV/fZlL2utf/AXwZulalp8BpDg
         Hm2ZTJldjo2XZp7H/aSxm9wuOAqeN3i19/e+XztDaf0CrmcaKOdZaOqZIPO8yFF1LdnB
         lT7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789053424; x=1789658224; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xDN/YUpPOFz+Kdvzz1//obMcefb85ZenH94zRZ152w8=;
        b=V+u3fMuSshckglSOI290t0c4VoE2Q80MDH9vWsMyuMwHic/kTl0KmfEW4PqWEMzmY9
         wqfvMdKZSIsy62MWsYE3Jb0EhFw8dqRneb0iaEh8DxzKZ8vGMW+5Z5J9vqQFEC0doLgq
         9ivJlDZeKUVdlXdt1cieSnuBaFKQGY7ebEPtsXfJ4FE8snKiUvTlS+2xmXvjgfYcjBWP
         7q53Y2ntvjBD83eAoHcyaHxMPiyPIKXvRMNMHEjGi0wI8BO4MTd0Th0xBelq75WOwF9e
         n5wwPvzJ007qn6jnFr+N2/8trLJ1z6zjoyNLi+b5j0pxz2NFr7jv3+Umt4pMn27DXXpd
         sn3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789053424; x=1789658224;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xDN/YUpPOFz+Kdvzz1//obMcefb85ZenH94zRZ152w8=;
        b=gKVKwQJdr9rf/V0R4M4AQlOax8KsuOWiqYiH/+4/YOldg/JZncq/tp2yUVBJqtrbw9
         Sgkc5IUSeh2b0yfPj3snb+/Eq+mO5V8EUzJfhpMtgWAsaR+PWvy9XyO0+enCURYnqJxM
         R0RWtnbAoaWp+Tvf33N43XyvkQssx0PRDAFOTIWBg3/RL36U08oZhWOusoY5nxlKqa9B
         xCQuV8pQYxr8R/JLZq8pK5OxVH9pN2GL+1ZhB9a7OIthp7ROhRrRcLf/axSo75/7WU+y
         HBJDnyKX6ogL8xm/iENWz1myFXszWFteta+8QVqLPxTq97ZI22fd27uEBih6XDDuSfpf
         6FDw==
X-Forwarded-Encrypted: i=1; AKwUvBzZrjislfIMoFWpqHVkQrhpoyC+vLdvq+8g3m7qZQKyGPOyjAPEUuNHf1ZCBXrybnx3Ygt71/dWugDz@vger.kernel.org
X-Gm-Message-State: AFuF++lODTvIyBD1tXVoKGdG0l+ch876khOtKrlWghCwFpuUj6ebOcmG
	lM/JgePRKFFWqfaYLl/KI83UXDB/RbWqXr6KGXP3kV79UKneLBdGquYVeoasPE+i1YMTcptfhuy
	hJPCcdtBeh228trOdIq6REjW84RLXC2J4Jk7WNhhR
X-Gm-Gg: AYBFou1IUCFHl+vNR+0GsMp8MULhAxuLjvLtxcTTdXKYAegbFyPIKG1kZuOAgjgHCTx
	C7UaBFbxOE06XvxHM8b8aSvm2z9G1jKsCKwcMgcq5lkg7brTGOY19pDO320a7wJDUXIpp8r1W0q
	V8nookIJczwj065CcbpLIxX2mBexJ5/e1aZHmaSg/UeqAzTiMbb9u6o4gqJ3PAI9WC9nTsVndx6
	iu/+cL+e52n7pcO51REEsIRa6WvhOgqDUgd9HjdLQjo/wch3fI8mAeKWtRE/Ec8TOCblndPZlJw
	cNL/HeWil5A5tk5GpQ/NZAu1iWoGSmK61uZioeBZfKpcPhwRjSLnh9teOwKyj2FMWDcC3+yNHsr
	NoQvdAf8MjtbYf+yh0Oa/
X-Received: by 2002:a05:622a:1107:b0:51c:ad5:93be with SMTP id
 d75a77b69052e-530b4874003mr21164601cf.8.1789053423038; Thu, 10 Sep 2026
 08:17:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202609102250.lIycVv3n-lkp@intel.com>
In-Reply-To: <202609102250.lIycVv3n-lkp@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 10 Sep 2026 08:16:51 -0700
X-Gm-Features: AcwNN1XA_1Vxrpu5C9I0NHGQICi5xwP_ReZ-YZ-hWwO3NXMcsgCngvh-2ENY2I0
Message-ID: <CAJuCfpGzZjvC49EJb8KwjzsEKi2HZbrKs=P+06GNLDSFoTedMA@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 358/388] mm/sparse-vmemmap.c:507:48: error:
 implicit declaration of function 'device_zone'; did you mean 'device_move'?
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2026 at 7:41=E2=80=AFAM kernel test robot <lkp@intel.com> w=
rote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-ne=
w
> head:   cf558a250cf4475a8936902b8978fbb6c61016f8
> commit: dd35ca2f2cac9d6439a2ba2f523b98b5a9a9f8f5 [358/388] mm-sparse-vmem=
map-switch-device-dax-to-shared-tail-vmemmap-pages-fix
> config: s390-randconfig-r121-20260910 (https://download.01.org/0day-ci/ar=
chive/20260910/202609102250.lIycVv3n-lkp@intel.com/config)
> compiler: s390-linux-gcc (GCC) 13.4.0
> sparse: v0.6.5-rc1
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260910/202609102250.lIycVv3n-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202609102250.lIycVv3n-lkp=
@intel.com/
>
> All error/warnings (new ones prefixed by >>):
>
>    mm/sparse-vmemmap.c: In function 'vmemmap_populate_compound_pages':
> >> mm/sparse-vmemmap.c:507:48: error: implicit declaration of function 'd=
evice_zone'; did you mean 'device_move'? [-Werror=3Dimplicit-function-decla=
ration]
>      507 |         page =3D vmemmap_shared_tail_page(order, device_zone(n=
ode));
>          |                                                ^~~~~~~~~~~
>          |                                                device_move
> >> mm/sparse-vmemmap.c:507:48: warning: passing argument 2 of 'vmemmap_sh=
ared_tail_page' makes pointer from integer without a cast [-Wint-conversion=
]
>      507 |         page =3D vmemmap_shared_tail_page(order, device_zone(n=
ode));
>          |                                                ^~~~~~~~~~~~~~~=
~~
>          |                                                |
>          |                                                int
>    mm/sparse-vmemmap.c:172:78: note: expected 'struct zone *' but argumen=
t is of type 'int'
>      172 | struct page __ref *vmemmap_shared_tail_page(unsigned int order=
, struct zone *zone)
>          |                                                               =
  ~~~~~~~~~~~~~^~~~
>    cc1: some warnings being treated as errors

I think this breakage happens if CONFIG_ZONE_DEVICE=3Dn.
The mm-new branch build breakage can be easily reproduced with defconfig on=
 x86.

>
>
> vim +507 mm/sparse-vmemmap.c
>
> 4917f55b4ef963 Joao Martins    2022-04-28  494
> 4917f55b4ef963 Joao Martins    2022-04-28  495  static int __meminit vmem=
map_populate_compound_pages(unsigned long start_pfn,
> 4917f55b4ef963 Joao Martins    2022-04-28  496                           =
                            unsigned long start,
> 4917f55b4ef963 Joao Martins    2022-04-28  497                           =
                            unsigned long end, int node,
> 4917f55b4ef963 Joao Martins    2022-04-28  498                           =
                            struct dev_pagemap *pgmap)
> 4917f55b4ef963 Joao Martins    2022-04-28  499  {
> 4917f55b4ef963 Joao Martins    2022-04-28  500          unsigned long siz=
e, addr;
> 4917f55b4ef963 Joao Martins    2022-04-28  501          pte_t *pte;
> 4917f55b4ef963 Joao Martins    2022-04-28  502          int rc;
> d1d11861d8a018 Muchun Song     2026-09-08  503          unsigned long fla=
gs =3D VMEMMAP_POPULATE_DAX;
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  504          struct page *page=
;
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  505          unsigned int orde=
r =3D pfn_to_section_order(start_pfn);
> 4917f55b4ef963 Joao Martins    2022-04-28  506
> 8fbaacc4a64bd1 Muchun Song     2026-09-08 @507          page =3D vmemmap_=
shared_tail_page(order, device_zone(node));
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  508          if (!page)
> 4917f55b4ef963 Joao Martins    2022-04-28  509                  return -E=
NOMEM;
> 4917f55b4ef963 Joao Martins    2022-04-28  510
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  511          if (reuse_compoun=
d_section(start_pfn, pgmap))
> 4917f55b4ef963 Joao Martins    2022-04-28  512                  return vm=
emmap_populate_range(start, end, node, NULL,
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  513                           =
                     page_to_pfn(page), flags);
> 4917f55b4ef963 Joao Martins    2022-04-28  514
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  515          size =3D min(end =
- start, (1UL << order) * sizeof(struct page));
> 4917f55b4ef963 Joao Martins    2022-04-28  516          for (addr =3D sta=
rt; addr < end; addr +=3D size) {
> 55896f935a60b9 Gautam Menghani 2022-06-12  517                  unsigned =
long next, last =3D addr + size;
> 4917f55b4ef963 Joao Martins    2022-04-28  518
> 4917f55b4ef963 Joao Martins    2022-04-28  519                  /* Popula=
te the head page vmemmap page */
> d1d11861d8a018 Muchun Song     2026-09-08  520                  pte =3D v=
memmap_populate_address(addr, node, NULL, -1, flags);
> 4917f55b4ef963 Joao Martins    2022-04-28  521                  if (!pte)
> 4917f55b4ef963 Joao Martins    2022-04-28  522                          r=
eturn -ENOMEM;
> 4917f55b4ef963 Joao Martins    2022-04-28  523
> 4917f55b4ef963 Joao Martins    2022-04-28  524                  /* Popula=
te the tail pages vmemmap page */
> 4917f55b4ef963 Joao Martins    2022-04-28  525                  next =3D =
addr + PAGE_SIZE;
> d1d11861d8a018 Muchun Song     2026-09-08  526                  pte =3D v=
memmap_populate_address(next, node, NULL, -1, flags);
> 4917f55b4ef963 Joao Martins    2022-04-28  527                  if (!pte)
> 4917f55b4ef963 Joao Martins    2022-04-28  528                          r=
eturn -ENOMEM;
> 4917f55b4ef963 Joao Martins    2022-04-28  529
> 4917f55b4ef963 Joao Martins    2022-04-28  530                  /*
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  531                   * Reuse =
the shared page for the rest of tail pages
> ee65728e103bb7 Mike Rapoport   2022-06-27  532                   * See la=
yout diagram in Documentation/mm/vmemmap_dedup.rst
> 4917f55b4ef963 Joao Martins    2022-04-28  533                   */
> 4917f55b4ef963 Joao Martins    2022-04-28  534                  next +=3D=
 PAGE_SIZE;
> 4917f55b4ef963 Joao Martins    2022-04-28  535                  rc =3D vm=
emmap_populate_range(next, last, node, NULL,
> 8fbaacc4a64bd1 Muchun Song     2026-09-08  536                           =
                   page_to_pfn(page), flags);
> 4917f55b4ef963 Joao Martins    2022-04-28  537                  if (rc)
> 4917f55b4ef963 Joao Martins    2022-04-28  538                          r=
eturn -ENOMEM;
> 4917f55b4ef963 Joao Martins    2022-04-28  539          }
> 4917f55b4ef963 Joao Martins    2022-04-28  540
> 4917f55b4ef963 Joao Martins    2022-04-28  541          return 0;
> 2beea70a3edc03 Joao Martins    2022-04-28  542  }
> 2beea70a3edc03 Joao Martins    2022-04-28  543
>
> :::::: The code at line 507 was first introduced by commit
> :::::: 8fbaacc4a64bd1bfbfb11bfb48b5db3f4943cbd7 mm/sparse-vmemmap: switch=
 device DAX to shared tail vmemmap pages
>
> :::::: TO: Muchun Song <songmuchun@bytedance.com>
> :::::: CC: Andrew Morton <akpm@linux-foundation.org>
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
>
