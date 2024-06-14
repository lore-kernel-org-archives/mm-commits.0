Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0789619ADAE
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 18:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718388373; cv=none; b=lWxeXhGMvAD+mKuxPLLrXxcSAGvdv5k1HimUFT02woXOI6TUPf/BJvqUfoGWA9zk1bBJV442Rech164L+Mr15R7BbuARrTp7XkZWFObtd1avmk7ovVIVU5yHFEkac0qKDtCDeGf7ImeSF5Uc2z+mVx7zpGXX1drBF9nxlbV5xf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718388373; c=relaxed/simple;
	bh=UmeqOnQadIVF8wnWLkHZokIi4HKfqGDBIHg9hXIQLqU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yh+MHzgWDVnBE35+FolfJp1yy9LdHKTkkRAvRAVlcZEVxen4D81cpCIXi+IkD/Aks9H2V7xtqKLIbGyH/QRURKZcSsyxdwVM0f7v6LgR98MvooHC1oIqalIdhEcX5OZn6zkcSopVqBCn7BII6MPdmQt4suW/0EypgkJqzRhrcmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=FttVynul; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FttVynul"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2549c883c43so1627051fac.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 11:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1718388371; x=1718993171; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yfW8jkPIpZOt+t8esAaeqDWC4xJvQRz6NlB2dtspT1Y=;
        b=FttVynulcoE52a5OQkRTnweYhV8gKWYty8GwTjFfaueWTqYPmb79OX3OKGcDq41OO1
         7cAj7BL4Cw4h2l8Kivbtm+rs5NrknmqYBqDkjHjICA1xtJHMEgWCtdEi9Y3f9T0b5A5W
         2CokJzMW94ZQrP2NdV0Rh+8F7efVfH+06DDmk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718388371; x=1718993171;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yfW8jkPIpZOt+t8esAaeqDWC4xJvQRz6NlB2dtspT1Y=;
        b=tGkilZRMUYcXXW8KGN+O7yeex4utTObqaiPVqPW8Fh/aCY7zY9PANpc5qakt5nn9Nd
         M1wjBhI5G9CeJVcCQPoFxImTfOghdKDRHGOsfUj0C52eby3xPl4Nfay8QNHmAPK1gnLm
         t1iHmR9m7ktNTDIsWa5nDkHFlxGcnp8eJ2kAWlcXBYFZsWXIO+MstyjiZC4VbYi06d7m
         9Jrt5D5wTA6WluR0lHr3CyrUPc1cIyvnKYRzBZtWB8X5yLA6HC5A3pKj8p/h5tAyMGSz
         z8X0Hw4DE7TrTVbCSerJg3tWC0dpqnEhW0AJMw5d867ssy1Nj/qraaRfc1PGXDU8XE/5
         g6UA==
X-Gm-Message-State: AOJu0Yw7j6RgPjXdrtJ9BRFjyVEZ408UHq+5Pe3SOGh8QJs7Q7Obvp+Y
	1CM6vSpWdpuetkpkAsZfRNxZOAOuQ5xUdEhKmOnt0aJVkgVzx8nMOX3sbEd0lf0vKmU14j+7PKg
	EeTy7bypk2Up/vmQN9Q46/7jLcAnAZyWmc1GW
X-Google-Smtp-Source: AGHT+IH7c6Zz0TSUTGhi5N6zlGgJKDd0kUWtoh090/pCklTivt74++7OXDHp3zkbFe8lOSLoQ+P8VTQ1G2C7/vdu0Tc=
X-Received: by 2002:a05:6870:f154:b0:258:37d6:52d6 with SMTP id
 586e51a60fabf-25841104cf7mr1955359fac.23.1718388370927; Fri, 14 Jun 2024
 11:06:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240612192325.009E0C116B1@smtp.kernel.org> <CABi2SkW4eg27XTe6otutK8P1MgK0MMnLdwWAuEDks98_aZku=Q@mail.gmail.com>
 <20240614103154.2dea6d48dfbbb2e1328acc9f@linux-foundation.org>
In-Reply-To: <20240614103154.2dea6d48dfbbb2e1328acc9f@linux-foundation.org>
From: Jeff Xu <jeffxu@chromium.org>
Date: Fri, 14 Jun 2024 11:05:58 -0700
Message-ID: <CABi2SkWSip60dF95A_UeViAWDP=EMVULdqBeU+5tXw5E0osFnw@mail.gmail.com>
Subject: Re: + mm-memfd-add-documentation-for-mfd_noexec_seal-mfd_exec-v3.patch
 added to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrew

On Fri, Jun 14, 2024 at 10:31=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 14 Jun 2024 07:32:07 -0700 Jeff Xu <jeffxu@chromium.org> wrote:
>
> > Hi Andrew,
> >
> > By fixing the document, the usage of MFD_NOEXEC_SEAL shall be clear.
> > Was the previous patch (which  changed ABI)  removed from unstable ?
> >
> > I pulled the mm-unstable this morning, it seems that patch is still her=
e.
> > I'm not sure about the process of reverting it, hence asking.
> >
> > c1e11be9abae86ebe5cecc42abc412f61ae563c6
> >  memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`
> >
>
> I'm not completely sure what you're asking here.
>
> Please try not to use terms like "the previous patch".  There are a lot
> of patches!
>
> I *think* you're saying that the patch "mm/memfd: add documentation for
> MFD_NOEXEC_SEAL MFD_EXEC" (and its two fixups) are tied to the patch
> "memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`".
>
> If so then this escaped me and I shall rearrange the grouping to be
> more logical.
>
> The base patch "memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEAL=
ING`" is in mm-unstable but I need to revisit the discussion to see whether=
 we should be proceeding with it.  Any guidance you can offer here will be =
helpful.
>
>
Apology for the confusion.

The  patch memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`"
changes ABI, and I think it is risky and should be removed.

The main discussion is in: [1]
There is an additional discussion when I sent v1 of the current patch [2]

In short, current patch obsoletes  the patch:
memfd: `MFD_NOEXEC_SEAL` should not imply `MFD_ALLOW_SEALING`

[1] https://lore.kernel.org/lkml/CABi2SkXyHegwpZKF7ZVDAOsqzaHE4BdDQOMmbuJ+5=
1HkQ3CmJg@mail.gmail.com/

[2] https://lore.kernel.org/lkml/CABi2SkV9fnVjscLzKwa6FxNzfYU64ibGQxi7VWVEa=
Gr-3gXfOg@mail.gmail.com/

Thanks
Best regards,
-Jeff
