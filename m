Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DF72E88B7
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 09:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754991497; cv=none; b=hccOHXWb/DaxrSBcCcsRYD3hOuFDSGXCjvkK32PllwH8bijGUgGgv5FS1Ea9viP0sPLQ5fw5F47DpVqqOWJMrkaetLJbzy57aSFJZWVdw+NKbAY5tRPjNC39Iamh9/xkyK/BnK26ZeUSEITbzSybDUhjGEhJIeFC1fe05U8XUas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754991497; c=relaxed/simple;
	bh=pRD8Cz6iAVpE9i3i5in3FTwGoSpwqCqOi827kQ6aflU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=aUFxHm30vcUnq5zUyhTdj4qEqZlLr+SsEgszT1sJI+f93EjDkQO9RK5WZv8Jw/U0ILU7se5bXcm5MTNo19hFgvX5jmsF0C6nHWHfYZFvcyrQjAULRXlTW8DYLsnYhr/8MAleCAyyvrCZNpVM0zeqEP8ALJFLAUQUj1vjMOinjHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V93jo46t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V93jo46t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754991495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vhvNFWpvH0JajgtKkk/MGXEUzpAEABIz2BPsPryMbpI=;
	b=V93jo46trguVeIGoiwaSV6xZcYuimMmfSAJFXmBz/OvtdTX3ibBZjnJSMFYcrdTlxmbDqd
	h7lhe9raZWuF1CsOoGKMt6HVqrbR4m2Tb82XDOWRZj9wypF8CR3b8SxOMUyOyoQxNsMiCd
	EdzbBtuEd3vtmdTG6KkXQs9RHLoGapo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-176-7gnKzejOPNiPjp__USGNXg-1; Tue,
 12 Aug 2025 05:38:13 -0400
X-MC-Unique: 7gnKzejOPNiPjp__USGNXg-1
X-Mimecast-MFC-AGG-ID: 7gnKzejOPNiPjp__USGNXg_1754991492
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8D8D19560BB;
	Tue, 12 Aug 2025 09:38:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.21])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A2FD51800283;
	Tue, 12 Aug 2025 09:38:08 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250812010237.B52F8C4CEED@smtp.kernel.org>
References: <20250812010237.B52F8C4CEED@smtp.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, asmadeus@codewreck.org
Cc: dhowells@redhat.com, mm-commits@vger.kernel.org,
    viro@zeniv.linux.org.uk, stable@vger.kernel.org, ryan@lahfa.xyz,
    maximilian@mbosch.me, ct@flyingcircus.io, brauner@kernel.org,
    arnout@bzzt.net
Subject: Re: + iov_iter-iterate_folioq-fix-handling-of-offset-=-folio-size.patch added to mm-hotfixes-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <650363.1754991487.1@warthog.procyon.org.uk>
Date: Tue, 12 Aug 2025 10:38:07 +0100
Message-ID: <650364.1754991487@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Thinking about it again, I think this:

> @@ -168,6 +168,8 @@ size_t iterate_folioq(struct iov_iter *i
>  			break;
>  
>  		fsize = folioq_folio_size(folioq, slot);
> +		if (skip >= fsize)
> +			goto next;
>  		base = kmap_local_folio(folio, skip);
>  		part = umin(len, PAGE_SIZE - skip % PAGE_SIZE);
>  		remain = step(base, progress, part, priv, priv2);
> @@ -177,6 +179,7 @@ size_t iterate_folioq(struct iov_iter *i
>  		progress += consumed;
>  		skip += consumed;
>  		if (skip >= fsize) {
> +next:
>  			skip = 0;
>  			slot++;
>  			if (slot == folioq_nr_slots(folioq) && folioq->next) {

Would be much better done as:

> @@ -168,6 +168,8 @@ size_t iterate_folioq(struct iov_iter *i
>  			break;
>  
>  		fsize = folioq_folio_size(folioq, slot);
> +		if (skip < fsize) {
>  		base = kmap_local_folio(folio, skip);
>  		part = umin(len, PAGE_SIZE - skip % PAGE_SIZE);
>  		remain = step(base, progress, part, priv, priv2);
> @@ -177,6 +179,7 @@ size_t iterate_folioq(struct iov_iter *i
>  		progress += consumed;
>  		skip += consumed;
> +		}
>  		if (skip >= fsize) {
>  			skip = 0;
>  			slot++;
>  			if (slot == folioq_nr_slots(folioq) && folioq->next) {

With the stuff inside the braces suitably indented.  The compiler should be
able to optimise away the extra comparison.

David

