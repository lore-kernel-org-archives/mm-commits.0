Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508FC3FADEE
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 09:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785922281; cv=none; b=XZHIZDlhd1y2h6/Vl4wMhOtoIugACoxHrXgNuG0oOyZj0gG+vAQPQVDidSiUWn4tIt9uFLZEIXQB5XaGeYPCSCkur4cZO1Jc/GFC5fuzwWlKVC1N7iNr7HfPgeGE2AsW1gsM1XodMvhaz2BdbcihyOYghFUJ8WmOYJf29Wv00+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785922281; c=relaxed/simple;
	bh=asWsS+TRE9F8r6Ozp6bHz/LxIZPDeukmYVExsQt/JqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NVscHp9ske+fiX/Db1dsWViMyiBAfhdZ53vlTJjJGT3zoKsPFRn+E8UrGmiDWEOLoStSOHtlqDiqESOd9JMkEObMBqI2Ma4y3KZ8vqqwc/MswcmgYb0tjnddAb1t1nZpJBDsv9tmUtSyMQ6Xg/xAvWwPsFKWAM5Ws0dNxpqsGyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AVJwE3It; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AVJwE3It"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785922278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WcBDVkrk61gpYBTr4imljUOOXkA1e7YBfjHMAc5Md9o=;
	b=AVJwE3It9PFvQHxitORhSfDvewsxz63Z+XM61VGM1u7KQa7ELJeHn+jAfimjDBb2rq7aJ/
	6Jjw2oRn1+GrNrUivMsxkVrVLDL26shugS53uvaWzXhUnzJVvoOI90POh8FsmNB+8mUf2J
	DaMA8OjF9eOyySFD+svvxJExqIKiVu4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-Bdz2SJ7UPO6k4bWTNCSY4g-1; Wed,
 05 Aug 2026 05:31:14 -0400
X-MC-Unique: Bdz2SJ7UPO6k4bWTNCSY4g-1
X-Mimecast-MFC-AGG-ID: Bdz2SJ7UPO6k4bWTNCSY4g_1785922273
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3099119560BA;
	Wed,  5 Aug 2026 09:31:13 +0000 (UTC)
Received: from fedora (unknown [10.44.32.54])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 41C79422;
	Wed,  5 Aug 2026 09:31:10 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed,  5 Aug 2026 11:31:12 +0200 (CEST)
Date: Wed, 5 Aug 2026 11:31:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Bradley Morgan <include@grrlz.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	bsingharora@gmail.com
Subject: Re: +
 taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch added to
 mm-nonmm-unstable branch
Message-ID: <anMC3eRoRdaST0Se@redhat.com>
References: <20260804200407.E858F1F000E9@smtp.kernel.org>
 <anJN-w0et3CXG64B@redhat.com>
 <5727577F-39B4-43AF-8E6B-003E9A980A12@grrlz.net>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5727577F-39B4-43AF-8E6B-003E9A980A12@grrlz.net>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On 08/04, Bradley Morgan wrote:
>
> cpu0 (thread A, not last)        cpu1 (thread B, last)
> ===========================      ==============================
> atomic_dec(&signal->live)        atomic_dec(&signal->live) -> 0
> group_dead = 0                   group_dead = 1
> ...                              taskstats_exit(tsk, 1)
> taskstats_exit(tsk, 0)           fill_tgid_exit(tsk) [siglock]
> fill_tgid_exit(tsk)              memcpy(stats, signal->stats)
>   spin_lock(siglock)               reads ac_utime (new)
>   stats->ac_utime += x             reads ac_stime (old)
>   stats->ac_stime += y             torn snapshot -> netlink
>   spin_unlock(siglock)
>
> The listeners receive a partially updated tgid snapshot, with some
> fields from before the concurrent update and some from after. There
> is no crash or splat, which is likely why this went unnoticed since
> 2006. A userspace model of the same shape, writer under a lock and
> a lockless memcpy reader, produces millions of torn reads in a few
> seconds.
>
> Take siglock around the copy like every other access does. sighand
> is still alive here because taskstats_exit() runs before
> exit_notify(), and fill_tgid_exit() already takes this same lock
> earlier in this function.

Acked-by: Oleg Nesterov <oleg@redhat.com>

However. I won't blame your fix, but I am not sure it actually fixes the
real problem.

In the scenario above, if thread B takes ->siglock first (before thread A)
it will report TASKSTATS_TYPE_TGID/AGROUP without accounting thread A.
Looks "obviously wrong" but I forgot everything about taskstats.

And OTOH... for_each_thread() in fill_stats_for_tgid() can't rely on the
tsk->exit_state check, the same thread can be accounted twice.

Oleg.

