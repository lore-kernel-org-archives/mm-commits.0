Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C79F1FECAB
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 03:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756267151; cv=none; b=Xu5YftLDY7pxTz4Db4NtGSxfEKrVLI8m2aHIIrRvx7Ch+NE3J4UIcuSOnQUjxW2L3MFQkkCMz7QP/kfcVSTbqzLJQcok8sNmCK6oSy4PFgDAdP66xhRjpStNAvk+AN4km1vz5hg9mx/SxemF7lr8uFa3d52xFi87d3qD72jNpUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756267151; c=relaxed/simple;
	bh=riScXKuxkh5mI+cWFJXkMkfrRsJwrE2BQ1SuvVzb4pw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F5gI/tQgGkp5c4/6CAZ8rQPh9AkqZ15nNphgY1GjMLToSxLU0uFGkk6zJTfDHVrT1Y9XdzLsmz0Ita3/96Pa0detxbUbNj77uUF3WP/nCeM4hpZdYiwYb2LtJzOn6xk59PHwHmoafsh1NpK0ySVI9DzfLWBhdJpR4DSGidDGtPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYP7SpUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYP7SpUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF845C113D0
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 03:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756267150;
	bh=riScXKuxkh5mI+cWFJXkMkfrRsJwrE2BQ1SuvVzb4pw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kYP7SpUCUFZBYLuXUMPSYRhP2BupzTpj1G1nsp+MQCWdljOuDNQnJppGLwqBOubtr
	 d2PxQ5bSJKX5iZ6tZnL1SV0TimR7kAG0coml9mK2oQ+8ctfmyWzB4K8vBCYKrglix6
	 Vl6DnQPcQXyW0p0vRU3Ltesff+sa/afWwaGmo7sZxQDQzeaR6VcqUav4drhJO+xLLT
	 Sf6sNMynqBarmiXXeq0S/Ril58WZTA7YbZxfpZV/AtVElq7avEKDBBp5AlgzOAyNGq
	 Jp6Ucg+Vjq7TOErLL9uR3LPkXEkuNiQs8L3uUZulgYekU+eqXvLtMpYk5f9L817Wbq
	 EIu52YDiwByOA==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-55f48d61ea2so3388237e87.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 20:59:10 -0700 (PDT)
X-Gm-Message-State: AOJu0Yxlk6qaVU/emvSdjMxxoiIFjZyVi6BDmFN1F4g5IW9MRtc1h+p6
	4D2gmmc8ujpbLvU/melmEA5mAlP7xzCk9ITPj+yU0yM8y84Z/Yx5dE71W6ls+e8I+euYO+/cDkX
	xXPnog/k1hXs2tK7CYmiINOvUfEjCohs=
X-Google-Smtp-Source: AGHT+IGp5w/qCV9gwmnSlvjd7W1uR6Kn+hf8uUq2X+uNT/CZAdeJcIwOqNukATBjjPA+wHwRD9WL+iE5IhsK4OFxtzU=
X-Received: by 2002:a05:6512:10d5:b0:55f:44b8:1edb with SMTP id
 2adb3069b0e04-55f44b8233dmr3052450e87.45.1756267149162; Tue, 26 Aug 2025
 20:59:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821213034.0B05AC4CEEB@smtp.kernel.org> <CAMj1kXG8OhR4TE013TqhFjf__nWbiF17gjSJFEbODH9wKk1b3g@mail.gmail.com>
 <20250826163129.8324fd9a457f549a6bd63728@linux-foundation.org>
 <CAMj1kXETbG0YZdJSjaw4o-QLpCNVmtuGpeJL6bFqpb_sBiW1MQ@mail.gmail.com> <20250826204233.997c07140f1ba550798720f9@linux-foundation.org>
In-Reply-To: <20250826204233.997c07140f1ba550798720f9@linux-foundation.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 27 Aug 2025 05:58:57 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHT3zJq5JzenRnYupkxSSUkzi_3DRKzOVpF6HZ8_x2MZg@mail.gmail.com>
X-Gm-Features: Ac12FXytzb6XxjkUnQOll4_n5c-LTpV8YAeKyv7rz3uloGBImlE_izgrT2-uvsg
Message-ID: <CAMj1kXHT3zJq5JzenRnYupkxSSUkzi_3DRKzOVpF6HZ8_x2MZg@mail.gmail.com>
Subject: Re: + efi-support-booting-with-kexec-handover-kho.patch added to
 mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, rppt@kernel.org, graf@amazon.com, 
	changyuanl@google.com, bhe@redhat.com, epetron@amazon.de
Content-Type: text/plain; charset="UTF-8"

On Wed, 27 Aug 2025 at 05:42, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 27 Aug 2025 04:38:38 +0200 Ard Biesheuvel <ardb@kernel.org> wrote:
>
> > On Wed, 27 Aug 2025 at 01:31, Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > On Tue, 26 Aug 2025 14:55:59 +0200 Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > > On Thu, 21 Aug 2025 at 23:30, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > >
> > > > >
> > > > > The patch titled
> > > > >      Subject: efi: support booting with kexec handover (KHO)
> > > > > has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
> > > > >      efi-support-booting-with-kexec-handover-kho.patch
> > > > >
> > > >
> > > > Please drop this patch. Once we agree on the right approach, I will
> > > > take this via the EFI tree. Thanks.
> > >
> > > This was part of a two-patch series.  You're saying we should split
> > > that series apart?  That this patch has no interaction with [1/2]?
> >
> > Please drop both if you think that is more appropriate.
>
> Why, what happens then?  Will the kexec patch be merged via the efi tree?
>

Who knows. But queuing it up now is premature.
