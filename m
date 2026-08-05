Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F030424D75
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 19:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785959784; cv=pass; b=t6AvZLSVXeOEpn8Zht3V5SVfmlvTLWLQ8hgLMI3GPZz4kj2qWW7QXyGj35Jh80Cdtt7iBqrMzXZhIv5WaCc2zeJoW8RE4S72pTKZjd8Bq+J/t5FTonmeSMdnkJzDEiGS0u5SkBnWMHDZflP4TRave7IdGCms40UnLp1AlmmBy5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785959784; c=relaxed/simple;
	bh=1WUMTKvhEU5AzjlcOF05qm749x3XQU+nsTSfFJSvSOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A70VJkoFePc8zekP/5/3UYSuoaX4w/S4mtGvmvH1qUQ4aShXrDS5hreDXukln/HWpOk397foJw8/ot2YMDhpYu3le7J34ZOWQxqvAhp1G+VrBogwhz2xnhyB2CDwM+lJ0RBRzLWhZ6GEhBxe+Nk48QvObEqLiP2y40JORJceOHU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cO8bjaUX; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cO8bjaUX"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c01c79467so67651cf.0
        for <mm-commits@vger.kernel.org>; Wed, 05 Aug 2026 12:56:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785959782; cv=none;
        d=google.com; s=arc-20260327;
        b=KlKehmnkpKXXcBi1xqsDIEmVEF5z1zuTfkpo9Dgabq5eostlthMAXXfFI4OIYGWsrl
         oC4x7TKue8xG5/pd7BC9CrVnDAEx4uVc4VzVIGR59SLje+wi15jPDylEP7yZNnVSVIXg
         2/cZzjXdtigK0WKbOOFkY/z9lHT3CLK7ORLYL5SiBbFnKLXBHQw63uBJOcV2Irsu9Jgm
         01Gv5SDRQaQ3i1usKSEUuqWdxK1Yf1C+jEvAqWD/kBMd38ypOzfP17HVTtDb7cSM2K12
         h+fbyDpm3vE73qx3JzOTZOenDODmiSdbPrHogvuSS2kcTaiX+viX9z/p9NI7WmLpd07D
         tP1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zHwIHqoPtrTJVrd9bNz+eu/8WRJZ5ib42Pm/eEnXe2Y=;
        fh=FjqeHCR6JczceMMJg4PFTNQQo7mMBbqiH5khiOetTd4=;
        b=EjTSCc1c2tZLaHbLJPRYqnmeHUrUDqZDmeRD7QfjUylJog4b7ilD1+HDqTcAr8U5U2
         BtW6zv58jv9EClxAhtpW7N3WeCgdFgdNevxFjUpNJ5CbP19gzo5tIRjDUIczMET0F3hy
         y9lmGINfCSVq77U9wmLVP6sjIcQijB3qU102xhvWoZlrvjA066slm3nQY/b9joBLXlbm
         r3nSBVK+Rt2oV1VLTroroImOu4COmDVoy9K7afyBJBXLKLzXBCYoBvYizG8Ojazyzb8Y
         m4WqenH2xxi+xRu1hkTntroXqIlRiuE6Q6m42ToMIxRd+DaL5un0ybcJcEC7CZEsJRma
         p35A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785959782; x=1786564582; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zHwIHqoPtrTJVrd9bNz+eu/8WRJZ5ib42Pm/eEnXe2Y=;
        b=cO8bjaUXioF6kyvNjcChco8B9JfFdRM0H+v0HVgswsnowNHeIJSvRHxJ4AFUuPRYk9
         3BQjh7Ox1GZJ3TKA7kBVvSLeQCpPGA6LNfeglaNDROE9cJRU/UffdgQ5VkvJQaL/LPUV
         ZSimNuG9E8geMcl4eWt3T+2B4VZyrqc4tDGMJ2gyIoIMU9bA/KghPfWZwpCkAfjoxjae
         Owv2fArMuePtgiBXRVJzHIVHkoq5UNBo5MR7UXABpVWBv/nPiAlNjlq5FyjZEmb0r9cm
         xlSx5X9TMRwl0yybMDK15QTPlxrTE9stEX/9p++X88ai849VFKxiZprUTGgkj0bftjjU
         WMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785959782; x=1786564582;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zHwIHqoPtrTJVrd9bNz+eu/8WRJZ5ib42Pm/eEnXe2Y=;
        b=WKAR7M7sH4b1NzUYJW1aX+aIyYcpAIHjwYhPmuaHiPWhyyKLP1MPWBC9sGVkhDry0W
         gVG2ySNb9MtLfpEmw31gh9q8lqceEvRSPovFBWdEGAfzwEjsZJ3deAcYEQeVtigQgJrU
         CB+bPBOzgV5Bc+zJUxmW/rxx/IpTLeuMFeUkPqU6GPLqkqYc2leRZ05ar0SeMcMGFgDk
         SYLQDgcmXlnmOgK39pjXVcidhpCgDszWd1ugHwj1HgHU45NVLbEZiktgASQXYsSYivT7
         9AsnwuxfTyE7eSVb26lmi5hSv/FaJ5hsTa9+9oKSWbKdO+toIwxJDZDu5/oMNyyOkMD2
         2a+Q==
X-Forwarded-Encrypted: i=1; AHgh+Rrs3jtUs6ARb3YySpHZ925/5yVM9eNbrx/6UJWcft1BynjESmAATqEJD1APh59CjkS41NOflxbi+crG@vger.kernel.org
X-Gm-Message-State: AOJu0Yy88CAKuZTuC4XvEt5Z4yaimLZoRDBTG3YkNmAsWW3Kw6j99V5F
	lE+XAyF/bJ41DuLjd8XO+K0vIAd4RXFVhte3vhjyOJoxaoE20RrD+4UM9W1c0DQY9HHU9CjZhwk
	lZD2FmJzY/KF28FClVh6vO9jcXTTq5rv8hSqhCjEH
X-Gm-Gg: AR+sD12iH3gLe7/guEfi4k+uJM8p91pYz+/mlZs3K/XqayYrvh8LZ3lZQ2oBFcqf/m4
	C+hdMCrFv1pgVJDT9cEQ1EDfyJhmRhtKIP0ywH4sJQruXS48JFweD9EPDJt00AkxZisS93ZiTZu
	HJrci+gF0kpCBu7noNyM4TqkBQQL5jkjQesem0X+UOeywTmMaiZZBrA9UUPbfKq9/dTIY3cIpwO
	K8qSLWdOdXPEUgDXCXQn24BuexkD4PiyHBlzV6S2Zl5VLAdFyR4y11kcESyCYWrwGwr0pq0IrTu
	TFlnKK8KR0IQIBF+FZt38hu9hv+qrNwHmT5Ey5FII+H3TgP3+5KQAuU61xjC6vd8ZtQQPQkRJUA
	=
X-Received: by 2002:a05:622a:87:b0:517:64f6:3365 with SMTP id
 d75a77b69052e-52cfbd65c9fmr3457111cf.4.1785959781216; Wed, 05 Aug 2026
 12:56:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202608052027.LCDnsFT0-lkp@intel.com> <20260805084004.afd47046925c62a5b19e242a@linux-foundation.org>
In-Reply-To: <20260805084004.afd47046925c62a5b19e242a@linux-foundation.org>
From: Pratyush Mallick <pratmal@google.com>
Date: Wed, 5 Aug 2026 12:56:09 -0700
X-Gm-Features: AUfX_myY1R11nU9KasiNlA68yK8CLGvKrR9s7tVmmqzIezO2sr5IYEZJAhJofek
Message-ID: <CALHaPKepTmhB2TZ-mk1kM5PhCq1774YCELDoRNypmus5RhVk7w@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH WARNING e47602c51d20a93fa1711ed896dc9480de4374d9
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

It looks like during conflict resolution in mm-new (commit e051bf0188c9),
the following negation rules from v4 were accidentally dropped from
tools/testing/selftests/mm/.gitignore:

!*.h
!*.sh
!.gitignore
!Makefile
!config
!settings

Without these, '*' ignores all scripts and headers, causing the LKP warning=
s.
Could we restore them when moving to mm-unstable? Let me know if you'd
prefer a fixup patch.

https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?id=3De0=
51bf0188c9ae10e822a532aac5821c2cc0632a
https://lore.kernel.org/linux-mm/20260803221732.3651981-1-pratmal@google.co=
m/T/#t

Thanks,
Pratyush

On Wed, Aug 5, 2026 at 8:40=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Wed, 05 Aug 2026 20:32:52 +0800 kernel test robot <lkp@intel.com> wrot=
e:
>
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.gi=
t mm-new
> > branch HEAD: e47602c51d20a93fa1711ed896dc9480de4374d9  mm/swap, PM: hib=
ernate: atomically replace hibernation pin
> >
> > Warning (recently discovered and may have been fixed):
> >
> >     https://lore.kernel.org/oe-kbuild-all/202608042227.XDO54bZk-lkp@int=
el.com
> >
> >      .gitignore files
> >      ignored by one of the .gitignore files
> >      of the .gitignore files
> >     /mm/write_hugetlb_memory.sh: warning: ignored by one of the .gitign=
ore files
> >     /selftests/mm/ksft_hugevm.sh: warning: ignored by one of the .gitig=
nore files
> >     _hugetlb.sh: warning: ignored by one of the .gitignore files
> >     a.sh: warning: ignored by one of the .gitignore files
> >     arning: ignored by one of the .gitignore files
> >     fd.sh: warning: ignored by one of the .gitignore files
> >     files
> >     g/selftests/mm/ksft_memfd_secret.sh: warning: ignored by one of the=
 .gitignore files
> >     les
> >     nore files
> >     s
> >     s/mm/ksft_ksm.sh: warning: ignored by one of the .gitignore files
> >     selftests/mm/ksft_pfnmap.sh: warning: ignored by one of the .gitign=
ore files
>
> Thanks.
>
> I'm guessing this is due to "selftests/mm: use pattern matching in
> .gitignore"?
>
