Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795515521;
	b=kaNvd44EEvfddbSKN1PLaBndwU01UrSQ95MiUHqK79cF+qsH2wV12/rGKaoylu7XGqX3
	 a4lccJRk8LJlXRBiiRvqkViiq23/aD4JQk44B8Db9G/KxAuu4NgaH/jrlExw9Zpf0CHXd
	 jSQ5GrQZLhq4Hskvj6afq5iYAcmfCZcaNV8xcD6YIr8LjBkzQCADYINwMlu8OiLogdDyk
	 ImqHFarwnYHmE3PJFq5A1BVSDNyxeGqFSAc6W4Yblg+oByjBI1KBEYvv65EdivJfR6VbK
	 ghZCnGexqh3N8WfjNuK96queBxxI7ARAd/UkZWCAq2oY0zhnyxv5dwV0MxqKgIdfEWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795515521;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=AKiFwm+7f8keg9BSmFTfyVt0HWfL4qhbZCPdmx3K5E0=;
	b=VHtwkVfmTu1Djd33+b1YWktk7E0R/swvKXDO6zcZsDAJmItMTevOz3uXPeM23y4VAJ08
	 N8hP9QByt2gBUcwN99tr7n2Z0jqIxhLGhMxBDkpQBD6lt2F+SCp8hvvEQ9B71ilEp0pVh
	 mOzqNwesPMRFg9LUfzZX/rSmQfHJGLXMSKaDWzcR3KYdVhsq0PYCYQ5Rh9z7DbDbhrRWL
	 4/CnMmPJt515m08uYBOMwhGiyMhbRepbOZYdtWsrKRW2V2dzcGI83XpfAlPY2UXr1EdP9
	 Z2wbTL3n3ZjR+ozNOgmng9HBeZGln2WHKfcxqucfCMgLaA6cKdu7MICrhiPPuUMxvLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IHJiUUa3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C143E606A33B
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 10:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IHJiUUa3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B7D1F000E1;
	Tue, 24 Nov 2026 10:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795515521;
	bh=AKiFwm+7f8keg9BSmFTfyVt0HWfL4qhbZCPdmx3K5E0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IHJiUUa3DYIuLddxK9HN8d3TCKL5vqQpMhWpQE2EUp0edxCvqON4uqdQs9yisojSp
	 zvAYX9GdlLNLlwAfIce4HAqfXehBlah12rcSEDVdYBF3bGmbmvcrme4zJfWPLE+mYo
	 Z/umN+7bBeW+Jqq8Ws47TiITnCBDYyPthuDvDMX5bmhTgpdAKo98RFf8xOoY3syWfl
	 J0oPt+RpyAdRtHBljWKoMEClf3dnfIlb76C7vpYZIy4K6KJ2GnXZfDGcv4UTE92sGt
	 SZOjfhJytj+uYzxXFDFOAne/pa7g0xRybZTvILq9P0gp4UwzSa9b//msTLmZpgjAdA
	 RJoOcMsr0xb6g==
Message-ID: <dab89ad9-dc90-497d-9fc2-08d40fb1525d@kernel.org>
Date: Tue, 24 Nov 2026 11:18:38 +0100
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
Subject: Re: mm-next: manual merge of the akpm/mm-unstable branch
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <a2b9c99e-b5d3-428a-9b9f-0761b352dbfd@kernel.org>
 <20261123103453.953259f94d3c5a0fae1c50c6@linux-foundation.org>
 <16e3b64f-1f12-4f4c-862c-056c7acbdb3e@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <16e3b64f-1f12-4f4c-862c-056c7acbdb3e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/23/26 19:50, David Hildenbrand (Arm) wrote:
> On 11/23/26 19:34, Andrew Morton wrote:
> --- a/mm/vmscan.h
> +++ b/mm/vmscan.h
> @@ -77,6 +77,9 @@ struct scan_control {
>       /* One of the zones is ready for compaction */
>       unsigned int compaction_ready:1;
> 
> +     /* The allocation may not steal from other migratetypes' blocks */
> +     unsigned int nofragment:1;
> +
>       /* There is easily reclaimable cold cache in the current node */
>       unsigned int cache_trim_mode:1;
> 
> ---
> 
> 
>> 
>> Ridong's series "mm/vmscan: move tracepoints to mm/ and add MGLRU
>> tracepoints" is large and contains a lot of optional code movement.
> 
> Yes, the move to vmscan.h is the real problem.

I guess this one not optional for the series if the structure needs to be
visible to multiple .c files.

>> 
>> So I think at this time we should drop it and ask Ridong for a much
>> smaller and tighter patch[set] which just adds those MGLRU tracepoints.
>> wdyt?
> 
> It's a good learning experience on my end ;) I don't care carrying the fixup
> forward.
> 
> We'll just have to let Linus know about it.

Yeah Linus always says merge conflicts are fine so I'd only start dropping
things when there's something more serious e.g. a semantic conflict. We need
to learn to live with this.

Thanks!

> Later, for changes that go through my tree (PULL requests from other components
> to me), I can just fix that up when merging and nobody will ever now.
> 

