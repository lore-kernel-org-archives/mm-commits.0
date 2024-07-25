Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AD981C6BE;
	Thu, 25 Jul 2024 21:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721942701; cv=none; b=fwULHd0uhGlXtsr0mfzY82e3ROLPa0fCpqiMLy6h3k2loH8KPRgAwJy3EpYceue3rNj4/dSk2ypj3fGOe1y47rt7e0GPFGM9njhhD0YIp8o26WyXooCPsHCj+dxfYvzUl6DUgStqiYZiUKOzrwXdaNP3N0LtQN43nnbdayumhho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721942701; c=relaxed/simple;
	bh=IHk3f+T3elnXYxk2bFb39E12U4MQ+JWRAjMNpEeGaaw=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=miKMRya6r/rbFKTK9BF2MfZpNuRAwjrULWPPvW932Ila1BElzk6YKHGyuMEFsmrzrp8lQMjXUUjPhLneNPY2IKRTXVj6uVVxeOYrIjS70vvARVKX5odo+SrE1xgixv/h1/Soze3O8tGwzVuK2OFc8oXnbXEYpvgHNMmikgP5h6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=urpxVPAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="urpxVPAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB3AC116B1;
	Thu, 25 Jul 2024 21:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721942701;
	bh=IHk3f+T3elnXYxk2bFb39E12U4MQ+JWRAjMNpEeGaaw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=urpxVPAst0WfLBiJXqT4GJekTjqJQBE1kHZny3Hoj11+7AGZCWnvJUC2ZcFPdcSOD
	 L1Id4q8iVFVa829kqndlXt0DS7j2EoWFx6ZuedEQar9thr99Ed8AceruYHGK7DUDBA
	 2V4RW+GzGlwJ/qRkNpuAPv05Eq7wen4yczWNV6g4=
Date: Thu, 25 Jul 2024 14:24:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: <mm-commits@vger.kernel.org>, <will@kernel.org>, <vgoyal@redhat.com>,
 <thunder.leizhen@huawei.com>, <tglx@linutronix.de>,
 <stable@vger.kernel.org>, <robh@kernel.org>, <paul.walmsley@sifive.com>,
 <palmer@dabbelt.com>, <mingo@redhat.com>, <linux@armlinux.org.uk>,
 <linus.walleij@linaro.org>, <javierm@redhat.com>, <hpa@zytor.com>,
 <hbathini@linux.ibm.com>, <gregkh@linuxfoundation.org>,
 <eric.devolder@oracle.com>, <dyoung@redhat.com>, <deller@gmx.de>,
 <dave.hansen@linux.intel.com>, <chenjiahao16@huawei.com>,
 <catalin.marinas@arm.com>, <bp@alien8.de>, <bhe@redhat.com>,
 <arnd@arndb.de>, <aou@eecs.berkeley.edu>, <afd@ti.com>
Subject: Re: + crash-fix-x86_32-crash-memory-reserve-dead-loop-bug.patch
 added to mm-nonmm-unstable branch
Message-Id: <20240725142459.d573ae747382d589adbce18a@linux-foundation.org>
In-Reply-To: <f177a4ec-821d-982d-3680-434861a4babb@huawei.com>
References: <20240724053727.28397C32782@smtp.kernel.org>
	<7898c0c5-45b6-9795-74a0-f70904dd077c@huawei.com>
	<20240724103752.f3ed5021d203d5e333b47873@linux-foundation.org>
	<f177a4ec-821d-982d-3680-434861a4babb@huawei.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Jul 2024 09:10:33 +0800 Jinjie Ruan <ruanjinjie@huawei.com> wrote:

> 
> 
> On 2024/7/25 1:37, Andrew Morton wrote:
> > On Wed, 24 Jul 2024 14:44:12 +0800 Jinjie Ruan <ruanjinjie@huawei.com> wrote:
> > 
> >>> ------------------------------------------------------
> >>> From: Jinjie Ruan <ruanjinjie@huawei.com>
> >>> Subject: crash: fix x86_32 crash memory reserve dead loop bug
> >>> Date: Thu, 18 Jul 2024 11:54:42 +0800
> >>>
> >>> Patch series "crash: Fix x86_32 memory reserve dead loop bug", v3.
> >>
> >> It seems that the newest is v4, and the loongarch is missing.
> > 
> > I cannot find a v4 series anywhere.
> 
> Hi, Andrew
> 
> v4 is below, thank you!
> 
> Link:
> https://lore.kernel.org/all/20240719095735.1912878-1-ruanjinjie@huawei.com/

Oh, OK.  Unlike v3, v4 wasn't cc:linux-kernel.  I found a copy, thanks.
