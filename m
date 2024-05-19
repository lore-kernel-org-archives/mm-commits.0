Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F84F495E5
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 16:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716137352; cv=none; b=LBryle/kBuzntVUV86J8SrXYeYyEUprWlLHY9uqbGYlFuaCfxTC+w9j2EsQ/NTgIAZy8Y+WtQXSGiCndQLhL8n3fzR0oW0LGkgiY+mA93msyn3Ffzs3qAx0SK1eyWUDh8jy+3esiJBRFdnQ4goYtuZqz+CYEc7ENCYQErYkFDgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716137352; c=relaxed/simple;
	bh=Fhiqd8BsQupsJpiNgkIjNU/SvByQ1V6nfzY3RL0SiXw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EKblKEXBFuh3atdXsti8mLWXTyC+Txs02X9E6EchlBeQtz14lZO6dI60EBJWbUDQh1pMsWODjYz4fYY6TjKCze0mAtzic5dIhdael7n79BrQ2bGkYkNBwqFapYfVzJ35FC/tUur4CGe5k8aet3kM3BqfMdLo6saK3rPINKf8Dmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FaVz0gNA; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FaVz0gNA"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5210684cee6so2781176e87.0
        for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 09:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1716137347; x=1716742147; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M9lPiIVfBe4u7k3tCVL2yrGrYYG9ynn3v8OVvk6ILus=;
        b=FaVz0gNAaGH8bZwJ6DQQvA43Q4gpnmsWItlmasb0t5McIcnseYHg/Si4E7CoE5HpmJ
         VeLDftAS+LCaa9puZoHZwkQIS8ymA7ezNnaR5ZcYLkiZKJQAFMdutwDcw71wSjbt570e
         /lWJ12JnSUXcQbP0qRj+F/y+JeeevK35OP5wg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716137347; x=1716742147;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M9lPiIVfBe4u7k3tCVL2yrGrYYG9ynn3v8OVvk6ILus=;
        b=FX+s1AjnG/Bm3ekBwoE3mTYwPQfWC0/vlVBi3V9/g3/tFLuKeirDdAkS+HYD9dGjwS
         7Jls0C8rEwT5RY0kuoCHC2tJwr3kk2HIAlK12IVYVpnT9/8gJSAyWfnTtn4gxKiccFWs
         WNwX1oYTOf7z/Bnc83pSjWNpm3v02mKP0SQO7VVjPi2nT5UgMTFwN8mXrtB7Ddb6GrpO
         Mv6ggjhuFiz5DhuA6gtZ4yeWSNwR+vWvouDgoHnW2sM6LzCadygTZA8uIvwcqE0YrB3D
         88qeU0naCaTpLE2IaW8D0QIcEuf72qhar/S9QZMYncbcrQrNbGsIWXv3eQnmBc99VLei
         z1Lg==
X-Forwarded-Encrypted: i=1; AJvYcCUzDFLzjQxyCrNlhkezqS4DHNi1birNcULhPBIRNgd9c1xgQf/0qLWSDHYLRQIi5Ys8G74V4pQrVMAFMe3cJsFj3oc5R4awOCQ4sQ==
X-Gm-Message-State: AOJu0Yw+6XL6C0PfrOcHQR3G+EW/1yMCHcC2tKn87vT6hRY3ofJk+g2v
	r2lt5cydVGa4Tr67fQQjnzKu2G8wje6V2UEWKUAHLzm/QZIqLc9El5Wyqix1Qwr0uZHOzxcAahH
	q0lUG9g==
X-Google-Smtp-Source: AGHT+IEasNhUP17dBTu7ju69eIWODaxXAc1dx1Uhq1WAS0YbmNjp5oadE3snVged+TQfs9pUmwRyzg==
X-Received: by 2002:a05:6512:310f:b0:51d:6660:e43 with SMTP id 2adb3069b0e04-5220ff746c8mr16459810e87.59.1716137347293;
        Sun, 19 May 2024 09:49:07 -0700 (PDT)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com. [209.85.218.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-574ec273185sm6595892a12.42.2024.05.19.09.49.06
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 May 2024 09:49:06 -0700 (PDT)
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a59cc765c29so206202466b.3
        for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 09:49:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVzbzKNGQUrapVTO4aoq8VdWnUtIQBLIbPCppFSuR9I0w2KvL1Xx0dYMhwAUDcE2k07yw/oBeV4rDBzT2CA0Z++S6SEubF7pp14yw==
X-Received: by 2002:a17:906:22c7:b0:a59:be21:3577 with SMTP id
 a640c23a62f3a-a5a2d5cd472mr1751615266b.43.1716137346046; Sun, 19 May 2024
 09:49:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240517192239.9285edd85f8ef893bb508a61@linux-foundation.org> <CAHk-=whEAquncw0wb59-XVAHmVh4CWSfwuWh4bTJjJzvx0=PzQ@mail.gmail.com>
In-Reply-To: <CAHk-=whEAquncw0wb59-XVAHmVh4CWSfwuWh4bTJjJzvx0=PzQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Sun, 19 May 2024 09:48:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=whSiUg7dggHaBLULuF6_GB6NORLDByog0p=Qo+0ewmZSA@mail.gmail.com>
Message-ID: <CAHk-=whSiUg7dggHaBLULuF6_GB6NORLDByog0p=Qo+0ewmZSA@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.10-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 19 May 2024 at 08:32, Linus Torvalds
<torvalds@linuxfoundation.org> wrote:
>
> I'm going to take this pull and fix up the cases I find, but I'm not
> happy with this kind of trivial C preprocessor misuse.

I did some other maco handling cleanup too and tried to regularize
some of this all, and it seems to work for me. But somebody should
double-check, and it's possible these patterns should all be
regularized further with a few helper macros for the whole "add
__GFP_ZERO to argument list" or similar.

            Linus
