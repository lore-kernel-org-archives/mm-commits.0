Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D583258EF5
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 02:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756262333; cv=none; b=scbxuMvJlBb2Hn06E4G8tSpQVDhZDp0Y1Z+uNboC+g8UcKUVPCRLGkZbR1mF/ETwMrh86mBNzui4OIEj/o8iDjHYWOxpbhrs6ymvX91POYMKkk+IaKhuQiFVEqi5bhxmVHoO3m54E27Gf1vbwt4Hb16XM3o4JtYL+rdvKIGA9Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756262333; c=relaxed/simple;
	bh=ixJyUxrhdBWBbQzdzvT2my0uhsqZ4/Wt2CFyH58dyak=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AxANjLClv9rID2ChNlC9ASf32cGW8wWt1Dau2KxiLa0hmZvX4eraSWt3EdiJ1GKbmaqyBab7C0BJjyTnCr23pvXLOi1E5t7d92Cev4n0LTKwIFWadryzO/yfWVtNyHn5OmGxS4mMv4GgF9cotRkIxnGN8epaf9czWcFijEJ7qc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d59KJ5jp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d59KJ5jp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0157C116C6
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 02:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756262332;
	bh=ixJyUxrhdBWBbQzdzvT2my0uhsqZ4/Wt2CFyH58dyak=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=d59KJ5jp1NOdQEyA+kNwkncVdnwD8+Mi1mmhHkyp99eAuoj6Au4+7/KgN3Mz2iBY1
	 n+O1YHcOI6Jek4kkrmbB+ePcuBiJQmc020jncfabG7lwouRg9iCYTdCa4UhMMDnYO2
	 pBTHBToWY2RNCHwB1+0MaCFKhSMHWWVl0vW7l7PO7KFzNI4xqigFShwidbtuGYQq9Y
	 tRi1W79d1rvZsw+5KQvjRhYqD0aFdB0Lpp2jbHQ1+79Ggx4QHKGaK9z9P4M4AwRiy4
	 B9jK/igceMVMsw7VKenVBTK3GLt/SEQTlywYC21PrWcRmB21DA6qc2n4HYxxOxlLgR
	 YxUjw6gy9E2/Q==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55f40cf5e54so3654173e87.0
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 19:38:52 -0700 (PDT)
X-Gm-Message-State: AOJu0YyLP84bvGhyygbDA95rs6lXoLqMQNleap7932YGvO8axhwN1+BV
	2K9Y+cXgrzOyDqnAwtVvTtixZn+UWh6QLwsI9FXQPfCkTeQkWlwRqY8/U8mrRzAxGrO3adj7VrG
	I5I70COKAWs5hCa32+ajVTHuHMMTr2Dk=
X-Google-Smtp-Source: AGHT+IFZLO4jh7FgSZZUkMmAFv7HE4y5VSEfK3xkV6iX5rgiIAuUw6oOj4kPrRN2V4AUguDwvz+EDjyOk8bS7jJyQCw=
X-Received: by 2002:a05:6512:3e26:b0:55f:5172:4744 with SMTP id
 2adb3069b0e04-55f51724a1emr951587e87.4.1756262331005; Tue, 26 Aug 2025
 19:38:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821213034.0B05AC4CEEB@smtp.kernel.org> <CAMj1kXG8OhR4TE013TqhFjf__nWbiF17gjSJFEbODH9wKk1b3g@mail.gmail.com>
 <20250826163129.8324fd9a457f549a6bd63728@linux-foundation.org>
In-Reply-To: <20250826163129.8324fd9a457f549a6bd63728@linux-foundation.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 27 Aug 2025 04:38:38 +0200
X-Gmail-Original-Message-ID: <CAMj1kXETbG0YZdJSjaw4o-QLpCNVmtuGpeJL6bFqpb_sBiW1MQ@mail.gmail.com>
X-Gm-Features: Ac12FXyGD5QqVWsgbYKz4peQL4Q1QBIZsB3SLum8od3_eUPpRNAVULsuBY8_8jc
Message-ID: <CAMj1kXETbG0YZdJSjaw4o-QLpCNVmtuGpeJL6bFqpb_sBiW1MQ@mail.gmail.com>
Subject: Re: + efi-support-booting-with-kexec-handover-kho.patch added to
 mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, rppt@kernel.org, graf@amazon.com, 
	changyuanl@google.com, bhe@redhat.com, epetron@amazon.de
Content-Type: text/plain; charset="UTF-8"

On Wed, 27 Aug 2025 at 01:31, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 26 Aug 2025 14:55:59 +0200 Ard Biesheuvel <ardb@kernel.org> wrote:
>
> > On Thu, 21 Aug 2025 at 23:30, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > >
> > > The patch titled
> > >      Subject: efi: support booting with kexec handover (KHO)
> > > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> > >      efi-support-booting-with-kexec-handover-kho.patch
> > >
> >
> > Please drop this patch. Once we agree on the right approach, I will
> > take this via the EFI tree. Thanks.
>
> This was part of a two-patch series.  You're saying we should split
> that series apart?  That this patch has no interaction with [1/2]?

Please drop both if you think that is more appropriate.
