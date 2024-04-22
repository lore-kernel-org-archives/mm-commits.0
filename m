Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B931CD2E
	for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2024 21:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713822981; cv=none; b=F5roY3KY8d3gVNgvF1+vkw81SXuB8eepCZGAlfSi8DjpI+6PT7Y1+5Mf4cYTTXK5qcudGMXihHoS3y6RpLTzPRCmdLYLsDLW4X4lqemo/HEqdcVQHgiMXSjpuEYHBZamGWz/wyh9UZq7u0l8b0az3wVq5Giwk1VyqMxPuh2cjuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713822981; c=relaxed/simple;
	bh=+vwmVPRrjzk5u2/tJCNBFptQalE5qRXPEhnTVzwbU50=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=AnZZtw3NyZ0mUtZOeZshYXQW3SGWixhYSJwp4bsh/hN27CaQ+I4uMpis1ODw/LjqvjD7l7Jex5LR/yhKoXkyT7xqJbZ5cBHcuHkuszUIYMreVRJvI1nQEjHWfO5V5vhaNhJ+fPm8qvYyTJWoy68W3Wmyh1RPAEeCFTcRmOg23F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qzyvuF2O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qzyvuF2O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636EBC113CC;
	Mon, 22 Apr 2024 21:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713822980;
	bh=+vwmVPRrjzk5u2/tJCNBFptQalE5qRXPEhnTVzwbU50=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qzyvuF2OcOM7gKatO9V13+HclrBZ9spaglWVjU6ABn4vuxTTzPMUp6FGVFpgeDuOV
	 SRLss52DDzCHoULDbBX+j18xmDKBC2/2M4PCFtpC+rLi+kKNIe4NPtMLtZV7ZfoUes
	 +FQelvw4aJRhRv09yTxyHIXHkPKMyUYkMnzmTrEo=
Date: Mon, 22 Apr 2024 14:56:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <mm-commits@vger.kernel.org>, <tj@kernel.org>
Subject: Re: +
 mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch
 added to mm-unstable branch
Message-Id: <20240422145619.3c040adc7706a8fb501d1883@linux-foundation.org>
In-Reply-To: <b5219c1f-02f8-4225-a578-d991d349f978@huawei.com>
References: <20240418194434.CF790C113CC@smtp.kernel.org>
	<b5219c1f-02f8-4225-a578-d991d349f978@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 Apr 2024 09:21:06 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> 
> Hi Andrew,
> 
> On 2024/4/19 3:44, Andrew Morton wrote:
> > 
> 
> > 
> > ------------------------------------------------------
> > From: Kefeng Wang <wangkefeng.wang@huawei.com>
> > Subject: mm: swapfile: check usable swap device in __folio_throttle_swaprate()
> > Date: Thu, 18 Apr 2024 21:56:44 +0800
> > 
> > Skip blk_cgroup_congested() if there is no usable swap device since no
> > swapin/out will occur, Thereby avoid taking swap_lock.  The difference is
> > shown below from perf date of CoW pagefault,
> 
> Thanks your for help to improving changelog, so kind to me.
> 
> > 
> >   perf report -g -i perf.data.swapoff  | egrep "blk_cgroup_congested|__folio_throttle_swaprate"
> 
> I make a mistake, this should swapon
> 
> >       1.01%     0.16%  page_fault2_pro  [kernel.kallsyms]      [k] __folio_throttle_swaprate
> >       0.83%     0.80%  page_fault2_pro  [kernel.kallsyms]      [k] blk_cgroup_congested
> > 
> >   perf report -g -i perf.data.swapon   | egrep "blk_cgroup_congested|__folio_throttle_swaprate"
> and  this is swapoff
> 
> We don't use swap in our scene, so avoid blk_cgroup_congested(), could
> you help to correct it too, thanks
> 
> 
> >       0.15%     0.15%  page_fault2_pro  [kernel.kallsyms]      [k] __folio_throttle_swaprate
> > 

Please send me the new changelog text and I'll paste it in, thanks.
