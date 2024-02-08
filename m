Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653253233
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 23:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707436228; cv=none; b=MJarwATnfhTxlanr8Fzt2rkj42H+Yf647yToTSxgY5p3a+3HB31fJGbfMAWuJPA1n6fV/xaxJ5+2pPtRyArAuCbzdgwBKr9zGSZL599ubAhrPcoioZoFqak7qvww7DvCWBmF0/0yWEL3t8sXfNwHZmD9ZgUNwl9nEfnU6FE/NlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707436228; c=relaxed/simple;
	bh=7O/3C5bktRbd15TfedckZvr6Gn9BQrLl3CsAyWU+7g0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oRJmU8hO1Z3fVDKspxDtY6dBOxSvF+oH28aur62GRzs62FPeS6zwBdK4DvpMySnxl4SFaJFUAhqnNn8Qe8U/m+Yllqp/TFs5MouE0FuTE56DnVzDMcSs8/KkTeAkrVnk650pt87MPST8bJYOqd/DgRxXD9iHyfEF/c42DGUxOKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aoBqf1SC; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aoBqf1SC"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-41059577f26so3703335e9.0
        for <mm-commits@vger.kernel.org>; Thu, 08 Feb 2024 15:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707436224; x=1708041024; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7O/3C5bktRbd15TfedckZvr6Gn9BQrLl3CsAyWU+7g0=;
        b=aoBqf1SCPjSMKvUayBmlG5zFsFElpiXQAHS1KrpUayH/DAKwKiMYJlP3tImAzGmMB/
         fjjNs74k3wJEIF0cPaoJX39G7KX+BZDTejP0vVrbJwgpHlkpy4uxdsaqt1Yl1DCsCX/v
         CbT/EBBrK+PVo+5Gd87NLWBfnvmKiakH9rQ796hc6+K6IelTCkLTNdx5F3Ug78WyOGxC
         wZEfKj5tMhrq6WEQRmV0D+w6Em4sIe8je7HNVKh9cUhmi31HqYxNtox0j2YwEgfMuGNz
         gFOIJcw1tNVP45RTMwKeDSQhk0qGktngCeTnO118Is6qEIlwO2ZDjLhIsk/P0yUReFbX
         Nlgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707436224; x=1708041024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7O/3C5bktRbd15TfedckZvr6Gn9BQrLl3CsAyWU+7g0=;
        b=cmMnQv6YSqAzUBlR6IMTiNxL1zXKncs69wbUEaHMZQjfwE720qYmnUwhJFCwcT3IqB
         GJYcXcIef7lYClbfKgeAexCZ5EFoD9gLY+G2zywK/h4FezXh7Ez/okQm6GSq8+5UUeGG
         dX4wojNyba0caEszFflN7t16eQccdvCcawMiG+zMDnwBVXUPnLbDYnjxN7XhMJXDec+0
         klFXqXDz3pShE2gxWJlzSsGSg9GNgZHJColBQQqqTJNIRhlSA6UB5yO55HjvIaqNMGhl
         P6f4H3LZI7kXeds1RF0pfcm/wPB5U1Y+b3fHDvOQ/QdboU5HSuShDQT+cz6cJKBl7Mk1
         b/ug==
X-Forwarded-Encrypted: i=1; AJvYcCVcFSfwm8IIk1MSGUnfFBraYg/4UTNjb7/ExFft8vKyNXh6DAWLkqu2H3KuIiaOA6Lwj5U2jze4xQz+V/QMgD5Qsp5yMLYzI1mF4w==
X-Gm-Message-State: AOJu0Yy0ujhIMhfSRoqjf2dhH0Skyr98TVQNVW3drIg9AvEuCOxkQD+Q
	u+3sXgDNf4nifDgHp9oA62zR1YGXn+sD481S7TOJ6vEFDmp5jeC9xgaFt3AU2NA3ncuClS6+faV
	caOJ+1gjGrpZruZBwL1ajA+qU3Bm8+GHn8iGX
X-Google-Smtp-Source: AGHT+IEZIkbU/xdlWfVypHz1ZQjn73o+gZ2C3w9+i9bRwoc/cJuIKAzwpNrpwiVeIXaDlXk80EcQB3Y0BSD4yRVs0uo=
X-Received: by 2002:a5d:6188:0:b0:33b:3774:ed0 with SMTP id
 j8-20020a5d6188000000b0033b37740ed0mr673178wru.2.1707436224391; Thu, 08 Feb
 2024 15:50:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240207231014.3A3F0C433C7@smtp.kernel.org> <20240208031413.GA185687@cmpxchg.org>
 <CAJD7tkbdzwjhhgK_-6iAHLn05Q-7wCOzEn9xug1Udr+Df-hLkA@mail.gmail.com>
 <20240208064411.GE185687@cmpxchg.org> <CA+CK2bCxPVyB8ZVk3dA5TKROScNHMzdu_PkBTK9b3zStvgemDA@mail.gmail.com>
In-Reply-To: <CA+CK2bCxPVyB8ZVk3dA5TKROScNHMzdu_PkBTK9b3zStvgemDA@mail.gmail.com>
From: Wei Xu <weixugc@google.com>
Date: Thu, 8 Feb 2024 15:50:12 -0800
Message-ID: <CAAPL-u-vmt9qx=E=tLq5NGQbam5i3WFqvuAepxzYMJ7EkRYgMA@mail.gmail.com>
Subject: Re: + mm-report-per-page-metadata-information.patch added to
 mm-unstable branch
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	yang.yang29@zte.com.cn, willy@infradead.org, wangkefeng.wang@huawei.com, 
	vbabka@suse.cz, tomas.mudrunka@gmail.com, surenb@google.com, 
	shakeelb@google.com, rppt@kernel.org, rdunlap@infradead.org, 
	rafael@kernel.org, muchun.song@linux.dev, Liam.Howlett@oracle.com, 
	kirill.shutemov@linux.intel.com, ivan@cloudflare.com, 
	gregkh@linuxfoundation.org, david@redhat.com, corbet@lwn.net, 
	chenlinxuan@uniontech.com, bhelgaas@google.com, adobriyan@gmail.com, 
	souravpanda@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 8, 2024 at 10:08=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> > > I am not closely following this series, but I just wanted to point ou=
t
> > > that this is not always true. We are actively extending
> > > NR_SECONDARY_PAGETABLE to add IOMMU page tables in addition to KVM
> > > page tables [1]. In that case as well, the name was left open-ended
> > > exactly for this purpose [2].
> >
> > I think you're glossing over quite some nuance here.
> >
> > Sure there might be highly specific scenarios where you can get away
> > with it. Like with a very recently introduced counter for somewhat
> > niche audiences, and bucketing/grouping that was IIRC planned from the
> > start. It's probably not reasonable to advocate nondescript interface
> > names as a strategy for getting out of ABI commitments.
> >
> > My point was that "memmap" is the established term for what the author
> > describes. And that this concept is sufficiently first-class that
> > mixing it with other things later is unlikely to be acceptable. I
> > didn't know WHY a new name for this was chosen, so I provided
> > arguments for two motivations that I could think of, that's all.
>
> Sure, we can rename it to NR_MEMMAP_BOOT / NR_MEMMAP. We picked
> NR_PAGE_METADATA_BOOT/NR_PAGE_METADATA as we thought it was a clearer
> choice. It directly conveys the concept of page metadata overhead,
> eliminating ambiguity about future potential structures. Today, it is
> "struct page", and "pag_ext", tomorrow memdesc and more.

Technically, page_ext is not part of memmap if we go by the kernel code, ri=
ght?

> Pasha
