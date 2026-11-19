Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795082837;
	b=vUAZqcmfosDj7t4uaiVjzwj3wbKkssRxpoCpHp0gBSugftUmKI54t3fTk1HmGTqRMwCg
	 IzTTha98/FQjePjnGBs1jV8bctybf1sKhx/iOVDuSyNtf899WsCQX1Obv9ZWswugR/4yS
	 P2uFra9gG5xKVYQYtUhGLQDoTuQ+zXuHuAo3dm4gcJhj2M4n6NtXuUfY2GPEZ+V00bqwI
	 21ka5cZUAW7q8Tfy+I/FBa7GhnQc5YZpm+p/jEjbhEjZGpKp29gejMN3bP/vBdF/ZZ1u2
	 rA2GmRozSeQJhWgpXtQqObD+BzehfeAGSFqBm+R7YGpgjD//CQg6JzzFVMaQVFh0B3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795082837;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=HGwpdbTlNY+DvHr0Ucumf9a6qslnhFBKpJ6OXW/8N7I=;
	b=XeHZXEUBg6gu4SD0y3dsZ81mvA8hC2L5eVEf6/EjfrqUg1EsBXu+65WDueC+rWUiT1ue
	 7ko4QWco9y/Z+ik3G6SSag2kIfT3H8jN8XnIGv1MtvZjq7k3YOn1OE3XoxmPp106G7DMm
	 T2kS/4TaV5pKJFjxN6jEHsKvG/GJqIYjJdm2ZQTjlZUZ41gtoRnE8HrgsjqDHWxFFKoGl
	 RwY+oBWRKg3Zr2qb5TPy8OUSZZz0sf9h7mAeIehjcONQ7BLSni5NepynsAqzEclx6pqj/
	 nGsrbZ/+7lSFyIa7xIUGBdsn1wRZ1lyiEmMw6S1FD1fmhFyhjT9rMYBEOdhxeBuAwzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UaA7sgxE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386A6606A324
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 10:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UaA7sgxE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32DA1F000C6;
	Thu, 19 Nov 2026 10:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795082837;
	bh=HGwpdbTlNY+DvHr0Ucumf9a6qslnhFBKpJ6OXW/8N7I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UaA7sgxEjbnM9lsll7m5KgsMYFJd/s3uxUFI2bLYfNkP4xiiVSWClXJzP34gFqFMF
	 8MmD49ZJs6FL2WkajJH2j3ammOlkMKuaM6TcpGjjbp4cYNc66vQRjmNkMADx2boICr
	 JduAvVFaZQWFxYapXoKoPRFJR1F+EEzidfb9tvrMYNRtmI99XYA1UjGk8f6CAMo92F
	 o+CBlayFEkHfgA8LmOMCoE7Vl84FXAal8356EtDgdIs3vRhREPuV/tCObC4w04Tx+2
	 XcrTVHER/wnlamJeik+PtnHk9nWTrw9qkzip/nFkR/GHcJxthFGLb4X086JZQN6FHW
	 cqxmnoImQ4Z6Q==
Message-ID: <b7474fd4-eb88-4472-9e8f-26ef6c646694@kernel.org>
Date: Thu, 19 Nov 2026 11:07:13 +0100
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Using In-reply-to: <patch posting> in mm-commits mails?
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, mm-commits@vger.kernel.org
References: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
 <20261118212538.7e6f11f0553d548a03c9c456@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261118212538.7e6f11f0553d548a03c9c456@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/26 06:25, Andrew Morton wrote:
> On Wed, 18 Nov 2026 11:21:47 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> 
>> Hi Andrew,
>> 
>> during some chat with Lorenzo, it occured me that it could be useful if your
>> mm-commit mails (addition, merging to mm-stable, drop etc.) were replies to
>> the respective patch postings, which would put them next to the patches in
>> everyone's inboxes. I think Lorenzo started to doing that on his receive
>> side with postprocessing.
>> 
>> While I haven't checked your scripts, I naively imagine it shouldn't be hard
>> to add that In-reply-to: <msgid> header. You already have the msgid for the
>> 
>> Link: https://lore.kernel.org/<msgid>
>> 
>> part. Maybe it's tricky when there are more Link:'s than the patch posting
>> itself. But actually after Linus initially hated these automatic Link:
>> additions, he later settled on the Link: https://patch.msgid.link/ template
>> as acceptable to him. It's sort of documented in
>> Documentation/process/maintainer-tip.rst too. So changing to use that
>> template should allow to easily grab the right msgid to reply to even for
>> later actions on the patch, than the initial addition.
> 
> np, that should be working now.

Seems it is, thanks a lot!

> I switched it to patch.msgid.link for just the Link: to the original.

Yes "just to the original" is what I meant.

> Konstantin's
> https://lore.kernel.org/all/20240619-docs-patch-msgid-link-v2-2-72dd272bfe37@linuxfoundation.org/
> was helpful.
> 
> I hope patch.msgid.link is durable.  It's owned/operated by the LF so I
> guess it'll be there for a while!

Yeah. After all, the same is true for lore.kernel.org :)
