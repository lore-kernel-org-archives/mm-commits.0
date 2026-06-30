Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4090B40BCC6
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 10:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782817044; cv=none; b=qeeetkZYeTF0MjWGHzPzcmL6HHY1TeUaQtDRCmNICFyrFzw6Glc9ms0Jws6Dfwl45EjrpXsnEHNzkXRvjKiS2C5NiwRm0r+1gt+dvgGqTxyDist6T44mzqX5YhxVnkeOwhwRFW+K/eyrTzRFMfC7PGZrk403OGfLM/nhYDBPtS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782817044; c=relaxed/simple;
	bh=SFJyhzApgCLMGmQKlBrEgilM7Tdt6DP5MxjLh24ot3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WAa01sNFVVMkAR6m4jRUvazUvgwAdVk21JTibdPx+VarCNeVKbOtq8GJbVh/nVZ4lN8Twpufvvrh4YMypiLZrU4OJgVvycMPQQMQZHehjrHk8sSWFio88XLIPuxCMJbICT0/HgsZtDxmeAVEJE17p8bYxP4B7QgH+y0nq3Z/v6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ml0Ca4UA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ml0Ca4UA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D911F00A3D
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 10:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782817042;
	bh=2+HA/JoBOxFhZJaSk9aZ5CarxkWj6UA49Z/NltJ50Cg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ml0Ca4UA8WnoIceeByIqxj9zleRHe4d4FldENXK+iKmBFAipQ75AEdeo/fGCqmRJC
	 Qubr3JAb4291J+0F8rRqobUgfrwR7AEdiTQvF3tERlrAkYYJAQt4tCZDdZDoc0Fmbx
	 FAaWWdZewjg/UrTOTRfiw+6Wi7dHvD0F0+oujEHCJvNwNi9jzf9SgfnQ17icKyQsNW
	 jsIphJi6kruZaAP1WC44aB58wb14jYgWJSz1GFqjOlCjw9IYclQq4dPwYUUbWJuVCd
	 rMjHy84CAguLrfYAops3rN5vfJdoFQTBYkmIA3Z+9ui4Xe/zGr01rwoQEuNm97vpkN
	 GtkF6n/sh4ACQ==
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c04bf4711so21815591cf.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 03:57:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+BN0xhP93wN3AQszGuB/GJu1I2DrYw5BDXCvrzfgvEKCJQdTTzYBHBYPo24WuWglN16fimx+O3arVW@vger.kernel.org
X-Gm-Message-State: AOJu0YxUPxC09kg+tPBQD43b2BmTj5uqhiDoYbeaPC79JrBKuBgM+0eA
	5XzYxuADvfZ3Ntc00VrW78bBOBF6x5Zc0N2aFRUprhH7l1oWKHlyYzRDzT3TwR/iX3jGSgFySVA
	i3B6ROgUyeDnLPw31pqNizDp/ZHqleZQ=
X-Received: by 2002:a05:622a:207:b0:51a:8c86:bd40 with SMTP id
 d75a77b69052e-51c1ca5ad03mr786431cf.61.1782817042418; Tue, 30 Jun 2026
 03:57:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202606291606.9h8aGniQ-lkp@intel.com> <20260629171909.1d6e96dd15a80b8f463bb68a@linux-foundation.org>
In-Reply-To: <20260629171909.1d6e96dd15a80b8f463bb68a@linux-foundation.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 30 Jun 2026 18:57:10 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wViR10e-9B1qqv5MNTMGVHVGLDiDzqh8PM=PPfm5rCTA@mail.gmail.com>
X-Gm-Features: AVVi8CfRjXxRj_MDC-E8kjBOS5LOmhQQQo2Vt2_pEXaIk32vDSLRHRLAK_LHPZk
Message-ID: <CAGsJ_4wViR10e-9B1qqv5MNTMGVHVGLDiDzqh8PM=PPfm5rCTA@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 59/142] mm/vmalloc.c:3590:23: warning: unused
 variable 'start'
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	David Hildenbrand <david@kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org, 
	Dev Jain <dev.jain@arm.com>, Wen Jiang <jiangwen6@xiaomi.com>, Guo Ren <guoren@kernel.org>, 
	linux-csky@vger.kernel.org
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

Thanks for the fix. We even have a checkpatch check and coding
style documentation for this:

6813216bbdba ("Documentation: coding-style: ask function-like
macros to evaluate parameters")

b1be5844c1a ("scripts: checkpatch: check unused parameters for
function-like macros")

Reviewed-by: Barry Song <baohua@kernel.org>

Best Regards
Barry
