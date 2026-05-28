Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDE43DDDBE
	for <mm-commits@vger.kernel.org>; Thu, 28 May 2026 17:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779990549; cv=none; b=cFqL9LstoGxHLP5VFWZiu28TwGF61PFwFedzJtTqOKFQAZ0Xvc5baacmC2RA6cmv3mtN7Ja5GP/2ZGUW0bk14CVYmWu75LLZG0J/z2N02X7PY1+GMbUI0yFQAJhzyQQlYjZ0LhiO8ZfBedVf94WhjmJiPhB7v3/HEPBTVut+y9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779990549; c=relaxed/simple;
	bh=8PIv6MyHiB35Td3BeCQRaJ/31mmQ3YFvH7BUAftNYh8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hZxRtCA67R1obwaKUR2npCE+NohX28CA4WfmP1G8DSjZgGCghG6y2Cix9+ERPQ3yXFtBi6GqxyU7fd2R2bTImw+gPdMN5Z3170q41J1jBmv3h4FqzEStDlodrgvlQa5B69xfmOTAUl24KlSPNN07RLQQ67yutY4vYwAC9YdINd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MY/Ty3Ox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MY/Ty3Ox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417601F00A3D;
	Thu, 28 May 2026 17:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779990548;
	bh=fU2fx7cAzyqWEpad/qbOWMkjQQ8+Xrw5mf2h6UogI7w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MY/Ty3OxC0VJJ2tmxGdI9/1Xhu+ZNo/52sij3DfaFLW1K+l7WPr9NcmnJtt2io6Lg
	 1g6teUcHzVsOz3O6oxRt9+EuXV55d9uF9EkgOk8ml44yKVmp+9SfzlrqJIPswtkLbD
	 m3QQaMrk18vgVaG7MTccvsXR2N6a6NpLdmFRSacge0vNNXcRqj7pFIN6tsxPy2iv55
	 YbZSY0fr61UO0EY/5Tdjpjq8WA57exavJVnA+0FurXWbXEbB7N+z+0UO7bCPwNumxf
	 IMrAs+sdJbiRtUoieR/bQjYnQAdsa9s6YwcE/MvZc2UX0V2c077OVknG00C/e+Q76j
	 kMKl6Wn19Nabw==
Message-ID: <2e6f54ad-c9fe-4ae7-b133-0957b03d1f5c@kernel.org>
Date: Thu, 28 May 2026 19:49:05 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: +
 maintainers-add-slab-related-scripts-and-tools-to-slab-allocator.patch added
 to mm-hotfixes-unstable branch
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@kernel.org>, mm-commits@vger.kernel.org,
 roman.gushchin@linux.dev, rientjes@google.com, harry@kernel.org
References: <20260525174125.746121F000E9@smtp.kernel.org>
 <5c340177-548e-4c9d-aaaa-d28b30b0903a@kernel.org>
 <20260528101401.c4727d268ee70092e7234966@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260528101401.c4727d268ee70092e7234966@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/26 19:14, Andrew Morton wrote:
> On Thu, 28 May 2026 11:44:20 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> 
>> > From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
>> > Subject: MAINTAINERS: add slab-related scripts and tools to SLAB ALLOCATOR
>> > Date: Mon, 25 May 2026 09:26:39 +0200
>> > 
>> > Make sure the maintainers and reviewers are CC'd on changes to the scripts
>> > and tools that depend on slab internals.
>> > 
>> > Link: https://lore.kernel.org/20260525-maint-slab-tools-v1-1-d66b69f1412a@kernel.org
>> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> > Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
>> > Cc: David Rientjes <rientjes@google.com>
>> > Cc: Roman Gushchin <roman.gushchin@linux.dev>
>> > Cc: Vlastimil Babka <vbabka@kernel.org>
>> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> 
>> Hm I've put that to slab/for-next too, and the slabinfo patches that
>> triggered this update as well [1] and they are also in the mm tree.
> 
> It's confusing when a git tree owner sends a patch.  I don't know if it
> means "please apply this" or "I intend to apply this, please review". 
> Not a huge issue, but explicit clarification would be helpful.

Yeah sorry, I tried to indicate by [PATCH slab] but it was subtle.

> I'll drop the mm.git copy of this.

Thanks, please drop also the 3-patch slabinfo series.
https://lore.kernel.org/all/bc96e4ee-faac-4bed-ac3d-54f1003be62d@suse.com/
