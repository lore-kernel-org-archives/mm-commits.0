Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2426640800F
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 15:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779204334; cv=none; b=d0WSz6YUIe8lQZhDYD7PNH65R6XzfbjgvQtOzCjMrqfnj5cCp5tJ6NTZ6G7K4yeoUM+mV9OG4Tv8k2ec4HhEaOsU/8giKF8IAjbtV+aDTK0VwaUTzmLl9Hzuem2fPvsxs0ySDs6J22dYIkdSn/Sed4lcTbVeekABFRzqn1xR+QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779204334; c=relaxed/simple;
	bh=704ReixzMuM4ubriNevzPx2kETukMG5HgcgaWBtkcTs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=pdiiVJeVpRJ4a55YO1k+zK9JUvsMi+CJdrDwVnBUwxGLIqKBDHhbXKtxlB+UxGKegK+KV2WgvvKNMmzUJPyjZz4q4mrvPXdSsFSbXoh8JHFzogDacjpliv7tx3fn/BWkePXMbzHc07WPpJEph9Wbw7k8NzhlqJXcQUq6g3mAtT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=noNvzjEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="noNvzjEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4DBC2BCB3;
	Tue, 19 May 2026 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779204333;
	bh=704ReixzMuM4ubriNevzPx2kETukMG5HgcgaWBtkcTs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=noNvzjEzoqwYx9Wo43k/9bSseyzNj1LweHkDo8Zy1tCBkiQuC1ovfymUABB8Kd5LO
	 VCntsq1kq11qXdo/3wXOsHsZIX1dW5NXOCyIRJsnesGzDn0wiKlu6siYiDjb1GQfhi
	 DCdVx31pMC0/U9z70jy+ZhRzm/jJAmcXVca6h1K8=
Date: Tue, 19 May 2026 08:25:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Byungchul Park <byungchul@sk.com>
Cc: mm-commits@vger.kernel.org, ziy@nvidia.com, willy@infradead.org,
 vbabka@kernel.org, toke@redhat.com, tariqt@nvidia.com, surenb@google.com,
 sdf@fomichev.me, saeedm@nvidia.com, rppt@kernel.org, pabeni@redhat.com,
 mhocko@suse.com, mbloch@nvidia.com, ljs@kernel.org, liam@infradead.org,
 leon@kernel.org, kuba@kernel.org, john.fastabend@gmail.com,
 jackmanb@google.com, ilias.apalodimas@linaro.org, horms@kernel.org,
 hawk@kernel.org, harry@kernel.org, hannes@cmpxchg.org, edumazet@google.com,
 dtatulea@nvidia.com, david@kernel.org, davem@davemloft.net,
 baolin.wang@linux.alibaba.com, ast@kernel.org, asml.silence@gmail.com,
 kernel_team@skhynix.com
Subject: Re: +
 revert-mm-introduce-a-new-page-type-for-page-pool-in-page-type.patch added
 to mm-hotfixes-unstable branch
Message-Id: <20260519082532.2e8eb2b67eee5f0919fd2b0d@linux-foundation.org>
In-Reply-To: <20260519064259.GA57974@system.software.com>
References: <20260519003125.5006AC2BCB7@smtp.kernel.org>
	<20260519051002.GA16061@system.software.com>
	<20260519064259.GA57974@system.software.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 19 May 2026 15:42:59 +0900 Byungchul Park <byungchul@sk.com> wrote:

> > > This reverts commit db359fccf212 ("mm: introduce a new page type for page
> > > pool in page type") and a part of 735a309b4bfb9e ("net: add net_iov_init()
> > > and use it > to initialize ->page_type").
> >              ^
> > 	     Check this out, Andrew.
> 
> Hm.. I might have expressed that incorrectly in English. I just wanted
> you to check the '>' wrongly added :)

yep, thanks, I understood ;)
