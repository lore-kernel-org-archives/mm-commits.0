Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795508558;
	b=gXg9ajiZL0FR7kzgqAgdPfU9WPArdpa4b9XQWi55XlY7hNdZTljScVDvgu2v18XcmxEq
	 8m5VUu6APzbv43LmNNUWLfZrbgPJCU7wBr2uKlAaawtCtneWIs1KNGEHP+1UOqwsgH/wg
	 C5jXnw66Ztff9FkykQV6gGQhdSpOv9kJksBXwdUHxYNng3c6aOiZC21g+ESEYnUAZ+A9u
	 wCbo3RaHsAd6p3Uubq6f4ylxD99aEnvG/Z42QL/8jazgKbys3BgNHSY1poFVMcigTi82K
	 0aVOLQ7pZiGP256Y+yFecp1/7VQ4ROvzS92Ti6m839BNrbr+Oa0gBq/gqF+I40I1WAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795508558;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:Content-Language:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=kv0XCIwgkvWUuyx/4DBxRlpACpywnFccpNNeXHlVO9I=;
	b=Wj7GSqmnaWjU47ScoU9Hlmfs54b9PwwwHPrA8pwzxRKQAkpUWkaXK5K9BwlQpzMZi1mv
	 cYnlioWgSncIqEBp9pBUjUZQTd6qWp1r8pd3VIwgCqyWaQyH2qyiT+M7+0fU6djH5zm3y
	 dpsaeQ1+Rfg4NZhaiN1DueYwf7/lsLFxazk+EMiTomYk9t6vU0cgyGhjlS4n+ne7w3uGZ
	 hYJCyvTuJ8yYSYF+fuXbTA+YC2zKKZiZVO2elqtjgvRZjgD7WfWJdVJaKPsaeKCurq08e
	 xtiZcBoZ51RurBVePoLhWUZ1wnf6PMvSQBT8ZNpwVlN78/03Ag441ab9QjE1vhCjEoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kmxMMbTg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90002606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 08:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kmxMMbTg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6F61F000CF;
	Tue, 24 Nov 2026 08:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795508558;
	bh=kv0XCIwgkvWUuyx/4DBxRlpACpywnFccpNNeXHlVO9I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kmxMMbTg+dP7ZjGNrpgw8we4BkdQzMkfzf3LSzxLSIDfCmMymJiuPAfseij5pI3Nz
	 aR1JWtdFA8k1W4PVqvzhp/MVXQcCbgGs9six8+jGWhTukQ7rKUqtKt5mF2cZIesde6
	 II+Ra2PkBz8I+PTKdByTo1hEXyHG9yx9Ao8FEMPVU4cRG9UBA1dKxTRUsjDr+mIHc9
	 YXOPmJh2a49RvdrwNloPu5p1pvL44dLbX/Fr5OOkf9ddX3pVOAdxYFxVlOVQ/BP7t5
	 PdemkCa+MC12opRpDH0TYN23bik9SK7//d5wr7GUfCutPd2cWuQWLG44oVjdaqKA58
	 pppwXa2gZXR1Q==
Message-ID: <8691815d-1c62-4519-907a-110b2d12b9b5@kernel.org>
Date: Tue, 24 Nov 2026 09:22:33 +0100
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
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, mm-commits@vger.kernel.org
References: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
 <20261118212538.7e6f11f0553d548a03c9c456@linux-foundation.org>
 <b7474fd4-eb88-4472-9e8f-26ef6c646694@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b7474fd4-eb88-4472-9e8f-26ef6c646694@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/19/26 11:07, Vlastimil Babka (SUSE) wrote:
> On 11/19/26 06:25, Andrew Morton wrote:
>> On Wed, 18 Nov 2026 11:21:47 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
>>
>>> Hi Andrew,
>>>
>>> during some chat with Lorenzo, it occured me that it could be useful if your
>>> mm-commit mails (addition, merging to mm-stable, drop etc.) were replies to
>>> the respective patch postings, which would put them next to the patches in
>>> everyone's inboxes. I think Lorenzo started to doing that on his receive
>>> side with postprocessing.
>>>
>>> While I haven't checked your scripts, I naively imagine it shouldn't be hard
>>> to add that In-reply-to: <msgid> header. You already have the msgid for the
>>>
>>> Link: https://lore.kernel.org/<msgid>
>>>
>>> part. Maybe it's tricky when there are more Link:'s than the patch posting
>>> itself. But actually after Linus initially hated these automatic Link:
>>> additions, he later settled on the Link: https://patch.msgid.link/ template
>>> as acceptable to him. It's sort of documented in
>>> Documentation/process/maintainer-tip.rst too. So changing to use that
>>> template should allow to easily grab the right msgid to reply to even for
>>> later actions on the patch, than the initial addition.
>>
>> np, that should be working now.
> 
> Seems it is, thanks a lot!
> 
>> I switched it to patch.msgid.link for just the Link: to the original.
> 
> Yes "just to the original" is what I meant.
> 
>> Konstantin's
>> https://lore.kernel.org/all/20240619-docs-patch-msgid-link-v2-2-72dd272bfe37@linuxfoundation.org/
>> was helpful.
>>
>> I hope patch.msgid.link is durable.  It's owned/operated by the LF so I
>> guess it'll be there for a while!
> 
> Yeah. After all, the same is true for lore.kernel.org :)

I works but it makes b4 go nuts when I try to pick something that Andrew picked (too ;) ) early.

 b4 shazam -sl -S https://lore.kernel.org/r/6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com
Looking up 6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com
Checking for newer revisions
Grabbing search results from lore.kernel.org
Analyzing 3 messages in the thread
WARNING: duplicate messages found at index 1
   Subject 1: + docs-mm-fix-stale-split-page-table-lock-references.patch added to mm-unstable branch
   Subject 2: Docs/mm: fix stale split page table lock references
  2 is not a reply... assume additional patch
Looking for additional code-review trailers on lore.kernel.org
Analyzing 0 code-review messages
Checking attestation on all messages, may take a moment...
---
  ✓ [PATCH] + docs-mm-fix-stale-split-page-table-lock-references.patch added to mm-unstable branch
    ✓ Signed: DKIM/linux-foundation.org
    + Link: https://patch.msgid.link/20261123053858.BC7241F000CF@smtp.kernel.org
    + Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
  ✓ [PATCH v2] Docs/mm: fix stale split page table lock references
    ✓ Signed: DKIM/uniontech.com
    + Reviewed-by: David Hildenbrand (Arm) <david@kernel.org> (✓ DKIM/kernel.org)
    + Link: https://patch.msgid.link/6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com
    + Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Total patches: 2
---
Applying: + docs-mm-fix-stale-split-page-table-lock-references.patch added to mm-unstable branch
Applying: Docs/mm: fix stale split page table lock references
Using index info to reconstruct a base tree...
M	Documentation/mm/process_addrs.rst
M	Documentation/mm/split_page_table_lock.rst
Falling back to patching base and 3-way merge...
No changes -- Patch already applied.

-- 
Cheers,

David
