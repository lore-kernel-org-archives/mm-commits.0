Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADFA37A828
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 17:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783014491; cv=none; b=hFKBdWJCE/g34l/SU4me3mIX4Ap45KOl2fW8LUAj0BcJeIpx+PjMhq5uqrT4zMRJ0uqegKZZsY+eejrviOX0HYkaOp9cuN8YiADhm/3aUyW26N2PTwcsRkx6VUsF+PK1zH+6zHlgKdSTfoHQOnwQWcP2xXDHTG6CsxzmX9Kb2+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783014491; c=relaxed/simple;
	bh=Wx8LvJ6VxBtTDed4i92jqBFvlQA1NiJ4kYvsgz4I0nI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=WOtscNmdDVGYHHIfn3jW7LYSfPok6aG78UDT9aOfN6ilXqFywC9F3J6JHSiJqbsg+QHoHCbwF1/jslPopM4iMGZGv3Hu/VUzbGJYXUXooHhELGbcDe8kC1WuVTUKe/E7cxucCyoBceFVDohiuocmOvWIreIuOMAY3ETxv7kNPdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fp7zdAg8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fp7zdAg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A071F000E9;
	Thu,  2 Jul 2026 17:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783014490;
	bh=3wIIvBhOVbUuy4vpl9hlDspmUEb+HloUkA6ennnR9Lw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fp7zdAg8doKNxnr8JIRlrlwniwEbc2HqbslY3XBOOzZ/cebxWmBGbu17RG26shWqO
	 fN+wdt70I9KdmQEmzsOHKtedRldBM4wlmHgaYqfudU+PWStEcAnKL+QsJtwoWRqTEf
	 nvaJY14lUd/a1gBpJeDOFCiNOAN9Ti04lOsYsi7A=
Date: Thu, 2 Jul 2026 10:48:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: David Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-new] BUILD SUCCESS WITH UNVERIFIED WARNING
 f4b4fac1867633ac17c35842f03933f6a7a4425f
Message-Id: <20260702104809.6a137d91eb7e42875b16afda@linux-foundation.org>
In-Reply-To: <202607022346.lOHuTDpa-lkp@intel.com>
References: <202607022346.lOHuTDpa-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 02 Jul 2026 23:31:59 +0800 kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> branch HEAD: f4b4fac1867633ac17c35842f03933f6a7a4425f  mm/swap, PM: hibernate: atomically replace hibernation pin
> 
> Unverified Warning (likely false positive, kindly check if interested):
> 
>     https://lore.kernel.org/oe-kbuild/202607021433.DYT5fDqE-lkp@intel.com
> 
>     mm/vmpressure.c:254 vmpressure() warn: check likely/unlikely parentheses
> 
> Warning ids grouped by kconfigs:
> 
> recent_errors
> `-- microblaze-randconfig-r071-20260702
>     `-- mm-vmpressure.c-vmpressure()-warn:check-likely-unlikely-parentheses

Thanks.

I can't reproduce this with that .config and microblaze gcc-15.2.0 or
gcc-16.1.0.  And I can't see anything wrong with

	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) == tree)
		return;

