Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F5F509EF1
	for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 15:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789745790; cv=pass; b=cLdf1qAM8xqn7Xsb03fM5qyRexb5hPPejISJXXNbsvnDMtM13/jmWJYveWarn1peBXC7n0CZ9RAhPWpSlXNsHCYA1yNDsF/qkKghTkFZnDjRDhpSf0yYxi6hgyaGc14ll3uYNoK+1DwPaEcMeOAk/QKoywewlTpbQQRHnK5+kXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789745790; c=relaxed/simple;
	bh=uf2dLRzOODEtCERb8nf4AtVQT8QPRC90SQzSH26gzoo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sNeTj53c1BMEQQJMPRLRrE3t3plzcxSJyH9j+YUVawWgWimZpGdVD+wzwVDRuo8U73hcB8Yjbygu82XnSxAWOzFj/1bLpdXKsk7zuXVXPgArrsDemvjw8nifZT3dNmUdC3nAUnFlivrM5rSDBPYM8SMwJaGxbGM9UYWiNL4if+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=saXOy//h; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="saXOy//h"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a5f95a879cso10553a12.0
        for <mm-commits@vger.kernel.org>; Fri, 18 Sep 2026 08:36:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789745786; cv=none;
        d=google.com; s=arc-20260327;
        b=XvQLZ6kGVVeWrIWcb5nDApBisieK7xKVCP4gunyVYxA9YwJTK6f2p2PpnX7rgwg2Va
         e+MBZV6JpafPTTgB+2XcJBxve/nwttflOz+k5W7XDwbn36UR/4iUIXebqYi+n7+SLxOz
         n8F4Q5OU8lbbPn53wVt6LAbFVMLJzMt2OGZMkPYSub2bhjrh1a4vbSdn5Ex+LGFJcqNy
         jgaN9OffriCW4BnOJeuQwaPUy54PjF1Lr9PVvJRADWLM6HPTfUfr1jyl3fcY/IHXnj5h
         JZMN0O8n7P0dgOlgUstn/y1HuN1VO/fLk3Kpq84YHXn8w5s0Eg+CaIoZkeYL5sBQAs+A
         ct3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gqua3gUcRF7Re1WJkYjTLrk5VPYvhO1vcZ33hBU/XZk=;
        fh=/xBh/y7j0WvJDrA6IdNt/Wysgb+FWgozk/oioRUdh3M=;
        b=Jz/YRfwzbB35t5VEZ3c6JL5pNGytRvmOTPWrX968jVxd3g40qBIl28oVY2BNG+I2TK
         KTZ4GyXfTL44JurWHYvhi3VZm5ednQ7uw0igxHOeqIj8DzfX/THGCRf/Q8LUuGcUhQlh
         lvmUS25u7X4pktSmzB0Ajhcd3Ffpm5dPGGfKPMqon1tQjAR+0OIxSqMSzqwCHk1DY4nJ
         i6dESgcwt4uqyu2DrxNvrstqMuccIQDVOUFmY8JColQwPGlBgWeGKrD0hLAO8mvEn7xu
         M01/8x6KWY2A1PQamWeC3Y8KSQHV1gRiOXatIDgCa8i9tBb0fw/US9S7QHHUHR4+NenE
         5KOw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789745786; x=1790350586; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gqua3gUcRF7Re1WJkYjTLrk5VPYvhO1vcZ33hBU/XZk=;
        b=saXOy//hEQzFjXc9elSJv1jtb9efv5OXY3sSdIIRo0ZWlF/5VDTsgTy+8cNZ/uHI1f
         QkAzINHQ89MbJh/gk6WAbQ+ILQ/T4VbApro8Uv4nNro8HUj1K+BPtufqk59Jqn0yZ0oQ
         bhg64MiwKjadKSQim3Fb/v8l7H4sRDWMR7//txLlF0FWiYDthDYY2k0a5Ep+onnb/zlq
         H8zP0tI+QdzqcAuTu6n1WcEVpBPPW4en4nHiIUmiJTAl7NfdoEUTppZk4mS+VWdk34hy
         1oGDaYgEBNlitxsmnJw6CoCmjkeDPCJjb8l6R5GPGazsfDEvTs8th4e23U2PsskcRyHr
         KaoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789745786; x=1790350586;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gqua3gUcRF7Re1WJkYjTLrk5VPYvhO1vcZ33hBU/XZk=;
        b=QoUJkwMLXrtbQEjTgQssBCmg8DiF73tIQRZGhPXqRd6MJjCboA+1eiVsKIVcMd82R6
         MnLb75ckEd5zKDXA0oeBxkY+K94UuvqexSjq1KZjXZeW8MZ2Bocdn4fW13p00JompPGA
         1r/zvLjgGInld3s1RML1hVMYsA+UCkHCNx5+CVHgQ4z8dDYCNEI9Ytn0GeGap8n7fGio
         nlGdizww+eMXjNkxgF+F/+3/UHEXoie5yL/lmSceDpbLv3IyxO2TidTsqDmXkM7iIjLY
         zVHOnCEyF8sYedIH8Cao5PhsRMG3fmQGmwoPJxV4YpV0EMVCRRHBL5ylLsrMyizrVpkF
         TAWA==
X-Forwarded-Encrypted: i=1; AKwUvBxE5C+RAvBROR1NugkJ2SPSvjt9qLAcne0/1dSYw0VdEAQqG/NXS8HVQSa4I5POtkn4RWNfTkZXBWU1@vger.kernel.org
X-Gm-Message-State: AFuF++mtDJnkgm3NtCy6p74Nr1COqtlHvOMsHDvlXQikrK6bMaE8F+pk
	ucmkI2AtRUrSuJoxZ4yEyN0gY19/FtyKpZr2yznuCeILVHOnNYpEYk0Vvnx4hUlrX+QmXAwD0o9
	9mma3iAQgV0J9Xz+kVVmzgtoBBuF6E7WNcoMxlNxl
X-Gm-Gg: AYBFou3Zn494yI/GjKA0fv3kq8W9I/9DyVPdjvs8tpjb6lYFFEpwlgnW2TBKjY7ld3e
	/BcTRDJ7lTCnqVFXmKknNY4Ck7NIWfCRCNMrvSmrjKPPtjUY9KFjaASmo3zTbTS3pEeDhmajstA
	Dac1d8wpnS9umlG19q3dBRvfJw/09XSf0C7KKm3aG6fWNcJKjD/wjsF/BaZrSk+sR3NAbnrIcDt
	oweE27/Mdq+V57Br9ryAbHjbyBliz2wfK9deblszSgIZp/gZbO7PKPzpf61zCSzt6JGrYA4gkSb
	yiuWO3cPODIsiqG5HVrcBqwN358OqmN8HC3E5v3B8IQwY2enOJ6t/8EzuMKk+ecqdafzJelAUla
	o2ZCBaCE8
X-Received: by 2002:a05:6402:3449:b0:6aa:128c:36ad with SMTP id
 4fb4d7f45d1cf-6aa4e1d7573mr50813a12.10.1789745785854; Fri, 18 Sep 2026
 08:36:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202609171758.049ApqPm-lkp@intel.com> <20260917092237.5ba48bf16e8406e3753eacaf@linux-foundation.org>
 <CAJuCfpG+iqRwjHtH-ZjEpMxWaXkNDTurFjGQbgL4P3RK-3k5SQ@mail.gmail.com>
In-Reply-To: <CAJuCfpG+iqRwjHtH-ZjEpMxWaXkNDTurFjGQbgL4P3RK-3k5SQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 18 Sep 2026 08:36:11 -0700
X-Gm-Features: AcwNN1Xtk4GHei-55Tb0wPB1L8DqKluVg-PFcT9sdhWZc1O1R8UctH5wLSSENOM
Message-ID: <CAJuCfpG2cSnG30gLUauqdCKF6OL0=MD_bBB9gJ4J-XJHMuOHBw@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION 892f5b3b07e5b07f2f29c87750ff94fa58dcab73
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 9:57=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Sep 17, 2026 at 9:22=E2=80=AFAM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > On Thu, 17 Sep 2026 18:00:02 +0800 kernel test robot <lkp@intel.com> wr=
ote:
> >
> > > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.=
git mm-new
> > > branch HEAD: 892f5b3b07e5b07f2f29c87750ff94fa58dcab73  mm/swap, PM: h=
ibernate: atomically replace hibernation pin
> > >
> > > Error/Warning (recently discovered and may have been fixed):
> > >
> > >     https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@i=
ntel.com
> > >
> > >     fs/proc/task_mmu.c:3448:3: error: call to undeclared function 'dr=
op_rcu'; ISO C99 and later do not support implicit function declarations [-=
Wimplicit-function-declaration]
> > >     fs/proc/task_mmu.c:3450:3: error: call to undeclared function 're=
acquire_rcu'; ISO C99 and later do not support implicit function declaratio=
ns [-Wimplicit-function-declaration]
> >
> > argh, we already fixed this five times.
> >
> > Confirmed with x86_64 and
> > https://download.01.org/0day-ci/archive/20260917/202609171159.oaB1OaSG-=
lkp@intel.com/config
> >
> > Suren, I'll drop the series.  Please check this (and the 'lock_ctx_mm'
> > defined but not used failure) when preparing the planned respin
>
> Yep, I was planning to send the fixed series today anyway. Thanks!

v5 of the patchset is posted at
https://lore.kernel.org/all/20260918153318.758387-1-surenb@google.com/
It should fix all the warnings including lock_ctx_mm one.
Thanks,
Suren.

>
> >
> >
