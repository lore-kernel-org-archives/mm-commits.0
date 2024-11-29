Received: from sonic301-22.consmr.mail.ir2.yahoo.com (sonic301-22.consmr.mail.ir2.yahoo.com [77.238.176.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CDB3224
	for <mm-commits@vger.kernel.org>; Fri, 29 Nov 2024 21:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.238.176.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732916654; cv=none; b=hYc/y9g6zyiEjaI8sk2zYZHQw0+cZauTH8Y/ASZqJWQr0xKOdbIejRR60QZEcLvlx5q2kMh+n0rBSAgs8Q5VtCbYsa3kznC9xP3Vol9lbivRqILNeqc0eU0xehk7d9KVrNxyCivH2RLLlMB3jyNBaiI7QcDQIs/JlM9rilniRb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732916654; c=relaxed/simple;
	bh=36fcXqiSAm8msRWwX/FrxJMY6pk9uzmmBhdg/HFWvFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=orJ6d5yB0dCvDMPdn+KMSkL3yjOOb+AUg2Ax1CoQ7rjqDe+7GD4rNOwT51mpycZF1JY/FMtcD3X2+GeaIFfejFKybwmagpMBpHn5EBvUAe3nH2YqUtlLHHlJkeMUnFBwFB0SS7PmWM/avtN8k+QPiw/kFw/CyrThnSrn0aj1pqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rocketmail.com; spf=pass smtp.mailfrom=rocketmail.com; dkim=pass (2048-bit key) header.d=rocketmail.com header.i=@rocketmail.com header.b=P/u77wka; arc=none smtp.client-ip=77.238.176.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=rocketmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rocketmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rocketmail.com header.i=@rocketmail.com header.b="P/u77wka"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rocketmail.com; s=s2048; t=1732916645; bh=+i2w83pfyv7UPp2rgCO0g5j0k+UwroboAe8SKb7yjJU=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=P/u77wkaZ3pIJE7m6FJe+VKMcoBhSp5PUOMQujwoFGx/IUA9D2DRMD6L6BHU2AA54YivY5wUsS33ORPX9Ktn5DWwfzcG0W4odMWXEwqecFVPEN5kemVaFtSwsoWEIYj7/1S2+CSwNT6jGXPfASL6ZI+7m8GQcvfN83tlhiM9RxOCONJ5GBT2eqq+YoqtHyMZ2rTMwKzoyV74qo2Un1Q1lKPdh7nSarIe5Ir69SVoADgLU3lq2OvIFWFy9D6kVkGRoA/93Ues28Y7CRuryio4SCUD0nM7YTibbmNqUT1tozvox24i69QqjV+GaLdXucgAHWeHhdwWUduwas9C6itLfg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1732916645; bh=U15dX59DxmU+QRVpNvCNI1bRaa3oBXIBrTXVyHWJ7R7=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=H8D4+oh7/hL2l7Fwllr1EKR3dH/Duqmw6WXtL7gvu9qMbjNtdQl5TQqz7WoWkngGfwiDd6Wf1EWdWPNlEaWjHmaOADj31KDLqMHkR1Fj+ZEPotBHYhfBO9yFyYxS3XuMb29vFuvE6gJv8GNuCYLrB7flWz67LWX12RQtiNGHJhQVS6j8tcdJjeidvo/5F8N2zLcOMlifkeCdBcFvUq7OSdYKC1BfOMEpBF033sClL1LHsfqJM7XoAANyEU1HWomquljc/NawCXERSVTJzUfUO3jEiF6bBRifEJiKBkDrjnJDBOaWQAUa7OnNb1cDZZqszobFdo4snHVG5AieUaG60g==
X-YMail-OSG: mKgGs2EVM1moYJ69brbFHJ7_oRJEOUZ1r9WJdgive_NmRF1mCP3CYYsp8vCEer_
 07BCoGl73BiegHGFuvbJ6muZ8gvR3HugO3mJ90M4_W9N3qRLOjH0vR374PDH2Tdy25Abkdy.ntRX
 GX0Tumm.l6P3tI2aa_bSH1xVUptfcAZJyQKjlz7VMaoM5UVOA9GM8PKZXOr7vZmOt7QDmKsdfsIi
 mWK2D4JhAWgoaeTSNMILgRDHirN2IopPLz3fWCOIVZkIqTGWaFiWv0Q5FO9v.wo0OyMOCWb_7IPZ
 2lrbpmR.sEvPkmKeFgBSZRAXWqhWR98Xxq6T8HlbQmrry0m5UG2xxl7mm3MGdNIYjw3x5_Ndjptz
 Hg3ZHl.vjOQvOXTwwfmAItaIHWvoTX2QeTGCLR5YkUlTYd3TyiVLGQtxHt46cPiQCeAN0p7nYva1
 V4qkKTxxTXa_594ZnpmtpOQEAl7My.Y1RdwwrUb6xJCSaq1DnAS38AzLIGP4GvaRp4XTwdwbo0Ea
 3pzh8h2pwlisa4uRUcWfGQKby5wzjx7L7kJ6iZBO8c2LQDhdZ_U60lbrDcHtFRZTyvpCCyByOtBv
 5f3P428D7OHXp43pIEPyd8eUOx9hYwt4c6UiyAWe6qjMS1l._PpLcmOBCgvHypk.d6TJdVVnpd_s
 QYfzJ0vBdwnXM8LKdaPq_FlV8a1iIt2CFGX.zPO3TUNoa6jLCGLRvl.eImrjZvfZ7gGcRLl6hGwL
 4pZuP12.slSjWGei9W1R_yDyWinub4AJSt6pWOPLOcEPVZ1y.ie_q5YN84j5jLPXxOkCLBKDSj9H
 3GaCG_WPbJ1HweZTwVJczP.vYwZxy0AEgkZf2nWUTfeWT.gZQQ0.muSdKcMRLOxSk0SV0B1na2dv
 dPW.ip.EAfUBWZEamEuS3nKPyHbn_5s4xqg9SeQnK0zoR1AH41OSViW1FGQfSuJnMrvk9fWdDfmA
 JpKkGgBkGEnGakEcZJQDAdQF9EgKzl2as0_6vmBJO9ygTFCXNO2kSUhg7Giz52bpjfaN6PwYNbrN
 WwMcvxehPdMIK2TMhrzm4yFXEa389esLMaDXyip8kdsOW5kuQjI95zryJf8vJpcqY8bAcMhjzg9d
 HyclhQ2Ai9XLjMYusKoMJmgAccRpqbS6Sc3XCAOniCEgHoAO_.tZslKGp27ckLMYHcCZcfqTHPbr
 GD_1vCQaVIEVXWBcM5NoysQSsfe6A8xMOfI90lMTHCirRsuf9q46IJVOVp6P8odyksO0WJZ0arER
 0jWVR21HC2RCkqIB9Se9AISqhi8eL57ihgcwoY.83d4QSdSL5njrJ6x8IRlelprmQzwhKsrvC76a
 mg4mOM1DdNH7AJQhPAArAveS1.fF5pF.bzT2nPdjkjdIkO3awXqVSe_n3LJtij4QgVr1LETT_tkQ
 hExEUo9N2Q9m2q6Kq5MJb767wPkMp83B_CzozBGYQlmI0SIqZ715JWTxJOpaEFt2weuF5vRxJO61
 MRjpb6nv9zvAIeM6JE0JhpCVP6EnoBxGmV6FO040D8aerGEO8yOw5LMWwrW1RsU9n.AX4DKyJ44a
 ieYbW_NDbnWpCt9lCxa60Zd4DFC.Be73qg3oQao0Y8VP8lQhX9HsfbwzgvK3hA9gxoZXBHGnhWC5
 Zbqdxbw4BciKkKFo.f3MTHK4rvF3FeplRgIqZ3jtD6c8YqclrwJ1w3UD4Nvo6cpCQrtsj.5r5P_B
 3LuIMzkZy75hjSjokRQoBqsSyUd7O0JcvRgyfcl2XAFoNLoEP0B7wjMXFviU_lMnCC9VrlwTj09s
 pUQcpy2iQBOh0LbymaMatr7EhzF8gUpIqB5C363GOoYdeyuE71Dk0L6jb3BjeSSnSimjmpqs1C1k
 wJ.5q0cyfa67ZgUmaQI0qZaYgvUW7aCjUNiUhiiFkQ_FX2WvvFUBbHfq2DJIMZrzsPIJP9rEKMqG
 kEVf62lOZa2ZjMQ4CMCfeQsxCdItPeqjn_2BXypoKrwrizhbz2MCyNL05XWRRaw__f.e9M4j5_CD
 n.rW0e6f3bdEOMdkeYzF5akwzO2BIQBQp2vkLPdmz6r_Lg.oUtGBl97_WE6z.qzQZGKcTBGKc0fp
 RNP61PwNsTzNR.dM6vj4wxLTVSgvnsoc6hbNYSR07ywoL8EXSK69tGLpo2ChnlmOqCw5VAFmnRn2
 cz5PCGrFf2FdrtVTMLx2i85iN6u_V.lOQHEqjsBuIcCSANB6t1lK0rElZbXwdgnSSthafCyx1_Ui
 LZksGxcrDiMutvb87_m9nmhUHspiPf5pIhCQ1.6sRn8vOUhsYPZTTJew_86o_PsrhR2V6E05T2TT
 CE9lNVBWMJNPM37oKD99z31YYSn7r2Z36lGHzgw7ajLngdSO4p1Cv4A1SFA--
X-Sonic-MF: <jahau@rocketmail.com>
X-Sonic-ID: 04f031bd-fff1-4744-a902-ad6ca02e487f
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ir2.yahoo.com with HTTP; Fri, 29 Nov 2024 21:44:05 +0000
Received: by hermes--production-ir2-c694d79d9-nk5dk (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID fec0a51abd8e9de8bb0d66542461d756;
          Fri, 29 Nov 2024 21:44:02 +0000 (UTC)
Message-ID: <458cfd34-aaef-4a39-b10b-1c37ae83306e@rocketmail.com>
Date: Fri, 29 Nov 2024 22:44:00 +0100
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + minmaxh-simplify-the-variants-of-clamp.patch added to
 mm-nonmm-unstable branch
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Laight <David.Laight@aculab.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "pedro.falcato@gmail.com" <pedro.falcato@gmail.com>,
 "mjguzik@gmail.com" <mjguzik@gmail.com>, "Jason@zx2c4.com"
 <Jason@zx2c4.com>, "hch@infradead.org" <hch@infradead.org>,
 "dan.carpenter@linaro.org" <dan.carpenter@linaro.org>,
 "axboe@kernel.dk" <axboe@kernel.dk>, "arnd@kernel.org" <arnd@kernel.org>,
 "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
References: <20241129111143.DB800C4CECF@smtp.kernel.org>
 <f0db5571-8c0c-4a39-8bea-e802d05deda4@lucifer.local>
 <496cba0483554fa187d2346159157431@AcuMS.aculab.com>
 <15a2907b-530e-4d0d-9b6e-3fc5a290ecc6@lucifer.local>
 <09dfd66250e24faf969ecd6fe2dd764f@AcuMS.aculab.com>
 <d9052f1c-756d-40d8-874c-ffb36abc36b8@lucifer.local>
Content-Language: en-US
From: Jakob Hauser <jahau@rocketmail.com>
In-Reply-To: <d9052f1c-756d-40d8-874c-ffb36abc36b8@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.22876 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

Hi Lorenzo,

On 29.11.24 13:14, Lorenzo Stoakes wrote:
> On Fri, Nov 29, 2024 at 12:10:19PM +0000, David Laight wrote:
>> From: Lorenzo Stoakes
>>> Sent: 29 November 2024 12:06
>>>
>>> On Fri, Nov 29, 2024 at 11:56:01AM +0000, David Laight wrote:
>>>> From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>> Sent: 29 November 2024 11:46
>>>>>
>>>>> On Fri, Nov 29, 2024 at 03:11:43AM -0800, Andrew Morton wrote:
>>>>>>
>>>>>> The patch titled
>>>>>>       Subject: minmax.h: simplify the variants of clamp()
>>>>>> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>>>>>>       minmaxh-simplify-the-variants-of-clamp.patch
>>>>>
>>>>> Hmm, this was generating kernel test bot reports, should we be taking it without
>>>>> that being fixed?
>>>>
>>>> That is reported for W=1 builds and is correctly reporting some very
>>>> badly broken code - that has always been broken.
>>>>
>>>> Probably also only affects allmodconfig builds because the code in
>>>> question is unlikely to be included.
>>>
>>> Ah fair play, you are poking around in some creaky, cobweb filled bits of
>>> the kernel so perhaps not a surprise...
>>>
>>> We should probably try and sort out the W=1 stuff though! And by 'we' I
>>> mean you obviously ;)
>>
>> Not me, Jakob is trying to fix the magnetometer/yamaha-yas530.c driver.
>> But I keep on pointing out just how broken the code was.
>> So there should be a patch to it (that needs backporting) soon.
> 
> Presumably that somehow interacts with this clamp code that he's also
> addressing you mean? As that's something of a specific driver (I have no
> idea even what a magnetometer is...)

I'm working on cleaning up that part in 
drivers/iio/magnetometer/yamaha-yas530.c.
v1: 
https://lore.kernel.org/linux-iio/20241126234021.19749-1-jahau@rocketmail.com/T/#u
v2: 
https://lore.kernel.org/linux-iio/11609b2243c295d65ab4d47e78c239d61ad6be75.1732914810.git.jahau@rocketmail.com/T/#u

> In general your series seems mostly to be various reasonable cleanups (at a
> glance) so think we're all good to at least have this in 6.14 unstable
> anyway, to be clear.

Kind regards,
Jakob

