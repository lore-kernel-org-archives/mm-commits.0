Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED0E38F227
	for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 20:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347868; cv=none; b=bM8EulCmDyQZvwWsbjEAnscw4GW/ONy5W0KTZYzKcD3bk6eqo8Vb6Qn/DYJ5pvuUVxIF++1EY8i541/KFfhT+sMOWobsxUB0+hGYqAIWIodusrw1SXB3RSR0d23+dKlGfy0CJDJyiWx1JXygADfB0BLsUKQ0acHN5dxrzMp7Q2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347868; c=relaxed/simple;
	bh=fDDfR0P4VXzc/vzXypAj9VdzfZghK6Rv749RX1dViz0=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=LovR6OHX6vg3kVzvF2a5N7JAfzxZo+T+o6ya3k4ruNLYV+yc+pT4Bq2mYj8880vZ/jNrwfpE3oDgaKes2pPrz242NncouarIUyXtmmrcHBzxPwo5gxlZ+UXQZ19tqMPaMSH2wlgRZ6hOd+TZLGk0W9JIwjTQPohg/DiESN0VxlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L9lHkpHV; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L9lHkpHV"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48534e9076fso12526935e9.0
        for <mm-commits@vger.kernel.org>; Thu, 12 Mar 2026 13:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773347865; x=1773952665; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDDfR0P4VXzc/vzXypAj9VdzfZghK6Rv749RX1dViz0=;
        b=L9lHkpHVMjubV8+dxMofOSV0xryqiq2RaDVfJxGX0BpFw40Y0fQuWkO6UElBLKQeMV
         8Ra/eH0dgkjFtrjYEO+nu71WXGcCdIItoMQwEk8XYzGUvutfAkKVBOnkFPrzZz/7GWxw
         v9KPkU3Poffkz982m9OB8MV2MawYR1iKqQe+XO3G+8BMoUjDSDGPjFekMsSiAshY6W/2
         +W613SmnSbQQzq0OOm/Ni4/zHgNIYfHhY8NixoY5sW9n25BeRBm2Nrevlvam7fhuyjLQ
         YlYQIVEfuGucGOBFS9+LbUBkRcv9Qk4CbhQOYIvi4nyvhbRqGtWQgCKJM+kwD9rsS3c7
         RaBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773347865; x=1773952665;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fDDfR0P4VXzc/vzXypAj9VdzfZghK6Rv749RX1dViz0=;
        b=swaLRRn8IzgKLQH3hAY44vQCkzzFHmiXvberea1dm4g7g8UshvU1nvxaA1RPbqetC/
         wXgzFH4AojsCPWN2uz7vtxE1EHbzYFiiluFL5IrBV/sctcxGIbCcYzY9Q4Q6OtXZOPt8
         udr+2FCMVnJgtWTGXGwAM1ImA8+26AbfYoiyjCGIZc59IyFYbFAa0Fr2m2buJyrgk4SB
         lB9rVSr5vIhQLJ4H8Ni7QJ9pgvcPibHIlRmCLKDZCBXbHRhD7n0lZ/eVS+MsvKo7o4ub
         PjPSbp24/kSFYkaigkXHPCaFwF/vfzbRfQQ5WzlYjwmU1H3VVhGntGV9/xba4hXFedCv
         +KnQ==
X-Gm-Message-State: AOJu0YylMOWvjeVIC4Ya4VM1+47/RJMAKrR4wmEzVHVWD5faYWDK6Bum
	MEBkwnjVGTB16Nmz39bare+4qFywrU4sbhiFrl5boT1S4wGOalMrBdfH
X-Gm-Gg: ATEYQzwJ5ZbZTnce8CzLu5kXsZmDpJycwVVAkfXo5d7Uaht07htgxRGuAbMq4kUtXV8
	apeUY1CAQ3FBJG8nLJPXqWXmLR8Xc++1gASjkIAi35aPp+RSvHhDRvJA/o7TFaX+WAQFB8lfREH
	bOJhf3x2OXoMj58vahGQw3wb/DYJKsSsEit1c0iVqkRZg3D35mke+8Pd0PjvekIDLle1EPmTUOX
	DKBKUOO2Uo5wUq3nRHFnbbN01t/wJ3rAJL7mpErPTL+gWcCZrm06uEGZxwyKfwOpWyjhOxLWRLj
	mlQFUmmlyA5u1qipMBgmOB/bjm+1jQE5eX0SsqE1rrVZvFrd3Fin26LgPbLLZOjWgMDKb7YcFFI
	8MOL5pY/iqlfY4/3kzso2sxirhZUE38XADLauVukrFu8M6rEjNr+qBQuJL4joMbvsP+VdMCRhey
	oEytv+9ScvO6KxhKQL
X-Received: by 2002:a05:600c:4e08:b0:485:2f4a:6ae6 with SMTP id 5b1f17b1804b1-485566cdc39mr10929195e9.6.1773347864986;
        Thu, 12 Mar 2026 13:37:44 -0700 (PDT)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe2187aasm9951078f8f.30.2026.03.12.13.37.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 13:37:44 -0700 (PDT)
Date: Thu, 12 Mar 2026 20:37:45 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, mhiramat@kernel.org, objecting@objecting.org
Message-ID: <d17e794e-7f49-4100-b532-adfa3158cfce@gmail.com>
In-Reply-To: <7a082e98-d66d-49e8-ad32-d3066e47012f@gmail.com>
References: <20260312201919.95880C4CEF7@smtp.kernel.org> <7a082e98-d66d-49e8-ad32-d3066e47012f@gmail.com>
Subject: Re: +
 lib-bootconfig-check-bounds-before-writing-in-__xbc_open_brace.patch added
 to mm-nonmm-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <d17e794e-7f49-4100-b532-adfa3158cfce@gmail.com>

12 Mar 2026 20:21:56 Josh Law <hlcj1234567@gmail.com>:

> 12 Mar 2026 20:19:23 Andrew Morton <akpm@linux-foundation.org>:
>
>>
>> The patch titled
>> =C2=A0=C2=A0=C2=A0=C2=A0 Subject: lib/bootconfig: check bounds before wr=
iting in __xbc_open_brace()
>> has been added to the -mm mm-nonmm-unstable branch.=C2=A0 Its filename i=
s
>> =C2=A0=C2=A0=C2=A0=C2=A0 lib-bootconfig-check-bounds-before-writing-in-_=
_xbc_open_brace.patch
>>
>> This patch will shortly appear at
>> =C2=A0=C2=A0=C2=A0=C2=A0 https://git.kernel.org/pub/scm/linux/kernel/git=
/akpm/25-new.git/tree/patches/lib-bootconfig-check-bounds-before-writing-in=
-__xbc_open_brace.patch
>>
>> This patch will later appear in the mm-nonmm-unstable branch at
>> =C2=A0=C2=A0=C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>
>> Before you just go and hit "reply", please:
>> =C2=A0=C2=A0 a) Consider who else should be cc'ed
>> =C2=A0=C2=A0 b) Prefer to cc a suitable mailing list as well
>> =C2=A0=C2=A0 c) Ideally: find the original patch on the mailing list and=
 do a
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reply-to-all to that, adding suitable add=
itional cc's
>>
>> *** Remember to use Documentation/process/submit-checklist.rst when test=
ing your code ***
>>
>> The -mm tree is included into linux-next via various
>> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>> and is updated there most days
>>
>> ------------------------------------------------------
>> From: Josh Law <objecting@objecting.org>
>> Subject: lib/bootconfig: check bounds before writing in __xbc_open_brace=
()
>> Date: Thu, 12 Mar 2026 19:11:42 +0000
>>
>> The bounds check for brace_index happens after the array write.=C2=A0 Wh=
ile the
>> current call pattern prevents an actual out-of-bounds access (the previo=
us
>> call would have returned an error), the write-before-check pattern is
>> fragile and would become a real out-of-bounds write if the error return
>> were ever not propagated.
>>
>> Move the bounds check before the array write so the function is
>> self-contained and safe regardless of caller behavior.
>>
>> Link: https://lkml.kernel.org/r/20260312191143.28719-3-objecting@objecti=
ng.org
>> Signed-off-by: Josh Law <objecting@objecting.org>
>> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Masami Hiramatsu <mhiramat@kernel.org>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>> lib/bootconfig.c |=C2=A0=C2=A0=C2=A0 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- a/lib/bootconfig.c~lib-bootconfig-check-bounds-before-writing-in-__x=
bc_open_brace
>> +++ a/lib/bootconfig.c
>> @@ -532,9 +532,9 @@ static char *skip_spaces_until_newline(c
>> static int __init __xbc_open_brace(char *p)
>> {
>> =C2=A0=C2=A0=C2=A0 /* Push the last key as open brace */
>> -=C2=A0=C2=A0 open_brace[brace_index++] =3D xbc_node_index(last_parent);
>> =C2=A0=C2=A0=C2=A0 if (brace_index >=3D XBC_DEPTH_MAX)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return xbc_parse_error("Excee=
d max depth of braces", p);
>> +=C2=A0=C2=A0 open_brace[brace_index++] =3D xbc_node_index(last_parent);
>>
>> =C2=A0=C2=A0=C2=A0 return 0;
>> }
>> _
>>
>> Patches currently in -mm which might be from objecting@objecting.org are
>>
>> lib-maple_tree-fix-swapped-arguments-in-mas_safe_pivot-call.patch
>> lib-glob-fix-grammar-and-replace-non-inclusive-terminology.patch
>> lib-glob-add-explicit-include-for-exporth.patch
>> lib-glob-replace-bitwise-or-with-logical-operation-on-boolean.patch
>> lib-glob-clean-up-bool-abuse-in-pointer-arithmetic.patch
>> lib-uuid-fix-typo-reversion-to-revision-in-comment.patch
>> lib-inflate-fix-memory-leak-in-inflate_fixed-on-inflate_codes-failure.pa=
tch
>> lib-inflate-fix-memory-leak-in-inflate_dynamic-on-inflate_codes-failure.=
patch
>> lib-inflate-fix-grammar-in-comment-variable-to-variables.patch
>> lib-inflate-fix-typo-this-results-to-the-results-in-comment.patch
>> lib-bug-fix-inconsistent-capitalization-in-bug-message.patch
>> lib-bug-remove-unnecessary-variable-initializations.patch
>> lib-idr-fix-ida_find_first_range-missing-ids-across-chunk-boundaries.pat=
ch
>> lib-decompress_bunzip2-fix-32-bit-shift-undefined-behavior.patch
>> maintainers-add-josh-law-as-reviewer-for-library-code.patch
>> lib-bootconfig-fix-typo-budy-in-_xbc_exit-comment.patch
>> lib-ts_bm-fix-integer-overflow-in-pattern-length-calculation.patch
>> lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch
>> lib-bootconfig-fix-off-by-one-in-xbc_verify_tree-unclosed-brace-error.pa=
tch
>> lib-bootconfig-check-bounds-before-writing-in-__xbc_open_brace.patch
>> lib-bootconfig-fix-snprintf-truncation-check-in-xbc_node_compose_key_aft=
er.patch
>
> Hi Andrew, before you complain about the other patches, "email" situation=
,
>
>
>
> Tomorrow I'll properly setup objecting@objecting.org to be able to send e=
mails, to mitigate this, thanks for the understanding
>
> V/R
>
>
>
> Josh Law

Also btw there indeed are other patches


---- uuid ----
https://lore.kernel.org/all/20260312184113.23564-1-objecting@objecting.org/


----maple_tree------
https://lore.kernel.org/all/20260312184054.23481-1-objecting@objecting.org/
https://lore.kernel.org/all/20260312184054.23481-2-objecting@objecting.org/



------ldr----
https://lore.kernel.org/all/20260312181948.20020-1-objecting@objecting.org/
https://lore.kernel.org/all/20260312181948.20020-2-objecting@objecting.org/
https://lore.kernel.org/all/20260312181948.20020-3-objecting@objecting.org/


(Yeah I was working loads today, I got a new server and I decided to help l=
ib some more)

#libforever

V/R
