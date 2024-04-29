Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157A114A8D
	for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 08:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714377918; cv=none; b=OC9xe94sE1Eu6V1vWoLxWvBEbkePevHoTrx1VzHby1JdwcsPdWWkxLQUJI3iy9t5hjdu/PsIzsNv0PpMC2Hmt1LUIPMReeSaUpcZujb49ltTxdBO8rwdlNYfjUXGjFX1I3CfTKqrqHG5/jpNusPMp2PHB06J3elZGz1HGID+imQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714377918; c=relaxed/simple;
	bh=qOe5dbEbz/LqRsuHcMnF30qOFp6BVmz/rHcwAdL6Nwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BlXzloRBJrSRnl+Qmx1fRKEsKunr7tKPzfOtgpSgGdg/mZjK0Disn5vzJL5eRG6GK3Kl+q1z1sS08q/mIWxjtCl+5Aa/+k2cSv2BuQl5rKObPAwthK4565fJkfnQb80R7SeHo4YwqioxfBt7sUrpodurmvUvugLZU8vavpVuaZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rasmusvillemoes.dk; spf=pass smtp.mailfrom=rasmusvillemoes.dk; dkim=pass (1024-bit key) header.d=rasmusvillemoes.dk header.i=@rasmusvillemoes.dk header.b=JjRLwjed; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rasmusvillemoes.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rasmusvillemoes.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rasmusvillemoes.dk header.i=@rasmusvillemoes.dk header.b="JjRLwjed"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a5878caeb9eso511336866b.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2024 01:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google; t=1714377914; x=1714982714; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f/OOrWTk6s+nQJmP4laALdai4j+ytpvRWErwL1QUwQ0=;
        b=JjRLwjedAazB2/KzI4lqn7AfTobWiZznK5I8X+xWiQGNVho3MdD3T1rr90GshidsFE
         crJW+w8CKD/8L0V9kgxndwrcLDp1fsi0tTKbCjRyYNvOQxBmjptpApJDlh723noF49pz
         HLskw0YFTLpDjXwWyhg82CTpaInzuFe4MkuRk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714377914; x=1714982714;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f/OOrWTk6s+nQJmP4laALdai4j+ytpvRWErwL1QUwQ0=;
        b=O7AkgnIC47bEbzgQF5EbQy9LTQxrAS3i3LwI8OvuERpkU3uKnDzxfj2m64u0aeUQz6
         h01AN0NPaCNccEzZONd2Ff/C/I6w7sg7ew+eSG+spHNji4oBwzhHiGO1bVHaHFe9jLFJ
         xNtgDFOEBzYLHsfJV5WO/wUJzJ8OGYIFBAdrHKDFcfdyIfZvTVj5Boc9M5wAi8/J5m0V
         Poe+zVgnTfEojyMm4N5mO+voUSf/kQ94OVvw/9bqzblAUNo3f8EtlDy8PtzH6owNqKgS
         83vI6usn7fUg96ittuI24N/vBteh/RU9g9910wBFzRK6x3gV4G10hIOMbiHjpTlQ2INw
         VQCw==
X-Forwarded-Encrypted: i=1; AJvYcCUDEIbyB5LjW2NI8eV32IKY110ld96BOvMgWlLQeAFEstQ91SZsEfYlEk2G8j02j7K/JQCc4g57P8m7fMMvxtQSaHfsLetfYMZ5FA==
X-Gm-Message-State: AOJu0YyWY9h3Qc3Q3uH4XELHo3ql+UJogO5w1pEwFsuczUoa0LpguE73
	vffZ/CzNEY+hQt7RWjI+D1yDTAMloPxGPTC6eS1VS7EK67bXcxR249RkRL0IhnEh7M7cUGpeF6R
	zU9I=
X-Google-Smtp-Source: AGHT+IFmW4WXasxYFK8L10TECe4k1U/xOfKR6+BfJZxyK82Y67ZkjYS5T/OQocvMtGsBjdGOCVmJiQ==
X-Received: by 2002:a17:906:434e:b0:a51:e5ac:7b7 with SMTP id z14-20020a170906434e00b00a51e5ac07b7mr5615845ejm.71.1714377914021;
        Mon, 29 Apr 2024 01:05:14 -0700 (PDT)
Received: from [172.16.11.116] ([81.216.59.226])
        by smtp.gmail.com with ESMTPSA id jr13-20020a170906a98d00b00a4e03823107sm13509473ejb.210.2024.04.29.01.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Apr 2024 01:05:13 -0700 (PDT)
Message-ID: <b14ef3d8-6b14-4078-b1dc-0df330948ebf@rasmusvillemoes.dk>
Date: Mon, 29 Apr 2024 10:05:12 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + bitops-optimize-fns-for-improved-performance.patch added to
 mm-nonmm-unstable branch
To: Yury Norov <yury.norov@gmail.com>, Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
 jserv@ccns.ncku.edu.tw, n26122115@gs.ncku.edu.tw
References: <20240426190857.BB28FC2BD10@smtp.kernel.org>
 <CAAH8bW9o+d48_84mWXwYkVgMzY+__UxfBnuzauci4qgt1jFZ+Q@mail.gmail.com>
 <ZiyOQ7RtG763rUSJ@visitorckw-System-Product-Name>
 <Zi50cAgR8nZvgLa3@yury-ThinkPad>
Content-Language: en-US, da
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
In-Reply-To: <Zi50cAgR8nZvgLa3@yury-ThinkPad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/04/2024 18.08, Yury Norov wrote:
> + Rasmus
> 
> On Sat, Apr 27, 2024 at 01:33:55PM +0800, Kuan-Wei Chiu wrote:
>> Before:
>>                Start testing find_bit() with random-filled bitmap
>> [    0.299085] fbcon: Taking over console
>> [    0.299820] find_next_bit:                  606286 ns, 164169 iterations
>> [    0.300463] find_next_zero_bit:             641072 ns, 163512 iterations
>> [    0.300996] find_last_bit:                  531027 ns, 164169 iterations
>> [    0.305233] find_nth_bit:                  4235859 ns,  16454 iterations
>> [    0.306434] find_first_bit:                1199357 ns,  16455 iterations
>> [    0.321616] find_first_and_bit:           15179667 ns,  32869 iterations
>> [    0.321917] find_next_and_bit:              298836 ns,  73875 iterations
>> [    0.321918] 
>>                Start testing find_bit() with sparse bitmap
>> [    0.321953] find_next_bit:                    7931 ns,    656 iterations
>> [    0.323201] find_next_zero_bit:            1246980 ns, 327025 iterations
>> [    0.323210] find_last_bit:                    8000 ns,    656 iterations
>> [    0.324427] find_nth_bit:                  1213161 ns,    655 iterations
>> [    0.324813] find_first_bit:                 384747 ns,    656 iterations
>> [    0.324817] find_first_and_bit:               2220 ns,      1 iterations
>> [    0.324820] find_next_and_bit:                1831 ns,      1 iterations
>>
>> After:
>>                Start testing find_bit() with random-filled bitmap
>> [    0.305081] fbcon: Taking over console
>> [    0.306126] find_next_bit:                  854517 ns, 163960 iterations
>> [    0.307041] find_next_zero_bit:             911725 ns, 163721 iterations
>> [    0.307711] find_last_bit:                  668261 ns, 163960 iterations
>> [    0.311160] find_nth_bit:                  3447530 ns,  16372 iterations
>> [    0.312358] find_first_bit:                1196633 ns,  16373 iterations
>> [    0.327191] find_first_and_bit:           14830129 ns,  32951 iterations
>> [    0.327503] find_next_and_bit:              310560 ns,  73719 iterations
>> [    0.327504] 
>>                Start testing find_bit() with sparse bitmap
>> [    0.327539] find_next_bit:                    7633 ns,    656 iterations
>> [    0.328787] find_next_zero_bit:            1247398 ns, 327025 iterations
>> [    0.328797] find_last_bit:                    8425 ns,    656 iterations
>> [    0.330034] find_nth_bit:                  1234044 ns,    655 iterations
>> [    0.330428] find_first_bit:                 392086 ns,    656 iterations
>> [    0.330431] find_first_and_bit:               1980 ns,      1 iterations
>> [    0.330434] find_next_and_bit:                1831 ns,      1 iterations
>>
>> Some benchmarks seem to have worsened after applying this patch.
>> However, unless I'm mistaken, the fns() changes should only affect the
>> results of find_nth_bit, while the others are just random fluctuations.
> 
> So...
> 
> The patch itself looks good, 

Well, I think it could be even better. While I agree that bit=ffs();
clear_bit(bit, ) is probably a bad way of doing it, I think the basic
structure of the function is good. Introducing a "count from 0 up to n"
loop is rarely a good thing, keeping the n counting down to 0 is likely
better.

So I'd instead just change the function to

static inline unsigned long fns(unsigned long word, unsigned int n)
{
	while (word) {
		if (n-- == 0)
			return __ffs(word);
		word &= word - 1;
	}

	return BITS_PER_LONG;
}


Now that I look closer, I think the

 * Returns the bit number of the N'th set bit.
 * If no such, returns @size.

in the find_nth_bit and friends' docs is wrong. Tell me what happens here:


  DECLARE_BITMAP(x, 12);
  int i;

  x[0] = 3;
  i = find_nth_bit(&x, 12, 7);

So I'm asking for the seventh (counting from 0) bit set in a bitmap of
12 bits, but only two bits are set. So i should be 12? No, i will be
BITS_PER_LONG, because fns() doesn't know anything about the limit of
12. Do we really not have any tests covering that? Or indeed covering
any of the small_const_nbits optimizations?

I've said this before, and I repeat. It was a mistake for the bitmap
functions to promise a return of exactly @size when stuff is not found,
they should always have just promised to return something >= @size. The
checking in the callers would be just as easy (and some indeed do >=
instead of ==), but the implementation can be somewhat cheaper. I'm
afraid that ship has sailed, but it annoys me every time I stumble on this.

Rasmus

