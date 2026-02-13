Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0793219301
	for <mm-commits@vger.kernel.org>; Fri, 13 Feb 2026 01:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770947020; cv=none; b=O/pR8nlGoBgqiNCKpjKXCWPMV9z3EcOacNTSPXBorETjUgofscNqqun3xGdK13ym50LXRiOcuI3UcTBfUb3ClbJNK6Dza2xfLtcnCV14Z54zhCHXkDkIR2IW4QhqfyCVaxZtoBW4Q9x/tvEHzlHdZ7WD8EKGG89OZK9rlzmPExY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770947020; c=relaxed/simple;
	bh=pIpsIskbihT4+Ir+w8xZ+aFs2r0DeBuqQH4DTPdT/Gg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m1T1AMRKlCD4rzyK9S4ZQQW3DxdGJZtDjF1WMOs4YuZKeG0kKiqHB/bswMu8sav6eMxzx3zOiRraoi4cjRvliyvkhOwBRJW88zVAyMx/41NlaBMspKDQzgkC7l1hk7IQBusri525royTAAox6TBWSPAAWR+d4O0onInXaWy8aJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pj1u6Fht; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pj1u6Fht"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b883c8dfb00so66860266b.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 17:43:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1770947017; x=1771551817; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yHjmq7oQCnTopIXFLdHO0WCCRKYh0w5rSxJt0mJXwC8=;
        b=Pj1u6Fht6f7fTv2KxRyzUdT3Gt6HXlpwm5JvZM8qYpegDLGu8uJMLPJogDaHVvdClH
         7nx0NO8FLFlJoCDjGAVpFI5Ca8jmmFcIZjkYWa/axma1uWM5Tzqy3BCMJkWYVcw2EEgd
         wG4M2ffz4GWtMpGqNPixQDgvITdOzQmV4IYvM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770947017; x=1771551817;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yHjmq7oQCnTopIXFLdHO0WCCRKYh0w5rSxJt0mJXwC8=;
        b=wtFL5fArzMpqwhbpfiZcmdnhzivqOPf6OSIJ5idw9LTEZ4viNVGBlqDGz67A7PiCZ+
         kqmqmulw7dNmKmzypzP7AimHXoPc0GE9t6lhMVQ0iTIGBGj//Xj83GXKdKVHQ2gOJxqm
         G8z9L0TsT0/n1+9P/80gakNBGsL+7+4EYSo8LOfjhKPACzx5gWKEns09cC4udwr8k4ro
         UjikD5cMGihmRSVn/s4YC/nrfyTjb5jfft2X8eHMYiE9OEyuuYe+oW3Y+x4uIHIoGcKP
         cskIQp0e/bFXJtwmD4DaIIktmHx0NU7X35BEGieAZvXvKDiBG04pR1VCpw19EHi2OMsT
         tfnQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0ThspwIiqE5GxZ7pi7ty/c6jj+c+BCM1viYXIMjfqrxlJrVywOMv4V22iA2dmJ5UeEQhH0GtGh7L4@vger.kernel.org
X-Gm-Message-State: AOJu0YyANV0ARM1OYBTeJcvktmfBHBI5G27xZejaScMQKJPYXDwhpCzQ
	4s+kAEULf8ith7jUmRZG8wNXDbXkFYNjSUmYUS+3K6y7MT2QFHH3NMMV91Nyo3yb/e4m8PTuG7F
	tHG+g4b8=
X-Gm-Gg: AZuq6aIA6NxMy5KItiSn/Z7kkMOkOIhJMkJajOynLQjKM44sqc/I48jcsRzuFAAaOvB
	lLCOSI3koCCS8o0PDdBMGmeTYkMnMb6b1IY7Pcv/CCFbINbuwJzcnpWVi33FLlOm1+pxLv7hIek
	wgw8l9KbUS7aH9ayzH0OMvxcqL1p982EKkCYo1orufusM+EUBLhTsHYtMGKGJhb+UlaNcy+L9V4
	ZxVJb9EmLxKzHr75+x937+ZtTnvxpJbtQeNCq7Yy/N8sz6E0cM2/QXxWJ+xhskTcjSHCmTwEDQH
	pQGBToPwCyJxCp75NnNBjGhoZBbOq8mm2m+cTTfvheY9/ohDZ+iA2mmKOlOtLliHYpdN5R1zExx
	A+NWasqKS9sd4nFV4vpIxiIFmfneQew4eJpXLAfboVZlE9aCnkUzuGv5z6S/Tf6fVzsJFcIgRtV
	TdF4pXMetjt1cFiCXkzyl6or0b/9nKW25nw3abB60eSE75qKX1izqikkH/6f8RS3ERAdoGSKNj1
	QgTJfrBoA==
X-Received: by 2002:a17:906:c144:b0:b8e:12fa:ff2b with SMTP id a640c23a62f3a-b8fb4462fa0mr5754366b.37.1770947016496;
        Thu, 12 Feb 2026 17:43:36 -0800 (PST)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8f6ebd60edsm209820766b.41.2026.02.12.17.43.35
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 17:43:36 -0800 (PST)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65a1b17a99aso720202a12.3
        for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 17:43:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVeguLjNyYW0VtNEJwTpqc/US0xxSDtYeUT0NarKD3dgIh1NI+ItsorpDbmQn8iGUrrRhlXNR3oBN9U@vger.kernel.org
X-Received: by 2002:a05:6402:40cd:b0:658:bab5:57f4 with SMTP id
 4fb4d7f45d1cf-65bb12aafc2mr65432a12.23.1770947015516; Thu, 12 Feb 2026
 17:43:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260211192351.6684a77b8c70cc032a3e7a27@linux-foundation.org>
In-Reply-To: <20260211192351.6684a77b8c70cc032a3e7a27@linux-foundation.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Thu, 12 Feb 2026 17:43:18 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiHK5_oBUdUiNAaevmN9f-ORe+QBqbRefAZaw-RbgEn3w@mail.gmail.com>
X-Gm-Features: AZwV_Qhnyci3h7J2gOjPBK9e5nycSau58MfyE6OpHA3pFmGCllIyDj5q3lOfKbM
Message-ID: <CAHk-=wiHK5_oBUdUiNAaevmN9f-ORe+QBqbRefAZaw-RbgEn3w@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 7.0-rc1
To: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Bah, I keep noticing these things too late, and have to fix them up
separately, but let's keep edumacating people about this issue...

On Wed, 11 Feb 2026 at 19:23, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Lorenzo Stoakes (20):
>       selftests/mm: remove virtual_address_range test

When removing rules for generating files, PLEASE DO NOT REMOVE THE
.gitignore ENTRY!

Removing the rule for generating the file does not magically then make
the file itself disappear in a purple puff of smoke.

That's just not how reality works. The past still exists.

And that means that the old generated file still exists for people,
and it has *NOT* suddenly become so supremely interesting that people
should no longer ignore it.

So when you remove a rule for generating a file (or you move it to a
different directory, or rename it, or whatever), that gitignore entry
for the old file - or old location - should stay around.

This is more than a "keep git status happy" issue. This has caused
real issues in the past, where careless developers didn't notice, and
mistakenly added stale generated binaries to their commits.

No, people shouldn't do that either, and it's a sign of being too
careless and not looking at what you commit very carefully.

But mistakes happen, and the other side of that argument is that we
sure as heck shouldn't have files suddenly appear in the source tree
because they aren't properly ignored any more.

And I'm sure this has happened many times without me noticing, but
I'll keep harping on this when I _do_ notice, because people need to
realize that .gitignore files are very much about state being left
around by the build system.

So you *add* files to the .gitignore files, but you don't remove them.
Not for a long while, at least - people keep their build trees around
for months (or years) and don't necessarily clean them up very often.

(And yes, we do have a "remove-stale-files" script that is intended to
deal with some of this, but it hasn't worked very well, and if you
want to remove stale files I'd suggest you just do "git clean -dqtx"
after you are really *really* sure that you don't have any interesting
files in your source tree that weren't tracked by git)

              Linus
