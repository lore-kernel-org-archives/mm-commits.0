Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF7D17BA2
	for <mm-commits@vger.kernel.org>; Wed, 25 Mar 2026 03:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774408364; cv=none; b=XyLMtBrOeFAzqsVWkdQ2aApXj4A5b05fQT43ReQqmpYWV7CBLqwTEU2VgW0S8F346B/iMUnebdhb/ZEaIzxdlfdaqlxVQynQ6Av0TKO7K5qq5w8ZJWOoliEwzdMUqqpWCVUEF1A/R+wp/FO0BWVbX6qFbvRQdt+OaL271Ucf9Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774408364; c=relaxed/simple;
	bh=Drmi9e+ioIcIfuEB6m97erT8wA90iFj8LM59VKUwY8k=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=pptn7cHxJc2WVyHBJJF/3yaLB6ekBWIg54zca2NrpsTl2JkxBDdZQSytI++BilED4zFQzjwom1Za/F+xSzWSsQ+SpCnFrXvnl2aN7/0oVKqwLKZxlx0kQkyg5ae+1ux8Y8ApZlygEUf60LbXROVHJW2GxUbVE8x5LBhcUwYUysA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jv9Mhb7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jv9Mhb7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9AE2C19424;
	Wed, 25 Mar 2026 03:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774408363;
	bh=Drmi9e+ioIcIfuEB6m97erT8wA90iFj8LM59VKUwY8k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jv9Mhb7lzqC+dfNjek7cEgBfYKTjsJ8x8cQdeCnDFdJAId+p0x/bbeoDveUGjBv9e
	 NH6FMZXPOeZnbj2ovlb2/RdLn8OprmhKok4WWbRaySYW6ImslvggzFun07hl9nWthn
	 zOP4YkATpb1ZVsM18wWhMreeivgzWRYJFSN2+hYc=
Date: Tue, 24 Mar 2026 20:12:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
 devnexen@gmail.com
Subject: Re: [folded-merged]
 mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix.patch
 removed from -mm tree
Message-Id: <20260324201243.32c686dd0d8b4259f482f215@linux-foundation.org>
In-Reply-To: <7b0c168c-818e-47bc-80f6-578409ddd82c@linux.dev>
References: <20260324231614.EFAC3C19424@smtp.kernel.org>
	<7b0c168c-818e-47bc-80f6-578409ddd82c@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 25 Mar 2026 10:51:40 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> > --- a/mm/memcontrol.c~mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix
> > +++ a/mm/memcontrol.c
> > @@ -4058,6 +4058,7 @@ free_objcg:
> >   	for_each_node(nid) {
> >   		struct mem_cgroup_per_node *pn = memcg->nodeinfo[nid];
> 
> The newline should be here. ;)

well dang.

<edit><edit>

there.
