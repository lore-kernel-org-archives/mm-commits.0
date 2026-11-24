Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795513797;
	b=GCUUJIDcttLHzz3zK9mYOv0mCRm9pQD2OdDhg+Clt6WlWkavtzlX+LAYs24LagXCJObz
	 nA8eLpzlXA6+/x2eADgYkZCjfmIA/ZCKadZN78Z8aGq+aHiEsaXnS9BrmGLP3ZDuKx2N1
	 wwU35RdNTBrfjmzZlzvQqTsZZi9l+AzspXxPgKnto0/kc0PWqHlk9sccyNf1O/T3460wt
	 lqXbCF31fMx9Otw8ywGB/5Q0UzLnnWK7ulxbBzg+XBKlLpD8wndfVGe2jZfUowsWteOk4
	 pX/fF7fWP+I12ZsC7E4Nvg70umHjBZHgbNMr0iEq0Usny2039IbUNpT8Fl+asaq6I+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795513797;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=reUGuo+ujbiHH1pvSPihUh3BtOf2xLUPR5B8ZOYkGlg=;
	b=I0PQGGrbMZc+LXJgSyMQAHpaoXYuz9Uu45rZDJpESSOFWBT6JrPRDLLSShG938YosYDn
	 IEEtny2EhpjwI9q6Agr/xRhgJetE/eezLuB14jUULt1VXU/nS8N/7T4czFaDfhW9RoeF1
	 7O5EqNvbmUkKVQ6oD8fJb7N0TJy3TbPC3S3WSZnYICjNhh/47JXYxmOWuEL5aPMXNwg8M
	 eiuuM4S47DbhQM0/fEG1+6kqxDytD2N+TjguS2eZya+6lrR0wzYfagQUYiv7KuBA6yLsA
	 BCGlNzTNSwXhlQvfv0cJ/ZEpLSJfoZtsxa45BZChRTrTTLYTl/1V6/MrjuXdPZaHGEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HaiW9F+N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08CD606A842
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 09:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HaiW9F+N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032691F000CF;
	Tue, 24 Nov 2026 09:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795513796;
	bh=reUGuo+ujbiHH1pvSPihUh3BtOf2xLUPR5B8ZOYkGlg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HaiW9F+NKVAhJxL8XzVEL6EUKwRPiErG5y/LbDmuadChRjjUpgsqr0l2tdHOEXL0x
	 NH/6oc2yeA0YtY5tmm9URMt9NtDi7VN0GKPcAc0/xnZ19C7MHqjoBjpqMRhmLgBbcc
	 fJ4dDI84JdGgpj4LKzIQaeQsLbLe48wMtcpj/2v+KprL9q9Zwho2Gn/Rlra7xbi7g+
	 JYcX2IP4n2UcrVoFO5nnFYvDOLQWQZhfeEOYFiG5dZ3tejzzvqzaYxaBg+1ke6QhDl
	 7NrsQM7t/0xmJ73H2hsyIVIv+tk+HcqxZXlVImc8g4BA/R8T3NGkTVioa4bqZWZwQ6
	 aeSw1rPSn0Wog==
Message-ID: <7ebcd1fe-8a98-4c12-9508-0399570e6a6d@kernel.org>
Date: Tue, 24 Nov 2026 10:49:53 +0100
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
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, mm-commits@vger.kernel.org
References: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
 <20261118212538.7e6f11f0553d548a03c9c456@linux-foundation.org>
 <b7474fd4-eb88-4472-9e8f-26ef6c646694@kernel.org>
 <8691815d-1c62-4519-907a-110b2d12b9b5@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <8691815d-1c62-4519-907a-110b2d12b9b5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/24/26 09:22, David Hildenbrand (Arm) wrote:
> On 11/19/26 11:07, Vlastimil Babka (SUSE) wrote:
>> On 11/19/26 06:25, Andrew Morton wrote:
>>> On Wed, 18 Nov 2026 11:21:47 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
>>>
>>>> Hi Andrew,
>>>>
>>>> during some chat with Lorenzo, it occured me that it could be useful if your
>>>> mm-commit mails (addition, merging to mm-stable, drop etc.) were replies to
>>>> the respective patch postings, which would put them next to the patches in
>>>> everyone's inboxes. I think Lorenzo started to doing that on his receive
>>>> side with postprocessing.
>>>>
>>>> While I haven't checked your scripts, I naively imagine it shouldn't be hard
>>>> to add that In-reply-to: <msgid> header. You already have the msgid for the
>>>>
>>>> Link: https://lore.kernel.org/<msgid>
>>>>
>>>> part. Maybe it's tricky when there are more Link:'s than the patch posting
>>>> itself. But actually after Linus initially hated these automatic Link:
>>>> additions, he later settled on the Link: https://patch.msgid.link/ template
>>>> as acceptable to him. It's sort of documented in
>>>> Documentation/process/maintainer-tip.rst too. So changing to use that
>>>> template should allow to easily grab the right msgid to reply to even for
>>>> later actions on the patch, than the initial addition.
>>>
>>> np, that should be working now.
>> 
>> Seems it is, thanks a lot!
>> 
>>> I switched it to patch.msgid.link for just the Link: to the original.
>> 
>> Yes "just to the original" is what I meant.
>> 
>>> Konstantin's
>>> https://lore.kernel.org/all/20240619-docs-patch-msgid-link-v2-2-72dd272bfe37@linuxfoundation.org/
>>> was helpful.
>>>
>>> I hope patch.msgid.link is durable.  It's owned/operated by the LF so I
>>> guess it'll be there for a while!
>> 
>> Yeah. After all, the same is true for lore.kernel.org :)
> 
> I works but it makes b4 go nuts when I try to pick something that Andrew picked (too ;) ) early.

Hmm wonder if there's a way to make b4 filter those out, or we ask
Konstantin to add that way.

> 
>  b4 shazam -sl -S https://lore.kernel.org/r/6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com
> Looking up 6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com
> Checking for newer revisions
> Grabbing search results from lore.kernel.org
> Analyzing 3 messages in the thread
> WARNING: duplicate messages found at index 1
>    Subject 1: + docs-mm-fix-stale-split-page-table-lock-references.patch added to mm-unstable branch
>    Subject 2: Docs/mm: fix stale split page table lock references
>   2 is not a reply... assume additional patch
> Looking for additional code-review trailers on lore.kernel.org
> Analyzing 0 code-review messages
> Checking attestation on all messages, may take a moment...
> ---
>   ✓ [PATCH] + docs-mm-fix-stale-split-page-table-lock-references.patch added to mm-unstable branch
>     ✓ Signed: DKIM/linux-foundation.org
>     + Link: https://patch.msgid.link/20261123053858.BC7241F000CF@smtp.kernel.org
>     + Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>   ✓ [PATCH v2] Docs/mm: fix stale split page table lock references
>     ✓ Signed: DKIM/uniontech.com
>     + Reviewed-by: David Hildenbrand (Arm) <david@kernel.org> (✓ DKIM/kernel.org)
>     + Link: https://patch.msgid.link/6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com
>     + Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Total patches: 2
> ---
> Applying: + docs-mm-fix-stale-split-page-table-lock-references.patch added to mm-unstable branch
> Applying: Docs/mm: fix stale split page table lock references
> Using index info to reconstruct a base tree...
> M	Documentation/mm/process_addrs.rst
> M	Documentation/mm/split_page_table_lock.rst
> Falling back to patching base and 3-way merge...
> No changes -- Patch already applied.
> 

