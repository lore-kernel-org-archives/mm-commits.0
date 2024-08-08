Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15FB15A85E
	for <mm-commits@vger.kernel.org>; Thu,  8 Aug 2024 22:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723155518; cv=none; b=TOJ+SacSXu2TiqojQ+V8L0ZxmhR7brIru29I/WhFhtbbKxgan7gk+z/1tRV/Klgx7kZwbxePQzu4059AyY5lQaFzyOQ5XkjIweBYAeOhxnE+tpWfnxTD0AV42IsoLRfzgaGM6z8nvk1ip2t+UiHid9TmIe2GNLhPFaotUWN/yXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723155518; c=relaxed/simple;
	bh=g2fz3LHYtQdEh6BMOZKUax+X5tIaOuUHF5RVi3RQXOM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GxvetZuocz1ZWxIIRErIP4Ua+cEbe/HSQjIvYZGVCLSh62BSO7aNzccGQs3N4Xodn4kajOYLl/m8JHlsMv29vRlwBh4SUg1G+s6GPX+7Oi24Q/W/hIfdu9ZNER3MDPBe1fzbCJwAIFukR7Um7NkiAjhYkwJ5Wo1XPrVGyZSUHJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ERDU5KTE; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ERDU5KTE"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5d5af7ae388so1235469eaf.0
        for <mm-commits@vger.kernel.org>; Thu, 08 Aug 2024 15:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1723155516; x=1723760316; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vmPhqf0HgZuuKA5pp1AA1x5CtuO9Z4jjg/RjWI5ogE8=;
        b=ERDU5KTERfpbuFFBRpL4PPK0yDSxs0MAHu7nUTxFXghQpLvaQUDBzOx/rZYHJhJkkv
         rj2Wsn/tkC5WteH9UqSatt7hzDoB69AVrq32Bg5vqWin4IfFkPGdO8uKRsl2ludkceQd
         KvSn08L3QnkzhBzR58zFB3MdN7CeOzaUP9vWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723155516; x=1723760316;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vmPhqf0HgZuuKA5pp1AA1x5CtuO9Z4jjg/RjWI5ogE8=;
        b=VviMaD6dV8e96iL+rYAypKwAPv5zqGE/EApTs08GtY6zieSSHq88HaWm90Mg0zo/dy
         Hjvh78gLqlbjCUl7Ca2fVBBTqOq3wz/tSrxakWkdVWY/YP+kQ3soy4fSzqsuUD5WtSme
         lzAhMuX54qGlIxhKEvVND0ZyMBqvaP8c9B1MczPBF/+s4+zAkX8j9wxq7aITmp2Qwimn
         ycvi6z+Wn+cOloxiThaxy+GMbwT7GA+9Gg5OB+pV2lianNudobQFjPOJGhfX6Au/ZhI+
         D7cnrfL+5Qdaa631C1gkL8Tb4C0b9ex57019EKgIlQQTL1oLV6AwBHfFLMQlrIpCqePX
         3sDw==
X-Gm-Message-State: AOJu0Yw29eIqv/nx5nU++3avXPCaVRbaThFHvISOvzturdj7wfGFDSib
	eSOG/KMBJ7GIlE+Iluq6TxkZyCwyuof/1P9RsofAZHE9LDXgO0ccdK+TZPhr9+GuFpVpH29h6ar
	LRm22JeorOzpcErWAY51eEko+4M2bLWZqI+4C
X-Google-Smtp-Source: AGHT+IFSXb3SPSimp+dHWUKEV5b2WKyupadPDR4lKPd3awPu9sJJeMjHbJgJq4sO0dFWeAhHyA9m+D1SDv4ikPboY5s=
X-Received: by 2002:a05:6871:5821:b0:268:a1e0:79db with SMTP id
 586e51a60fabf-2692d342b92mr1408801fac.14.1723155515884; Thu, 08 Aug 2024
 15:18:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240807185954.1F5F0C32781@smtp.kernel.org>
In-Reply-To: <20240807185954.1F5F0C32781@smtp.kernel.org>
From: Jeff Xu <jeffxu@chromium.org>
Date: Thu, 8 Aug 2024 15:18:24 -0700
Message-ID: <CABi2SkU+A0dhwkGMPKuHvKaLH=kEcRRemo+tYxa9amuiYZxCEQ@mail.gmail.com>
Subject: Re: + mseal-fix-is_madv_discard.patch added to mm-hotfixes-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org, shuah@kernel.org, 
	Liam.Howlett@oracle.com, kees@kernel.org, pedro.falcato@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 7, 2024 at 11:59=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
>
> The patch titled
>      Subject: mseal: fix is_madv_discard()
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>      mseal-fix-is_madv_discard.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mseal-fix-is_madv_discard.patch
>
> This patch will later appear in the mm-hotfixes-unstable branch at
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
> From: Pedro Falcato <pedro.falcato@gmail.com>
> Subject: mseal: fix is_madv_discard()
> Date: Wed, 7 Aug 2024 18:33:35 +0100
>
> is_madv_discard did its check wrong. MADV_ flags are not bitwise,
> they're normal sequential numbers. So, for instance:
>         behavior & (/* ... */ | MADV_REMOVE)
>
> tagged both MADV_REMOVE and MADV_RANDOM (bit 0 set) as
> discard operations. This is obviously incorrect, so use
> a switch statement instead.
>
> Link: https://lkml.kernel.org/r/20240807173336.2523757-1-pedro.falcato@gm=
ail.com
> Link: https://lkml.kernel.org/r/20240807173336.2523757-2-pedro.falcato@gm=
ail.com
> Fixes: 8be7258aad44 ("mseal: add mseal syscall")
> Signed-off-by: Pedro Falcato <pedro.falcato@gmail.com>
> Cc: Jeff Xu <jeffxu@chromium.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Tested-by: Jeff Xu <jeffxu@chromium.org>
    Reviewed-by: Jeff Xu <jeffxu@chromium.org>

In case needed.
Thanks
-Jeff

> ---
>
>  mm/mseal.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> --- a/mm/mseal.c~mseal-fix-is_madv_discard
> +++ a/mm/mseal.c
> @@ -40,9 +40,17 @@ static bool can_modify_vma(struct vm_are
>
>  static bool is_madv_discard(int behavior)
>  {
> -       return  behavior &
> -               (MADV_FREE | MADV_DONTNEED | MADV_DONTNEED_LOCKED |
> -                MADV_REMOVE | MADV_DONTFORK | MADV_WIPEONFORK);
> +       switch (behavior) {
> +       case MADV_FREE:
> +       case MADV_DONTNEED:
> +       case MADV_DONTNEED_LOCKED:
> +       case MADV_REMOVE:
> +       case MADV_DONTFORK:
> +       case MADV_WIPEONFORK:
> +               return true;
> +       }
> +
> +       return false;
>  }
>
>  static bool is_ro_anon(struct vm_area_struct *vma)
> _
>
> Patches currently in -mm which might be from pedro.falcato@gmail.com are
>
> mseal-fix-is_madv_discard.patch
> selftests-mm-add-mseal-test-for-no-discard-madvise.patch
>
