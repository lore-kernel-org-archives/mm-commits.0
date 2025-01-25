Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7003F20551E
	for <mm-commits@vger.kernel.org>; Sat, 25 Jan 2025 22:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737842978; cv=none; b=G8YmRAOUwaMr+WjjNXNuWW2jI8zeYbK2nHgwV2kZTXECK5a5HG9VatBdS2yQ2PMOVTiF551hpBXXBTlmtNtzdOw6u9tRRw9SlE5NTx9YQCFNKsn08AbxAW0wHpMAlbbnZ1zye0hD4BkHYDupJGXH6L2VN7dP3d+NHeD5oSHWgCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737842978; c=relaxed/simple;
	bh=E4e3Oq0pvFr8pCPFeOhvQY05+4aosSGMyLU7VMzUoMw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wnu/yOW6GRAhi5A7A6BmtH/sgDufxEmHxdPTVkQV1ziA3vHZh+DtePs7TVMRDBcmxtVUOaGVyDv68rcDsX1FO/V5o8jAXtdw3NPlg2j2tyaPPIcS8vkAldRKZLVP34X9HObFjxaGE6vosecbNbBrQIlBET1Jb5iDUpu0naO397o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LFOxi4eu; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LFOxi4eu"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ab651f1dd36so628340866b.0
        for <mm-commits@vger.kernel.org>; Sat, 25 Jan 2025 14:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1737842974; x=1738447774; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u3XUNfoDvfeXXLrtZ6h3wKrEUjnmzztfw8Nesk75FwA=;
        b=LFOxi4eudYj1i9ar4tyUwpZvaXbIHGvQzhcuzwNZ5ejBcEvaRFI4ufJHACg9RqwftD
         XrPNYGxIQc0vBkky3vnCTXH0EeqtLD5G58nqUM7SZGJD6560Iw3u7JW5Pk5HbTqCSibi
         zbN2J9eBmkDM+6dEVPO5DMILpO7xa0oi2jAJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737842974; x=1738447774;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u3XUNfoDvfeXXLrtZ6h3wKrEUjnmzztfw8Nesk75FwA=;
        b=jEkJHkF4njA5m1WeTAyeBzjRokpMIhEiZ3YfHKY2JXI6JLMn8lp6YecKQA6nUf6znF
         uiiS50Xb0Yd/O11nN4poq97HGoX/au8sHwbVTFZaLPPzK0fXHiUOW0Ur5ArpB2wCwjbA
         vx0gk4KuGgkMN3jvHb0WTx2KiBppvI5Osh3UtGSS6JsDMzglgT2vcwyrsDg4Zcm+RwOB
         Aew0E+rHWmLF6R/eKdMlWUX5UPXz5QB15g0Kp+9Dl7AvM/LecB3hKeJWpiuptOEV4wQ+
         LT9Yo6QGGeRiIWTW833JXSWeR1oYPN+tdfuO6Rvqg4arfVR4Guvm50lNFy1nVQnWUmBr
         6d5g==
X-Forwarded-Encrypted: i=1; AJvYcCUplC7NQOTiWBI5HWles3KOdK0GLdwpIqETkjYavtns7ckC2wYtvHM4AyR6S5x5BHzG6s4ymDrIsOQE@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6HU3P+RFW92eNgP0N1ri2TRRFlXj113yMpg8+z0Nl2nB3yugu
	GRGppfOCikIgpdPcP+HmLqq1AR66C8VBG/xT1UwBhP1/s9O0nB2HrMzeOHVxgkmu8C3X9C3qXnN
	FeOQ=
X-Gm-Gg: ASbGnctSDYfvBKCT3Sw+lLKR30yUhh/ZOL7ZvHojnCPIbIj9qraS54GRViJnDzgVDLm
	FmTsSQJLVjoCU4H418P/0MyjquhMB0q6zMesWn4B76NJ4uAvAsks0DvJZh4Mi81e4Ylb/FiPLx+
	fFD/8hucmmNNIIP1vsgtQXDqppkJSSw9sN7Ak42gDCWB6KKB6wch9dyAlc8f5VhsKBON+3aHg3z
	BsMk7t2XvKP6HIzWtqBH4oFmZmzm3hUwYhGvhxF8C/ALYqazbkDg5HISMY8vVdwfweTquC9Rsix
	5FAzwF0Ku64LUUVxf3fD59ILWP+RZWKTlXYZIu6hyf8BLgTAbh7yFdo=
X-Google-Smtp-Source: AGHT+IHhkU2pd+lxahIaC1cMPFRyMnYmOxgSAXw1K4mn064vciGZk3behxBcFM4+thAl5sYL+bTuaQ==
X-Received: by 2002:a17:906:6a26:b0:aa6:873b:ed8a with SMTP id a640c23a62f3a-ab38b4aa1aemr2932548566b.47.1737842974391;
        Sat, 25 Jan 2025 14:09:34 -0800 (PST)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab694d05370sm84762166b.181.2025.01.25.14.09.32
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2025 14:09:33 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5dc149e14fcso4401885a12.2
        for <mm-commits@vger.kernel.org>; Sat, 25 Jan 2025 14:09:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXWf69UVDJengr7Kij7Dd0oJi/VPgMgPkS/J5OEdgKRS6VH0vo8t0MLB8CZBEd2syYeCHvVyAu/hQWo@vger.kernel.org
X-Received: by 2002:a05:6402:5209:b0:5db:f26d:fff8 with SMTP id
 4fb4d7f45d1cf-5dbf26e0139mr14729546a12.22.1737842972337; Sat, 25 Jan 2025
 14:09:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124162248.60104eec848619a187242392@linux-foundation.org>
In-Reply-To: <20250124162248.60104eec848619a187242392@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Jan 2025 14:09:16 -0800
X-Gmail-Original-Message-ID: <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
X-Gm-Features: AWEUYZn2PUxTtvEnXoKDwoOWwRzxy-y46wZW5dX8swsgm-4Dr4NisU3beoeOciI
Message-ID: <CAHk-=whddBhfi5DUi370W3pYs+z3r2E7KYuHjwR=a1eRig5Gxg@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.14-rc1
To: Andrew Morton <akpm@linux-foundation.org>, Uros Bizjak <ubizjak@gmail.com>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 24 Jan 2025 at 16:22, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Linus, please merge the MM updates for the 6.14 development cycle,

This does not build at all for me.

I get

    ./arch/x86/include/asm/current.h:49:9: error: call to undeclared
function '__typeof_unqual__'; ISO C99 and later do not support
implicit function declarations [-Wimplicit-function-declaration]

when running the Rust 'bindgen', and what seems to be going on is that
my version of *gcc* does support __typeof_unqual__, so I end up with

    CONFIG_CC_HAS_TYPEOF_UNQUAL=y

in my kernel config, but I think that 'bindgen' that generates the
Rust bindings is based on LLVM, and clearly does not understand
__typeof_unqual__.

I have bindgen 0.69.5 (plain F40 install), in case somebody wants to test.

Apparently few people test linux-next with Rust enabled, and the
reports that I find on lkml were ignored.

I do see reports of this failure on lkml from mid-December, so it's
not like I'm the first person ever to see this.

Anyway, pulled and then unpulled again.

             Linus
