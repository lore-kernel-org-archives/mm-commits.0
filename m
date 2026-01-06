Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4DA2FC024
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 20:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767732572; cv=none; b=j2p52WqGfEyMISI5JTI74dg6QeyOrNaRT+MjH/aXhNK7VSKwh3WHPP8JXJH3zwFHV3GJ7zB8/l+JDti4p3PC0XNE/zH2VJdgU+kTnQOFmZLYRkLlxn56c89xVpuIPJXvWT7ws/OkY3VC8SuvULKE5Tjxc72pwC4imwca85XH+mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767732572; c=relaxed/simple;
	bh=tL8zhQkRPp16OX0FSU8OkLUU5dz/c1HxHsn9ozNQ+3k=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=c+86L0db5Bu5LQlaGvP+2OOPyK7qs81sAK2SacrFkG+/iwau1asfnG6qHSKnxNA7I0bBtZSFaH2gHa9ONormndxLLhmyEtCBuTdioNI8zQK1+TlBYFSnmBwQ+AigDKFfVmRuON7L+imbfmk8QA0qc1dFLdunvR8p1KgKldOwVDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hUyc/lbq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hUyc/lbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22D2C116C6;
	Tue,  6 Jan 2026 20:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767732571;
	bh=tL8zhQkRPp16OX0FSU8OkLUU5dz/c1HxHsn9ozNQ+3k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hUyc/lbqTX5uWA1QBDf8E2cOIlzfxFYS1oj+yWkgrYOvX1d03O2QYstnJBVNAIhqY
	 52sbD6cDFAh4hgNeuzPXr3D87koAc/pZRQnrtGpLjmXx60bXlNj9GauN6MJEMuf/L6
	 ZTcVanGRJGrkpOUxz3eI2ky6t7fFjIhgs5hCq+90=
Date: Tue, 6 Jan 2026 12:49:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
 yuanchu@google.com, weixugc@google.com, tballasi@linux.microsoft.com,
 shakeel.butt@linux.dev, roman.gushchin@linux.dev, muchun.song@linux.dev,
 mhocko@kernel.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 hannes@cmpxchg.org, david@kernel.org, david@fromorbit.com,
 axelrasmussen@google.com, rostedt@goodmis.org
Subject: Re: + tracing-add-__event_in_irq-helpers.patch added to mm-new
 branch
Message-Id: <20260106124930.827da463ea281bb392a9843d@linux-foundation.org>
In-Reply-To: <3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
References: <20260106033842.559EBC116D0@smtp.kernel.org>
	<3a96b65e-49b1-45f5-a36a-77b38cea62e2@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 6 Jan 2026 17:30:32 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> This results in (yet another) case of mm-new not compiling. I was trying to
> do some other work and (yet again) ran into the compile failing.
> 
> I bisected the issue to this patch, enclose error message below.

It worked for me, and presumably for Stephen.  Please tell us how to
reproduce this.

> Andrew - I am still confused as to how mm-new works, this patch looks
> unreviewed

It was written by the tracing maintainer.

> (+ doesn't compile) but you took it, a related series that also
> didn't compile and had review push-back was taken to mm-new, but other
> series without review are rejected for not having review?
> 
> Be good to get some clarity as to what mm-new is for?
> 

The email you replied to had (courtesy of David):

: Note, mm-new is a provisional staging ground for work-in-progress
: patches, and acceptance into mm-new is a notification for others take
: notice and to finish up reviews.  Please do not hesitate to respond to
: review feedback and post updated versions to replace or incrementally
: fixup patches in mm-new.
: 
: The mm-new branch of mm.git is not included in linux-next

