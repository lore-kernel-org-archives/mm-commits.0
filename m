Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A201714D0
	for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 13:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728884; cv=none; b=jkqlNGGn47V2OM0r47og0kxQYK/GxZK5Gcr1lFYtylU18+na1z9HMoB01yhB7Fp95LXJonZbT1RKwsj4yvttZzEg2zown0fZS9Dp/uPxa10ILqIQSy17p6XoOAALYgaSFDaoKUVGQabTABeBNfaWhpGjgFEk9IRQIL8AdbW4eFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728884; c=relaxed/simple;
	bh=LxQFSfuzvmkveXtjKBwsYlnTgh7u+bLcpxWU99qf/z0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n6eoakrS10Zo5CsFf1AM7vYVXhV18L6luAV+gAZsIv2b157sUnjd8vd+syhyZq4SVtUIlRiEO7bvse5XODUrIqiOhSaQFWRIETQSVTU4/8tfKexy2SDYIFO9ADg3OmNPq96EHkbeAwLJ9rkMkOfgHljGCDBaIVJpSH2WVd2EaNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dBc7OQpp; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBc7OQpp"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2d3d0b06a2dso281152a91.0
        for <mm-commits@vger.kernel.org>; Thu, 15 Aug 2024 06:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723728882; x=1724333682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LQwxBKf3uU+3GvALboAFtrbyH9GotoKzkq4mFpsuiGY=;
        b=dBc7OQppRDQrknfToikYn2TaLO5NJBjjK7Bt3rPHnBn8ULR7lW98CLHolgQSmU5p1p
         yttzQv3ftTB+ehWIB9VSja9Nwh95n41xHx6+PtntQpNw7HExZln87A659YnCJ57vdfs5
         A3a106LmW/YzYNw7PNpUgE7GgDL/E4G4F9ZobQLa93QLUkrr64xYeYmpoqG/ZnF8CUe/
         nxTov3rQ7AUh/fT+Oulkmtvg/XriAApl57hr3G/SSxbV5sFkBCqGHsgkFZ/m6wt2jlPB
         cgtmHAeXwHQAhMRBXhjIJ3x5zE8AzTd1+9RM9GwtNacV9/pSQ68RyrWugQwxGOzHCcy1
         yo9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723728882; x=1724333682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LQwxBKf3uU+3GvALboAFtrbyH9GotoKzkq4mFpsuiGY=;
        b=JgL7E/4Xr70Jbu9yfRmjZsanPR/CjG7ljgcyYrONWh2XxRuZJsQfsZUuLBKkUziLte
         pm6qsxEYIT2o9N6Ce++oEfDzCZoTUf5C6oOFNG8orf+uKSzw9aGfQ5WtHdN0Z8+51Wl+
         y335Nfd5MVNkdLviHsNaUUAZkjlbPdl/TIb77rQwpK4KUg4copKufw4QVoP28TEvefVL
         eui7hx2l+849PzkHKe0gtlxJgJzYw/NyEx2+mv0SFdcod+i8DzIjZOA6pUuZKvj56VMM
         4HN+IeXpEFhlYFLUaZOfZKNp2skLwAd9WRBFYNzdXUrpcA55Lj5AozYBb+T0wt7JuCiz
         hxBw==
X-Gm-Message-State: AOJu0YwAxiOu+52PeBfiTjAA7MHdlrN5X7avNiQI9VSgC2CXwt2vIunq
	vB3ULpFkunYkkpD5Wf2SwUgTOmIbO0RWG/FBJM8UVQUPjfiQSHWKvPNu4m/B0kj+Oo/4SER8MgZ
	PYc640BYBq0lLI60Uaq4o/rRj083bSRR1UDY=
X-Google-Smtp-Source: AGHT+IGQPiGr04e5GTBWx6PzyzS8clv5IYitRVg4QxJBk4T60As30lQpg8OCfBigEBI7pHwj7d4/nbbmuhUa3nUdJ4k=
X-Received: by 2002:a17:90b:3687:b0:2d3:c4cd:245f with SMTP id
 98e67ed59e1d1-2d3c4cd24ffmr3165600a91.17.1723728882513; Thu, 15 Aug 2024
 06:34:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240814202725.5BE36C116B1@smtp.kernel.org>
In-Reply-To: <20240814202725.5BE36C116B1@smtp.kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 15 Aug 2024 15:34:30 +0200
Message-ID: <CANiq72mOivuUg_S5KCmrh71d9Tk49LaaCWjgxLFFNAs3dZWQFA@mail.gmail.com>
Subject: Re: + kasan-simplify-and-clarify-makefile-v2.patch added to
 mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, ojeda@kernel.org, andreyknvl@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrew, Andrey,

On Wed, Aug 14, 2024 at 10:27=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> The patch titled
>      Subject: kasan-simplify-and-clarify-makefile-v2
> has been added to the -mm mm-unstable branch.  Its filename is
>      kasan-simplify-and-clarify-makefile-v2.patch

Would it be an option to take this through the Rust tree, since it is
a dependency for the KASAN series? (which hopefully a new version may
make it to the merge window)

https://lore.kernel.org/rust-for-linux/20240812232910.2026387-1-mmaurer@goo=
gle.com/

Normally I would ask whether you want to take everything through the
KASAN tree, but in this case the KASAN one also depends on another
non-KASAN patch (target JSON), and that one is a dependency for KCFI,
so it is tricky this time around.

If that is OK with you, an Acked-by or similar would be really
appreciated -- thanks!

Cheers,
Miguel
