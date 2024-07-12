Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD67E573
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 03:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720755955; cv=none; b=nsCKcVRQR/j8JGnO/UO/CJDQfXO+nuiuUBWUlH769cpmLUO8B0HRgjsllJVwaYJ4gtL3ZNU/Z7rq8AZhWIJkIPJH1+HXMBjz9SJdw8XPXwSz+EjdjwAEjXcaSXue27X8v6SoxHDJYWrFO6ZfY3q2B4OEF0mo1kKXkkt7s8ASbi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720755955; c=relaxed/simple;
	bh=RAT+VpaAw5ddIENCp6EgCkAQluc9EtbO12DY6YQegr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gKWgupzYy1iDRYee1OZz1LUqjvl3f0/aTMJ0TrDA570DkviMOk13VBoQcCONQ9G2879DebinGVIR/yoWyfO6ecQ89TwPYbghWeA2cMYQmfKhCxbZ7Gm+d4K9b3BiJFeKVG03BfsllCU8rj6u9mUwiTyCwOsC6pxLz+eEbefDMoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ebbGeB5P; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ebbGeB5P"
X-Envelope-To: hughd@google.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720755950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MdExeQJlhs/NfrSgGERL/DB43h/UqmjelBRfvohOdYA=;
	b=ebbGeB5PjPbAlB3gDlmH0bxYEtjhRg46whFmWxgb3VM4Uz/aDnc34nFw1ekbStGE53O25O
	kNeAjItpwocaR3Cof998mqXGj+OFhnEePlAOXyZLNBnM5ujQBunDtzBN8QjycW72ZRTjnv
	XR0FrzwtHgmVDa/pE4D9jq47sp0q1Pg=
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: aris@redhat.com
X-Envelope-To: mm-commits@vger.kernel.org
Message-ID: <f20a719c-5697-4b76-a2ca-5a574e3132b0@linux.dev>
Date: Fri, 12 Jul 2024 11:45:44 +0800
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: mm.git: a small error in mm-stable
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Aristeu Rozanski <aris@redhat.com>, mm-commits@vger.kernel.org
References: <85b0d694-d1ac-8e7a-2e50-1edc03eee21a@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <85b0d694-d1ac-8e7a-2e50-1edc03eee21a@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2024/7/12 11:30, Hugh Dickins wrote:
> In looking through a "git log -p --reverse v6.10-rc6..HEAD"
> of mm-everything, I just noticed a small anomaly in mm-stable:
> ac90c56bbd73 "mm/ksm: refactor out try_to_merge_with_zero_page()"
> modifies mm/hugetlb.c! undoing a oneliner which had been folded-merged into
> 003af997c8a9 "hugetlb: force allocating surplus hugepages on mempolicy allowed nodes"
> which comes just before it.

Yeah, it's strange, that commit I sent should just change ksm.c

https://lore.kernel.org/lkml/20240621-b4-ksm-scan-optimize-v2-1-1c328aa9e30b@linux.dev/

Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
---
  mm/ksm.c | 70 
++++++++++++++++++++++++++++++++++++----------------------------
  1 file changed, 40 insertions(+), 30 deletions(-)

