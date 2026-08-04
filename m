Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57BC4963B3
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 20:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785875980; cv=none; b=eL33+rHaaM4M9je9xxP4zi86cBwmN25YtTvslcYPOX+hd73e0VgzBDe8XkLikPZGT8JXlvjK6QN5tCC9B8cZti0Pm0PK5Tc+29jFFb7Nxwcf0YZlIv8pnuyqooGpAN7T+sN9k4BtsDkymOc7S3+c190LgxaijmF7RsKH3FgKN1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785875980; c=relaxed/simple;
	bh=7R8gzWNJhF2hgAp6JrCWFZ2c7/+/4EfCGaevyddwfIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F2O+bp0N7xXVAsc7LsUbR9aU/FyndvOQwFRWHDadzFKFsTv4tOjeW92sPFVX7sWG4eUYjmApkaqmtEU7yqMeH/IqT5IcPHPjrMmoFEyc6KSFN1VTCatHZ7qUz1tflkt1mSbE21oht4m7gWsG9Zbh1c+0TwSWlkd9UxwNLf3nLNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X74XBf4y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X74XBf4y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785875973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=74c5xxC2USF+IPzk+zxGlCvjgdJYKhXbkEu8xSKY14M=;
	b=X74XBf4yhwa44H24E+LdFQtpWloN8LhfWNkqDXWo4TCxGWYTLwKzF45Ng3xJ8oiwgY6mxb
	3rFfIfQnScqGdqLA8cKcohAMgInTXqSA3Pm+g5uAtZeeoAwDZFsH0s0w8OOIglcb//JFgY
	jApySGs5x2cQfuABZTlodj7hmcgD9Ao=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-nRvWII5qOlucKtV6Hj0Zqg-1; Tue,
 04 Aug 2026 16:39:29 -0400
X-MC-Unique: nRvWII5qOlucKtV6Hj0Zqg-1
X-Mimecast-MFC-AGG-ID: nRvWII5qOlucKtV6Hj0Zqg_1785875968
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AAD9C1955DC5;
	Tue,  4 Aug 2026 20:39:27 +0000 (UTC)
Received: from fedora (unknown [10.44.32.54])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 72F851800480;
	Tue,  4 Aug 2026 20:39:25 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue,  4 Aug 2026 22:39:27 +0200 (CEST)
Date: Tue, 4 Aug 2026 22:39:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, bsingharora@gmail.com, include@grrlz.net
Subject: Re: +
 taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch added to
 mm-nonmm-unstable branch
Message-ID: <anJN-w0et3CXG64B@redhat.com>
References: <20260804200407.E858F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804200407.E858F1F000E9@smtp.kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 08/04, Andrew Morton wrote:
>
> From: Bradley Morgan <include@grrlz.net>
> Subject: taskstats: copy signal->stats under siglock in taskstats_exit

...

> --- a/kernel/taskstats.c~taskstats-copy-signal-stats-under-siglock-in-taskstats_exit
> +++ a/kernel/taskstats.c
> @@ -590,6 +590,7 @@ void taskstats_exit(struct task_struct *
>  	struct sk_buff *rep_skb;
>  	size_t size;
>  	int is_thread_group;
> +	unsigned long flags;
>  
>  	if (!family_registered)
>  		return;
> @@ -635,7 +636,10 @@ void taskstats_exit(struct task_struct *
>  	if (!stats)
>  		goto err;
>  
> +	/* This was racy before, copy the stats under siglock. */
> +	spin_lock_irqsave(&tsk->sighand->siglock, flags);

Why _irqsave? The only caller is do_exit(), and it obviously runs with
irqs enabled?

Oleg.

