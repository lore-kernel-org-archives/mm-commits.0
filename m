Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CFE3161AB
	for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 20:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776284445; cv=none; b=BWLWjL+Uveq5oxo2b5RpzBHT/xby6oeB2jMyGr4HcmiIW5/GoShhq63LhxgxE1WsyKc5V8pHvWTOI4ZqWBGljomzfVdWNMoGftT5Z7Z1LfpHNuPouHchdokzY1BflDB1G/inAuytzn9+cBq8UZ/a5zegnKdZNmDQjrJVVVYRESM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776284445; c=relaxed/simple;
	bh=hCIf+weQww+YirHC1PZlVswZ1UJyibBA03y8a0U5pVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gEv9Ph/KuoeTdkP/L1k1Gw1WAEfYLNcjHjwq3Zy+NantMO0bfRCUOlncxdYN1o6Wn/9Cvn4fRBj41ZGgL2F/c7mCp9YcNsjOFj9KEfzZOfSl/jw2loCzvoyCneXMK+vdKqttqcmSxksRFqmuvVow+2fbdYgIGXuFzuCE96p77ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=boQeic1a; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="boQeic1a"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b9910707d82so916590066b.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 13:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1776284442; x=1776889242; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RD0WZ4vxceOe2Q9LtAJJvUrGVmgktyPaNbz/Rw5H6EM=;
        b=boQeic1aYY5fJ2FOatMXFyRc3sIl5XJXMUOEkBdfA4dt8ai2yDpm0CXkwREOh0/3GL
         yK13zXE1/LmIStshckSwuvkdabL91yDyX7j/gzmjHPp+kOHedXQYXqxt6rJaeZb7xWtO
         Ck0tcuBpXpFmGG4ZMuzKd0JCF6AH3NeZM+KmQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776284442; x=1776889242;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RD0WZ4vxceOe2Q9LtAJJvUrGVmgktyPaNbz/Rw5H6EM=;
        b=PDvWwHngHCPgz9IgBEaH8GH284+92Wq9WA+h0uV8UGMFeJ0L7U5UQu5P0YkASrM6wW
         KRffA8jVyKQ4W5ZUMCrzz/vhUao3v0FzZWKLsXc/70ITkAfDWt1OudHrAzRQjI6DDfFp
         uw4AVfS8Q+4S4UGdwvYUIACayc9YrV298HI0+z0UzGQaMufWETrALqa9DvtEO6kCb2NH
         fj1ephpT2A1WFg65zL0rNlX0uOW8SL5IhRPuM2jKXLBB0li/VZXb1sq/mw+CH5UkGctc
         SwQ9HL4HRInIzddpSyF6V7B6MkNc3+cLBc/lDkSw+0J+2Z/4obEAYxbVVl1w1q4gLDEt
         YoVQ==
X-Forwarded-Encrypted: i=1; AFNElJ9RkqXCHbl1r8DhdkoJwg5rwjXGBraj/KsIZu2jV0IOrUldwruGEJcAzTJ95wux0aYgvwz2Qx6adV1R@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz+sbW0g4T55MrFRPPtdJhgIBXma/ffr7nWZg/zboFjs6Y2gsV
	LxFwZZuEq3n1G0DODPj5fYwfuTAH02aMES3/m4Q736OFOvpFRN7mHVALgjY3UKyNy+11Oj9cbg/
	QtZqcOXqg+w==
X-Gm-Gg: AeBDietE+mdVo0kejk9fLWynxuLK2dHHJLG5VmZRB3nqA/qPRJbYVA9CI7t8PRLWpBN
	kxvEPXjaSJRA1HmwZxuVEIA5V6XoEF0cZjPD6k2M6QPdTgVg3ebdWklDjR/70PvwlfScPHVYonz
	gzIz7ZOnULwkcw3nzABnC5U0eYYKzmmdOYWm62rCcsEeJsdkhegY4p4Y153Xt4TF8DL0jYOyYfy
	0Lx9dTYQgk++OHkSSM3t121vk3xp+y8DbjkcXca55LU0jk7kVk9TghB0YvXY4oke9lBkL7NQxkp
	4es2lRJWvRQrVTiJha3EWoCKoryOdM+cqdQg1B91W69fDorgrw1y0jME/3mo+UQPV96CBE37KQP
	LhPSVta7Dg46dh6p99ozUNzQ3clJ8fHeB1XrUaZ8Ml+LMVM6xVssKaTWnNh2IBADqU3Cwvt0FgV
	iWkeDwv2Vclo5QNNrTFQHvAwFoYrcMSY5yT+ZNikQJ5zLQj4UtHw/Mi0hC2GrDLLjLbJjr2WoN
X-Received: by 2002:a17:906:fd84:b0:b9e:3bd:6ed3 with SMTP id a640c23a62f3a-b9e03bd788amr656998066b.47.1776284441850;
        Wed, 15 Apr 2026 13:20:41 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba177dd36a5sm91284866b.54.2026.04.15.13.20.41
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2026 13:20:41 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-66f727d6849so10521405a12.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Apr 2026 13:20:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ97aH0rWdN1pFpw96dUDms8UDqe4Vr4VO13vxwCrpQYivQMrQKBHTbFlJeLZcYQQusiRM/ex9lXq9GL@vger.kernel.org
X-Received: by 2002:a05:6402:3596:b0:672:7298:31a2 with SMTP id
 4fb4d7f45d1cf-672729837ebmr124115a12.7.1776284440889; Wed, 15 Apr 2026
 13:20:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
In-Reply-To: <20260413214952.62836ac9df0eb348ee4aeb2b@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Apr 2026 13:20:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjMroU7PofBOC52f5u5bTjTO2tm5ehycf9evmjeq-hq3Q@mail.gmail.com>
X-Gm-Features: AQROBzCKylPsnYLo4V0oRH2sXSLCdE6OFA3N89cLViHqNyOTdUIjQqN5FrzJ8QI
Message-ID: <CAHk-=wjMroU7PofBOC52f5u5bTjTO2tm5ehycf9evmjeq-hq3Q@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 7.1-rc1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 13 Apr 2026 at 21:50, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> include/net/netmem.h, vs net tree:
>         https://lkml.kernel.org/r/aaGiDINfnUexT9Px@sirena.org.uk

None of your links work for me, all resulting in "403 Forbidden"

The proper format would seem to be

    https://lore.kernel.org/all/aaGiDINfnUexT9Px@sirena.org.uk/

(or "lkml" instead of "all" if you want to be more specific).

Maybe something changed recently, or maybe your scripting for this is
just broken?

               Linus
