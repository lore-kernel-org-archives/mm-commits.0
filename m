Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8203314A82
	for <mm-commits@vger.kernel.org>; Thu, 23 May 2024 21:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716499165; cv=none; b=YhTld0A8SUenitJYkQFS399971f3uLxexGH5qfM7FEm2F/SGlNNvixeUghwkvJNsk6Y75C9r9IptPRantjhlNfmaae4bjSaQmva/Ogsr9JIMe1uIWKkb9ZITZ3vi1e9IXN4Ijn7IHJ6R0CjSBOe/6d+focNJz4H56BrVWQcA2OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716499165; c=relaxed/simple;
	bh=NpcDxf7//Z348y+UX2RqJu1dmOlpoazAutrQYxvO91U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gxHaj8SoTYAsE46eWAeug5tmndSGA8rGYXPotcp74uHKq1yHL2pGRJQWFNh096oocgw278OgN28VqsCGCVxH3rG1Cgttlh8yZS5WdpP2GvEYx6yIWz+/IKLLwhfK1Vos9EFxmim/p/H/As71uGhgD7KDjNUOdsW5tr7oiNvRgdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WBEO4Peq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WBEO4Peq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716499161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cthhlu8pEuptbMXKgh+2/JeKi13WJZ+L20yZosipWOI=;
	b=WBEO4Peq3ZZ8pt+baXdiqBeyWKawWx8Qirrhz9yidFsvTwV7q/bRH0QaaAPi+mkZIR9oc2
	9kSjzIfbloCO+8shdjSUbzQYXI5ME8iAKjF7siecZj8FgYzNHQzJBkHc6auGjxA4idADDP
	aULwnrUzPDtjPHi27xnIFYQxxY39UxA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-cRA9Vh_1ONOlbuGHthOyXQ-1; Thu, 23 May 2024 17:19:19 -0400
X-MC-Unique: cRA9Vh_1ONOlbuGHthOyXQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B5AF85A58C;
	Thu, 23 May 2024 21:19:18 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.226.7])
	by smtp.corp.redhat.com (Postfix) with SMTP id 2EDB4200A35C;
	Thu, 23 May 2024 21:19:16 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Thu, 23 May 2024 23:17:51 +0200 (CEST)
Date: Thu, 23 May 2024 23:17:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	keescook@chromium.org
Subject: Re: +
 fork-use-this_cpu_try_cmpxchg-in-try_release_thread_stack_to_cache.patch
 added to mm-nonmm-unstable branch
Message-ID: <20240523211748.GF15163@redhat.com>
References: <20240523190751.543B0C2BD10@smtp.kernel.org>
 <20240523204358.GE15163@redhat.com>
 <CAFULd4bmZNMVefC75oQN9G-DtKV=r+Q=skBVNsxVaTTxHSmbHw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFULd4bmZNMVefC75oQN9G-DtKV=r+Q=skBVNsxVaTTxHSmbHw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On 05/23, Uros Bizjak wrote:
>
> On Thu, May 23, 2024 at 10:45 PM Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Why not
> >
> >         static bool try_release_thread_stack_to_cache(struct vm_struct *vm)
> >         {
> >                 unsigned int i;
> >
> >                 for (i = 0; i < NR_CACHED_STACKS; i++) {
> >                         struct vm_struct *tmp = NULL;
> >
> >                         if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm))
> >                                 return true;
> >                 }
> >                 return false;
> >         }
> >
> > ?
> >
> > To me this "continue" just adds the unnecessary confusion with or without
> > this patch, but I won't insist.
>
> To ease review, I was trying to make the patch as simple as possible
> (almost mechanical),

I understand,

> because the logic around cmpxchg() and
> try_cmpxchg() is somehow hard to follow

Yes,

> Any additional change would
> just unnecessarily complicate the patch.

I disagree.

If you change the code for any reason, it is always good to try to make
it more readable. And to me

	for (i = 0; i < NR_CACHED_STACKS; i++) {
		struct vm_struct *tmp = NULL;

		if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm))
			return true;
	}

is certainly more readable than

	for (i = 0; i < NR_CACHED_STACKS; i++) {
		struct vm_struct *tmp = NULL;

		if (!this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm))
			continue;
		return true;
	}

but of course this is subjective, and as I said I won't insist.

Oleg.

