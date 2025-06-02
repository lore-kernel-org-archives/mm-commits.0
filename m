Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAD746B8
	for <mm-commits@vger.kernel.org>; Mon,  2 Jun 2025 23:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748905404; cv=none; b=nLyFNJ0XCG7/YUIwtnzf8Di+m1UvGySYpL4xh+fUqa/YEHn0YXwB8tQo8fYKUNoPliL2wsrWDygZHbm5EMPJQpQRD+EBZIVtLsWIaE0lre/njig47lIxPLQ78iL3RLcXD5KnhoDSPmjxzukdgx+DoKBHRqs6+xYfq3/XJ6T6wCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748905404; c=relaxed/simple;
	bh=++szFMEtgyqwwYz0D+PwSonYFKpvE5qF2EiDkDJfZzU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=npC/HxNMlQv8tymtvj7ivqxc1YoyVrk+2SIWUGRLS7cWmagN/3LkRNQMZ8+1iVJQikHlWfsxGWg+H1M4ImT42tNQkah7AAwslIirdAnue0w1wwlpQxeYYfkvkscRVpIinqjpFVQjLJ0AOGL6E4fKsKmOdrHv5w2pjmpJEkzDeDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yej4+GtC; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yej4+GtC"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ad8a6c202ffso966586166b.3
        for <mm-commits@vger.kernel.org>; Mon, 02 Jun 2025 16:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1748905400; x=1749510200; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7f60M5hYbeRCzldPkBmcnfnzcWSP10+sVHiJXwkVxp4=;
        b=Yej4+GtCaj1tptR6eUrQRbrXZXFuW+kLFjBoaoifpFgjHs5ebsQ0PosoP5FrUbvpYZ
         QLp+8eB6qE3v6X3lqAZ21ucbYJINmiP2oFP1paJQrQ3T8CXmnzbKm1UNoDa4FM0xi+oy
         6pcGrNc2fN8XKunAS7CthVF/UYtnu+RlgKnXs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748905400; x=1749510200;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7f60M5hYbeRCzldPkBmcnfnzcWSP10+sVHiJXwkVxp4=;
        b=pn2i78tNyTFBxmcrFARckeji5bAOyQf1rEnibcu6GaiByyLGSZtW8ubvQ4fi7eUEgZ
         zscYxNGxprXV8YB1T6CEDnLMi1rFGSy1Hm5qM9VMCb1cjAxyM3N88y0xx5vcdcKo/ZYf
         C+8nxex25Ar5bbJ05HFsu1DpKwfeATnF1JBcR3jRcODofP/D8ia4SDUSdC5GhIUR+rbz
         FqcdlmfYauUTZ6JGTPVjaX4xIm24UCuJ62QEEIhkBxOWN+QxZIqY8zvbh6U9T45vAFrq
         UOnYvLbRS6y4Lbf4CDI7wV/5jqg4MJx+OasMLu2YYOyur14YLnQd/DpYV49QNgwXHIRP
         N6xA==
X-Forwarded-Encrypted: i=1; AJvYcCUYWobDWbSBKwi5YlDYorsILLigLYAef+crjIP3duZKZZEL9I8S3u6mRF0QnrqoTvnGgG4bYEEV4phk@vger.kernel.org
X-Gm-Message-State: AOJu0YxEIgm+pbsB8Bap3AS1VcVkXBpTl58/FVeeC6jFslAvgvmhMU4D
	zLG1FOQz1C+PJC70U+4GdxG5qHShmpGs38mortmAU+YAFRt1enu+PBxGHfSNb623/ATjNbzDmSL
	/MxzbXIIUig==
X-Gm-Gg: ASbGnctx8tYZ8VrjpROhacJ9CdLnnfY+e2IvbxmBUuT3F1SVaZmtzgMX8671x/V+iio
	Yr/vonmeqwp4xAvF5EWm8OwxYMl+gxGiYxsv4lVsq1UriqKS2PuZCaSAcVDF4TWUB+0160HTsBb
	7W4BGTcpoWSjpZUyuU+WhWe2glpGITsjKU+7giwRRvEhjuDRe+rsY/rMl7IKVhTYsD6DqW2XZ7s
	dB+zxWbsbf3aepeGoFIB+s6707Pd8a7kCnz0RrnquPsJRWinBCaCEqcR6lThcdWo+vhde6JF/Db
	gIC46XiWs00WNQopbQnNDvGJRI3Fji8D14xYwam501ndlvOb6AsVZjX/EHSlMNJWyjzbHa+hClk
	o2Dx1cbsB4u0MmsItaAPSvhACZA==
X-Google-Smtp-Source: AGHT+IF4ZcBCLGm0H7f1mfA8pBWTriSdSA7GAwh/VN23tM6OTJjFMHjWVDl4sdFVN4S774GfNqS5qQ==
X-Received: by 2002:a17:907:9815:b0:ad8:8529:4f9b with SMTP id a640c23a62f3a-adb494e5fe3mr1033669666b.38.1748905400527;
        Mon, 02 Jun 2025 16:03:20 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5e2befaesm876331466b.104.2025.06.02.16.03.19
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 16:03:20 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6021b8b2c5fso9544502a12.2
        for <mm-commits@vger.kernel.org>; Mon, 02 Jun 2025 16:03:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXrmMYzDfWMqX/gKffxYd6q5K4q5SIHpqinE5d3o035l01jVsSVKkAehmr1nneL65eRW17nXRP65ouH@vger.kernel.org
X-Received: by 2002:a05:6402:518a:b0:5ff:f524:90e0 with SMTP id
 4fb4d7f45d1cf-605b751baf6mr9475234a12.11.1748905399615; Mon, 02 Jun 2025
 16:03:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250601151222.60ead71e7d8492a18c711a05@linux-foundation.org> <aD29wnb5zR-afWpM@casper.infradead.org>
In-Reply-To: <aD29wnb5zR-afWpM@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Jun 2025 16:03:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjtk+LLCWt9JLGip+qb2Vksq727V6anKg2gN2Z1npO+GA@mail.gmail.com>
X-Gm-Features: AX0GCFuFKxyTIMjLhDG9GgQUaYyPLSKJxQy9zCek0XFUSfqYyE2N5joutpwyQnw
Message-ID: <CAHk-=wjtk+LLCWt9JLGip+qb2Vksq727V6anKg2gN2Z1npO+GA@mail.gmail.com>
Subject: Re: [GIT PULL] Additional MM updates for 6.16-rc1
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Jun 2025 at 08:05, Matthew Wilcox <willy@infradead.org> wrote:
>
> A word of warning for Linus since he wouldn't've been cc'd on the
> earlier email.  This branch is based on v6.15-rc6 but contains a
> commit which depends on 97dfbbd135cb which was merged during the
> current merge window.  You might want to do a rebase or ask Andrew to
> do it in order to prevent a bisection hazard.

Gah.

If I rebase the thing, I lose the pgp signature.

This is not optimal, but let's hope nobody hits the bisect issue.

            Linus
