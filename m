Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1A0497396
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 16:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662159; cv=none; b=VUiGa/W6v0ia4mkxQED54kQt3h9JhCGF39JUJaG+9Db4ijRpBNLNtK5WCjg+peUZ60sXokz8O0LznWQrXe1l2b4Mux5Yq01FJ7114nsXd89IkRuAoxZjc3ON435gMpsKoRLu4GcX5rThBrRwniu8+3dZu0GmMHBKObI77OqF+JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662159; c=relaxed/simple;
	bh=y7J4hky0rlWea8SsYwrX0TF7Y1OqpWNCeIk55f14heg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=gj9Zh7WvLGCLbDbA7n7EdPjYN1s5Gw8SLv9ZaXCpF05L2q3bo9aFPMjoeHBeDIIPMsYP3q59dCd93RqYvudk7kcGuvtieDz+pTiuTEA4r2SrGfAit6gZ1oeJB7W3H6054WnKRUuRydHxnw3ILKuvN4XH5KqnUTfZehVdM2lJcw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BB24ejYj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BB24ejYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44031F00898;
	Thu, 17 Sep 2026 16:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789662157;
	bh=lWKk6VoHrKC3iYLdqNgUoi+2NqdVBf14F04xFZxpklE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BB24ejYjYhTa3VGHJVwJS3Zuf8vBxfWXP1gP7QTxzfgU5BVNQNyUfoi8/gXSmeSpg
	 pAFKA0X8j9JJLhVqrBpQ4pVA9xU3C0fQUCx/q85YkYj0q/zuPTyStNLhGVsTQp72Tu
	 wkus1re/GMkTSF52HiCObx/xxTvBajnrCaatMnGM=
Date: Thu, 17 Sep 2026 09:22:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org, Suren Baghdasaryan
 <surenb@google.com>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION
 892f5b3b07e5b07f2f29c87750ff94fa58dcab73
Message-Id: <20260917092237.5ba48bf16e8406e3753eacaf@linux-foundation.org>
In-Reply-To: <202609171758.049ApqPm-lkp@intel.com>
References: <202609171758.049ApqPm-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 17 Sep 2026 18:00:02 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: 892f5b3b07e5b07f2f29c87750ff94fa58dcab73  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Error/Warning (recently discovered and may have been fixed):
> 
>     https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@intel.com
> 
>     fs/proc/task_mmu.c:3448:3: error: call to undeclared function 'drop_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>     fs/proc/task_mmu.c:3450:3: error: call to undeclared function 'reacquire_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

argh, we already fixed this five times.

Confirmed with x86_64 and
https://download.01.org/0day-ci/archive/20260917/202609171159.oaB1OaSG-lkp@intel.com/config

Suren, I'll drop the series.  Please check this (and the 'lock_ctx_mm'
defined but not used failure) when preparing the planned respin.


