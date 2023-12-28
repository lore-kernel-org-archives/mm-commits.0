Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDDE4409
	for <mm-commits@vger.kernel.org>; Thu, 28 Dec 2023 00:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VO5nOxIR"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-50e7e6283bdso2150558e87.1
        for <mm-commits@vger.kernel.org>; Wed, 27 Dec 2023 16:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1703723795; x=1704328595; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZuhB8VHwVQmrv2O2PykI3H6Y0tt0rKki08G/rfRh77c=;
        b=VO5nOxIRiLkalyxUowQieckgkyaaGx54F1ujZOdEQiceQzMkbTbJJlvX1MhyHzKdZc
         sAEGuU0v70T8778W32CGgRdxcy5xPd/yV61knK5Q4E4ZKHY36/TnduHCB//Xxr1dtlRm
         SYyZ2KdpWb1Pfu1QSxY89UkNYXPTeOanZsmxw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703723795; x=1704328595;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZuhB8VHwVQmrv2O2PykI3H6Y0tt0rKki08G/rfRh77c=;
        b=cN9b882ZBdxgLyEJMV4KQatmvMkVWSDY1HtbGBH2/bxdJEO+GbguRBTH+ME7RzfrVR
         UyicdBVVnhXS+YKFYJFdjeZDtvfmMiv/gqxsKoiEay4QqUBG2IcXPdKR6MP9rnDhhwht
         gPv2qEl+ECh4qmjBxQwuejDbJQo4endgNcO1B6xjTSgdUcVZ6Qg2R3sj6nDOxDQKLYon
         b5Kw74wJ9Q+JURck8Fqv9cHnRVd1r7W2jvwhC5p9PlDPK34CzuViXJHGb9xM7tDvPo0o
         R5KPT8jXSrI08+7Ce7aKu/ML1EA35nFNCic8JJxGD+lgYB2kkQ1ptouvB03kcSKSi9Js
         YY6Q==
X-Gm-Message-State: AOJu0Yx0/x17sEp2XNF1XLJR4sSXQuL+fckcLZDe7K2FdTH07ns7Diam
	7CObbm+gjqT1oFGPOFSsMeLiXGrj579Ld2kytNy9nZb73er2tg==
X-Google-Smtp-Source: AGHT+IEUJLM3kCOUdyQ5g+tFWG5h+2ruJIgsZsTddWGaVxMYW2CD/OgyjrT9dOXNkcWgfOWGXKPMDw==
X-Received: by 2002:a05:6512:60c:b0:50e:2a3a:c25 with SMTP id b12-20020a056512060c00b0050e2a3a0c25mr1726911lfe.211.1703723794780;
        Wed, 27 Dec 2023 16:36:34 -0800 (PST)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id zz15-20020a170907350f00b00a26c8c70069sm4972359ejb.48.2023.12.27.16.36.33
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Dec 2023 16:36:33 -0800 (PST)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a2698cff486so680236866b.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Dec 2023 16:36:33 -0800 (PST)
X-Received: by 2002:a17:906:254e:b0:a27:2f11:2928 with SMTP id
 j14-20020a170906254e00b00a272f112928mr781979ejb.271.1703723793333; Wed, 27
 Dec 2023 16:36:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231227150354.9437b5c792000b8eb22758e9@linux-foundation.org>
In-Reply-To: <20231227150354.9437b5c792000b8eb22758e9@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Dec 2023 16:36:16 -0800
X-Gmail-Original-Message-ID: <CAHk-=wifOnmeJq+sn+2s-P46zw0SFEbw9BSCGgp2c5fYPtRPGw@mail.gmail.com>
Message-ID: <CAHk-=wifOnmeJq+sn+2s-P46zw0SFEbw9BSCGgp2c5fYPtRPGw@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 6.7
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 27 Dec 2023 at 15:03, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Baokun Li (1):
>       mm/filemap: avoid buffered read/write race to read inconsistent data

Hmm. I wonder if we should have made the i_size_read/write helpers be
smp_load_acquire/store_release()?

The existing smp_wmb() are almost accidental, and aren't primarily
about the inode size, but about the page/folio uptodate bit. I guess
they work, but it's all a bit messy.

Which might *also* be better off with acquire/release, but we don't
have those bitops, I guess. Oh well.

             Linus
