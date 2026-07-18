Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E253305698;
	Sat, 18 Jul 2026 20:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784405126; cv=none; b=BU7UrtLaLlhiXS6P8AZLXbfQqwwazAbZ/MVmbVhLibAyymuUPUjWSl4KgtrtXc2QmMjgV6KltHuJ2AFKE4jztOpFnmrn2lOw1tIreBXABRwfwmA75lUJ53Svc6BEPDQ1Gif/jhRJGyaFuaaMTIOz1g6TciaGwL2Bz6xql0X/lrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784405126; c=relaxed/simple;
	bh=Fx6s90lcYjkIDya2qz4IJuvQ2eB4d0/5qLXQCDW3q1o=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Aj9r8pWhDj3nkgNKXjcY9F/FOKFQNKN8xkXdLqOMjHZavg9zW5TnNPgvbpc2mZhz7jCzjDzp4qSGA0WbpkPdLGW77WsqGdY74ID/8H1V2mUN0aUjVcsjCwINfijbxrdmcZKjRS5ySnBHQD+ELDssDRq85QFFGZrNMMW4UqBV3M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lu5fv3DO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lu5fv3DO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC6A1F000E9;
	Sat, 18 Jul 2026 20:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784405125;
	bh=bsjsetDsv6LJ8ZKZu9WL5e2IuUCIT5aDWag8CKSejSc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Lu5fv3DOyUgue6BXOq1HnNFVnbewuyrNwzpOnKop1TF8XQLqS2DP3nUpFP0zGi+Wp
	 Gtt7wjqlIQTeYiiIJMbAcKFsdlkCt7gGw5R9mCUx7hiMqJ+844htvLw45KzzEasZrY
	 D5E9kCVY7yw4JsHbx46CtauiPUOSKCRCIO3Eo+aY=
Date: Sat, 18 Jul 2026 13:05:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: mm-commits@vger.kernel.org, xuanzhuo@linux.alibaba.com,
 vbabka@kernel.org, stable@vger.kernel.org, rientjes@google.com,
 jthoughton@google.com, jiaqiyan@google.com, jasowang@redhat.com,
 gthelen@google.com, david@redhat.com, david@kernel.org,
 alexander.duyck@gmail.com, linkl@google.com
Subject: Re: +
 virtio_balloon-avoid-shrinker-execution-during-pm-suspend.patch added to
 mm-new branch
Message-Id: <20260718130524.4408c5f964d9ba9465bb237a@linux-foundation.org>
In-Reply-To: <20260718101506-mutt-send-email-mst@kernel.org>
References: <20260718003902.B6DD51F000E9@smtp.kernel.org>
	<20260718101506-mutt-send-email-mst@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 18 Jul 2026 10:16:54 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:

> 
> This patch generated quite a bit of discussion. Are you
> sure it makes sense to keep it in mm as is?
> In particular:
> 

Thanks.  kvack.org decided not to send me either your reply or David's,
dammit.  It's been doing that lately.  Fortunately linux-kernel was cc'ed
and vger sent me copies.  Argh.

I'll drop the series.

