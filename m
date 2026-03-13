Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159AE3A450E
	for <mm-commits@vger.kernel.org>; Fri, 13 Mar 2026 15:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773417427; cv=none; b=hzj7RFh6g0WHEA300SpMyG7sMQTzaYUCMdLpc+KNlg87ukUh4Fy9S6fNQIWXVc6OsVtOH3WtRzaCZwrMU3aodDJF+DFENsZAD6Ja6zXT1NTDpip8k5ylczQjOkkKsxQjwGdTNTIsVF2iB7yE2x8ETUBWzx9AYiPEc05cvKKrxBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773417427; c=relaxed/simple;
	bh=zY427AMrai7+zxNkbm1MrezB+hn7xFrEJwERqR1RUww=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qkSbHkzFFiTmAzqpGanXmVSKHHo2KWxMxXWsyZnvUn+234bFS2dvkLJPWlvyxUTxtpJr0SA5mnneXhoGu5dn1V5PM//0WyaqnZDhutA2hAUm36KCKGIUpfJyvTDlzd8rQiYHfwdzW662rDPMWqQOQwncpCHI1H8ALwIRDKON/U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=u6DN3V4E; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="u6DN3V4E"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-67bb5c2e0fdso902348eaf.0
        for <mm-commits@vger.kernel.org>; Fri, 13 Mar 2026 08:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1773417423; x=1774022223; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G32NUmkyUhdgvQXYH4bjB54U5vbbRHfkPcIOooyQxMs=;
        b=u6DN3V4ER4IPy0pmHZi9BXSDkm4nivH9EW7Wu3Up78T0NuXMao2PExHWiHNcuThvTD
         QvsfNYf62U25qm9dEX0b9R5sIPPfanLKvMHK7SiG6HKpURa2kbGhIYJC3OwIDBYlXq58
         OxMbQ/ADE79+oB09e5GrUoNIEu8ULJr19A/f9kf3Ewek2gbwB+VPb9mBWxTrgS90yBKf
         mDOZxN1X3DbcEf4lsiCfJAS3X6tQOeRckmsGH5OCi4oovxrGVc8SpDROLxLwGZCPkIBT
         csMmpkTcPckz51CXlx/dJwrC4sRGEb57Z/hA0wP0rFgsSDhAAeEphdlEU3EYLdO7iubd
         RwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773417423; x=1774022223;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G32NUmkyUhdgvQXYH4bjB54U5vbbRHfkPcIOooyQxMs=;
        b=HD8wZAunEwNEXsPT7qZfhew7kmY7pA/VcVw9rF303JGuWalVLIQeq6yT+Ln2eugZRi
         cYsiIu1eETFZoi3wPNYqQiaUomY4FUXAe3ljbmHyDs/Rzfa+5j+z7VRDt4uagQcp6Frg
         HxV1/px/q9K0ZKAtPO7unDz/0kgtcZyCn5QD3WjihpoTP98WHCRA6xc3qS1TypfGILmT
         CIR2U/Nn8BJOqGbE1MPqIe+aQOl9iSrgZ0eY6AKxvUC9bHigDpLRrIu90bPSoP29hi8c
         s7074gIppbw1/yvtdgFQR7cWgygn7NPYjhvpZ0p5IUtz0tmaFzlCBul4SkBhEKv7Ckw+
         TWYg==
X-Forwarded-Encrypted: i=1; AJvYcCUgYa5kMeEvZ2AFm8EOM1bgDXll4ItSoDdipZIZMIQR7446dvXQsyUPwNVADe8IMGxKECqIzP0FWVtr@vger.kernel.org
X-Gm-Message-State: AOJu0YynU6UeBEBfHUr7tkEFBs+nCxEK88k3rALVJmPPia0dqm4qT8Nj
	5hoN4br0/3dcJr7/VH5QYFmPj49RefLgsIe2oPRDRtq5KB4bXBEt6I9zW8cQPgrbBz8=
X-Gm-Gg: ATEYQzzeJuO26AQU8vuo21bOOVqNSsBS2TM7oXzgMH4VXEQ63fb4BffBWHmHU5Z8abI
	ynNB8ldDi09hO4RyiKrfl47G8ax8D5TtXm5McYBy8+tm2epaOuTc3rIfXT8gkSDZCuVxRxU49zb
	NKpN2uBW8i4Qk7fHvtDRxf3FJ/asL2A/RDA+enrHZPNnvSRAF6/4pnIAfURuGDnU5sA/yus3ATp
	RKV/ain8/NowfsOSrQ3EBGmezYxckKNHOlwfvzD6bhJyZlV19bHUmeKpTKA9gto1NSVdON/m4Vw
	JchNZAQ0gZE8FMAkFYT/NU7ztutEmV33w0Q13V7uenqb5rG6YvVIPSfnZZxarzDRfpYOPRn2Dz+
	JyTFUGJ+rFldikhuEfDzuX8y26ArD013wpGnJUvlPo1fQP+bFvF0DsKS02Tn3aEfFWrJkb/7cEV
	JNAADYT4h965/i10k5iHJmGDBeePBlQ6WAUdYY0W4LAhCAzfYJUY/33+f6PKvXky8mZ0YsL2kG7
	irbB8Kgzw==
X-Received: by 2002:a05:6820:217:b0:67b:da69:ac56 with SMTP id 006d021491bc7-67bdaa4c4c1mr2430422eaf.50.1773417422566;
        Fri, 13 Mar 2026 08:57:02 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67bdd612b6esm1156934eaf.10.2026.03.13.08.57.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 08:57:01 -0700 (PDT)
Message-ID: <e2278198-22a4-402d-9179-c7cbbb186d5a@kernel.dk>
Date: Fri, 13 Mar 2026 09:56:57 -0600
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add Josh Law as reviewer for library code
To: Josh Law <hlcj1234567@gmail.com>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Vlastimil Babka
 <vbabka@suse.com>, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, Josh Law <objecting@objecting.org>,
 mm-commits@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 "David Hildenbrand (Arm)" <david@kernel.org>
References: <20260307221931.2848601-1-objecting@objecting.org>
 <3cd25de5-3737-49f4-aa8b-eaaee471af50@lucifer.local>
 <ee644e1b-5759-477f-8aec-35c91a5a938e@suse.com>
 <20260307222154.2848660-1-objecting@objecting.org>
 <667b75ad-bce9-4997-8ebf-8077952c2797@gmail.com>
 <20260313-anvisiert-gemeckert-352414e3d58d@brauner>
 <20260313-halskette-annahme-94e782eb4ae4@brauner>
 <01a6bbcc-1442-48c7-be5b-14f07fe655c9@lucifer.local>
 <28175752-2775-476d-9485-499335a99aea@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <28175752-2775-476d-9485-499335a99aea@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/13/26 9:51 AM, Josh Law wrote:
> 13 Mar 2026 15:48:32 Lorenzo Stoakes (Oracle) <ljs@kernel.org>:
> 
>> +cc David for mention
>>
>> On Fri, Mar 13, 2026 at 04:33:49PM +0100, Christian Brauner wrote:
>>> - first patch Feb 28 under pseudonym "techyguyperplexable", switched to "Josh Law" only when Andrew required a real name
>>>   in https://lore.kernel.org/all/20260228114939.de7d44de38d907a9b6632480@linux-foundation.org
>>> - 142+ emails in ~2 weeks ? 37 patches in a single day (Mar 1)
>>> - All trivial/cosmetic ? SPDX headers, comment grammar, spacing, const qualifiers. Zero bug fixes, zero new functionality
>>> - Carpet-bombed multiple subsystems ? lib/, arm64/, staging/, input/, etc.
>>> - within 1 week of first-ever patch, submitted MAINTAINERS: add Josh Law as reviewer for library code covering all of lib/ (locking.c, iov_iter.c, rhashtable.c, etc.)
>>> - Email identity mismatch ? From: hlcj1234567@gmail.com, Signed-off-by: objecting@objecting.org
>>> - Formatting problems ? top-posting, line length violations, patches not applying cleanly
>>>
>>> So I mean, one week to Reviewer. Even if we're being very generous here,
>>> we need to do a lot more due diligence going forward. We can't just hand
>>> out core components like this and risking our reputation and security
>>> posture.
>>
>> Thanks! Agree absolutely that we need to be careful about this. Jia Tan should
>> be instructive.
>>
>> Josh - there's nothing personal here to be clear, this is a question of
>> procedure and caution.
>>
>> More broadly I think we should avoid assigning new people to catch-all
>> categories anyway unless they are well established enough to be involved with
>> _everything_ the catch-all covers.
>>
>> For instance adding people to the mm/* other than perhaps... David ;) would be
>> crazy.
>>
>> Also - Andrew - I think for cases where you are the only maintainer but it
>> impacts others, you should seek acks proportional to the scope the MAINTAINERS
>> entry spans - in this case that'd be a _lot_ of people - but that only
>> underlines that we shouldn't be updating such entries anyway.
>>
>> In fact - can we just do away with catch-all's and just make sure MAINTAINERS
>> entries are established for everything?
>>
>> I have ground to stand on for this as I personally did it for mm, although we do
>> still have a catch-all (not sure if necessary any more?)
>>
>> In the case of lib/ a quick fix could be to figure out which files are not
>> covered by other MAINTAINERS entries and adding them all to what is currently
>> the catch-all?
>>
>> Cheers, Lorenzo
> 
> Well, it's already been merged into linux-next, I will keep constantly

That doesn't matter, lots of things end up temporarily in -next and
disappear before it ever sees upstream.

> trying to prove myself as a trusted figure in the community, and I am
> learning new things every day about the rules, and when you talk about
> me making "trivial" patches, I also made some medium sized bug fixes,
> yeah my start was just "janitor" code, but I will try to prove myself,

I have to agree with Christian/Lorenzo/et al here. This is not how it
works. You prove yourself by doing quality work, and then and only then
does it become official. Adding someone after 1 week of a bunch of
trivial patches is literally crazy, imho.

-- 
Jens Axboe
