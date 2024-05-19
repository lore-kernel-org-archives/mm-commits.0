Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9A24C637
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 19:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716145218; cv=none; b=OvEyyicfTbavFKQSR2HHHzCBDz3xKmATbKfe8g9Rvrk3dk8P3wzF0dy4YLe+gDMjS4CaCQRo7e0HHD9tU6fhasEdKoX7g6RIGxOoMtBod/KUgmPyTyHqxHTEbvl2ncJg0GVvokwHl9LXpX7yYKRmfiB4D8Gei1aO9Yrq25BOXz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716145218; c=relaxed/simple;
	bh=DHmSszyfjhEcPAzaxAqwGfnCK+56Q7eIRYpFVGQsK6U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PHF1GTZqw/lLE5lhjKIzz46MJ0ol2POq0wac1DjF6nMOce5XS0H/Z6nrKeGHx+3KZ/bwJoWrJuL2l4dX3IeeFyC5BBTOVvDH1PTx10o2AMb4JRaFiVj70G3IcLhxBknR13Ft9V71r2KDUuqp6FoapkenMuC5+PltWdsYLAql/DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPsz894A; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPsz894A"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-572e48f91e9so7340440a12.0
        for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 12:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1716145215; x=1716750015; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9Rcdyva3+VOwNI8m9OxNo40+uCy3eJX0+lP+NPNz1Ok=;
        b=PPsz894AVrYuFog75nLPSCACuhOqiusQUgvSz422T8TfT0KVT11rg0TsLUSHQhAryp
         g50VQ5CpVo2cNHKHzZTr84BJL/A4e5AaviJEcgPx4h1iBl1XqoRJ+S2YOJCJ0wmDPQgl
         xbb3XlLG8xFOM8XEKvwGc6bJaSzFVX+hdVuRg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716145215; x=1716750015;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Rcdyva3+VOwNI8m9OxNo40+uCy3eJX0+lP+NPNz1Ok=;
        b=kiOODrG3Sk8sBgdSkxOUx2IH/8bA8OXiu4D+4XaGCMSLAO30S6BKD91/vuWITK5aM8
         +JInPr9JtMZ256IqnsI3POhX2L5Nbw271usE5TZ9CS1ulWSTCPONYVS/N+AhNrQJ8RY4
         r7vbQ1UUCkvcm00jSCLg7dghHvMGVlNer/FmfGOYQ11oD97vmxMyPQmvHlJDF2Z4pceu
         jyxfeYkdniLwEdxIdVzhj95/9krYE2JIvNg6IOjIJ8vDGl5131TR6hrnkBR8WFnkUd/K
         6cm6/j7+ZeRLgMKFB/JFeIcuNaz0jq9lSlEWGQPgOgpQp2VZmPqus4sRqk1oN6eIPmaQ
         teOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHfUjtAROmNtwuWLJlXEHQLaZAAX/IIc/xYqg+G6uSbIckZqOAzpIeXJck4Q+pBKoVnxwq9rOgNkne3ibuhEIkjJ5FXk8h/mFndA==
X-Gm-Message-State: AOJu0Yxgf2jsNy4ZzernG2KrjAyE8eGyEOEE2HiR0qgIw+lfrVaeHaie
	ySqv5QSy5wIREHBxhlAeCpE9PQNENVb+p6/+4s6xobUQbyJ2b7ZhihlcJEWeiIxX6F7MbPKW+r2
	r/JmixQ==
X-Google-Smtp-Source: AGHT+IGE8gOFHRv5piRnMNcddCiu64RAoGYTffkPby4zbX9ewCep3x9Nk83B8i2rwoocb0zitfXaVQ==
X-Received: by 2002:a17:906:4808:b0:a59:c31a:91be with SMTP id a640c23a62f3a-a5a2d54c571mr1742020066b.16.1716145215266;
        Sun, 19 May 2024 12:00:15 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a1781d294sm1365232666b.28.2024.05.19.12.00.14
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 May 2024 12:00:14 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-572e48f91e9so7340427a12.0
        for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 12:00:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXP41zmgn6fZ0bZUeLsGg05ODn2XTqFvfHLYark6FoBg6cIeILJHMG8huruXaFIIpnAd6lSn7t077xGuxQgAj9mhIcoDGHxGobkxw==
X-Received: by 2002:a17:906:1401:b0:a59:b136:e40f with SMTP id
 a640c23a62f3a-a5a2d5d08e0mr1738036566b.38.1716145214360; Sun, 19 May 2024
 12:00:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240517192239.9285edd85f8ef893bb508a61@linux-foundation.org>
 <CAHk-=whEAquncw0wb59-XVAHmVh4CWSfwuWh4bTJjJzvx0=PzQ@mail.gmail.com>
 <20240519113639.db3fe5f80d25be4e7666751e@linux-foundation.org> <CAHk-=wiy+25i1VZhDaV-b_m4aXGNELuVok9Prv4=oYqiun--rg@mail.gmail.com>
In-Reply-To: <CAHk-=wiy+25i1VZhDaV-b_m4aXGNELuVok9Prv4=oYqiun--rg@mail.gmail.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Sun, 19 May 2024 11:59:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg5uUJfZEh7hG_iFcR4kzAwwCrhBmuBDLc3+roZTov5kA@mail.gmail.com>
Message-ID: <CAHk-=wg5uUJfZEh7hG_iFcR4kzAwwCrhBmuBDLc3+roZTov5kA@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.10-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 19 May 2024 at 11:56, Linus Torvalds
<torvalds@linuxfoundation.org> wrote:
>
> Instead you seem to merge _and_ then rebase. So you do the worst of both worlds.

Hmm.  Your non-MM pull request doesn't show this pattern, so the
problem seems to be purely about something you have done differently
in the MM branch.

                 Linus
