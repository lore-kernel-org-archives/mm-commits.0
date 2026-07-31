Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC27449B0A
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 17:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785517550; cv=none; b=UGz8nGyzj32X4y80/ogSopDi3xG6IqJDLisO2puz9h7JGB8WuCVBp7dL4JhDb5JHkkqpxe0XjrtwM63ar6em5dWWGmnL8ellzR4i9Yn8Ela7tyNNfcPBv+ppxo4u3NpPREeoy0GoCcw1FKuKQ3RjGVGyJ4/NKqaYP6ancTl5WZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785517550; c=relaxed/simple;
	bh=K3AwgeGWDCNiRbZqQo1KG77Cw+/Z87pjr9pn8txUJcA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=rxZ/xC/9OVxk8iHM8+XzUYu1Jn/+Qt3RzC/V3I9EiJs7h3wZShaW5MkMY1ZzFdxAoALdGk9XFmTpIKJr7zKRIP9Gxv7AR7rZu5egvH06GtISoWhI5wUB2/zxp6uxV0dtxdrg7awSsI4UC5eT411oYSh0pPC8+FYcbbPygYb1IK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zVujV1G3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zVujV1G3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF181F00AC4;
	Fri, 31 Jul 2026 17:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785517548;
	bh=TqAIK+llZBMk6DlijQEEYbjFZ2sn7l7HVlve64fFpcs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zVujV1G3bpuLx1untn6LC0L9LnhqML06gKvGHzDFq18UN9eR7GgjyoAguD19cc8kZ
	 w6Rs2pbBM9fYleHB8kup7z8qs2wQsHguFHll5/h6WikcKjh2PYftCazKsU/Jxj3L3c
	 h4wyrn4d3HRM1CAiNQTKyoPCQ5IVH3rZlQmVn5Ck=
Date: Fri, 31 Jul 2026 10:05:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Stanislav Kinsburskii
 <skinsburskii@gmail.com>
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 0c39e2f552f5e16be695cec3a1c77d6a6bf086bb
Message-Id: <20260731100547.57414d6c37e65f08eb52ef04@linux-foundation.org>
In-Reply-To: <202607312212.u1pPx1f6-lkp@intel.com>
References: <202607312212.u1pPx1f6-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Jul 2026 22:31:38 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: 0c39e2f552f5e16be695cec3a1c77d6a6bf086bb  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Unverified Warning (likely false positive, kindly check if interested):
> 
>     https://lore.kernel.org/oe-kbuild/202607120402.clBrrZQA-lkp@intel.com
> 
>     mm/hmm.c:673 hmm_do_fault() error: we previously assumed 'hmm_vma_walk->locked' could be null (see line 654)

Thanks, due to "mm/hmm: add hmm_range_fault_unlocked_timeout() for mmap
lock-drop support".  I think we've looked at this previously.

+	if (hmm_vma_walk->locked)
+		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;

...

+			*hmm_vma_walk->locked = false;

Stanislav, can you please take a look?
