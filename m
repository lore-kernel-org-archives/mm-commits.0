Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCD0535D4
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 20:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716497138; cv=none; b=tfEJdrvClX5SbY107wav6GbZHOXTC2Ni2tDs8e1VvBguUGPelGj4paoDZrF2sM++IordHfBubNJE+rWXWSzHJ3tYqVJnbhgmRdw5uWR9nX0W3rkFSO7HSd75PXZrkgWWHRqCNtK0+xSldVs+sQg/vLkr+JNiVJ3S2nd8jCQGHfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716497138; c=relaxed/simple;
	bh=3gIhZ8jmDMqLeoGcvRL2p47PNN5Zx2gdFcz8ErRlU1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kSLan9BfQ/5xJ35b97kqueW4nWX3rB39Rwtmd97G8JYU/5eG6roMCOnyop1C/W2g9O7NN87ClIicvuuRupAnYSCRK7+Nf+W31J+Mu9Oy/HuRAJTdbyQrcvOYIinHDgzuIbbqT6zz4giQFF8GEspaXF5wrpujadjlkN6Z1EU0Atg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B+3/UV7z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B+3/UV7z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716497134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iV0eec7nYykYMryd1o5gXHZ77PvoPL9qi2N+aKeDrpk=;
	b=B+3/UV7zuEOqFut0GSNZEDc16UoLBNNIM/y6B/3jN8CCjj0UHtQJpETkNV8zZgEqjrH879
	4X86Ua2JpxEWJhlV82yx3qZswdADkOIVR3q0IgXuumAntkympqLclM1Mee4jxw4dDQQDbW
	FapHhKr98FSgFqZ1jvKpotuAME3O/XQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-341-FNpuulybMWuFvUKVMZwVog-1; Thu, 23 May 2024 16:45:28 -0400
X-MC-Unique: FNpuulybMWuFvUKVMZwVog-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C9E68025F9;
	Thu, 23 May 2024 20:45:28 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.226.7])
	by smtp.corp.redhat.com (Postfix) with SMTP id 0DB9828E2;
	Thu, 23 May 2024 20:45:26 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Thu, 23 May 2024 22:44:01 +0200 (CEST)
Date: Thu, 23 May 2024 22:43:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, keescook@chromium.org, ubizjak@gmail.com
Subject: Re: +
 fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch
 added to mm-nonmm-unstable branch
Message-ID: <20240523204358.GE15163@redhat.com>
References: <20240523190751.543B0C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523190751.543B0C2BD10@smtp.kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

> From: Uros Bizjak <ubizjak@gmail.com>
> Subject: fork: use this_cpu_try_cmpxchg() in try_release_thread_stack_to_cache()
> Date: Thu, 23 May 2024 09:35:14 +0200
>
> Use this_cpu_try_cmpxchg() instead of this_cpu_cmpxchg (*ptr, old, new) ==
> old in try_release_thread_stack_to_cache.  x86 CMPXCHG instruction returns
> success in ZF flag, so this change saves a compare after cmpxchg (and
> related move instruction in front of cmpxchg).
>
> No functional change intended.

Sorry, cosmetic nit...

> @@ -205,7 +205,9 @@ static bool try_release_thread_stack_to_
>  	unsigned int i;
>  
>  	for (i = 0; i < NR_CACHED_STACKS; i++) {
> -		if (this_cpu_cmpxchg(cached_stacks[i], NULL, vm) != NULL)
> +		struct vm_struct *tmp = NULL;
> +
> +		if (!this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm))
>  			continue;
>  		return true;
>  	}

Why not

	static bool try_release_thread_stack_to_cache(struct vm_struct *vm)
	{
		unsigned int i;

		for (i = 0; i < NR_CACHED_STACKS; i++) {
			struct vm_struct *tmp = NULL;

			if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm))
				return true;
		}
		return false;
	}

?

To me this "continue" just adds the unnecessary confusion with or without
this patch, but I won't insist.

Oleg.

