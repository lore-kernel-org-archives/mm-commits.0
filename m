Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B391DDDC;
	Fri, 13 Dec 2024 01:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052529; cv=none; b=ZYC5qVf2JnbguXwuj+sZPtaM2CAt47PJTaPU8HKgKTdFFD2lW6KCjouwze3EGsLd11MaAA5dBnzpvFL7fjUwE81gPeSXsFCb71tbZO8IbM0KQ/ZUWW8eotJ+OgOz8V3q6+xoaDP1co1iox7r80nDFLPCZsWNmlhQlm8EnZ9z0aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052529; c=relaxed/simple;
	bh=y/ykMDI8/QN6PsiGVNzYEwYt5g0NAajzmgm0x261DHI=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=WpdMX9EcGH24xtzT1sivArsClZVXmmweuTa1WnxRll8lfCdwu/ttPnc973yVKMGR7Hm+vp73YivK+d1pdbrWPF9LyHZXKczOfU4N6EJ8LpWZfZmguX8+3Ikp5MYFp1ZSXcpjIsebDpHVMtdQLQJDUqIOJ25bTr9M8ZklhneIhX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m9SBoSle; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m9SBoSle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73464C4CED4;
	Fri, 13 Dec 2024 01:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734052528;
	bh=y/ykMDI8/QN6PsiGVNzYEwYt5g0NAajzmgm0x261DHI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=m9SBoSlep+evQGFRnuzl7G3XO0nRk3gnNQWTDBHNJzVBwvJQv+dCwRjg8kCRA61Pf
	 2YZWq2dcY0E7p2f8qk6UzRLkr+tWLMlZAKRHx1qmCXM5s+wnAZyR67wS6mhiXUSFga
	 ZFa3Vo8zsGM0rTQtmZNG5fDLcyQpsnFmYn1/3i2c=
Date: Thu, 12 Dec 2024 17:15:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org, minchan@kernel.org,
 caiqingfu@ruijie.com.cn
Subject: Re: + zram-panic-when-use-ext4-over-zram.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20241212171527.324df0289e34719e9b79d9f6@linux-foundation.org>
In-Reply-To: <3awo2svbnsv2mvozhaqspwztgxhifphj7ffpmykc35py6wp6ol@xlt2q5qgv6c3>
References: <20241130030456.37C2BC4CECF@smtp.kernel.org>
	<3awo2svbnsv2mvozhaqspwztgxhifphj7ffpmykc35py6wp6ol@xlt2q5qgv6c3>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 12 Dec 2024 17:40:24 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> > The reason is that when the handle is obtained using the slow path, it
> > will be re-compressed.  If the data in the page changes, the compressed
> > length may exceed the previous one.  Overflow occurred when writing to
> > zs_object, which then caused the panic.
> > 
> > Comment the fast path and force the slow path.  Adding a large number of
> > read and write file systems can quickly reproduce it.
> > 
> > The solution is to re-obtain the handle after re-compression if the length
> > is different from the previous one.
> 
> Andrew, I'm leaning toward asking you to drop this patch.  zram cannot
> (nor should probably) do anything about upper layer modifying the page
> data during write().  It's a bug in the upper layer which zram should
> not hide.

No probs, I already have a "don't do anything with this" note so I'm
awaiting resolution.

I often hold onto "wrong" fixes as a reminder that a "right" fix is
needed.  Rather a weird bug tracking system, but it works for me ;)

