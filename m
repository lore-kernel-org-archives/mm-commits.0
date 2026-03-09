Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B48B8321445
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 21:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773092874; cv=none; b=tooGacmEzCaygOHATaFvr26IBFt3NgcfsbNzXnPzQa056omDgpkOuEqpFL5KkeRhPbu8XroGynhqJqxtu3FXXgAPqmi9+7G6RMzwkmFUG6iVBodpnpNc71alssNICJbO1v+wqdIDtr6eOw71IOZ6GTT6KZjDcBxomc5DuCu9/JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773092874; c=relaxed/simple;
	bh=fYVhR0T5JlIvKWHDRMcHnHaiW+1ektBeyGYt5+/MXaM=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=dMdc96t5b3EtYlZ5mPYqgoCceq8WqS2+YV2c1H5oWcZ3o3bxBu8PC5IDa+vmFVrcpmZO+IWYXVRzpShCYTRzl9cY7vT9Em2hmtShNO3LZkIO246or9MI4ohGd8rY5JwEzXk48HXDb9b04puou5JMsAHuMVJ8ELvEKAKBQhOz4fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JHb+sN7d; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JHb+sN7d"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-439b97a8a8cso8126630f8f.1
        for <mm-commits@vger.kernel.org>; Mon, 09 Mar 2026 14:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773092871; x=1773697671; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fYVhR0T5JlIvKWHDRMcHnHaiW+1ektBeyGYt5+/MXaM=;
        b=JHb+sN7duUXpETdB00UVrDhHrPQwVFcoyq93wrwf5/9Rq1EtZiMrO1bv97E9OfqCl5
         bB4eUpTxMLkY+nStZkn3s1eB4Ctw8vo8SxtzjpwkteB76rek0tT4gIE1rdozYqjG9q8c
         /mF2fDwhI6sDSBjgo+R93YWlqhlMn0GDuNLDXM8vux3pKHdjr24enpSJWojvXn1Wn8Od
         fo9q8NFuXkMFqTNK9gH0HMXLKNvvjxrowbV87gOurc3mqxdkrL6899uvxdsGQW6Jsv7f
         gSThyseQlym2PWWICOAgc3lMMd/8n408CSujdPtBqd1S9d0t7sIP/e/bl5/QECnQLkjq
         N4WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773092871; x=1773697671;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fYVhR0T5JlIvKWHDRMcHnHaiW+1ektBeyGYt5+/MXaM=;
        b=vflYwgCNMKtL+pPo3U1zBabH7FKz+b/lknEk+iJUfWLz7+wB5qUs8MUql23YivK2nw
         XFbMI9h3Btuzznuw0AEU4+Z0gzFGifRkQeD1Evqpm+TVpBgoGhM2ska45qT8Qnro4MU8
         xe9l+1yd34nsnkOgeSWqOlUZ74HnJBQ8Ji/n1OBqpQ6kM55fprDm25x+soRsCcpMR2kP
         bxaS2XwNChAEyd1/jSYj4Wb6IGB77kx4pqddZhyKrxWYF+HKrLkhcaV5WZg/PcEqyPOc
         4Ii37xURcBuF4rT34jOlBfBfcVZwnMIFao6U7mBc4klHqChXaDu6VIkvZhwozLodYADT
         +M5g==
X-Gm-Message-State: AOJu0YyGT/kbgPl1dwTyeTVPG8ER7pIbsG1xAi8fmhGoP2ea+UZVf09i
	fAMlr4OYEgoR0JI363hA+MwVGwRyawJlc6Ppt9GnGfvyomxcC8tNAd87zmTF/yz/8H4pgw==
X-Gm-Gg: ATEYQzyOS9U3dWCOudj+O9pxhUTlFRlTP2jZjz/Udz4dyKpaG3DEpcFTaT7ShLyUTbZ
	aqDPhZ7CSop3I6EHkth233AIGaTuKcROBUzZOIx4JoDtRpFhQJQn88RQ4daHHOwWC7nulH16tqR
	zZDXqCIfkGklxkOecw158QRt/TYk5m7sVwQQkGuFwwk18UTgIhhPEtlD/tZMkzjRV+SlL1C+sQO
	vQZ2axpNOTU18FPbkfBYpmBuwzO7sLVCL+xyzgyQMh9Wg/NfpnQ7uUDZfJu9PIEZVWLwQh5ZtEp
	WF9G6ELL9nr9CpLMiwWuxH0OJoxv4hu5B7BoxmPd0cbnw+w2cbIA17UPeTb1VC0jFS9DQ/Q1MwW
	u2tcP/kAghE1ZqPUK6VXNlMfC80CEQ7Vd6ChzegEtYQPZlpx5yJJGUHm3pXI2TvbbQKmUGzaqDb
	gygiupjtY6Fwy3xQFA
X-Received: by 2002:a05:6000:26cc:b0:439:bc31:a056 with SMTP id ffacd0b85a97d-439da8a6cbdmr24391618f8f.51.1773092870833;
        Mon, 09 Mar 2026 14:47:50 -0700 (PDT)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dad8d95dsm32638525f8f.7.2026.03.09.14.47.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 14:47:50 -0700 (PDT)
Date: Mon, 9 Mar 2026 21:47:51 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, objecting@objecting.org
Message-ID: <ed6f028e-b8f7-45f2-bb04-c5195c629b69@gmail.com>
In-Reply-To: <5629bf19-9f07-45da-b32d-534f8e7dc80c@gmail.com>
References: <20260309202433.1ED14C4CEF7@smtp.kernel.org> <2583e57b-fb3e-4e43-9d93-a3db4c816c11@gmail.com> <20260309134310.6036ef100f81a943f0fe6e2b@linux-foundation.org> <b1324259-8cad-4fef-94b9-2a72ac5e54f4@gmail.com> <5629bf19-9f07-45da-b32d-534f8e7dc80c@gmail.com>
Subject: Re: +
 lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch added
 to mm-nonmm-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <ed6f028e-b8f7-45f2-bb04-c5195c629b69@gmail.com>

9 Mar 2026 20:54:29 Josh Law <hlcj1234567@gmail.com>:

> 9 Mar 2026 20:45:45 Josh Law <hlcj1234567@gmail.com>:
>
>> 9 Mar 2026 20:43:11 Andrew Morton <akpm@linux-foundation.org>:
>>
>>> On Mon, 9 Mar 2026 20:35:07 +0000 Josh Law <hlcj1234567@gmail.com> wrot=
e:
>>>
>>>> Do you think these patches require Cc: stable?
>>>> Idk the severity of the bug to you, the swapped arguments got Cc stabl=
e,=C2=A0 overflow could cause some screwy bugs
>>>
>>> Probably not - is there any reason to believe any callers will hit this=
?
>>
>> I=E2=80=99ve been looking at the callers. While most are in-kernel const=
ants, xt_string in Netfilter allows for dynamic patterns. Even if it's curr=
ently mitigated elsewhere, hardening the allocation logic in ts_bm and ts_k=
mp feels like a 'must-have' for stable trees to prevent future heap overflo=
w vectors. Basically... Better safe than sorry!
>>
>>
>> V/R
>>
>>
>>
>> Josh law
>
> Yeah, I now think Cc: stable is a need for both of the overflows, I am th=
inking about that 32 bit shift aswell, but that probably won't need it

Cc: <stable@vger.kernel.org>



These patches (ts_bm and ts_kmp) fix a potential heap overflow. The pattern=
 length calculation can wrap during a size_t addition, leading to an unders=
ized allocation. Because the textsearch library is reachable from userspace=
 via Netfilter's xt_string module, this is a security risk that should be b=
ackported to LTS kernels.



V/R



Josh law


(This is my final input :D)
