Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A32B3346B4
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 20:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773089148; cv=none; b=ZMpsjG8WRrN7EGlZaXcTpQZ7CFrd0YcfsHohOMSf/I/LL+acKOoy/VNcvFwO2JMO1t3qR7qv6b+7412npC4rrUrkkEjlzsaDAkuXpiWMxx9EZ3M7o3EFBK35Eku6OlhMorE/0MEXV9Pi6P/fXO/XKYuo9JkhECGZ/40L+wlzX9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773089148; c=relaxed/simple;
	bh=HcSrHfLeL+xRhl4vHLxVae6asBdEQhVzCasok1TUdGA=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=DgS7fhA+ZwL/ZsykQF4bxguF/ZD+TqM7wD1x/y5aUdRNz7xEjgi+iayyu9ag3qsL32KawMfFZ35olTuoGAEq1jO+Gvt4VKYWiTy2pSrBZ6ysH1n6IVTOEPS/gJYzV3apsOedsR8VaWBG5PbJntUvPBfexbeB95YKCHmTSv4RNxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DcUgVYQ/; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DcUgVYQ/"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so27126615e9.0
        for <mm-commits@vger.kernel.org>; Mon, 09 Mar 2026 13:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773089146; x=1773693946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HcSrHfLeL+xRhl4vHLxVae6asBdEQhVzCasok1TUdGA=;
        b=DcUgVYQ/zK8rFmrM7gevK0BgSkzYW22Ep8XDvSwOYE8DCiPNNFz5Qyj3bQS5E9nTEx
         kOSL7tyap6gd6DxA0LdAXIM4YYbtotpog+f0CU7TkMEaInFORgQtZY1EA7gslKIwCw8d
         3KVALKlfZZbsVdNNUywvB/+T31dGHGmEB4tbS3L6Yew1ipvi5G0Lym+MLqJ9eNZAEzBG
         UkwC+Oi3Ce1ZVhlIIxvLZC50IXQKznikhEP+dh78QO0tcZU2/nOBGOmZyZMJ9j4C6Hq8
         cqdJCIU0jr4/EaKEyy9Gsh0Iu38OEe6YhLbqMj5wEsL9lXhXTw/l5quJt5odN3mCNgrc
         R4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773089146; x=1773693946;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HcSrHfLeL+xRhl4vHLxVae6asBdEQhVzCasok1TUdGA=;
        b=plHDnSdEjx3ANK+CNVLH6syM+rKIxgOfpCzMxAtI5dT9ys6KTUWQBrJHsXJ7BYxNdu
         ARV7coXfZx8Z4ozfbsCWWT8aV6AogYXtbneYJf1y06OZXTnCJQbXTscNXh9hICnSerOP
         KAvGcHoXnMw4oK6eUF4hS/A/dfgCDg9H29bKxwtqEBHDYzUZg41sFJG9ZUSBHKsTdvd7
         98OQ+HUPeD8dFVEBDhw7rJZ2PxPCSJ0ccSpjaOHRAU23uVxgGA/nyXgONF8klDcWpdk8
         YcGJf5cXJ0jL6frRUW0qHZPyUIuZvQCD2MG0vpHovyX0XvqnkHLd3E0oih8lg0juAESg
         mfoQ==
X-Gm-Message-State: AOJu0YxNm2iFMktw9VIeuOISjZb2pdNtrVoV8XstpTcgPoB7hp5SyNV8
	Q1FmWKxtW9CiGzqI678Hvj0VbJ6bblo+cT2MePqiE6aKs+mFW7NFTBHd
X-Gm-Gg: ATEYQzwYBragiMdA6Y54jPMCWEHkt9178UkVm59aOYmjS7lBrBoFNbM0v1IZgiGMrmE
	+q7BBlh5vWlxbRWZu59/9rDRJQCCP6nVrA24knc/zbF/N75Dr6jIQho9Z8a+3KzKrjWMl8EijKs
	RScdstLje7qjsr10DnuHk6VaZKw3f1YfZqRLm0Ck/RuqfwLs6W6FMWjHBnBaDbw/cyCZYOhaIVM
	vCoay3VNbhdZEmudtrfka9hwAn4nTYCrxomXE8dAbw6XBqoZPI7Jvpiz/xK///xse+v1MhICEO1
	RiZf96/xJSEcob1t1RyiP2R8Ja7IXIr5ia4jw80bUrvnx/bdhDnoULEg3UWV+LY9hh/Zx4otjIg
	H/+uCTyQG6BeNL9wkJTTJHVZhaJtd19XzV96Arn/65VFaYekimyA7sKxITnqFQuPP/aZrtKoe0y
	fUp4PjqOCaXo8JKpUJ
X-Received: by 2002:a05:600c:4752:b0:483:7783:537b with SMTP id 5b1f17b1804b1-4852697a593mr218753085e9.24.1773089145357;
        Mon, 09 Mar 2026 13:45:45 -0700 (PDT)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541b6f6b7sm22973195e9.9.2026.03.09.13.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 13:45:45 -0700 (PDT)
Date: Mon, 9 Mar 2026 20:45:45 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, objecting@objecting.org
Message-ID: <b1324259-8cad-4fef-94b9-2a72ac5e54f4@gmail.com>
In-Reply-To: <20260309134310.6036ef100f81a943f0fe6e2b@linux-foundation.org>
References: <20260309202433.1ED14C4CEF7@smtp.kernel.org> <2583e57b-fb3e-4e43-9d93-a3db4c816c11@gmail.com> <20260309134310.6036ef100f81a943f0fe6e2b@linux-foundation.org>
Subject: Re: +
 lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch added
 to mm-nonmm-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <b1324259-8cad-4fef-94b9-2a72ac5e54f4@gmail.com>

9 Mar 2026 20:43:11 Andrew Morton <akpm@linux-foundation.org>:

> On Mon, 9 Mar 2026 20:35:07 +0000 Josh Law <hlcj1234567@gmail.com> wrote:
>
>> Do you think these patches require Cc: stable?
>> Idk the severity of the bug to you, the swapped arguments got Cc stable,=
=C2=A0 overflow could cause some screwy bugs
>
> Probably not - is there any reason to believe any callers will hit this?

I=E2=80=99ve been looking at the callers. While most are in-kernel constant=
s, xt_string in Netfilter allows for dynamic patterns. Even if it's current=
ly mitigated elsewhere, hardening the allocation logic in ts_bm and ts_kmp =
feels like a 'must-have' for stable trees to prevent future heap overflow v=
ectors. Basically... Better safe than sorry!


V/R



Josh law
