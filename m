Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CAE4431
	for <mm-commits@vger.kernel.org>; Mon, 22 Jul 2024 01:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721610780; cv=none; b=li8TzftE02wT764CoICQkamH3OuiUNOfw+I5fmKiFouDLmEwzYW8+DBVqgmVzgCtViEpIbjjK+wuIWjQnmwW5535HcXHzu5kz1UCs3c8htqqFBn200QoiJvkeU5v3o5xdlhyHJbYMZFKpNtEPL/2xnnHWKDV9pd19huWg4SRyqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721610780; c=relaxed/simple;
	bh=tCut4qU1NxMAK76eXQVTCNfTH1sNoI1sNersotmkaRw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KobE/13GocPBbyiOfoSYj7I2IodBgDcroESLb46UdFAm2jw5zAFL9VUpolsA7eNPQcCVp6nIlz5E3zn87pCit5LOLbSgspr0ORWvHA+v52JEOKFsqj6p+sxobX5X4TMevPF8bTikTMp1D7aOs55Wm9jkQnPf0cDRquJu6LG3wno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FJPyLwj4; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FJPyLwj4"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a797c62565aso339171566b.2
        for <mm-commits@vger.kernel.org>; Sun, 21 Jul 2024 18:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1721610776; x=1722215576; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4Ks9M3kzBCPwupF4DA1Vj4pSXzb7G5/N05vKszYZASg=;
        b=FJPyLwj4eMDqwmkaHhAuakN4wy2eXVRtHyWEQBokWl+jQN1PcLIswz3oiMfymnOXeI
         PhfDe615UVnO6FNQEtnwLpnVcP9JxozOKlcviup1RFqrhN3wDA5+UkDzz+GRZE6Va6Bq
         xO8b8W3vf7SEOp7uYczOFVXe1E+UOthwyEnWM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721610776; x=1722215576;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Ks9M3kzBCPwupF4DA1Vj4pSXzb7G5/N05vKszYZASg=;
        b=fq75WjC7WAIHseB4DKova+7NF7fR6EWt7oZd1SJLu3yKEC9NzSP4O1MJghiBxwzE5N
         1CJmV2hA7+QFfxQer3o/UfHh7Ux37PFtuk6Hmb92KgQCsqRl/1mOK5RcqmuOq18AtEPV
         mj0gSW+GZVJn2PdluI8YwbcqcIYbB58/UXqHYbJyYtDEU99Lc43EY0GmAJ9zv3Q90QQG
         jQUNPy4Uq96efyylB4Y2airTP+iNgOvLN5XhAQOxB1R8rDk9zlZ0b9NckXsQgSOG09LE
         8knFh091txvk5PP4OC66JuPfH49I3C0LHf5blKcCDTizPRiRZE0FkuuQGZ5Bt8G7/4/V
         +64Q==
X-Forwarded-Encrypted: i=1; AJvYcCXogEC6QSdCaB/PHqsiw16UqbhI4DSXvdLdI6sz0my9k1+ubRhmUZxpZvgPPQ1CwcGngV7r9HC0sk7J9/qbN5Uw6UB/1KYV8cJ76w==
X-Gm-Message-State: AOJu0Yx4z8DIMuyXcdd6w6aBrrpPP1V0LhInRARz/vtSDX+L8OSUN+7V
	dvQA8x7JRaCpefY4RjrkR4wGah1qKpeAj6nWip7Dn81UJrwakEyxiLcTvlI1V1MYoaUrAHymOBM
	OizQ=
X-Google-Smtp-Source: AGHT+IF8l3hbSKpK4p6DjrkzAvAPso9ODAenfUCJiveR+/2uWYShTgMlthc5kp0tPMjLY1T+wojclQ==
X-Received: by 2002:a17:906:7145:b0:a72:744e:6703 with SMTP id a640c23a62f3a-a7a0114675amr903242966b.22.1721610776005;
        Sun, 21 Jul 2024 18:12:56 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7a3c922d15sm355608966b.168.2024.07.21.18.12.54
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jul 2024 18:12:55 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5a20de39cfbso2796764a12.1
        for <mm-commits@vger.kernel.org>; Sun, 21 Jul 2024 18:12:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWgpXSPu6OMCPV9dVXIm1TR3RWjtbv58dbnRNLIrm7HFYtK2XCN4f89Nd+PFPXzkM5d8B8UmlLtozvHhRsFSFSSEmq0NveDhl+XkA==
X-Received: by 2002:a05:6402:2114:b0:5a1:ef24:e9dc with SMTP id
 4fb4d7f45d1cf-5a3ebea7d26mr4934512a12.0.1721610774619; Sun, 21 Jul 2024
 18:12:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240721151013.b9b331ce79f5f60c54c69636@linux-foundation.org>
In-Reply-To: <20240721151013.b9b331ce79f5f60c54c69636@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 21 Jul 2024 18:12:37 -0700
X-Gmail-Original-Message-ID: <CAHk-=whqXizOqcpcrqvRJ88Twi4+o=G1Y=5qsLBs5R-8uHjs+Q@mail.gmail.com>
Message-ID: <CAHk-=whqXizOqcpcrqvRJ88Twi4+o=G1Y=5qsLBs5R-8uHjs+Q@mail.gmail.com>
Subject: Re: [GIT PULL] non-MM updates for 6.11-rc1
To: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 21 Jul 2024 at 15:10, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> - In the series "treewide: Refactor heap related implementation",
>   Kuan-Wei Chiu has significantly reworked the min_heap library code and
>   has taught bcachefs to use the new more generic implementation.

Bah. I think the users should probably have been converted in their
own trees, instead of having this thing that caused a somewhat nasty
conflict.

I think I sorted it out correctly, but I'm not seeing why the bcachefs
conversion was done outside the bcachefs tree.

(Ok, it's not like the conflict was all that nasty, really. It's more
that conflicts in this _kind_ of code is a bit nasty).

As it is, I do see the Ack from Kent, but I'm going to ask him to also
double-check my merge.

I see what happened in linux-next, but that state also seems different
from my tree (at a minimum, Kent also moved the tiemr_lock around a
bit too).

Anyway.. The conflict resolution looks sane to me and doesn't seem
fundamentally complex, but (a) mistakes happen and (b) it does seem
like this whole heap conversion could have happened in the bcachefs
tree.

Kent, mind checking that I didn't do something horribly horribly bad?

              Linus
