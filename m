Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B00022F77B
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 22:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767825070; cv=none; b=lbEUHtpth3SSiRm1irT+yVCjRpoeQWVX4JhS2I2pMom32eh3rW1DxvCGLbV0UnBi3aOU+e9/3McJUipfodK0RHUnLhNLlO33EbE0OcGukMUlWgOFsJS0toltOn9pW7Ctvxrxv/z6il2GK0IhQ8QZwqdt3uoLUzDBH7CH9/B5V9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767825070; c=relaxed/simple;
	bh=FP//ouiHAmkgFdPB5b6rQpPo5NWeq0pIViBL7iM2/kA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aM18H9I+RyeNqGViX1wjkBYy57qwU9ZNlS1aMEc6fkMhw/+vWecGddDIXkCxsPKY4p4hhbz9vca5N4xXUYC2Dt0Aew7hhstEiJtPveDG9b/pDmOpJLS2X18zFBQK5TIgspMdOdTpUOK7QopZU8H3thALKI4mby7FBLCapICc6C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b1bbZIdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b1bbZIdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14581C4CEF1;
	Wed,  7 Jan 2026 22:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767825066;
	bh=FP//ouiHAmkgFdPB5b6rQpPo5NWeq0pIViBL7iM2/kA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=b1bbZIddK/G+gt2q6B130zlZk8QbrWxEcsXEKNb6lqkYQhqtpSeXarc2Hd1St4wXd
	 uPoIHu5k+ymr9PCq8OGfOOOC35yv4xCPHmZUvD72wsr7Z1tF01r8HrsPp4etRrnVqO
	 NN/fflbjnMbTZ+mspThmaBPNbcXydH/Ci0CI6HT39M/lIV9MD7IpXhRWnSM1lctPY9
	 yo9WlfFRPpLqAQUZoVvXCPRWEiRZcQjHSfgrJ7kPkdC5AFUws/uAoyoOPKyZ3ilsOl
	 RKgg4bP9BVMLiMz7MO3ZGBnHSWpUoFmRCUPMwi7Hoi4WCP9YmhK0YyVGcZXZ7rvCRS
	 b/INWbETQmRFA==
Message-ID: <f916c970-33fe-4147-9daf-159ba61a0302@kernel.org>
Date: Wed, 7 Jan 2026 23:30:58 +0100
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: + tracing-add-__event_in_irq-helpers.patch added to mm-new branch
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
 yuanchu@google.com, weixugc@google.com, tballasi@linux.microsoft.com,
 shakeel.butt@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev,
 mhocko@kernel.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 hannes@cmpxchg.org, david@fromorbit.com, axelrasmussen@google.com,
 rostedt@goodmis.org
References: <20260106033842.559EBC116D0@smtp.kernel.org>
 <3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
 <20260106124930.827da463ea281bb392a9843d@linux-foundation.org>
 <4cccaf21-c78e-4017-bb95-29a401d7c3a5@lucifer.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAa2VybmVsLm9yZz7CwY0EEwEIADcWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCaKYhwAIbAwUJJlgIpAILCQQVCgkIAhYCAh4FAheAAAoJEE3eEPcA/4Naa5EP/3a1
 9sgS9m7oiR0uenlj+C6kkIKlpWKRfGH/WvtFaHr/y06TKnWn6cMOZzJQ+8S39GOteyCCGADh
 6ceBx1KPf6/AvMktnGETDTqZ0N9roR4/aEPSMt8kHu/GKR3gtPwzfosX2NgqXNmA7ErU4puf
 zica1DAmTvx44LOYjvBV24JQG99bZ5Bm2gTDjGXV15/X159CpS6Tc2e3KvYfnfRvezD+alhF
 XIym8OvvGMeo97BCHpX88pHVIfBg2g2JogR6f0PAJtHGYz6M/9YMxyUShJfo0Df1SOMAbU1Q
 Op0Ij4PlFCC64rovjH38ly0xfRZH37DZs6kP0jOj4QdExdaXcTILKJFIB3wWXWsqLbtJVgjR
 YhOrPokd6mDA3gAque7481KkpKM4JraOEELg8pF6eRb3KcAwPRekvf/nYVIbOVyT9lXD5mJn
 IZUY0LwZsFN0YhGhQJ8xronZy0A59faGBMuVnVb3oy2S0fO1y/r53IeUDTF1wCYF+fM5zo14
 5L8mE1GsDJ7FNLj5eSDu/qdZIKqzfY0/l0SAUAAt5yYYejKuii4kfTyLDF/j4LyYZD1QzxLC
 MjQl36IEcmDTMznLf0/JvCHlxTYZsF0OjWWj1ATRMk41/Q+PX07XQlRCRcE13a8neEz3F6we
 08oWh2DnC4AXKbP+kuD9ZP6+5+x1H1zEzsFNBFXLn5EBEADn1959INH2cwYJv0tsxf5MUCgh
 Cj/CA/lc/LMthqQ773gauB9mN+F1rE9cyyXb6jyOGn+GUjMbnq1o121Vm0+neKHUCBtHyseB
 fDXHA6m4B3mUTWo13nid0e4AM71r0DS8+KYh6zvweLX/LL5kQS9GQeT+QNroXcC1NzWbitts
 6TZ+IrPOwT1hfB4WNC+X2n4AzDqp3+ILiVST2DT4VBc11Gz6jijpC/KI5Al8ZDhRwG47LUiu
 Qmt3yqrmN63V9wzaPhC+xbwIsNZlLUvuRnmBPkTJwwrFRZvwu5GPHNndBjVpAfaSTOfppyKB
 Tccu2AXJXWAE1Xjh6GOC8mlFjZwLxWFqdPHR1n2aPVgoiTLk34LR/bXO+e0GpzFXT7enwyvF
 FFyAS0Nk1q/7EChPcbRbhJqEBpRNZemxmg55zC3GLvgLKd5A09MOM2BrMea+l0FUR+PuTenh
 2YmnmLRTro6eZ/qYwWkCu8FFIw4pT0OUDMyLgi+GI1aMpVogTZJ70FgV0pUAlpmrzk/bLbRk
 F3TwgucpyPtcpmQtTkWSgDS50QG9DR/1As3LLLcNkwJBZzBG6PWbvcOyrwMQUF1nl4SSPV0L
 LH63+BrrHasfJzxKXzqgrW28CTAE2x8qi7e/6M/+XXhrsMYG+uaViM7n2je3qKe7ofum3s4v
 q7oFCPsOgwARAQABwsF8BBgBCAAmAhsMFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAmic2qsF
 CSZYCKEACgkQTd4Q9wD/g1oq0xAAsAnw/OmsERdtdwRfAMpC74/++2wh9RvVQ0x8xXvoGJwZ
 rk0Jmck1ABIM//5sWDo7eDHk1uEcc95pbP9XGU6ZgeiQeh06+0vRYILwDk8Q/y06TrTb1n4n
 7FRwyskKU1UWnNW86lvWUJuGPABXjrkfL41RJttSJHF3M1C0u2BnM5VnDuPFQKzhRRktBMK4
 GkWBvXlsHFhn8Ev0xvPE/G99RAg9ufNAxyq2lSzbUIwrY918KHlziBKwNyLoPn9kgHD3hRBa
 Yakz87WKUZd17ZnPMZiXriCWZxwPx7zs6cSAqcfcVucmdPiIlyG1K/HIk2LX63T6oO2Libzz
 7/0i4+oIpvpK2X6zZ2cu0k2uNcEYm2xAb+xGmqwnPnHX/ac8lJEyzH3lh+pt2slI4VcPNnz+
 vzYeBAS1S+VJc1pcJr3l7PRSQ4bv5sObZvezRdqEFB4tUIfSbDdEBCCvvEMBgoisDB8ceYxO
 cFAM8nBWrEmNU2vvIGJzjJ/NVYYIY0TgOc5bS9wh6jKHL2+chrfDW5neLJjY2x3snF8q7U9G
 EIbBfNHDlOV8SyhEjtX0DyKxQKioTYPOHcW9gdV5fhSz5tEv+ipqt4kIgWqBgzK8ePtDTqRM
 qZq457g1/SXSoSQi4jN+gsneqvlTJdzaEu1bJP0iv6ViVf15+qHuY5iojCz8fa0=
In-Reply-To: <4cccaf21-c78e-4017-bb95-29a401d7c3a5@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>
>> The email you replied to had (courtesy of David):

I think it was courtesy of Mike :)

>>
>> : Note, mm-new is a provisional staging ground for work-in-progress
>> : patches, and acceptance into mm-new is a notification for others take
>> : notice and to finish up reviews.  Please do not hesitate to respond to
>> : review feedback and post updated versions to replace or incrementally
>> : fixup patches in mm-new.
>> :
>> : The mm-new branch of mm.git is not included in linux-next
>>
> 
> This provides no information about why/how things land in mm-new. At the
> moment it seems entirely random.

Yeah, I am also still a bit unclear on some details of mm-new. So the 
summary mostly captures the idea of mm-new from a submitter 
point-of-view: if it's in mm-new that doesn't mean that your job as a 
submitter is done. That's a great start, but obviously lacks some details.

One point I see, also related to another mm-new-related discussion 
Lorenzo raised: If we want to use mm-new to find issues before they hit 
mm-unstable->next [1], then we should make sure that some known-broken 
patches/tests don't stay in there making it harder to test other patches 
that get put in there afterwards.

For the time being, I assume that everybody should develop against 
mm-unstable, and mm-new should mostly be a target for build bots etc. 
But then, if everybody would develop+test against mm-new, we could 
actually find more issues earlier (IOW, before mm-unstable -> next).

Hm.

[1] we have 0day now running and reporting problems mostly private to 
me, I just didn't have the time yet to closely look into the results 
I've been getting because there seem to be some false positive test 
failures in some unrelated tests.

-- 
Cheers

David
