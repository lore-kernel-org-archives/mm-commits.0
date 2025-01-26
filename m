Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E080E25A62A
	for <mm-commits@vger.kernel.org>; Sun, 26 Jan 2025 22:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737928812; cv=none; b=E/zH1lQb72fgLqQuLYINfKlSMmQrzNk+AXcEfBGt5fsDCDRCYxKEtXJZNXHSfo4fRFcMYcTBwlqIdnKYptGigO/hlOiQn6HJJ8JuU7PfPwGygoqexWmJEcPrnKt5V4uC52zvZkzuFENWthRzxVcTpDpGLqSIfcRGLAqoKYLmgVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737928812; c=relaxed/simple;
	bh=TRSo5xvEAby/8UVFB4YxlLqF8Xw1+3viUpKCUx936cY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YLoojTO78Ld57W3xc5lgF8Q+FKK/CMDHDm4VblrbsfJpTw+mJv7OFh2OH2nXG1MX9isBGLV/CczpqNJS5ykTEiwqCu/YWbGzrOqrIO9kt3LyRvsXWri5Xz8UOod7Ry/xGluSYN0LR7Q9IPXCc7l77WeiNUMbyj37ZvRz4JLb8Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LOq1jSLJ; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LOq1jSLJ"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5d3d0205bd5so5653919a12.3
        for <mm-commits@vger.kernel.org>; Sun, 26 Jan 2025 14:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737928809; x=1738533609; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MZXcST6Gw7O/Lgjhs1LmvOD9s4ldWwsl8TSHFRifec8=;
        b=LOq1jSLJogZeXzTf4gtuThEB8BmiipVQQeNQ4fkolzaB4TLc9N0fZtTuC+TphxmY5b
         PdFhCVTCbj3WIANitIHM5Wx17XhWD1y7J0sUdfruRKXzN52XDfhsIXXYm3K8laetPCHQ
         2fkf+wn7nLLqqTzSAoY1XR68CZe2qZtDYTxGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737928809; x=1738533609;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MZXcST6Gw7O/Lgjhs1LmvOD9s4ldWwsl8TSHFRifec8=;
        b=ZBgOdYhJCGDlMRAGHs0h7JCMHwl3TEv6ZSNdKtkN0X3N3RCFi2RNllPnR7AFGOEApT
         HO9ZMYhAZdclPgBRBxYaVF+b4bUfTHjE76rVz465Tz3/nBYlPrI1xb51U/tMHrRleVbd
         ZGzGWJASWKeBTT+pEfmIpJL5zkI92kDeLg8Zht3UyXfAWYlYrlTXfWzDN3k9C4TuwWLE
         qIjVxHp0JAsza+wrPT6GvTpN/0hx9CSSNJjkzht7o9Jx/uNYP7wen+LJMs5EuBOJmzm5
         axDivDFdcsN55QZaS3IrzD2THL/kXa0ksOnb5PA3JnaRpQLK+rizTvofJQrqM1TvCejQ
         nY/A==
X-Forwarded-Encrypted: i=1; AJvYcCVad1jdCUbG4Uk9Dj1CVFlHoDM/3bqn5Qm+/L3DOVqNDINTvqmY1Ugf7etIeqot8F3klR7SlIlQEFEk@vger.kernel.org
X-Gm-Message-State: AOJu0YyYoBzayWyQtY4VgzFzK0ZohgNaR8kQXBPI95x2DTUdDNWPG4Oi
	JwfH7aCmz/YnvdhlTbPCerRYV3HN34V/b3iDYwpZV94KRNvDQ9kcgUIZGAwSgi3d6adJe2kLwZz
	RV8Q=
X-Gm-Gg: ASbGncsLFHfJiawzjfp/Nj+BQPie6tmCdKqFDjXHHzP3888vmAmj/AD0HQ8NG95b69C
	gjDDjqIdxKKRNStB5GiSydgIq+3T+9j+JbqnNSwD3Dx+jPumK1aiYEOYrpFWvnszCwRJ1K6MW5a
	yJI7/bnbnU85EAMS2EIu40j2CYIdPJNclzP0jfHxRhxccx+rcYHaVpGgsiZF3CtiN9QJylIBd3w
	FGsbkvOUNAxZzmFbBN7aAyCqLtnipYTR4/U2J3gsvCyLhyU0Gc9o5PKCk+Ur7QUOw29DStUTQ3G
	m/ZItw3ZmqiGSl346Qo2h4MJEMbk+UJ1noh6NmJmhp6j4S0q9dj8EOo=
X-Google-Smtp-Source: AGHT+IHZt2slWqaxyzwiAeKOg6/D0eDT51Gqq7FPv8rmqd6pXg0LeqJWe2RHEYV4x6FAZSNwM8rdzg==
X-Received: by 2002:a05:6402:26d5:b0:5dc:2077:8017 with SMTP id 4fb4d7f45d1cf-5dc20778312mr5566649a12.8.1737928808905;
        Sun, 26 Jan 2025 14:00:08 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc186d8a27sm4293722a12.73.2025.01.26.14.00.06
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 14:00:07 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d90a5581fcso6468968a12.1
        for <mm-commits@vger.kernel.org>; Sun, 26 Jan 2025 14:00:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWKjlLu7R3ylTk9TTy/hJFKbd5XOBP+C0BgHi24yFeVaLqCshViovOOji16XaknsJnauv/YoFL1h2PE@vger.kernel.org
X-Received: by 2002:a05:6402:51c9:b0:5d3:bc1d:e56d with SMTP id
 4fb4d7f45d1cf-5db7db2dbe4mr33984157a12.31.1737928806508; Sun, 26 Jan 2025
 14:00:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
 <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
 <CAFULd4ZWS4Cxv0CELosQHJh9vTqOJFdr+Fk9NMgSREr_dFG05A@mail.gmail.com>
 <CAFULd4a-2F_zKMeR0Yjo2WhRLmyoOQ1VdR2qdV34BrM-b_cQCQ@mail.gmail.com>
 <CAHk-=whgufZwjAuL1PBs1gjSMK95TEhGj1SiMbNvkysWBcEPMw@mail.gmail.com> <CAFULd4Z2eSJhE0qF0QEtsb-7zoOMKH=KvvrfK0M5UozLw_TYUA@mail.gmail.com>
In-Reply-To: <CAFULd4Z2eSJhE0qF0QEtsb-7zoOMKH=KvvrfK0M5UozLw_TYUA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 26 Jan 2025 13:59:50 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjmThGBZCxmBTypng2NEczY7cdJi2Dotf7ygun=hu_EGQ@mail.gmail.com>
X-Gm-Features: AWEUYZnB18NFaiQ2m7JAM-sNijawslpBRz9H16_egsXxhwW7RUEVE8BMB5knEQk
Message-ID: <CAHk-=wjmThGBZCxmBTypng2NEczY7cdJi2Dotf7ygun=hu_EGQ@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Uros Bizjak <ubizjak@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 26 Jan 2025 at 11:47, Uros Bizjak <ubizjak@gmail.com> wrote:
>
> >   #if __clang_major__ >= 19
> >   # define CC_HAS_TYPEOF_UNQUAL 1
> >   #endif
>
> It is available in gcc-14.

Ok, let's take that approach, instead of messing with CONFIG_CC_HAS_xyz.

Andrew - if you send me the MM pull without this series, I think we
can sort this whole mess out later.

We should probably look at a few other CONFIG_CC_HAS_xyz cases, but
from a quick grep the existing cases seem fairly harmless and
obviously haven't triggered these kinds of issues.

          Linus
