Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A269E3612F4
	for <mm-commits@vger.kernel.org>; Fri, 13 Mar 2026 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773417307; cv=none; b=NGxR4p/SeTzwqRtPSNTD1YUF67p1FPWy9gd4JZCemeu6M5+lUc84WVtdQSi16/kX1X5qPQFYAtnqAqB+lgoPqu8S5bb91GxfeP4BnI0Fr5IN1CYx28zBwtGzCK6ps/iJz91lKLXsSiDbZ5OvzkN4ZfRTrRz+Cr7FjyoRKtDN+sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773417307; c=relaxed/simple;
	bh=cp32tPD7fA8pRZuoWQCoy2UJgl0jI6GFO6+VjGdEd/g=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=Q1+7hOyfyJFceaa+afPVviR/T27eTJBBzeAOYR4gxJ8p2sRbF/TRdlFlRlwZa26Wqt+/MDuNikFV5u1jjJiamtb8dapsdcwfHrVfZlFOPxAZF3jp0AmaF8CT6YPg0GgvijyH5XgmzRXypyD/ev9Yn2znwV0cUDmE6sHXJoxnwZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QSr/FZku; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QSr/FZku"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-439bcec8613so1895241f8f.3
        for <mm-commits@vger.kernel.org>; Fri, 13 Mar 2026 08:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773417303; x=1774022103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cp32tPD7fA8pRZuoWQCoy2UJgl0jI6GFO6+VjGdEd/g=;
        b=QSr/FZkuwj+SXJx38sZNmrLACHxV2OUU6HK0Ib5T5MUNHTECqOcRbG9e4w/Uju+VZl
         mOFSchb+UENkH/mqGWw3J10KJ9GgWBSc3RgloSQ5zyD7S44LcfSPbkWX+LMg6XppSNTt
         9eAbsrX9B914UE3eRVq2YxTsT5Kb0+SdWM6DX5yvJaVwR/jlUO0uTndb1S7LIbjA3r+5
         pXeHVHC17ojm2CqlwAjnP8sYoQrzThgFi9MpPYH7CFVWQMnTUPo3cP2w5P0pGCqQI29p
         1lGYFN4OeDq5muHu/e9swmXcHs5xEKAzuOPN/MlwJVyuw/p8UH0frgc7Ul8VJRuMAF7T
         x0Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773417303; x=1774022103;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cp32tPD7fA8pRZuoWQCoy2UJgl0jI6GFO6+VjGdEd/g=;
        b=crlZQzkYELMNGHb+Ia6HQD8hrZgLLDEHY5TacbpC3Nb/n1KIQnhPNhrY1jYutp8pXq
         GtNw3a9V+4PICTByKCFK62yW0jklfPos9VAJotBW7F/KqTtFO1DHCOaOuG2w6Ao7jD1L
         B0YS33QQIgBlJmmmMcUculJMRURUjQ3SXt1W4nuSDiDCH9iwmqsajEZ17X0PaFjZz5Mu
         um9jMrW8grtb5gFnt+B3v/0NRnbesXJUwVVZdqIKjHSIvH4TUSmAEmS5nuQe7d9FMwZ6
         zXzCgDHoDV48A7KvWjjy8Z2Pk07bvJesBvifrUUmzmtsNe2ktOYhyjgjNmG0BmNyyXU+
         jNIw==
X-Forwarded-Encrypted: i=1; AJvYcCWuXQKKsXf9bZfGqd9uXH39/3sa6rnGoG2qMynvMgjFy1ijoqtjQrdFlyUeir0wTZ1opprZgFxLW0Ew@vger.kernel.org
X-Gm-Message-State: AOJu0YyfysgnNyGYWSQJEj70ikR4vjtEqC3xkePkvwhkVPSJ2UcRLQMK
	INm7ww+moyXcFWdAJa1mqXWmO8fgTtM58f0BhpyNKBuX4HH7Cxu6iBVS
X-Gm-Gg: ATEYQzyNQ/E4VsK1xyhJnwCO+nIjWAF2+v7GQpb5iEmtWcti/UuCA2RO04OExu6r4Ws
	5+zgBTPhscWwd0zZPdCWRpjeguy2PhxG3lXo8hsVCCgjBk2lfWIn6EaXf5a+Zff1MnVI2mvx4vw
	16nSefQf0QPn1E9+QXKz+L8ewnoJVxP7qWL+0mg89eSPuyqb137aL4pcUQXsGpjm78mxMKPlIAB
	tkRxkLKFRC6mR3aWPqhPLwg9ZiX588ckRqK2/yq0B36nUOfB3PjVgP1bDP154Tjxcsg0RVmJfzb
	ce2smj6GLME/FDd9TJIkHzZOnFuFpKHMk5tSozIcWXh+OrtEtsYO9P+ltBbyYEW3MZ/zaQ7fTW0
	mEUAY9TcbAI1MQlGEBji1mPAW/yJNbP4Nje4kSSPvpZS+g9R020KhgmDAdOVI1QEUGj/6KaF2nw
	he3GIrjr+HKYuqjIVKovQvuCc8iQ==
X-Received: by 2002:a05:600c:8489:b0:485:4552:8fbb with SMTP id 5b1f17b1804b1-485566fab29mr62390785e9.22.1773417302290;
        Fri, 13 Mar 2026 08:55:02 -0700 (PDT)
Received: from ?IPv6:::1? ([2a00:23ee:2968:8e13:3055:679d:b1a9:b589])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541b6f6e6sm562531455e9.10.2026.03.13.08.55.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 08:55:02 -0700 (PDT)
Date: Fri, 13 Mar 2026 15:54:59 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Vlastimil Babka <vbabka@suse.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Josh Law <objecting@objecting.org>,
	mm-commits@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <3f572c65-3381-4e99-9e2c-fb36fd7a85f1@gmail.com>
In-Reply-To: <20260313155253.GD1742010@frogsfrogsfrogs>
References: <20260307221931.2848601-1-objecting@objecting.org> <3cd25de5-3737-49f4-aa8b-eaaee471af50@lucifer.local> <ee644e1b-5759-477f-8aec-35c91a5a938e@suse.com> <20260307222154.2848660-1-objecting@objecting.org> <667b75ad-bce9-4997-8ebf-8077952c2797@gmail.com> <20260313-anvisiert-gemeckert-352414e3d58d@brauner> <20260313-halskette-annahme-94e782eb4ae4@brauner> <20260313155253.GD1742010@frogsfrogsfrogs>
Subject: Re: [PATCH] MAINTAINERS: add Josh Law as reviewer for library code
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <3f572c65-3381-4e99-9e2c-fb36fd7a85f1@gmail.com>

13 Mar 2026 15:52:54 Darrick J. Wong <djwong@kernel.org>:

> On Fri, Mar 13, 2026 at 04:33:49PM +0100, Christian Brauner wrote:
>> On Fri, Mar 13, 2026 at 04:00:38PM +0100, Christian Brauner wrote:
>>> On Sat, Mar 07, 2026 at 10:19:31PM +0000, Josh Law wrote:
>>>> Add myself as a designated reviewer for the library code to help revie=
w
>>>> incoming patches and improvements.
>>>>
>>>> Signed-off-by: Josh Law <objecting@objecting.org>
>>>> ---
>>>> MAINTAINERS | 1 +
>>>> 1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>> index 96e97d25e1c2..8fd03ab9c657 100644
>>>> --- a/MAINTAINERS
>>>> +++ b/MAINTAINERS
>>>> @@ -14613,6 +14613,7 @@ F:=C2=A0 tools/testing/nvdimm/
>>>>
>>>> LIBRARY CODE
>>>> M: Andrew Morton <akpm@linux-foundation.org>
>>>> +R: Josh Law <objecting@objecting.org>
>>>> L: linux-kernel@vger.kernel.org
>>>> S: Supported
>>>> T: git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-no=
nmm-unstable
>>>> --
>>>> 2.43.0
>>>>
>>>
>>> On Fri, Mar 13, 2026 at 10:17:53AM +0000, Lorenzo Stoakes (Oracle) wrot=
e:
>>>> On Sat, Mar 07, 2026 at 10:19:31PM +0000, Josh Law wrote:
>>>>> Add myself as a designated reviewer for the library code to help revi=
ew
>>>>> incoming patches and improvements.
>>>>>
>>>>> Signed-off-by: Josh Law <objecting@objecting.org>
>>>>
>>>> Sorry but NAK, I appreciate your enthusiasm but this is literally _all=
_
>>>> library code, and you don't have a long track history in the kernel.
>>>>
>>>> Also in [0], [1], etc. you aren't demonstrating a great deal of maturi=
ty,
>>>> so I don't think it's appropriate for you to be added at this time.
>>>>
>>>> I really don't think a 'catch all' category should be getting arbitrar=
y
>>>> extra reviewers in any case.
>>>>
>>>> Please take some time to contribute to the kernel, establish yourself,=
 and
>>>> then look to reviewership for a specific category.
>>>>
>>>> Thanks, Lorenzo
>>>>
>>>>> ---
>>>>> MAINTAINERS | 1 +
>>>>> 1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>>>> index 96e97d25e1c2..8fd03ab9c657 100644
>>>>> --- a/MAINTAINERS
>>>>> +++ b/MAINTAINERS
>>>>> @@ -14613,6 +14613,7 @@ F:=C2=A0 tools/testing/nvdimm/
>>>>>
>>>>> LIBRARY CODE
>>>>> M: Andrew Morton <akpm@linux-foundation.org>
>>>>> +R: Josh Law <objecting@objecting.org>
>>>>> L: linux-kernel@vger.kernel.org
>>>>> S: Supported
>>>>> T: git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-n=
onmm-unstable
>>>>> --
>>>>> 2.43.0
>>>>>
>>>>>
>>>>
>>>> [0]:https://lore.kernel.org/all/c41dbb9d-b8a5-4b5f-9f71-3fe1bed210b6@g=
mail.com/
>>>> [1]:https://lore.kernel.org/linux-mm/40767ecf-7e25-48f5-a604-c43b835b6=
b66@gmail.com/
>>>
>>> On Fri, Mar 13, 2026 at 11:49:03AM +0100, Vlastimil Babka wrote:
>>>> On 3/13/26 11:17, Lorenzo Stoakes (Oracle) wrote:
>>>>> On Sat, Mar 07, 2026 at 10:19:31PM +0000, Josh Law wrote:
>>>>>> =E2=80=A6
>>>>>
>>>>> Sorry but NAK, I appreciate your enthusiasm but this is literally _al=
l_
>>>>> library code, and you don't have a long track history in the kernel.
>>>>
>>>> Agreed, just a week after first appearance on lists is really quite to=
o soon.
>>>>
>>>> Yes, getting Cc'd thanks to R: entry is one thing, but that can be ach=
ieved
>>>> with lei as well. The other aspect of R: is giving weigh in replies to
>>>> (potentially new) contributors and that's why it's not given out rathe=
r that
>>>> quickly.
>>>>
>>>>> Also in [0], [1], etc. you aren't demonstrating a great deal of matur=
ity,
>>>>> so I don't think it's appropriate for you to be added at this time.
>>>>>
>>>>> I really don't think a 'catch all' category should be getting arbitra=
ry
>>>>> extra reviewers in any case.
>>>>
>>>> Agreed. Many of the files under lib/ are listed in other sections with=
 their
>>>> own maintainers. They were not cc'd on this MAINTAINERS update and yet=
 it
>>>> would affect all patches to their files too, so they could at least ha=
ve a
>>>> say. It's unfortunate that it's how this catch-all works. Maybe X: ent=
ries
>>>> could be used by the specific maintainers in the catch-all section, al=
though
>>>> it's somewhat tedious.
>>>
>>> Agreed. I'm sorry but there is no meaningful track record that would
>>> justify this addition. lib/ encompasses locking.c, iov_iter.c,
>>> rhashtable.c and a ton of other stuff that is consumed by literally the
>>> whole kernel from core to drivers. If this was something innocous I
>>> wouldn't care but there's a lot of really gnarly but important stuff in
>>> there.
>>>
>>> And yes, all of the externally maintained files should be dropped from
>>> the generic lib/ catch-all ideally.
>>
>> Ok, so let's look at this for a minute:
>>
>> - first patch Feb 28 under pseudonym "techyguyperplexable", switched to =
"Josh Law" only when Andrew required a real name
>> =C2=A0 in https://lore.kernel.org/all/20260228114939.de7d44de38d907a9b66=
32480@linux-foundation.org
>> - 142+ emails in ~2 weeks =E2=80=94 37 patches in a single day (Mar 1)
>> - All trivial/cosmetic =E2=80=94 SPDX headers, comment grammar, spacing,=
 const qualifiers. Zero bug fixes, zero new functionality
>> - Carpet-bombed multiple subsystems =E2=80=94 lib/, arm64/, staging/, in=
put/, etc.
>> - within 1 week of first-ever patch, submitted MAINTAINERS: add Josh Law=
 as reviewer for library code covering all of lib/ (locking.c, iov_iter.c, =
rhashtable.c, etc.)
>> - Email identity mismatch =E2=80=94 From: hlcj1234567@gmail.com, Signed-=
off-by: objecting@objecting.org
>> - Formatting problems =E2=80=94 top-posting, line length violations, pat=
ches not applying cleanly
>>
>> So I mean, one week to Reviewer. Even if we're being very generous here,
>> we need to do a lot more due diligence going forward. We can't just hand
>> out core components like this and risking our reputation and security
>> posture.
>
> /me sees "Lmao you and your test cases" in [1] and responds with "LMAO
> NAK".=C2=A0 If you're not serious about helping everyone to test your cha=
nges
> to library code such that you respond that dismissively to longtime
> maintainers, you shouldn't be working on operating system kernels.
>
> --D

I apologize unreservedly to the maintainers and the community. The
comment I made was incredibly disrespectful and immature. I realize now tha=
t
testing is foundational to kernel development, especially in library
code, and my dismissive response was a massive failure on my part.

I have a lot to learn about the technical requirements of the kernel,
but clearly, I have even more to learn about the professional
standards of this community. I accept the NAK and will step back to
re-evaluate my approach and conduct. I am sorry for wasting your time.


V/R


Josh Law
