Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4804CB28
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 14:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716128435; cv=none; b=ZUo1LegPeCfLL0L7bWxPSqDWK2qRRj6jAtET1NDDVjS8CZ1+HmN/c1ERC8wRRlBCXxz5luSDZmxUy2d0lBHOKEgXk4xGJc5mqRorY0ZohP+MI3pgk3/YcFVcDcTaqRMcSR1WGFS3xnags0uuX4zMmCK0z8i3ZgsX0upY++K4BUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716128435; c=relaxed/simple;
	bh=HDSrJ2IOowjwO2fOM8lB78qfntp1wsgsAM1/IMgRg5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qV3eDGvVMrs4Irk+5xRwNPC8NYyczRsxvD7Nu/09ks8jWlDGNVyfW2dPAclVsJ3kSAnwn/iCMNiB5jp2kX6hBe5Pd7q7NHVxCwq0MLZIY/bB80pZnf7w54O3qq8+FWf16WqAiix/xmF6fo5FloJ4VM0rcHzhYTsSMKaN1bUccdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DraRiJpy; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DraRiJpy"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-61e01d5ea74so16847197b3.2
        for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 07:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716128433; x=1716733233; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nHPt9kY8ZvJVhbmzwFV5BXMi5lSr+EBmXBs6ZAvcZAo=;
        b=DraRiJpyeoVKhKxVBY3lCIVh9TBBq6Inm5GA1z+M5PvY5njowJwhLOPBmZbeH2mkdf
         QBNt9ZbwCtEl3A1K2l9S+/n9UCvzlHn5yNI5UayXPijmXqjyDrA35XcgDiiVG0G3n+bR
         sK+l1p0UYVvly/GNTFFsSBxYocqbkWbdmObMfWdaftghN/zGsG3X/jOvbpi6Jjea5Q3i
         Ysiv4DqfWY10TK0ze1IscT7ZCoVjS5VjwQuNCWKqKIRhLEDrHQP5Vdxn7xb387gQa0Ef
         PtH0yDFOIpnKD4Fxuk1rm8Fq5wgDez8Qogx4SPeDgQ4s0JMj1EpdGZWd5+dj00CUS7IG
         XvwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716128433; x=1716733233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nHPt9kY8ZvJVhbmzwFV5BXMi5lSr+EBmXBs6ZAvcZAo=;
        b=o40h2NCvxEfz2tou4rFgewDnEBnYwE3W9E/segSu0BCGXU3RDtbx4sfsK+MhIhkJOC
         +Tn5KYQUdBQCD1oJpZnwOgWBFAzkI7K1bOLOntpPxhrb130n6DMF1NdVsvyznxXRH1CE
         147HLM1FrkQSyIDNLy98dbCMMiUikYh8FP2yBwbNoX8FBgyrZmRGInDBLA743GviUGm7
         EfcjWVlkO8Ibc7hdNhl/6xAoVm3oh2B0o8kN3/K0Scy0NjmDXVgDzyCgwIonY9kSKEjo
         7k0ecjSpgrRtkf4DobEaFPftS2wa/e/UU8TigrnPfdods957/E5O3JY8vnKQ+ajUtZHz
         +YGw==
X-Forwarded-Encrypted: i=1; AJvYcCU0H5Qgo0s6Dpy5I9fPnqoz8kVNS1YHu7VJ8DyLu/Boa7IdLNsreqraYCRrnm2FwZDhLXO+kzSV9/7RCnb+d1xTTQa/5vqMa7CTpQ==
X-Gm-Message-State: AOJu0YyLkgENlyvEyGA7O2p3J54fOCXTBuaFQcbpgTZ8hapgaGOG4FoR
	etkcVF9xbQvHbGu5BLXltuvMsPuFNw27rArerKmclgsBuucTjGJWwDqsyyKC7a6Ak/6qCwuxz7E
	lNCF4FSh0T8D5Bq3MfUVoHq9Ix7eE8pg9Oqc8
X-Google-Smtp-Source: AGHT+IF7ijZKXFPpkytHHcCrHz20wDDoOyWabtpJMM9cSAMjCIwDBuPFoDdsoRHnP9XZeG4M0VpoxZQSMqEL5cdAVm8=
X-Received: by 2002:a25:84c4:0:b0:df3:88ee:799c with SMTP id
 3f1490d57ef6-df388ee85a4mr11697100276.7.1716128432623; Sun, 19 May 2024
 07:20:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240514202009.2FA52C2BD10@smtp.kernel.org> <5c047df0-266e-420f-9bcc-fdec16c9b16b@suse.cz>
 <20240518225655.728977c51f94812804cb85c2@linux-foundation.org>
In-Reply-To: <20240518225655.728977c51f94812804cb85c2@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 19 May 2024 07:20:19 -0700
Message-ID: <CAJuCfpE9XhDf2h1YZBz9M4LyRFKeQOrOuP3i6rJjEoMhngYRdQ@mail.gmail.com>
Subject: Re: + lib-add-version-into-proc-allocinfo-output.patch added to
 mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, mm-commits@vger.kernel.org, pasha.tatashin@soleen.com, 
	kent.overstreet@linux.dev, keescook@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 18, 2024 at 10:57=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Sat, 18 May 2024 23:03:52 +0200 Vlastimil Babka <vbabka@suse.cz> wrote=
:
>
> > On 5/14/24 10:20 PM, Andrew Morton wrote:
> > > The patch titled
> > >      Subject: lib: add version into /proc/allocinfo output
> > > has been added to the -mm mm-unstable branch.  Its filename is
> >
> > Hi, I don't know how mm-unstable/mm-hotfixes-unstable is handled during=
 and
> > right after the merge window, so maybe it's already the plan, but wante=
d to
> > note that for this patch to set the userspace ABI with versioning right
> > away, it should go in before 5.10 is released, and maybe even in the me=
rge
> > window itself so the version line is already there at 5.10-rc1.
>
> I assume you mean 6.10.
>
> Yes, I'll either build a little mm-stable for -rc1 or I'll add it to
> hotfixes for 6.10-rcX.

Perfect! Thank you folks!
