Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBB4A59;
	Sun, 26 Jan 2025 12:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737893427; cv=none; b=IrT/ru0VDkr602brLoa4zIqy8jNfA7i4mCmP9JLIp8X393WJTtD7ApQ15HHo8e7qgo7eeq3GsQtpaznLecRVRYOzgGayw7NslYmYseaz1BDjC+f+57dQ5qfKaY4rc70f7m7oHw4EMlH/tVjxZ9x4oqJRx30Fj7kdpPZ2/0KIwBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737893427; c=relaxed/simple;
	bh=p2Y0+AsCXHlMunBWZ28bGvWzD6GSojHslAjGC/wXT5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QFXTRPGPA7QNgf0O3sOuuYb5j0H9hudcim63JYD9kTlXWhsqUlJ4g5vPh2j4t2rr6uhRXrMsRYdimLHx5lwIfSu72xJPJZPyWM+EtccvuSds/R74wU3v6jkfRrwiyPvqp3G9/e7eeEV+2WydWS9WrKY8m/sZNhY1OFLUJLuSMZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k8KnpzYb; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k8KnpzYb"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-304e4562516so35075331fa.1;
        Sun, 26 Jan 2025 04:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737893423; x=1738498223; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TH9pfJxpKjAwENuhrSUz3E5bEwwre1ue+DesRAA13To=;
        b=k8KnpzYbRU7/XwSpEfQVz4lKv/Y1rmvfcbNk3rJP6UlG1VFjzu119deYbs4p2nJcJ1
         kwNCdKpzXfhgnvOtXlfSXN4lKN73/jIeKGS7zNGmJF7I9507+E7dgKPR1/CF7v9Tve4N
         W9jdaRHrPK9L5BQTceKLzDIRCPDqNkdoQfzGqCGoagq1jHB94cGvALHkqBwMhxrj2uFz
         4VMQIV/x3ND2Mkm5DCd0D73Ya3wXeGH45Rgf+PRttBKYmWdqhKyQdex5hJgMXxRH/wSn
         +iksa8iRlLH5UcKEO8VruBIqHnSAg4x6uhAcJMsdLaKUtlBfL8P34BdFh7oM+RHGkpKr
         UYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737893423; x=1738498223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TH9pfJxpKjAwENuhrSUz3E5bEwwre1ue+DesRAA13To=;
        b=mVn5EC2x5/KjSW6kDBeEhPjwiZJUTYtiR5t2AARVyphr16Onga6dWvQiSRgmZHT1Ol
         hpf5wWr8juc0A3TlsvSV4C5NYS+CjbOKx3Depy4dYCDOXJpZ+bGpGxPyhXbY8c2+5o7v
         XM2PcRX2/HKHGkJivbcasWXyzKL+KF3Pfaxf+fQJZSc6B7r9clDzaFSQvDfsS5KMiYT7
         55Z3Tnibk7Fb3odgl64qpouN1MApkmXiYTD1yo+SdPvf+zqdi/uLRdspNwTl35/RcgO/
         g1qcJk4DcPgGFvzRhJshcHJYkG2Hi44rc1dbpcUE+g5F9Hw9rVArgbZ87s0EnLf9tWRV
         BZaw==
X-Forwarded-Encrypted: i=1; AJvYcCVu0ktkDJEwUEVx0bi95Wi+qVaLNKHMqyt5yIh8mLA1/0ydphs/ptEFtNRNdXLIY9wGmWpFuNr7vWVlf74=@vger.kernel.org, AJvYcCWDVwdi8zBcntaMyATOiaCWH4m1b+t7rcNxzWVGrQeXq26SppdrahnMj39o/7evkkgO0pc4LyxWehmXaA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz69XaxtQi8a3XGt6MJIcan/YQ/SoSiLdszCjzgrm/wwf3QQi9V
	32CYu3bQQ1Hy8YB7OKmvSCgA3T08OTCuxyxHv8/DtUaYIxBXTalqw73jKz+oZ0EHhsULz9e6+2a
	1yodksSyAL2AKvvI9rUZ/+XCq+WA=
X-Gm-Gg: ASbGncvADIh6sKVjHm+rbFu8/mNA7lEsQkCNJ3wjLSIb+p9kCjAJYds+2+ohVtratRY
	4hBXLXNTJzLglcIqdfvj/4OUgMmcNgEfcaxt8zTC1WAA5JOaPPga5onDB/9JNWQ==
X-Google-Smtp-Source: AGHT+IHQ8WYTRXlhBZ+SuMUELBewP+7bAz5LcJ1mq+3ZPx7GWANDbEgbQ4WAJzTcqSxsHYacW+tw2bkRrWJ1PG7z0FY=
X-Received: by 2002:a2e:bd0a:0:b0:306:1380:2410 with SMTP id
 38308e7fff4ca-30761b8b959mr59042381fa.1.1737893423207; Sun, 26 Jan 2025
 04:10:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
 <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com> <20250125210016.815b4260ad539b1e66298d98@linux-foundation.org>
In-Reply-To: <20250125210016.815b4260ad539b1e66298d98@linux-foundation.org>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Sun, 26 Jan 2025 13:10:12 +0100
X-Gm-Features: AWEUYZlgPOF5NDGYcotrSgzCws6poa68bMIrlHLNHE4weJH-u3KcMWpX7nZWMWg
Message-ID: <CAFULd4ZVz=eeh=eE9-hKQN_-430WRSsjbtO1ge_qji5PPcHndQ@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Naresh Kamboju <naresh.kamboju@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 26, 2025 at 6:00=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sat, 25 Jan 2025 14:09:16 -0800 Linus Torvalds <torvalds@linux-foundat=
ion.org> wrote:
>
> > On Fri, 24 Jan 2025 at 16:22, Andrew Morton <akpm@linux-foundation.org>=
 wrote:
> > >
> > > Linus, please merge the MM updates for the 6.14 development cycle,
> >
> > This does not build at all for me.
> >
> > I get
> >
> >     ./arch/x86/include/asm/current.h:49:9: error: call to undeclared
> > function '__typeof_unqual__'; ISO C99 and later do not support
> > implicit function declarations [-Wimplicit-function-declaration]
> >
> > when running the Rust 'bindgen', and what seems to be going on is that
> > my version of *gcc* does support __typeof_unqual__, so I end up with
> >
> >     CONFIG_CC_HAS_TYPEOF_UNQUAL=3Dy
> >
> > in my kernel config, but I think that 'bindgen' that generates the
> > Rust bindings is based on LLVM, and clearly does not understand
> > __typeof_unqual__.
> >
> > I have bindgen 0.69.5 (plain F40 install), in case somebody wants to te=
st.
> >
> > Apparently few people test linux-next with Rust enabled, and the
> > reports that I find on lkml were ignored.
> >
> > I do see reports of this failure on lkml from mid-December, so it's
> > not like I'm the first person ever to see this.
> >
>
> Well dang, nobody told me, and I assume Stephen didn't find out.
>
> Guys, if tree owners are carrying bad patches, please do give them a
> heads-up!
>
> > Anyway, pulled and then unpulled again.
>
> OK, I've dropped Uroz's series "Enable strict percpu address space
> checks", shall resend the pull request soon.

Patch 1/6 "x86/kgdb: Use IS_ERR_PCPU() macro" is required for the rest
of the series, but can be committed as an independent improvement..

Uros.
