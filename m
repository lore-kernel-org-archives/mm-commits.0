Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713CFBE4A
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 19:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714160944; cv=none; b=Wbp8Suv6Fnu19sT4i1gCJODUyqjLLuVndj4unINj/4e9wwqkGvixkQ943Ymau0x0L+ua+rYWvpM4hRTd990ibbxOlIxcCXTQyyeNUguJKM4s9HJCxav1nux2BCIIJhu8owjWePRq2fkqF3SaA7/thBuLzjJE9xH2s9otqt1w+mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714160944; c=relaxed/simple;
	bh=HrzyqQPVU45wnrMD0gRAjNGVddYUC04WZ8uFeAck3Uk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nkc78bljzlCKpKKeem8ESYGamxHxlxYDfg85SV/uy/Tt321k23hacGpn2LRJPvqKhoefmq37NQddaQM3AhKPLYZzq68ZBLdS0Yvebzk0wNXLI2ucIgY6CRV89hEbAEd3q1VsY69jLx/OSnyba7aG+8ZI8TQIZaK0tpfwMwF/FQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LGgIjPx7; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LGgIjPx7"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2def38477b8so23035411fa.2
        for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 12:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714160941; x=1714765741; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SzbQqc9IESHkyQIJMfwOYaZyKEQmvIrs7b4AcF5PDzA=;
        b=LGgIjPx7nqBrbZ/iYzkxcaDRd0hrFyQgBncB4jbfC32EwE6BT7Dou4WXXKK/Zeds69
         RGW1pLWzHPOP3xP1dANDVsi7PsNnWgPG2ldESETzAJ3ntad1RWmQCTAsEzjAbAoGPPI+
         VzGo/c8x5pBuzPo3qUjRdfPdLQ6TGLNgYWIL5lpB/xAB/vlUdxxcfyMqISPofKT0qsqW
         uJYKRc9zzLiiUREHE123xegOVHjOa23quRXIBNWt5eM3xtIiAB7PpHNUpICo14oOf9W/
         QCKX6b8COBw57WwFa7cpcyM4W4cAvQy9MUZkSurFVvinSQ6zbYf5PudopeO6ThLXvML4
         EKGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714160941; x=1714765741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzbQqc9IESHkyQIJMfwOYaZyKEQmvIrs7b4AcF5PDzA=;
        b=qGrNZ3dETdGWD/sxsxOhFsZQ204n/PrB7STnpQvkBO7QUBg3MgvbURjg+mp+04N13P
         LXqYhjyyeYgRWaaNAVANcie4phnYUZPPtJZC7smRlwFrBBu9ulz+rZ+YHnEdxAhfiBLs
         7Hq/6frxS10tVBjxBpSxsRcksVsFLWpCRAZf14gYVYof7SjEVWy7745Dh5vJSIl3nsI9
         Hf7sc4IY+FVl+RkcADsv17MN863LLykogy0pnrnYRH0Q54Sgbi2o0bD2gpwNgFTsf7lm
         PCQOSuLc13oMSlzGdbje9Vb7udJPBlzvo3Z2IbaSfcBQFFPDbGnwDxxl+R20NJaRgZk6
         L8sw==
X-Gm-Message-State: AOJu0YzEgiwgEnX/fiRFivugojtpmxN7biwgQqop4diCyAyzjlhnMN8m
	0EKyJvnOCpHbyv6FYbxo86M2bT21rbCIDvKH7IrMWsQPK1VSF/uhhWz7StB/qgZbCEXfKNC3V99
	qLxUesFMDvSGg21HAlwnBt2BI7sXFmUtM
X-Google-Smtp-Source: AGHT+IFnCflWGqaQuzXVVrmzUVAFq4x+28cPVpeJIrlBT1PvljKyNV/KE/DXqiVipW5vgMs4Ok0Q/7/i19aK1Tgz6B4=
X-Received: by 2002:a2e:9b03:0:b0:2d6:ff04:200f with SMTP id
 u3-20020a2e9b03000000b002d6ff04200fmr2197702lji.33.1714160940307; Fri, 26 Apr
 2024 12:49:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240426190857.BB28FC2BD10@smtp.kernel.org>
In-Reply-To: <20240426190857.BB28FC2BD10@smtp.kernel.org>
From: Yury Norov <yury.norov@gmail.com>
Date: Fri, 26 Apr 2024 12:48:48 -0700
Message-ID: <CAAH8bW9o+d48_84mWXwYkVgMzY+__UxfBnuzauci4qgt1jFZ+Q@mail.gmail.com>
Subject: Re: + bitops-optimize-fns-for-improved-performance.patch added to
 mm-nonmm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, jserv@ccns.ncku.edu.tw, visitorckw@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 26, 2024 at 12:08=E2=80=AFPM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: bitops: optimize fns() for improved performance
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      bitops-optimize-fns-for-improved-performance.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/bitops-optimize-fns-for-improved-performance.patch
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
> From: Kuan-Wei Chiu <visitorckw@gmail.com>
> Subject: bitops: optimize fns() for improved performance
> Date: Fri, 26 Apr 2024 11:51:52 +0800
>
> The current fns() repeatedly uses __ffs() to find the index of the least
> significant bit and then clears the corresponding bit using __clear_bit()=
.
> The method for clearing the least significant bit can be optimized by
> using word &=3D word - 1 instead.
>
> Typically, the execution time of one __ffs() plus one __clear_bit() is
> longer than that of a bitwise AND operation and a subtraction.  To improv=
e
> performance, the loop for clearing the least significant bit has been
> replaced with word &=3D word - 1, followed by a single __ffs() operation =
to
> obtain the answer.  This change reduces the number of __ffs() iterations
> from n to just one, enhancing overall performance.
>
> The following microbenchmark data, conducted on my x86-64 machine, shows
> the execution time (in microseconds) required for 1000000 test data
> generated by get_random_u64() and executed by fns() under different value=
s
> of n:
>
> +-----+---------------+---------------+
> |  n  |   time_old    |   time_new    |
> +-----+---------------+---------------+
> |  0  |     29194     |     25878     |
> |  1  |     25510     |     25497     |
> |  2  |     27836     |     25721     |
> |  3  |     30140     |     25673     |
> |  4  |     32569     |     25426     |
> |  5  |     34792     |     25690     |
> |  6  |     37117     |     25651     |
> |  7  |     39742     |     25383     |
> |  8  |     42360     |     25657     |
> |  9  |     44672     |     25897     |
> | 10  |     47237     |     25819     |
> | 11  |     49884     |     26530     |
> | 12  |     51864     |     26647     |
> | 13  |     54265     |     28915     |
> | 14  |     56440     |     28373     |
> | 15  |     58839     |     28616     |
> | 16  |     62383     |     29128     |
> | 17  |     64257     |     30041     |
> | 18  |     66805     |     29773     |
> | 19  |     69368     |     33203     |
> | 20  |     72942     |     33688     |
> | 21  |     77006     |     34518     |
> | 22  |     80926     |     34298     |
> | 23  |     85723     |     35586     |
> | 24  |     90324     |     36376     |
> | 25  |     95992     |     37465     |
> | 26  |    101101     |     37599     |
> | 27  |    106520     |     37466     |
> | 28  |    113287     |     38163     |
> | 29  |    120552     |     38810     |
> | 30  |    128040     |     39373     |
> | 31  |    135624     |     40500     |
> | 32  |    142580     |     40343     |
> | 33  |    148915     |     40460     |
> | 34  |    154005     |     41294     |
> | 35  |    157996     |     41730     |
> | 36  |    160806     |     41523     |
> | 37  |    162975     |     42088     |
> | 38  |    163426     |     41530     |
> | 39  |    164872     |     41789     |
> | 40  |    164477     |     42505     |
> | 41  |    164758     |     41879     |
> | 42  |    164182     |     41415     |
> | 43  |    164842     |     42119     |
> | 44  |    164881     |     42297     |
> | 45  |    164870     |     42145     |
> | 46  |    164673     |     42066     |
> | 47  |    164616     |     42051     |
> | 48  |    165055     |     41902     |
> | 49  |    164847     |     41862     |
> | 50  |    165171     |     41960     |
> | 51  |    164851     |     42089     |
> | 52  |    164763     |     41717     |
> | 53  |    164635     |     42154     |
> | 54  |    164757     |     41983     |
> | 55  |    165095     |     41419     |
> | 56  |    164641     |     42381     |
> | 57  |    164601     |     41654     |
> | 58  |    164864     |     41834     |
> | 59  |    164594     |     41920     |
> | 60  |    165207     |     42020     |
> | 61  |    165056     |     41185     |
> | 62  |    165160     |     41722     |
> | 63  |    164923     |     41702     |
> | 64  |    164777     |     41880     |
> +-----+---------------+---------------+

Hi Kuan-Wei,

I didn't receive the original email for some reason...
We've got a performance test for the function in find_bit_benchmark.
Can you print before/after here?

Thanks,
Yury

> Link: https://lkml.kernel.org/r/20240426035152.956702-1-visitorckw@gmail.=
com
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
> Cc: Yury Norov <yury.norov@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  include/linux/bitops.h |   12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> --- a/include/linux/bitops.h~bitops-optimize-fns-for-improved-performance
> +++ a/include/linux/bitops.h
> @@ -254,16 +254,12 @@ static inline unsigned long __ffs64(u64
>   */
>  static inline unsigned long fns(unsigned long word, unsigned int n)
>  {
> -       unsigned int bit;
> +       unsigned int i;
>
> -       while (word) {
> -               bit =3D __ffs(word);
> -               if (n-- =3D=3D 0)
> -                       return bit;
> -               __clear_bit(bit, &word);
> -       }
> +       for (i =3D 0; word && i < n; i++)
> +               word &=3D word - 1;
>
> -       return BITS_PER_LONG;
> +       return word ? __ffs(word) : BITS_PER_LONG;
>  }
>
>  /**
> _
>
> Patches currently in -mm which might be from visitorckw@gmail.com are
>
> bitops-optimize-fns-for-improved-performance.patch
>
