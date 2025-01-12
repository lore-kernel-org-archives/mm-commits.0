Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5A625763
	for <mm-commits@vger.kernel.org>; Sun, 12 Jan 2025 07:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736667259; cv=none; b=sWPynwMm/4Tz+t0dKER6uaFRyx+bafTPuAOiDXhdQj3bz8c+0VlHpff5KtPUgeNbSJZ5m0gP4daiwxr2cDevxF+bfCPIDaSNLn0RzMc6wjshP8Ee+FJgIEYbmB/TEm5qi7nKX3YTJmRGOEer9UKFOyy4uS6FF31HZJouKsvQkUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736667259; c=relaxed/simple;
	bh=CZRUb5HIahJt5po9Co4ULkuHQEcmqFADg4dsJILUmY0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QlwaIMjk/B5O5a8lR9TqDf0cq5/cdtXVirsitGeaWgRNX6rlNr+QCVM7pTcFaut5EyA5rHo7m8LJnJRrcBY7/6U/2phRfyYvK47EAYrRKqQyyVwBiOO/EvcB9xQxtanX4s/5tyvlOqyR+ottk3S/M3jRqDOReru1SVcqp7ZbLAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eVOPVGSI; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eVOPVGSI"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aaecf50578eso650538266b.2
        for <mm-commits@vger.kernel.org>; Sat, 11 Jan 2025 23:34:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736667256; x=1737272056; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Uwuc+boSW20rvx0UrEpHpeI3fwnAj/gmqChABlH11I=;
        b=eVOPVGSIwj5NSPBJQGuXGNTuN4VJ9Yl453daV2LI8GfFu5knqBxNi+pnrgZxvdPekk
         MFNE2/Lgj529PFlIkNyLhOfLTnRtCRqYVDYKfoSi89I6w8NSrDG5uaWQjeBSOwuIKg2N
         VthZ0j0saS+JI2m0Q7zkgHm/x0K0l9JVVApAYt6nSqTIbPuVzKPcTMYPu2YeOVPAK9Qz
         3wK4JLu8MzhRfXtAg8gOmthOw4cmuEPNGf4b0msR6MtS/idahGyjfs0kHQD80x5YKMDp
         6cWY8tcyFV02c6b/cpldNgN2HxjoDGg0JXkWc4Mre0OpaxoECpvz4nupkx55ACNXWSjx
         Sqxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736667256; x=1737272056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/Uwuc+boSW20rvx0UrEpHpeI3fwnAj/gmqChABlH11I=;
        b=GC/ReVik0J/IYtUgk2kKDKyHrb89cC9JTpASCDhYgVo7MnPwQfYViHI2sc1PfD7JU2
         lqixCSa9VeIQOpw0YDPDgvZ7NE4YB3jsUK8UWP+KJhKv8nJG75ys/jgHF5dAZX5JGNgR
         8Q3yUZoBsSqrmKKDyQjRp/1A0x0RlmH8XzhxLBvGHO4hg7mkqp5XDSdCbvk9XlBYIg5R
         /R/+jHFxM88/UgE4oCR5Tk5muY8ldCwpeKrUzdSPo14zgtO7rLQQe0G7xraakYct+6GG
         IJXYREHTyPyZ0jShPsdjpLJ+85OkCgRWArl1Ftu382l3liwYd0kzqcx7eev2T8Sk2fI1
         Ygqg==
X-Gm-Message-State: AOJu0YyE7IEn7I2XlXmnhHN+XPvldc+JAaNCSWf14xFzcRivkUK+/BLE
	APK1FsFPY4ggpxnBkQrSKrU4kKpiWHv3vn3uxYVOUTctj1in3B6aQzwVkOkPmooApXwe6rYTNRS
	0Gzn4Jsxv12s4hD1Yn6MTzTQP0kA/rX+5jQA=
X-Gm-Gg: ASbGncsSKl+xUv155UCC0ffwz2+Oh1HN4wzjIf3eUat5iCyj5UEn2GZnxHpLLBbrQjR
	FFnoFMaLJbnwvSh0soYrTUTkBppVyXdGt49gr+n7Cqg5pBZ9JXfNvGnqULYZTu0wc0LWcu30h
X-Google-Smtp-Source: AGHT+IFPf+PuSMEsy7b1VazhVrHzvle7fPWUTy8i359W9G921BooA49o/+S6P0lk9Y75fe3vPL9REz3aC5h680VsC6c=
X-Received: by 2002:a17:907:3e1c:b0:aa6:83cc:7996 with SMTP id
 a640c23a62f3a-ab2ab6bfec7mr1706749066b.42.1736667255687; Sat, 11 Jan 2025
 23:34:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250111232639.A83AFC4CED2@smtp.kernel.org>
In-Reply-To: <20250111232639.A83AFC4CED2@smtp.kernel.org>
From: Tanya Agarwal <tanyaagarwal25699@gmail.com>
Date: Sun, 12 Jan 2025 13:04:04 +0530
X-Gm-Features: AbW1kvZZ7Uhb8zlmt77I9QX7ChIwnYF8My1kuZ0oqL9-ca9E4XygWhu0mUUfDcw
Message-ID: <CAPdGtUwAKw7VA+PRrbwYfnXzeT9wxvLgjgTWjvDqcyyNmw+cXg@mail.gmail.com>
Subject: Re: + credits-fix-spelling-mistakes.patch added to mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, skhan@linuxfoundation.org, 
	anupnewsmail@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2025 at 4:56=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: CREDITS: fix spelling mistakes
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      credits-fix-spelling-mistakes.patch

Thank you Andrew for merging my patch.
Regards,
Tanya


>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/credits-fix-spelling-mistakes.patch
>
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Tanya Agarwal <tanyaagarwal25699@gmail.com>
> Subject: CREDITS: fix spelling mistakes
> Date: Sun, 12 Jan 2025 01:17:10 +0530
>
> Fix spelling errors identified using codespell tool.
>
> Link: https://lkml.kernel.org/r/20250111194709.51133-1-tanyaagarwal25699@=
gmail.com
> Signed-off-by: Tanya Agarwal <tanyaagarwal25699@gmail.com>
> Cc: Anup Sharma <anupnewsmail@gmail.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
