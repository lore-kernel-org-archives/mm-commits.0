Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37D33C01
	for <mm-commits@vger.kernel.org>; Sun, 29 Jun 2025 01:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751160793; cv=none; b=IuigLy1AnukU2LyGsB+OxTCdNkcK9Lk9oCmtoisCfhDgqZfMABtXNfz20rbX4FbFb9jRwJHuw/vRoZ/7GdWwMri2S2SylChdWrcROmbBQJygrylW1B69frnbD4O3T/xqeX76BUb6W4MbBFC1HIbal12jzNYbK16m3zw1IWb+Et0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751160793; c=relaxed/simple;
	bh=XQ8hZxSGNfIyPJWUG6myuaivgdHAMc7npKmYeoevYdY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mChJgfgXWPs3Y3jAOHleTOycwbeYlellbAKBORU5Okp6Yjgzlwoa/wM9JjL9gUAIW7JrMMkgSlQ++h2EkO/cKh8DzOM/CSHe4uq0WXVLG5Nhgdn4/UQBQme6u7R/JBDHGB3ezWbsmQgQEe3ouyzX4VQd3pLE3tQMf6uYi9bvoZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vP6AGtZF; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vP6AGtZF"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4a58197794eso175991cf.1
        for <mm-commits@vger.kernel.org>; Sat, 28 Jun 2025 18:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751160791; x=1751765591; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1MRGTaccYCZA6j7U19WU55sakRCt9MqO1zvW7pBC5J4=;
        b=vP6AGtZFW0XcySfhzPhlAS0238mH8EjOL1buWBftjC1EBjpOhVtUMLr3nvc7teP3ed
         b0cLR43W0P08iKCnse8NW69KlhZUt231+s0kbJKQcOHt/DAMcIUEqewCAwlVO3IjvnU9
         bpYcfrrTBF1oTSYBAyVyzOTV5w3oiP4QSNUrWb0dZZ/7MsSuN2HAT8AIFZhNOr04gCvz
         OCi6B0ofWk4wmWimWeToFRE8DSQeV7o5ZuU4Oft/qCZhDQfynW6lSXPdX1R0PY6TC57/
         bkyFYHLNg7FEDyxtEFyEiNRTgu/uhfVT9/g4eGpvS5K2B2PSOGSldtlxDZsQ799/n7xo
         btiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751160791; x=1751765591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1MRGTaccYCZA6j7U19WU55sakRCt9MqO1zvW7pBC5J4=;
        b=KiJuyenqXMWgJxj6lV/hlfr8BTbC0PhXDsEPRkMPEAYo1toSClEKR9+6TmCO7dg31I
         ylSJ1Dogyub44Ds5XNrTPDLMBKjzg1+Xvj4RK5GizvHm2f1Q/fY75mNweG1QYDjelNVU
         ngb8F8EDBQ2YpmWeC6YGRxxrSq4HD9dJ3bDaNKX9SqaYoZ3GrRfShhAB4vgwt2vLvJ1h
         jPXgl/JnYOwuvwKvldHA0nIfpcu9h1Y2BMRRlyeGQoVtgoNxDtWO7Ww2UWMGGjUVJ8Zc
         BmQpFUIpyt9xY58pDkeo4Dec3nnarOnQ8sAA73H9CaK07xchspWEJ3c5SyTttjjfo0xp
         umUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdZydr5446AY+RvdTDjz0H1eOrUK3FksGo5AwHeOloclqdAz7cpNDmbSylDCH7JhPiX2Vkw2RsTTGE@vger.kernel.org
X-Gm-Message-State: AOJu0YyWfTxX+mP6/jcsVTfrx6Y4V5Pp7Uh66HLvNlTrnV0MlLWl1V0O
	6NKzdHOhjvXV6W8p011J4GDOX3gC+CZyF7oEuJE+Ts+8Z9PDFll87/Oxu5OvqVINPI2L3+CrCea
	gKYLsM0GoTpxxhN67WlEUUsYsGX07JqpG53pZFiBk
X-Gm-Gg: ASbGncu37E13rkptX7B9GH+Wy2Qb9cVp62nyL99WJOwk11rJfkMkF1YUqswMoGgnA5K
	69htbbplLnTcRHUo5PkmIdpd2bWBtt54g850a7MFgCHH5qbmZ/1Yjmr2sbHulRoHD/UiR8+wKnM
	uVDlXJ5lY1pwfy5WDb+0Clv7HLN+sL99YX/4ctgjm56A==
X-Google-Smtp-Source: AGHT+IHgFTdV90TRO1Irr5ObTCUfhag3J1S1IqkCkGv/o2Q7Bm3WMSqHLy16dv78CJo2LGyRLwc3tY0qEPi7+3TEJHs=
X-Received: by 2002:a05:622a:1448:b0:478:f8ac:8adf with SMTP id
 d75a77b69052e-4a808ff65ddmr2484221cf.19.1751160790372; Sat, 28 Jun 2025
 18:33:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250624200809.54B9DC4CEE3@smtp.kernel.org> <0760b4dd-b6e3-4b78-aab2-ae5cdb8076cd@p183>
In-Reply-To: <0760b4dd-b6e3-4b78-aab2-ae5cdb8076cd@p183>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 28 Jun 2025 18:32:59 -0700
X-Gm-Features: Ac12FXyvoxGE5wgEEwHq_EidnNMDaPFWwUYrwUUn3xeOCzxDqw1QW5-nmTIG5Qk
Message-ID: <CAJuCfpGSG2haE=ekTOJufnuEgPo-KA_514Enq5kB=HcS-KnLOA@mail.gmail.com>
Subject: Re: + mm-maps-read-proc-pid-maps-under-per-vma-lock.patch added to
 mm-new branch
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

On Sat, Jun 28, 2025 at 7:31=E2=80=AFAM Alexey Dobriyan <adobriyan@gmail.co=
m> wrote:
>
> On Tue, Jun 24, 2025 at 01:08:08PM -0700, Andrew Morton wrote:
> >      mm-maps-read-proc-pid-maps-under-per-vma-lock.patch
>
> >  static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
> >  {
> >       if (*ppos =3D=3D -2UL) {
> > -             *ppos =3D -1UL;
> > +             *ppos =3D -1UL; /* -1 indicates no more vmas */
>
> What's going on here? loff_t is signed. Maybe it is OK.

Yeah, that looked weird to me too, so I just checked the history.
Looks like this comes all the way from 2.6 era when these sentinels
were used against seq_file->version which was u64, see here:
https://elixir.bootlin.com/linux/v2.6.39.4/source/fs/proc/task_mmu.c#L119
I think now these sentinels are used only with loff_t which is signed,
so we can change them to be signed constants. I'll add this small
cleanup patch at the beginning of my series.

Thanks for the feedback, Alexey. I'll wait a bit for more feedback and
will post the next version next week.

>
> "unsigned long a =3D -1;" I can understand. Give me some time to recall
> casting rules.
