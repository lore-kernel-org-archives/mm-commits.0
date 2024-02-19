Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FB0EADB
	for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 08:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708331518; cv=none; b=jx6PuiE75kW916uJ5bjBZ7MOdQjFQcwHlCOc45crf4+Jajtt8keAMvlqc8eDChumMFiw1D4jS8G6jWDfXbn7gmLZLwyAFpA/CINqDm1s4hN51vZcdnN5w3eoVYp4lia9pGFdo7KywnfHSaIREMDB9Ec/Uf2IB8qC5TRDsYWnRoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708331518; c=relaxed/simple;
	bh=azzMnpxuyOxwwD9JIbQoonHVz1ujs57sMBFdHa3Fxss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eMWcPtkjQqm8jf/OaHR6+GH6AvMKb4JqqdL5J90GJYifAAV5indngBJpD3SjHHvbZs9xYMAqfNzZuiap0DQjcx4cq/BVThJPI/Lx66M9M36E2Dd36jSnOrQBvPWPYmEqxZPZuGwc34OOv4fNYZuR7XaajR2ir2nu7pwSigzId/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tCkCMXq4; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tCkCMXq4"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5611e54a92dso5311712a12.2
        for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 00:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708331515; x=1708936315; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ReF7ZS4BdM2heVD/O98xwE04+bHW0JzO/v3Zlj/ehw=;
        b=tCkCMXq4tP3pdpo7kqAZZNnOSm/U8aiHnfZ/YWaaqtfV1ilZokIErPLuGbdXxp0MPs
         rPLYIv+4pUVtM/DvtHEv14luLitGVwX5X5xzt2dM74dGjkF8uweG7EZsymrq+1/I3HpC
         IlNmyFYbwVmuFIVCFxeP3i5GxGhQAi4/3XXnPzvaSEl/NWkZmxHyP9P78JlXCnxUnuSj
         MtmpCkq5AF7+Fv3LhvZT7cyY+yIP+/goDMYeCBUdoqzQKrAQjlO6MYfz/9ouiObmE9vX
         EZFu86gLSlz4oZrUGzpl9oc4H0vedx+WYv3TcpgVKkBeAR+acC8teCfdUiwrkmYjx2Ml
         qszQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708331515; x=1708936315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ReF7ZS4BdM2heVD/O98xwE04+bHW0JzO/v3Zlj/ehw=;
        b=rbbpVw6mN3RJa80hZhjiCZ8Epevxtbq+rITpmSefLnKJ9Fg5zjqVjI9xc81XFDSBwY
         bjizhG7UlkahQWPHPSUJDFmEQUdQVabcrvYbKoDgJEN0+M7OvmP22ah7vQp8+fqmruxC
         a5+W7PdzLi91JXieMcV03xu2betHZyLvvq0KblqViI5Rs2bI8ayCMGQLZZ+Pg+qFV8v7
         X574z+zlmnby2RUjiICK6RwsNa167M62NLvgxdlR2xqO4kNA2KYet+3WV9AtRv9FBLbK
         +FRxZIMjWCo5TTdTw2h9g7Lt2iKd5qdUm7bwdqOWtzL7htNMMg7U/MapLsgLJCRz22Eh
         iqBA==
X-Forwarded-Encrypted: i=1; AJvYcCXaFAjtFirbGaGMRUH/AMCtHx+U2tj0NcUWzdvU+wjn8jZyxKcxaI9GEqmdqZ2UQAWkH5dvtq7cT+s0AT5lTeTnmo+q+nQOvoh/tA==
X-Gm-Message-State: AOJu0Yx2DZE2CzYF1BbvCWuW89e3JuGSlVfRfpY6L0htGkDX0EzBozHo
	niGLro716FIiYXNH9efiEo91hKXgZ4DBqufkfo6bpO7d21X5tcw3B22xqLIM3lfuGu2qbXNLIhX
	Uvjn2PC+jIMhwpxCVqRScPPo0ehAmpKDDKIwo
X-Google-Smtp-Source: AGHT+IFM9mBSvKcbxWaPh562fVG0cVrUMKvvvVVaRvv3MzecRuDd78jjni0ScfRZxzbjs+0500gfyc2nWw3pIEMzpgo=
X-Received: by 2002:a17:906:84f:b0:a3e:6aae:d342 with SMTP id
 f15-20020a170906084f00b00a3e6aaed342mr2096122ejd.47.1708331514654; Mon, 19
 Feb 2024 00:31:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZdK4x9J/hhReO6wg@gondor.apana.org.au> <20240219040317.5184-1-v-songbaohua@oppo.com>
 <ZdLW0/cLS0YT6P9E@gondor.apana.org.au>
In-Reply-To: <ZdLW0/cLS0YT6P9E@gondor.apana.org.au>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Mon, 19 Feb 2024 00:31:15 -0800
Message-ID: <CAJD7tkZ2TF-hFTFBthcdEaxJoojo7rvWRe3vLkfLT4ALgVyygw@mail.gmail.com>
Subject: Re: + crypto-introduce-acomp_is_sleepable-to-expose-if-comp-drivers-might-sleep.patch
 added to mm-unstable branch
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org, chrisl@kernel.org, 
	davem@davemloft.net, ddstreet@ieee.org, hannes@cmpxchg.org, 
	mm-commits@vger.kernel.org, nphamcs@gmail.com, sjenning@redhat.com, 
	v-songbaohua@oppo.com, vitaly.wool@konsulko.com, zhouchengming@bytedance.com, 
	wangzhou1@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 18, 2024 at 8:19=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Mon, Feb 19, 2024 at 05:03:17PM +1300, Barry Song wrote:
> >
> > Not Andrew, i wrote a note in cover-letter and said zswap was
> > the direct user for this patch, so it is good to go through
> > mm. but it's also fine to go through crypto.
>
> Even if we decided to export whether an algorithm is sync or not,
> the approach taken in the patch is not the right way to do it.
>
> You're exporting an internal data structure and making it available
> to everyone.
>
> > But the problem of directly using scomp is that we are losing
> > the chance to use hardware like intel/qat/qat_common/ and
> > hisilicon/zip/zip_crypto.c to offload the overhead of
> > compression/decompression as those drivers have no scomp.
> > On the other hand, acomp with acomp backend can sometimes
> > decrease cpu usage especially when PAGE_SIZE is big such
> > as 64KiB while providing higher performance.
>
> No I'm talking about using scomp only in the specific case of
> an unsleepable context.  If you think acomp offload still
> provides a sufficient benefit in that corner case, please
> provide the data to back it up.

Zsmalloc is the most commonly used allocator for zswap (and perhaps
the only one). For zsmalloc, we cannot sleep while we map the
compressed memory, so we copy it to a temporary buffer. What this
patchset is trying to do is avoid the need for a buffer if we know the
compression algorithm won't sleep anyway. This shows noticeable
improvement in load/store latency.

So it's not a specific case, we always have an unsleepable context.
It's just that now we use a buffer all the time to handle the
possibility of compression being sleepable. It would be nice to only
use the buffer when necessary. OTOH, we can't just always not use the
buffer as we would need to drop support for offload devices.

Please help guide Barry into the best way to expose this information
from the acomp API as you see fit, your help is greatly appreciated.

Thanks!
