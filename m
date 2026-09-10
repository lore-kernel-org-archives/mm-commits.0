Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589D6386C20
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 15:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789053786; cv=pass; b=WIUsiEq77Ybl09ifZc9gxbgKd1mv3srf/fAVwjgCYGlLxvIuVcObmvBBvfOwEFMLY1Aq2IBOqkDdtzOAG6GwPIfqLnEzcfDZaDRexONM0grU0+qtUTXfFGnsSWr/n8IxtePCTWbCrTBFshPAPd7HLUvsjiKt8lORH5lg9b2t928=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789053786; c=relaxed/simple;
	bh=3LIsNSPlEFTHIQ/gX7BnyzjivlVIdxXWfdHId7CEHpU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VpufrVX3GT6KaAIXMa6c07m+v28TBFkIToc0h7CCcBt75BpvULqBf6IRzV9udBXfIY/0mqGD+u2B1Aes2KuLF8KMz6DuL8YLffBq9+mN7GAXmkn70yCUim+K8fRcwlmWJh9cGy9Ha+fyq5KzG4mxphMqiJzlv0CkV/orYE/kZOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fSZIRXjv; arc=pass smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fSZIRXjv"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so301131cf.0
        for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 08:23:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789053781; cv=none;
        d=google.com; s=arc-20260327;
        b=gwj1TdpPD8vGgWjAawlh0t76tDPXnt2cXj9aFU3qpbTyt7eWlqGj3ioY8k5p2O+SsQ
         rWKWmBI26Q3DzCKPdsN8WZ36jjXjWX/DmrHA9HEBb1mBT2EQvFZAfk931+uhnbBIHhsS
         0hsv+AbVpwq3/g+6haVqjsNv4yFAOsvWDW0vP31u6YCkHv6Qg7qZ7/guXF1J+/Uyu/xx
         8jbBcqJ3pR8It5tU1X73sJ4WZJUZaZpp4qdPpzHo+8KtxHRWr49p6APx9E1IH3fwmkBe
         cl1mUmX0TA4Co6ZBS562EtzWUnprn6/vb/4AzTLu1RBDNsFLL5pMek8OHwJeQric/xyk
         dpNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=foiDQ6diynQrcBaahnIV4yufuKYFC6bgEE9f3Z6k/+4=;
        fh=WXnpdLcV+jxdRRoA/dYY58aclv7r1+oJ9n6S2uU4YFw=;
        b=hEwUopeZzrV2d3E+x8il77mWfRIr8O1Tm9nXtvK1yfIefLbD4WrE13CYv4UFddvKnV
         E4tpHAngVbll2+gpOlzJVMQsgWYUqHIcPakZ+ek13TzJzGeyZqEMxZ/bu5VZehSEZ6ri
         jK0O/eXliNIIME0LbNYpF6ver1jCq/5/E1tpogz1iGz9bMvWMGycq1ZTIC5Bjhvu7Zjo
         7BYk9AU5OikdzRX0nWilFJvj8j59JrpOqdnq37j2ufjPZetiqGi/kEsIFiYWizDGA7Og
         PXs0QNqGhz0MvwxgtMHLoDS0P/EU27mBtmDcqBb5g3CStiEshUzCOoGxMm52DKGTF6ZO
         MZTg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789053781; x=1789658581; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=foiDQ6diynQrcBaahnIV4yufuKYFC6bgEE9f3Z6k/+4=;
        b=fSZIRXjvqJsq59TMlBOhoihmGJpwf4jz9ygKrW1rdQ5pHpnzF+S+P9l7XcS76Phm94
         sASqruxQK9L/ca14+j7+SNquxgID+Tx93yBDS53gWya0w4hbuPAjO7G/Uyo0P6cY1aZ3
         VOMc2Zb7M1GHBL52tiJv9FoH0tbX5mJs74JuqKhyt+rdG9kG5Gztl7xEpcEjk8XMX5VO
         VLBrNq3TrhuK55h7fjeF78vLYtg/YKqr/v67Vme5yArrDjS8MmHwbEUXxZRNKeaVxunk
         n9jWi/orVmO9ADplKtq+Y8NNByCC0qW6BZ59494gGDao3sDsNcxVhLprgJSvruieuJZN
         Kypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789053781; x=1789658581;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=foiDQ6diynQrcBaahnIV4yufuKYFC6bgEE9f3Z6k/+4=;
        b=ZJzBLvo3tV6ScllaFf+qbVAGn1u3zz3LnaHvKwJwxiQi65e56R+KWP1iqpBEMCaGRj
         NAyKYl++rByCdPHFcKt3suNoXteSCBVXv4B3jPnyM4Y2fbwxzFtoXFH+dHFhAnmWCpLV
         naUJgLTUoteLm134i9zLkFjhVMqA+0VAKSpzbfVojWcohdzAZm6avlJQe2BhPx4DfE1q
         X/u9/YdVKK6ZAoOcz/D3QuYVJVOycnAdvtk5R/H9K8SOdcbM7Xo4eIrUeV1Efkx9qooF
         pNzN56onsiwe039JVlriszPqwegC2EkHaQ0hVvSNo4lfdBf9vasm3lpHqm/k3y1tmgSH
         CyiQ==
X-Forwarded-Encrypted: i=1; AKwUvBxcMHtCN9/mqwv1Ma3ksrjZNuHfJyTmRo/2uHoKhrhfWSr/HpFmYcZm3hxMLdQ1uE0rXHRJ8leZMiXq@vger.kernel.org
X-Gm-Message-State: AFuF++nFOL8dJyfKVxCuP8EPitWyZNMZDZx9w/wivPaU4z2X0CjNZ8iP
	ca5htYeqbUjKY+ucs9WgJxh9kkRe4o5snhvn/QoHf2Fgl+Lcxcg5JwSMxQJaJLbU+ll7THkGI0H
	RG0tq3FQRt76ic8I2eRRPeFfAp/nTsXD2LcO17NJD
X-Gm-Gg: AYBFou2mPTgAF0MvspTQ/meIEzVFwVorJtvKCazQEMSPKoqUpan2NT6IAP2prB7p8Nz
	G7araMH9jgcK2CKxyPKJ/qqwzFHoU7G3dKhiodnqENPgYXJxz3Hvbzra7rC8uQHnZ1h3DM8og8K
	PJqIdinQoWx1rYH1IUo1IRurxaTNB/vO7KMZPt5BhVCpNBakgmVC1a+ZIAZPMwpwGuVU5mwTygX
	BJq6JI+Pp7fVCCP+fq3gi1Hk0hvpbboPOTg+x1SSgiz1m6Gjp1VHrEKtyMlggUb3FkSgvFVKHm3
	xrUh71GhZLpKqC8W7MLZZJpIs1XZw/gVeP7mUB0z79d3IExBBX+PWBStH2ADuMLnG6vLcQoCHLL
	rMbG9TjgedA==
X-Received: by 2002:a05:622a:229e:b0:51c:ca9:3d17 with SMTP id
 d75a77b69052e-530b493ec9amr21800701cf.12.1789053780219; Thu, 10 Sep 2026
 08:23:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202609102250.lIycVv3n-lkp@intel.com> <CAJuCfpGzZjvC49EJb8KwjzsEKi2HZbrKs=P+06GNLDSFoTedMA@mail.gmail.com>
In-Reply-To: <CAJuCfpGzZjvC49EJb8KwjzsEKi2HZbrKs=P+06GNLDSFoTedMA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 10 Sep 2026 08:22:49 -0700
X-Gm-Features: AcwNN1Vpd9Nn3bXuKcyUSWjUYWc9CR-onv1HPhUAjO_3tU0VLTHMUNIuNLQxO5s
Message-ID: <CAJuCfpEz8=emKgxjQ3_Sv7knJZW1+kN7b6Y31uoMh2TQ6C0EuA@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 358/388] mm/sparse-vmemmap.c:507:48: error:
 implicit declaration of function 'device_zone'; did you mean 'device_move'?
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 10, 2026 at 8:16=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Sep 10, 2026 at 7:41=E2=80=AFAM kernel test robot <lkp@intel.com>=
 wrote:
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-=
new
> > head:   cf558a250cf4475a8936902b8978fbb6c61016f8
> > commit: dd35ca2f2cac9d6439a2ba2f523b98b5a9a9f8f5 [358/388] mm-sparse-vm=
emmap-switch-device-dax-to-shared-tail-vmemmap-pages-fix
> > config: s390-randconfig-r121-20260910 (https://download.01.org/0day-ci/=
archive/20260910/202609102250.lIycVv3n-lkp@intel.com/config)
> > compiler: s390-linux-gcc (GCC) 13.4.0
> > sparse: v0.6.5-rc1
> > reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/arc=
hive/20260910/202609102250.lIycVv3n-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new ve=
rsion of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202609102250.lIycVv3n-l=
kp@intel.com/
> >
> > All error/warnings (new ones prefixed by >>):
> >
> >    mm/sparse-vmemmap.c: In function 'vmemmap_populate_compound_pages':
> > >> mm/sparse-vmemmap.c:507:48: error: implicit declaration of function =
'device_zone'; did you mean 'device_move'? [-Werror=3Dimplicit-function-dec=
laration]
> >      507 |         page =3D vmemmap_shared_tail_page(order, device_zone=
(node));
> >          |                                                ^~~~~~~~~~~
> >          |                                                device_move
> > >> mm/sparse-vmemmap.c:507:48: warning: passing argument 2 of 'vmemmap_=
shared_tail_page' makes pointer from integer without a cast [-Wint-conversi=
on]
> >      507 |         page =3D vmemmap_shared_tail_page(order, device_zone=
(node));
> >          |                                                ^~~~~~~~~~~~~=
~~~~
> >          |                                                |
> >          |                                                int
> >    mm/sparse-vmemmap.c:172:78: note: expected 'struct zone *' but argum=
ent is of type 'int'
> >      172 | struct page __ref *vmemmap_shared_tail_page(unsigned int ord=
er, struct zone *zone)
> >          |                                                             =
    ~~~~~~~~~~~~~^~~~
> >    cc1: some warnings being treated as errors
>
> I think this breakage happens if CONFIG_ZONE_DEVICE=3Dn.

Sorry, it's the combination of CONFIG_ZONE_DEVICE=3Dn && CONFIG_NUMA=3Dy.
This seems to fix it:

---
 include/linux/mmzone.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 136235b6975d..0e4c09f4ad3b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1700,7 +1700,7 @@ static inline bool zone_is_zone_device(const
struct zone *zone)
 }
 #endif

-#if !defined(CONFIG_ZONE_DEVICE) && !defined(CONFIG_NUMA)
+#if !defined(CONFIG_ZONE_DEVICE)
 static inline struct zone *device_zone(int nid)
 {
  return NULL;
--=20

> The mm-new branch build breakage can be easily reproduced with defconfig =
on x86.
>
> >
> >
> > vim +507 mm/sparse-vmemmap.c
> >
> > 4917f55b4ef963 Joao Martins    2022-04-28  494
> > 4917f55b4ef963 Joao Martins    2022-04-28  495  static int __meminit vm=
emmap_populate_compound_pages(unsigned long start_pfn,
> > 4917f55b4ef963 Joao Martins    2022-04-28  496                         =
                              unsigned long start,
> > 4917f55b4ef963 Joao Martins    2022-04-28  497                         =
                              unsigned long end, int node,
> > 4917f55b4ef963 Joao Martins    2022-04-28  498                         =
                              struct dev_pagemap *pgmap)
> > 4917f55b4ef963 Joao Martins    2022-04-28  499  {
> > 4917f55b4ef963 Joao Martins    2022-04-28  500          unsigned long s=
ize, addr;
> > 4917f55b4ef963 Joao Martins    2022-04-28  501          pte_t *pte;
> > 4917f55b4ef963 Joao Martins    2022-04-28  502          int rc;
> > d1d11861d8a018 Muchun Song     2026-09-08  503          unsigned long f=
lags =3D VMEMMAP_POPULATE_DAX;
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  504          struct page *pa=
ge;
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  505          unsigned int or=
der =3D pfn_to_section_order(start_pfn);
> > 4917f55b4ef963 Joao Martins    2022-04-28  506
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08 @507          page =3D vmemma=
p_shared_tail_page(order, device_zone(node));
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  508          if (!page)
> > 4917f55b4ef963 Joao Martins    2022-04-28  509                  return =
-ENOMEM;
> > 4917f55b4ef963 Joao Martins    2022-04-28  510
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  511          if (reuse_compo=
und_section(start_pfn, pgmap))
> > 4917f55b4ef963 Joao Martins    2022-04-28  512                  return =
vmemmap_populate_range(start, end, node, NULL,
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  513                         =
                       page_to_pfn(page), flags);
> > 4917f55b4ef963 Joao Martins    2022-04-28  514
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  515          size =3D min(en=
d - start, (1UL << order) * sizeof(struct page));
> > 4917f55b4ef963 Joao Martins    2022-04-28  516          for (addr =3D s=
tart; addr < end; addr +=3D size) {
> > 55896f935a60b9 Gautam Menghani 2022-06-12  517                  unsigne=
d long next, last =3D addr + size;
> > 4917f55b4ef963 Joao Martins    2022-04-28  518
> > 4917f55b4ef963 Joao Martins    2022-04-28  519                  /* Popu=
late the head page vmemmap page */
> > d1d11861d8a018 Muchun Song     2026-09-08  520                  pte =3D=
 vmemmap_populate_address(addr, node, NULL, -1, flags);
> > 4917f55b4ef963 Joao Martins    2022-04-28  521                  if (!pt=
e)
> > 4917f55b4ef963 Joao Martins    2022-04-28  522                         =
 return -ENOMEM;
> > 4917f55b4ef963 Joao Martins    2022-04-28  523
> > 4917f55b4ef963 Joao Martins    2022-04-28  524                  /* Popu=
late the tail pages vmemmap page */
> > 4917f55b4ef963 Joao Martins    2022-04-28  525                  next =
=3D addr + PAGE_SIZE;
> > d1d11861d8a018 Muchun Song     2026-09-08  526                  pte =3D=
 vmemmap_populate_address(next, node, NULL, -1, flags);
> > 4917f55b4ef963 Joao Martins    2022-04-28  527                  if (!pt=
e)
> > 4917f55b4ef963 Joao Martins    2022-04-28  528                         =
 return -ENOMEM;
> > 4917f55b4ef963 Joao Martins    2022-04-28  529
> > 4917f55b4ef963 Joao Martins    2022-04-28  530                  /*
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  531                   * Reus=
e the shared page for the rest of tail pages
> > ee65728e103bb7 Mike Rapoport   2022-06-27  532                   * See =
layout diagram in Documentation/mm/vmemmap_dedup.rst
> > 4917f55b4ef963 Joao Martins    2022-04-28  533                   */
> > 4917f55b4ef963 Joao Martins    2022-04-28  534                  next +=
=3D PAGE_SIZE;
> > 4917f55b4ef963 Joao Martins    2022-04-28  535                  rc =3D =
vmemmap_populate_range(next, last, node, NULL,
> > 8fbaacc4a64bd1 Muchun Song     2026-09-08  536                         =
                     page_to_pfn(page), flags);
> > 4917f55b4ef963 Joao Martins    2022-04-28  537                  if (rc)
> > 4917f55b4ef963 Joao Martins    2022-04-28  538                         =
 return -ENOMEM;
> > 4917f55b4ef963 Joao Martins    2022-04-28  539          }
> > 4917f55b4ef963 Joao Martins    2022-04-28  540
> > 4917f55b4ef963 Joao Martins    2022-04-28  541          return 0;
> > 2beea70a3edc03 Joao Martins    2022-04-28  542  }
> > 2beea70a3edc03 Joao Martins    2022-04-28  543
> >
> > :::::: The code at line 507 was first introduced by commit
> > :::::: 8fbaacc4a64bd1bfbfb11bfb48b5db3f4943cbd7 mm/sparse-vmemmap: swit=
ch device DAX to shared tail vmemmap pages
> >
> > :::::: TO: Muchun Song <songmuchun@bytedance.com>
> > :::::: CC: Andrew Morton <akpm@linux-foundation.org>
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> >
