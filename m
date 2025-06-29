Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB14F12E7E
	for <mm-commits@vger.kernel.org>; Sun, 29 Jun 2025 01:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751159611; cv=none; b=gSiFhK/cXU4xsABvVrGYOchSr8BjZRxFHQg+5bDSKgfPrBShLnTe/T3hmYCgZic2qIPyNaSirLkKEbbJuJPGSzllyhJyVIdcUe95Tn1+4+5U7YmuJlD6k3GJ7xhHjdx0JorUAGj6QzZPzMlJ6AT/VHxctF/fTOG05NVUbdS+0pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751159611; c=relaxed/simple;
	bh=rfTioqpyihx8okOzrZsGWtqi+Tjxx+H2L1ej/JYwFBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=awq3r+rCId/jgetWlIqA0KbwSfv77S3eFrp7KYf2ekyd/q5/1Pz8YgpiveYzYA5Yypf28hgkHMAKlD3tEyrYpUukUhZgBvkCYN6PZcMBfTkmdBiAjRFV9fAC+cx4s/5WS/mOqwmXqj2xT82np+WuBhIlB5lyIcrgy53Wge6vcv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XwArhct9; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XwArhct9"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4a7f5abac0aso266151cf.0
        for <mm-commits@vger.kernel.org>; Sat, 28 Jun 2025 18:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751159608; x=1751764408; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WXc2G0OQeWMzL+5K3wGXk+CQJgVS2AAi6U6Q81jyJlY=;
        b=XwArhct9VP79q7nO2567jwXqp/eKkqU89nyMXJkCUc8jN9edg/vwLCZoWm1mIhOjth
         SOqwQTVlzPtxXnvHq34mquChYMEQsnEfFvO14fL/R2dgD3PN9U83wHX6zhIl+6AZpIWX
         87yZC206Au4SJkyxg78e3VbTJwSgFSaIe2cQgOk8qyWPf1yDKKeO6GPya6Koh/I3QC6q
         UfZ1AoUoS4SagOJOttvbKwHhr21UGqjn8Wfx9u1CaGACf9D0zt5S4+HIprAiKEjQ1cOk
         TsfonUQDlw/Lp6jPw6sopRvsssfOI04P6IkZXWR3UZQK2o6IDwhdIX3VL3fEqbPB9WGJ
         8PcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751159608; x=1751764408;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WXc2G0OQeWMzL+5K3wGXk+CQJgVS2AAi6U6Q81jyJlY=;
        b=vFPrW1URz3fGSeWhtISqwrLf6Rlioplcf9Oty/mcuJHDZoG2wqeDEJ8qtE+jNhHLCz
         UwLCLyBksn9IEsdi/Ak7K2xf2zr6l2Pk9Y/REJK2dGAyDBWYtcGZnw7Y5lvKTuhe67GJ
         3pGBWhy5nf49seh/YJTipgZG/nXjAkWyyVr/tK1h7L7QNHtfQj738aEnlNKVAXK9QHkt
         VAgtZSHgU7PPYRFazRzPK2fzjxqJDQmrpSSnH6viL2KBe6VxrO9izpGnazfTDaSbyDrK
         dP4RkLaOMq1gFL0MtL++LafcdmBd9/PbecfLSqlRx7Cx9CsfHqfZm05mZbGGu6XusSnF
         g1XA==
X-Forwarded-Encrypted: i=1; AJvYcCUD/uZIZjeIhwP2oLCHtt4vXLAOYhF0ZmvQwSDp1cLPGlJajov+AqvnyuNTN62SQrahoneWp88Syfib@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1bt3Szbgw+wWs4yS4N1S26MN8auVZlROlboeVOLJhBpPFd+fw
	zULgPfV1jizRN3HoA3W23EiUJYu9joFO17/887n9MWKC2Z/ATjh/02Lojut6+WtbtWNfb06OrWj
	bFujQNIioepSvFrsvyPbsRogdv7a5IhYvpigXTGo7
X-Gm-Gg: ASbGncs9gY2XA73d3VPF7DdiiX2uwpFdmYSXfUbA1sezPYDrayvTLhf4Guba5bwmZv+
	G5idDrteVidh1X3FkYkD/sRbMS1QZnb1EyfzZrplOS30jtjMk1FC3JLUipArY3lAnGeSbLdeVUe
	KQ/PMmcOnwOC9a0RK8IFfKpP1L11FSEwEPZqtrdBtmug==
X-Google-Smtp-Source: AGHT+IGkHUhKRQqbV2rVvm2j8VBfwM9n76m1n9CbKXrTSIKOVAExi5xQmGBjvG3gO9hSrhM9Lgvhl+iPqKRBmNxJF6o=
X-Received: by 2002:a05:622a:47cd:b0:4a7:ff6d:e956 with SMTP id
 d75a77b69052e-4a808f48839mr2471961cf.3.1751159608129; Sat, 28 Jun 2025
 18:13:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250624200751.ADDEAC4CEE3@smtp.kernel.org> <df410ed0-054a-4867-a2f9-1baf92c2d41a@p183>
In-Reply-To: <df410ed0-054a-4867-a2f9-1baf92c2d41a@p183>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Jun 2025 18:13:17 -0700
X-Gm-Features: Ac12FXydpF-ADyT4QhSWLYyH5F5DxH86P7SQ98-IIA8tJdbJDtOoRgXiY9xlrgA
Message-ID: <CAJuCfpEeMjsK5RuD+fZyoDo+pG0D+752WtFM7VntyjYt_X0fuw@mail.gmail.com>
Subject: Re: + selftests-proc-add-proc-pid-maps-tearing-from-vma-split-test.patch
 added to mm-new branch
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org, 
	yebin10@huawei.com, willy@infradead.org, vbabka@suse.cz, tjmercier@google.com, 
	shuah@kernel.org, ryan.roberts@arm.com, peterx@redhat.com, paulmck@kernel.org, 
	osalvador@suse.de, mhocko@kernel.org, lorenzo.stoakes@oracle.com, 
	linux@weissschuh.net, liam.howlett@oracle.com, kaleshsingh@google.com, 
	josef@toxicpanda.com, jannh@google.com, hannes@cmpxchg.org, david@redhat.com, 
	christophe.leroy@csgroup.eu, brauner@kernel.org, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 28, 2025 at 7:20=E2=80=AFAM Alexey Dobriyan <adobriyan@gmail.co=
m> wrote:
>
> On Tue, Jun 24, 2025 at 01:07:50PM -0700, Andrew Morton wrote:
> > The patch titled
> >      Subject: selftests/proc: add /proc/pid/maps tearing from vma split=
 test
> > has been added to the -mm mm-new branch.  Its filename is
> >      selftests-proc-add-proc-pid-maps-tearing-from-vma-split-test.patch
>
> > From: Suren Baghdasaryan <surenb@google.com>
> > Subject: selftests/proc: add /proc/pid/maps tearing from vma split test
>
> Can this be moved to separate test?

Yes.

>
> Original is about /proc/*/maps being correct and isn't about races.

Well, this test is also about the correctness of /proc/pid/maps, only
when there is a concurrent writer.

> Original is amd64 only while yours is not.

Are you saying that this test before my proposed changes can be run
only on arm64? It's counter-intuitive to me that such a test for
/proc/pid/maps correctness would be arch specific.

>
> And it is one-shot test not time limited.

I see your point but would that still be a problem if we limit the
default runs to some short time period, say a few seconds?

>
> > +     /* Test tearing in /proc/$PID/maps */
> > +     if (test_maps_tearing())
> > +             return 1;
>
> This just glues 2 tests together.

Ok, I'm not really against splitting these tests. Just wondering what
I would call it because, as I mentioned, both tests check
/proc/pid/maps correctness. Maybe proc-maps-race test?
