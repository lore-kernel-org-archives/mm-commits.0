Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FAC26ACB
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 22:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744237931; cv=none; b=nF+5qlhk96Hodp+eHNB24Oo5+MC/m682r+jqsq6FgyLaykpOJDZbsr1tNcNK5agMjy32gWAubcUMKnL24Y3TLxzbJnS00OgYjkWWHT+i3dxr/rcjGZuSHo6yLpiX18rmWH8UAZX2cJnluQMZztuMstokRACsbxE02KS+d2reApQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744237931; c=relaxed/simple;
	bh=dUcFiEevDd2uXsRnng0N8jTZMVmnH+f0c9jIaQy4Wmk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YufSfNVrXOjKbjD2RH3PpWd4IrhynOSrLPBivutfRUrXINGflAW/dTiQea4q3bm12gkUzItswmhRvKE8gMK9FGNAxxuIrBtc8BGAtGTa8ZKl+Jn8Eq6Z1P/thVDf5VDkcK4gbd8dOo/ogg5B7wAosQtcoErJN5KhtHuUtLZVJac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oX8RoJDd; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oX8RoJDd"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-47681dba807so30611cf.1
        for <mm-commits@vger.kernel.org>; Wed, 09 Apr 2025 15:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744237929; x=1744842729; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZRpYe9kZljsIsb6Q8443FGoIbulqLc9TInapjHrYYxI=;
        b=oX8RoJDdgk3XdfuDpblhJzdI202NVsxsVtfbNSWBtpM7oDApZwPyCROAOk0ZL/GLQZ
         B7Dh6saOIl/HKBD6IDsM1Xin9fG38F9QWhhSublipgWHFQTxpZRceJQJklynnHS2G8iI
         aVexkLILRe5DHES3rEHVuFelpT2px7+F/Z01zFSvp7MbyT20haMcOyLz3gQsRziFe8vE
         5Z4BOe1bwxUPH3ktiStZ9YnbajimnIyj/DINWSJiPkypclv2XZsVL7el5OcWjYztvZPy
         GNqw4cjFtP79iAEQf94S9SqrqBdgRo67ZVykuiwANhMKsb6O3N70JtqMap3xZ2yznOBl
         GzkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744237929; x=1744842729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZRpYe9kZljsIsb6Q8443FGoIbulqLc9TInapjHrYYxI=;
        b=TYPTCCwszcJbb819+QRf4TONfVRJlMGKaZ2hov5MBeB2Zen+XUnvbssw+thI3M7N9d
         EcJGGlEpyH9A6Cv2UmQ9/0Hy4dmgAvNSrGbQYFMcHUeQeB9mmN7dklm/8gisNvn4a/iG
         xqi6p1hwn/+HmtL9AerLeS9eLomekLH2p23wSSZB5HdxPVzBXEgOcx4CGvmJWuYMGwzd
         jXVA3fNWkL48FCrptOZ3UFHBOAAmzJUWqga423m+N0e7EqipDtSeanDtqsOZG1owci5b
         9GTECHCfT+orUTZqAeDrsrjxX8qTTRNsQZKwPz9HpPdglp2kiJxfduacX8DyTeF82ZXB
         Wh+g==
X-Forwarded-Encrypted: i=1; AJvYcCU2uxRqIVHhyNZy256sPMSPtyvPk4qRmsW85tydUVo/ms2f/SHnElcSb5EyHnFUybQaKLWWAc6HMGng@vger.kernel.org
X-Gm-Message-State: AOJu0YyQkOs09BCoc8oTis76F0TjbatHjyX9hmOU3MdWtq5Rhs+CFaNl
	5AI2x14msLE7oRP+5nIPfIsnaseISG4w9tY3kn+B59jwgOqgetEVsKR7YVw0jMVwMLOonEzRIeZ
	Ybb7XJOgJDSgwzU5Q5Hezg9yoLvSV7tce/AmQ
X-Gm-Gg: ASbGncua5IyVeKkjHmQf6+2dcV/J+WhpNLid2rsF9aAQt51uPYKI1+g/g51Qjg7DMKE
	+Z/j8zZU3SR0CxO6x6cfHhUZGX3rBrkeP5uC2yHTQFLIZgutbQV8j3K2yP/RQsZRaUjTFhavPwi
	dpFt/KkHcwrAK2sWFg1FOc
X-Google-Smtp-Source: AGHT+IEWnzv75rMRVNfzSPLGWPXCHotFgM7AwSEOWuPCUVWA0mtZQClB0wAQ6dnxCPDDtVUQdrQrQyXYqp2BtETmx7Q=
X-Received: by 2002:a05:622a:50:b0:472:538:b795 with SMTP id
 d75a77b69052e-4796c96779dmr866331cf.22.1744237928663; Wed, 09 Apr 2025
 15:32:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250409211241.70C37C4CEE2@smtp.kernel.org> <hzrrdhrvtabiz7g4bvj53lg64f7th5d7ravduisnaqmwmmqubr@f52xy2uq6222>
In-Reply-To: <hzrrdhrvtabiz7g4bvj53lg64f7th5d7ravduisnaqmwmmqubr@f52xy2uq6222>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 9 Apr 2025 15:31:57 -0700
X-Gm-Features: ATxdqUFn5hZFVlhVlz0m44XW9D_8EYWgqwFtOyNZawf41CSs-dLCKnhfqgSInYo
Message-ID: <CAJuCfpGe3cY3yYGB03kTGJR-Dyh02w8spDDRkckjdP+qSKtdXg@mail.gmail.com>
Subject: Re: + alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate.patch
 added to mm-hotfixes-unstable branch
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	stable@vger.kernel.org, janghyuck.kim@samsung.com, tjmercier@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 9, 2025 at 3:10=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Wed, Apr 09, 2025 at 02:12:40PM -0700, Andrew Morton wrote:
> >
> > The patch titled
> >      Subject: alloc_tag: handle incomplete bulk allocations in vm_modul=
e_tags_populate
> > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> >      alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_pop=
ulate.patch
> >
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tr=
ee/patches/alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_p=
opulate.patch
> >
> > This patch will later appear in the mm-hotfixes-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> >
> > *** Remember to use Documentation/process/submit-checklist.rst when tes=
ting your code ***
> >
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
>
> I don't think we want to rush this patch, given that it's not fixing an
> actual crash.

It's not designed to fix a crash. The issue is that whenever tags
require more than one page and CONFIG_PAGE_OWNER is enabled, memory
allocation profiling gets disabled. I missed the fact that
alloc_pages_bulk_node() can return less number of pages than requested
and this patch fixes that.

>
> I'm currently chasing a crash (null ptr deref, slab obj extension vector
> seems to not be getting allocated correctly) in 6.15-rc1, so I'm
> wondering what's missing in our test coverage.
>
> > ------------------------------------------------------
> > From: "T.J. Mercier" <tjmercier@google.com>
> > Subject: alloc_tag: handle incomplete bulk allocations in vm_module_tag=
s_populate
> > Date: Wed, 9 Apr 2025 19:54:47 +0000
> >
> > alloc_pages_bulk_node may partially succeed and allocate fewer than the
> > requested nr_pages.  There are several conditions under which this can
> > occur, but we have encountered the case where CONFIG_PAGE_OWNER is enab=
led
> > causing all bulk allocations to always fallback to single page allocati=
ons
> > due to commit 187ad460b841 ("mm/page_alloc: avoid page allocator recurs=
ion
> > with pagesets.lock held").
> >
> > Currently vm_module_tags_populate immediately fails when
> > alloc_pages_bulk_node returns fewer than the requested number of pages.
> > This patch causes vm_module_tags_populate to retry bulk allocations for
> > the remaining memory instead.
> >
> > Link: https://lkml.kernel.org/r/20250409195448.3697351-1-tjmercier@goog=
le.com
> > Fixes: 187ad460b841 ("mm/page_alloc: avoid page allocator recursion wit=
h pagesets.lock held")
> > Signed-off-by: T.J. Mercier <tjmercier@google.com>
> > Reported-by: Janghyuck Kim <janghyuck.kim@samsung.com>
> > Cc: Kent Overstreet <kent.overstreet@linux.dev>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> >
> >  lib/alloc_tag.c |   15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> >
> > --- a/lib/alloc_tag.c~alloc_tag-handle-incomplete-bulk-allocations-in-v=
m_module_tags_populate
> > +++ a/lib/alloc_tag.c
> > @@ -422,11 +422,20 @@ static int vm_module_tags_populate(void)
> >               unsigned long old_shadow_end =3D ALIGN(phys_end, MODULE_A=
LIGN);
> >               unsigned long new_shadow_end =3D ALIGN(new_end, MODULE_AL=
IGN);
> >               unsigned long more_pages;
> > -             unsigned long nr;
> > +             unsigned long nr =3D 0;
> >
> >               more_pages =3D ALIGN(new_end - phys_end, PAGE_SIZE) >> PA=
GE_SHIFT;
> > -             nr =3D alloc_pages_bulk_node(GFP_KERNEL | __GFP_NOWARN,
> > -                                        NUMA_NO_NODE, more_pages, next=
_page);
> > +             while (nr < more_pages) {
> > +                     unsigned long allocated;
> > +
> > +                     allocated =3D alloc_pages_bulk_node(GFP_KERNEL | =
__GFP_NOWARN,
> > +                             NUMA_NO_NODE, more_pages - nr, next_page =
+ nr);
> > +
> > +                     if (!allocated)
> > +                             break;
> > +                     nr +=3D allocated;
> > +             }
> > +
> >               if (nr < more_pages ||
> >                   vmap_pages_range(phys_end, phys_end + (nr << PAGE_SHI=
FT), PAGE_KERNEL,
> >                                    next_page, PAGE_SHIFT) < 0) {
> > _
> >
> > Patches currently in -mm which might be from tjmercier@google.com are
> >
> > alloc_tag-handle-incomplete-bulk-allocations-in-vm_module_tags_populate=
.patch
> >
