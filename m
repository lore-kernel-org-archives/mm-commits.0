Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F7615AF
	for <mm-commits@vger.kernel.org>; Fri,  9 Feb 2024 01:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707441679; cv=none; b=fStJWwiWsgd8eqhcGOs5Xt17fyEyN5d+vffGb+VH+v2hcf52TINlUog10PrNemnV2Q9xbREMJDJ3vYeh13Wf9qqTbSCRy7Ow12WjSZKaclq30O78ikyIdlpAxPbYOLAEdkjmGZiGVOMz5mb/LXS1+Lhu9gNd91rBFoceQ6FuDw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707441679; c=relaxed/simple;
	bh=pn6ReTvnUVbJ25qqg1omgIvgCRjuYqlgg61/1KtGe6c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I6kr/sMmDxeM5xYY6mFzyOZav6LNugpYb3af1ftTib63bb0x/9RCBHRnbxaYjsHElBgHcYzodR5uANcWwHPAHL+K/WwTcjeh4sIFmDhzD+N9TjB9b4PUwM/1SXlxApD7cWmAAG8bG8Ou5ky0d7RK8dL2EQSVYaDHnE5NfCnLfe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tV8ACGZw; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tV8ACGZw"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-33b0ecb1965so168578f8f.1
        for <mm-commits@vger.kernel.org>; Thu, 08 Feb 2024 17:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707441676; x=1708046476; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pn6ReTvnUVbJ25qqg1omgIvgCRjuYqlgg61/1KtGe6c=;
        b=tV8ACGZwGigUCxDHWFRbutMxlDU/upnOuK8iDdY5+QRUVkpB4i2XAs0Kv7IbI1aOzY
         7l0onpsG0V+RvBdogV5c4XoJfkj2KDitbH1sY4dQKiowrekZ4JFIvm4MTcxbokAO3Q77
         UqF8PhAqLhfb6w961G2GvjX80Hrry4lh7GbTY2XuqMPn9xcLiam3bxCtP5g7Mf0tu/F1
         jBRYWUoWypb3hzv6LxgBUAiahg2SzwgU+oyhTjkXRkNqYOKU09JEpB2KBxCJyEWj9S/N
         Aju9mMwxuSi3twg1DxQnnKHKjjDGpc+qhQ4813Nhhmg0N55jnuHHxlzv+PUurD0BCZK3
         Wvpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707441676; x=1708046476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pn6ReTvnUVbJ25qqg1omgIvgCRjuYqlgg61/1KtGe6c=;
        b=HR/vMfrDP3jjCgzT510KaFTRXg+OnhJr3KSFL+FxYP/YQUHb80dd6AFnb+6+3qgdez
         PTUbohwWWggIuuutIjn5jbds6bj9upMruTZ/0WHoWNNpocTsC0vvXZ7P0vg1I43a6SKF
         3Qf6c1yxelI/uymDraPNGUk0Q3F9UCbZp50qD0TXtNmOgBiEm1Riv6VP96GIaqqja/QU
         +kVlezeqOgbdo513ktyyGZ2jLls9jipk1b/h5RqpuZPn+6kyHxtwQH/ycbQc7+nn2jtQ
         intO2nHDXlGZH6gEkSo5Z7Ww+C6qK+H1Y/ZmIpGv5U388KM4LAS7OyKLTvQT7riDgCpL
         3+cg==
X-Gm-Message-State: AOJu0Ywf9y/R5kgjoceZvI2AcjM/S6iALZHiwoUssefjDYjv2J6Q+BYU
	XPU44wnSc9APl4Wff6FQUWnJ/MZDD4ON9/JuOXFAOsNfXmDhQdXBBjLmXbmVuKaTMQC8l2lviXV
	sFLQb6Wnr9nxqveJPWPVuL0vjb9tbTlScikTs
X-Google-Smtp-Source: AGHT+IFyo8ZmF94C0LDhOTSGBMFF+QGzq53nltI+q8IYSmCzPaQzDjlDqxiLjhc2+6nJr9Odr6CIZdAQr9JQ9cDnkb4=
X-Received: by 2002:adf:f88f:0:b0:33b:60cb:c3ad with SMTP id
 u15-20020adff88f000000b0033b60cbc3admr761527wrp.41.1707441675636; Thu, 08 Feb
 2024 17:21:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240207231014.3A3F0C433C7@smtp.kernel.org> <20240208031413.GA185687@cmpxchg.org>
 <CAJD7tkbdzwjhhgK_-6iAHLn05Q-7wCOzEn9xug1Udr+Df-hLkA@mail.gmail.com>
 <20240208064411.GE185687@cmpxchg.org> <CA+CK2bCxPVyB8ZVk3dA5TKROScNHMzdu_PkBTK9b3zStvgemDA@mail.gmail.com>
 <CAAPL-u-vmt9qx=E=tLq5NGQbam5i3WFqvuAepxzYMJ7EkRYgMA@mail.gmail.com> <20240209002538.GA896819@cmpxchg.org>
In-Reply-To: <20240209002538.GA896819@cmpxchg.org>
From: Wei Xu <weixugc@google.com>
Date: Thu, 8 Feb 2024 17:21:03 -0800
Message-ID: <CAAPL-u_2yfwg6h-_sDu0sCA7SphSpjwDAwd0dF9e3iDwEPW0gQ@mail.gmail.com>
Subject: Re: + mm-report-per-page-metadata-information.patch added to
 mm-unstable branch
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Yosry Ahmed <yosryahmed@google.com>, 
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

On Thu, Feb 8, 2024 at 4:25=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org>=
 wrote:
>
> On Thu, Feb 08, 2024 at 03:50:12PM -0800, Wei Xu wrote:
> > On Thu, Feb 8, 2024 at 10:08=E2=80=AFAM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> > >
> > > > > I am not closely following this series, but I just wanted to poin=
t out
> > > > > that this is not always true. We are actively extending
> > > > > NR_SECONDARY_PAGETABLE to add IOMMU page tables in addition to KV=
M
> > > > > page tables [1]. In that case as well, the name was left open-end=
ed
> > > > > exactly for this purpose [2].
> > > >
> > > > I think you're glossing over quite some nuance here.
> > > >
> > > > Sure there might be highly specific scenarios where you can get awa=
y
> > > > with it. Like with a very recently introduced counter for somewhat
> > > > niche audiences, and bucketing/grouping that was IIRC planned from =
the
> > > > start. It's probably not reasonable to advocate nondescript interfa=
ce
> > > > names as a strategy for getting out of ABI commitments.
> > > >
> > > > My point was that "memmap" is the established term for what the aut=
hor
> > > > describes. And that this concept is sufficiently first-class that
> > > > mixing it with other things later is unlikely to be acceptable. I
> > > > didn't know WHY a new name for this was chosen, so I provided
> > > > arguments for two motivations that I could think of, that's all.
> > >
> > > Sure, we can rename it to NR_MEMMAP_BOOT / NR_MEMMAP. We picked
> > > NR_PAGE_METADATA_BOOT/NR_PAGE_METADATA as we thought it was a clearer
> > > choice. It directly conveys the concept of page metadata overhead,
> > > eliminating ambiguity about future potential structures. Today, it is
> > > "struct page", and "pag_ext", tomorrow memdesc and more.
> >
> > Technically, page_ext is not part of memmap if we go by the kernel code=
, right?
>
> From a user POV it's the same: the fixed linear overhead of mapping
> out physical memory for kernel use. struct page is the build-time
> component, struct page_ext is the boot-time component, but I'd say
> that distinction is mostly just an implementation detail.
>
> If between memdesc, folio, slab etc. struct page disappears entirely
> some day, "memmap" remains a valid concept and a cost of interest.

"memmap" is not a meaningful concept to the userspace. If we choose it
because it is well-known within the kernel code, someday some kernel
engineers may be surprised to see non-memmap overheads get reported as
"memmap".

Anyway, I don't have a strong opinion on this field name. Just want to
point out this potential issue.
