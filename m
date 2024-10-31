Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F365119E999
	for <mm-commits@vger.kernel.org>; Thu, 31 Oct 2024 13:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730380592; cv=none; b=aitiHk0jX+FArZzYDvyv8/OzbCazcjzoyfU6nax8Zzp99s8P66yjfvg9g6I0O19RNMqLPDcEwLKDO5cJbdJUVzT3NJ1xE6LYRJwYTbJSisSua0plGNVVna+cTfdy4erFAZ0xSyB4k1sYfP8yagyH6+3NUn3UeuxIKqPLS3RTu/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730380592; c=relaxed/simple;
	bh=uIASmehFdpVSyO1GLRRV3g/NO6lBbfl/+m54BMAIy3w=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=RhcpwSt42VtKOdL2ASWBIciPiRCFbNoGBrH7hDz7hYveyIUn3spLm0wE9/0v6BRhohYB2PI4ao9usTHEI/8XDi6GJmkd0tx9qjWOO3v4/7EhG6nrx5gqK0WZ55Znkiz376F2u5MGVVjUNnPGruDJzaJtXFfn/maJ+jTUVhpKql0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BbnLa2My; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BbnLa2My"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730380589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dfFNQ56rVFjUlXb+iq+tZczUaenglGnWldpWlTTa4iQ=;
	b=BbnLa2MycIzwvLim1vWXkftQChZcSTD+LPpSs/lVSrhku2z+Htu4uaseCtka6iO2BP0QM8
	nbt1txCd0WibBL5S0Vd+2/ZAWlCDl4S5wLF9uZifxVui3l+U46d0VQJb1oWrMrOAj91sUf
	fHndMHrGrArszvf4wBQwvRS1KaegdIA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-625-J8_g8ae8M2Olb4TTMmEd1g-1; Thu,
 31 Oct 2024 09:16:25 -0400
X-MC-Unique: J8_g8ae8M2Olb4TTMmEd1g-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCDFC1955F41;
	Thu, 31 Oct 2024 13:16:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.231])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1F78F1956054;
	Thu, 31 Oct 2024 13:16:19 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20241026230305.32360C4CEC6@smtp.kernel.org>
References: <20241026230305.32360C4CEC6@smtp.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, mm-commits@vger.kernel.org, willy@infradead.org,
    wangkefeng.wang@huawei.com, shy828301@gmail.com, hughd@google.com,
    david@redhat.com, baolin.wang@linux.alibaba.com
Subject: Re: + mm-shmem-fallback-to-page-size-splice-if-large-folio-has-poisoned-pages.patch added to mm-unstable branch
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <44140.1730380578.1@warthog.procyon.org.uk>
Date: Thu, 31 Oct 2024 13:16:18 +0000
Message-ID: <44141.1730380578@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Andrew Morton <akpm@linux-foundation.org> wrote:

> +		/*
> +		 * Fallback to PAGE_SIZE splice if the large folio has hwpoisoned
> +		 * pages.
> +		 */
> +		if (likely(!fallback_page_splice)) {
> +			size = len;
> +		} else {
> +			size_t offset = *ppos & ~PAGE_MASK;
> +
> +			size = min_t(loff_t, PAGE_SIZE - offset, len);
> +		}

It might look better to write this as:

		size = len;
		if (unlikely(fallback_page_splice)) {
			size_t offset = *ppos & ~PAGE_MASK;

			size = umin(size, PAGE_SIZE - offset);
		}

David

