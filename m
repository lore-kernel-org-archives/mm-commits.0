Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990CDC2FA
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 08:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739868537; cv=none; b=p4fB+Q0BHNdao3M2J2sPrq2/4pFgMgdC042Y5NgLubyhSJdzGUrJdfw6N2NRL5+bUHpCevYfIbLuVtki3iPBlR1VDsC4AvI0xZdm0I7hbCrG7FneNjruL2dP13PnD6r70Uf0F11I4UbdA9vt7tj3B15PKpNdqGqoyQcHYANaXjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739868537; c=relaxed/simple;
	bh=kH/e1SU6FvJqYbGaPpivjO2OzyMjuNGbB+2dUAGjkqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UInxf/idCGK6qcceK3DV9giXxvTTaXTA3ijtMsnBPY+fvGaYfGP47TxGA42AEmx1M2LpfcjtUqK8NQiW8gvWbV+oAPYsgC8Tg/MEb6MJ1uY0Q5n2puWR5ktFnalUYRbVKCIhTmIL+wHWZ/hr6RTTWiw9vDnw7ri2TJAs/TgC7V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FR11jy0w; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FR11jy0w"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3f3edbef7d2so572228b6e.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 00:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739868533; x=1740473333; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w1MmnCayVmCKnV17R+SPQYgsQpqgqtnHQEQyD/XwNmA=;
        b=FR11jy0wXl7ANMGv4MirxqU4VDwjmWApBl7omPp1NUAkUmb4hSX0h5A76mAh6NsTJX
         RS9pNyNG4y68hU3gf+q87y+et0kxQbrbqv4s6AY2PeckudXOYd3//Kmwf0n7kIv1FCCl
         azSgJ7Yojo5mqxEezibc0nLD2b9i6cuD1C3FSwfyzkJ4lS2k+FQz8vvCD6lpI/8vKder
         S1vt2bJs9z6k5ILhtwr+JmkPXKm8SsajEj6zA0AjgkxIVzGnwwSw8JFi9sOn7Yp4jdlH
         BtTlXc6cECnyuB1GcGWspI3pGElgLtPnrjdC50BI3v/8a20/RRXMydlF2YIQM4mknPoq
         ww2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739868533; x=1740473333;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w1MmnCayVmCKnV17R+SPQYgsQpqgqtnHQEQyD/XwNmA=;
        b=OXazTrzql2+B9akKYSV54/9yY/ykW3E5yL26vHFu3QuHXyY56X25Z1xu0M3efC53q3
         FZ55tlr3cY2091oSzs7ru0TJjWCbfZ/AcZuAzkKzqgDs2DTXaqnnYwF/teqe6B2TiLZ+
         eGSdrcqM8hYv6woKrIcouBYifJHAd7gJ9IlHQPGfgFZsSq0Mk3sELV7baY9QL6Y50y4Z
         Ns0EvuBwcyDOpHNq2r4IXaQysKMVAt62msvTPDRJP8dIaI9w0WhcOET0hSDvGm9GzKGo
         b/iC9nZ5UAh/2B4WX5eLraiaCEzbeiFgM2BdmaXsZWJOMbN4+zH3cqG7RHEGgbCCAABt
         Akaw==
X-Gm-Message-State: AOJu0YybilQ5EdXDYH5/KYyrmrE2F1croCMrijS7qFQMLV36uwgjkT5q
	xWfZezdcDw3xt+YArj+Nb45pim2eHodGwWCBqWLH/Kv4YT211xxP/+LYjbF6bi8+s2C6jPXaiuc
	VWaGUR5eSivSzYii9WlEHbB/QeFzEfyFVK1p5OA==
X-Gm-Gg: ASbGncsswthcU9YzEXvFmxMmWlHxdMPB2vSan7xgjD1rWCIaxbXkjRlOSbW71SAdJw0
	e8YnDtlu5nZdeozZGKhPP0W7+wvKM3fPmqIGO0PBYO1EWpNdjTKm7GffXt7S2kx2jYAdUyopJ7w
	arpeWtB12A9DDMQA==
X-Google-Smtp-Source: AGHT+IGKo2lwEL+RUGRydqR3jceHxtioue+DTzHuZf9dPYrRZoDgTL+WjY72pd3VLgoqDoGXBpJUrDuGYgnJ/htLGbU=
X-Received: by 2002:a05:6808:2e8d:b0:3f3:e6a2:34b9 with SMTP id
 5614622812f47-3f3eb12db4dmr8305991b6e.37.1739868533448; Tue, 18 Feb 2025
 00:48:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218042407.5B384C4CEE2@smtp.kernel.org>
In-Reply-To: <20250218042407.5B384C4CEE2@smtp.kernel.org>
From: Suchit K <suchitkarunakaran@gmail.com>
Date: Tue, 18 Feb 2025 14:18:42 +0530
X-Gm-Features: AWEUYZkV9QlJMDjNKKzVP-826---tJynjpRZCzptdtGbE8SNdkTdMiyJ9hu_57A
Message-ID: <CAO9wTFiAphJkat=64R9EmWC+SqQ_ysmyHDVV30E+sHLhYt2_Rg@mail.gmail.com>
Subject: Re: + documentation-mm-fix-spelling-mistake.patch added to
 mm-unstable branch
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"

Hi Andrew, I'm not sure what my next step should be. Should I find the
original patch message and reply with something specific?

On Tue, 18 Feb 2025 at 09:54, Andrew Morton <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: Documentation/mm: fix spelling mistake
> has been added to the -mm mm-unstable branch.  Its filename is
>      documentation-mm-fix-spelling-mistake.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-mm-fix-spelling-mistake.patch
>
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: Suchit K <suchitkarunakaran@gmail.com>
> Subject: Documentation/mm: fix spelling mistake
> Date: Sat, 15 Feb 2025 22:30:42 +0530
>
> The word watermark was misspelled as "watemark".
>
> Link: https://lkml.kernel.org/r/CAO9wTFhe4sf1eVVgijt2cdLPPsUHBj7B=HN-380_JSpve5KbvQ@mail.gmail.com
> Signed-off-by: Suchit <suchitkarunakaran@gmail.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  Documentation/mm/balance.rst |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/Documentation/mm/balance.rst~documentation-mm-fix-spelling-mistake
> +++ a/Documentation/mm/balance.rst
> @@ -81,7 +81,7 @@ Page stealing from process memory and sh
>  alleviate memory pressure on any zone in the page's node that has fallen below
>  its watermark.
>
> -watemark[WMARK_MIN/WMARK_LOW/WMARK_HIGH]/low_on_memory/zone_wake_kswapd: These
> +watermark[WMARK_MIN/WMARK_LOW/WMARK_HIGH]/low_on_memory/zone_wake_kswapd: These
>  are per-zone fields, used to determine when a zone needs to be balanced. When
>  the number of pages falls below watermark[WMARK_MIN], the hysteric field
>  low_on_memory gets set. This stays set till the number of free pages becomes
> _
>
> Patches currently in -mm which might be from suchitkarunakaran@gmail.com are
>
> documentation-mm-fix-spelling-mistake.patch
>
