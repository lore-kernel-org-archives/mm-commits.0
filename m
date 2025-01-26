Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3C781727;
	Sun, 26 Jan 2025 19:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737920823; cv=none; b=X8h0UI2QQZevc4gFI1KLQqdjbrWjP33oGEEil1VI6POzNTRvN7JTEJdzgSYxUkcm3Q1Jm+2SHx3k4kgmQ0EsF3Qw4Ti0DxPHNYu+lanI8lX+czQlZgfWX1ophgwZTWWhncSTHWwfkBP042NOz7p2C3esdXRgg9kSL43MpO7lYa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737920823; c=relaxed/simple;
	bh=l5HY9TlJNnVpsDOYnLDRpqs2mrHEqQO2voZdeAip43s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TYOC+9WyfjPlkPEq2vLgqJhOMUlWcPruL4XvCvMAR+u4TrX0e5Hhah5NUykKNwHXVokV9/CECYUrjZkkSJM17M1oeI67hYS826ajVJe4N466K4ueTSXV028LMUxlDkhO82sQaPZVmn+JHYU7pq2RFIxG9CvfwkBHkXijCNkNIYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GyHyU18/; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GyHyU18/"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-3061513d353so40848381fa.2;
        Sun, 26 Jan 2025 11:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737920819; x=1738525619; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZrEU/IFSJ22nzQLWKv/mqw90Y/TttSN+kzfoxaSe8xI=;
        b=GyHyU18/fCvSxbgEfGRBu2WevNWIoHCq3u0MzWmjgB3qbQWTNmy1jXlSK2I+p8V78U
         kJOZF22zLXQYSk8sJswrq1x9/8Ebwwh2siamfdP7rBzXfWJrwctqUpGL3bw5wlAw8wFW
         W0bZfwsIDXpW0toIKudJiCJsxGTb6kM80Anfm/8E0mEJ3w/ypc2RZzDwyoIqRdc+NYB/
         fTxHL7NkvSIRgbKUKaZO7choABRz61PBZ18A71C64DQ2KNxHtXq38+4WCno6HMqDutJT
         7Plcy7csGLr4sN/L8Xv/mevJwIIBSp/0jsChW/8rejlYGLnhdF7yDzMMWjpM1YkweqVu
         onlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737920819; x=1738525619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZrEU/IFSJ22nzQLWKv/mqw90Y/TttSN+kzfoxaSe8xI=;
        b=P4gU8nn65V8ZAq82S68aWz0Or6vi2a5psGG0ZpPFmangBlXyDloJK4iqIJBeEc5lmD
         J8gArqZTUpcIa+V0NnRQ6pNBShe9NwOe8uRbQQi2VvRp3xMhCLt+P30BRSBB7Oe+UGht
         sjGvJJJHKkPNQX0r45UaXdyWhdn2G7gzxtqGjHzZt2B+ijf4sp2AgYZH5fDJt7EI/ZEB
         fIENUNSUDzSG8Zj9V2+ri2fCS3BLCnPy82S81ZdBt8BgQEei5+yN7BOjQLWoxEWVJzYF
         O5dpKtnLfP6CxiQ/h4mg4N7p0CW24/EytYkhVAo+s6zgjJFl1NY9ltopl61xPvTxS6mR
         RlMg==
X-Forwarded-Encrypted: i=1; AJvYcCWoSniyImxGDdFmoBRnqbKer1iJThiwhyPnxu02MBCtRzNrfSQk56uIDruVq+Eyf0biSuS48qeqx0dvR5M=@vger.kernel.org, AJvYcCWuJYSkZXEnHJeVyfz//KVC8Ip50AjxmKNe1vaBsc0c6Ejuhzu3tGjRXtt0SiOt12wZ33L6jrJVeB9hTA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd32PiqSEozR/TTqxTqpK5/aBgr98beNIK72NZLD2ecuv5JdTP
	3+AwvFSeMB3hCq7L1Mw8mJduFPNb+NZV1YnkSZvKgD5OhtmB4QIWfxktxDe74RfxGsqZgnHC+7v
	09T8QBRRGklRtW/uFL0JzvNAhvtY=
X-Gm-Gg: ASbGnctiXUCtUsg/FNTNMa+ar/yy+Uz1en2q2jBnU/XuQjDEYk5kg1g78GjhuXr76sb
	4CbBQxq2mUK10h1sGY3pCexVp1R0hRxflH4jMPfL7EuN0VLQRzshGbbxU4dufow==
X-Google-Smtp-Source: AGHT+IGM6JZTt/3SUXdRYsbWlL6P0k3VlZoLIsIqb7Qn1SD/IH+vCWUrqoCwtauujMLdbYNJ8/GYrSZUCwNQoVASqvg=
X-Received: by 2002:a05:651c:887:b0:2ef:2490:46fb with SMTP id
 38308e7fff4ca-3072cb30adfmr150804251fa.37.1737920819132; Sun, 26 Jan 2025
 11:46:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
 <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
 <CAFULd4ZWS4Cxv0CELosQHJh9vTqOJFdr+Fk9NMgSREr_dFG05A@mail.gmail.com>
 <CAFULd4a-2F_zKMeR0Yjo2WhRLmyoOQ1VdR2qdV34BrM-b_cQCQ@mail.gmail.com> <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com>
In-Reply-To: <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Sun, 26 Jan 2025 20:46:46 +0100
X-Gm-Features: AWEUYZmZkwqvcszTbvTeZYez9dllzuKjCQS6DRPoSXdmIjzXTkmFH59V_KiEwmA
Message-ID: <CAFULd4Z2eSJhE0qF0QEtsb-7zoOMKH=KvvrfK0M5UozLw_TYUA@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 26, 2025 at 7:30=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:

> That does seem to work, but I'd admittedly be happier if we could just
> find some way to dynamically disable/enable __typeof_unqual__ based on
> which compiler is used, rather than make it a config option. So that
> bindgen would not see it, but a recent enough C compiler would.
>
> We already use '__has_attribute()' for some of these things. There's a
> '__has_extension()' thing that comes from clang but that gcc also
> supports.
>
> But I can't find the list of extensions that that model supports, and
> I guess typeof_unqual isn't on that list if I find it.
>
> In the absence of something _clean_ like that, can we just do it in
> <linux/compiler-xyz.h> instead? IOW, not use the CONFIG_xyz tests for
> this at all, but do something like
>
>   /*
>    * bindgen uses LLVM even if our C compiler is gcc, so we cannot
>    * rely on CONFIG_CC_HAS_TYPEOF_UNQUAL
>    */
>   #if __clang_major__ >=3D 19
>   # define CC_HAS_TYPEOF_UNQUAL 1
>   #endif
>
> in <linux/compiler-clang.h> and the gcc version check for gcc (I don't
> know when __typeof_unqual__ made it)?

It is available in gcc-14.

Uros.
