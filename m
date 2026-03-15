Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378F0256C70
	for <mm-commits@vger.kernel.org>; Sun, 15 Mar 2026 20:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773605099; cv=none; b=ezhnZQsI4J2oDsbrMjHFjKveA4NsSn9e4Jbbt5lbaXMb8psrwqxUMyh/e7Zy22ef7RQ/1Fs3iOrlJpavPq3/D3MjBWEfqzsHUN6G8hjBcauF5OcRf4Q3Klg5fUGOi1CScdRRaSCoWyF7IkSVqXaTp7DIyQlAVrAPBY6DVab6dE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773605099; c=relaxed/simple;
	bh=eySMtCqDk3b45FqY6RtQy4qxp8aL2LrSVSKBgOZrOxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kbaoYkg5EQQXwMsrjpO1Ju2bGITC+hX58rwuZEO7WdnN3+8w49f/5G+OQOsOEhiauBGwQq4L3Y01kj7j2iqsmuzcjAxkwuPH9ABPDAYPWSe9msHJvGfvxm3Zgv6Q3EzdYi6lk7yfZEzKf+hhGki6Ho1Uxk9h+5XEZEG5CZYAQho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M8519zTG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M8519zTG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773605097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Av64PTZTx00+LrXHrjvSdBtdr+FbvrIm9xicioz1uvg=;
	b=M8519zTGECUMFmpfQAwROPM6h7wyw0qsMKhe9CYbAR7ZANnmEfibn/GG/utO3AXVeCDvxe
	VKMC4ZsNWcfL9gXNGH7FsDlov+a9JT7CMSln1/elH8zoDBXbhCL7JJSMBBhRdBLwl0Aphy
	uXsv8QuTdycrDAvsG8X5Yp9FgEbOz64=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-oSkMaxtcO9SkFNLVhD3Jrw-1; Sun,
 15 Mar 2026 16:04:55 -0400
X-MC-Unique: oSkMaxtcO9SkFNLVhD3Jrw-1
X-Mimecast-MFC-AGG-ID: oSkMaxtcO9SkFNLVhD3Jrw_1773605094
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5505B1956088;
	Sun, 15 Mar 2026 20:04:54 +0000 (UTC)
Received: from fedora (unknown [10.45.225.204])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id DE3B019560B7;
	Sun, 15 Mar 2026 20:04:51 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 15 Mar 2026 21:04:53 +0100 (CET)
Date: Sun, 15 Mar 2026 21:04:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Deepanshu Kartikey <kartikey406@gmail.com>
Cc: mm-commits@vger.kernel.org, mjguzik@gmail.com, kees@kernel.org,
	brauner@kernel.org
Subject: Re: [withdrawn]
 do_notify_parent-sanitize-the-valid_signal-checks.patch removed from -mm
 tree
Message-ID: <abcQ4o0BipVJkT_8@redhat.com>
References: <20260309200920.56FCFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309200920.56FCFC4CEF7@smtp.kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On 03/09, Andrew Morton wrote:
>
> The quilt patch titled
>      Subject: do_notify_parent: sanitize the valid_signal() checks
> has been removed from the -mm tree.  Its filename was
>      do_notify_parent-sanitize-the-valid_signal-checks.patch
>
> This patch was dropped because it was withdrawn

OK, thanks!

but then please also drop kernel-fork-validate-exit_signal-in-clone-syscall.patch
from Deepanshu (cc'ed).

Because that patch:

	- is not complete in any case

	- makes no sense (at least with its current changelog) without
	  do_notify_parent-sanitize-the-valid_signal-checks.patch

If Deepanshu sends V2 (with the updated changelog), we can reconsider
both patches from Deepanshu and me.

Oleg.

> ------------------------------------------------------
> From: Oleg Nesterov <oleg@redhat.com>
> Subject: do_notify_parent: sanitize the valid_signal() checks
> Date: Sun, 22 Feb 2026 16:23:47 +0100
> 
> The "sig" argument of do_notify_parent() must always be valid and it does
> WARN_ON_ONCE(sig == -1) at the start.  The 2nd valid_signal() check before
> __send_signal_locked() must always be true or we have a bug.
> 
> This is confusing.  Change do_notify_parent() to WARN and return early if
> valid_signal(sig) is false.
> 
> Link: https://lkml.kernel.org/r/aZsfg0Y055yuAvsq@redhat.com
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Cc; Deepanshu Kartikey <kartikey406@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/signal.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- a/kernel/signal.c~do_notify_parent-sanitize-the-valid_signal-checks
> +++ a/kernel/signal.c
> @@ -2173,7 +2173,8 @@ bool do_notify_parent(struct task_struct
>  	bool autoreap = false;
>  	u64 utime, stime;
>  
> -	WARN_ON_ONCE(sig == -1);
> +	if (WARN_ON_ONCE(!valid_signal(sig)))
> +		return false;
>  
>  	/* do_notify_parent_cldstop should have been called instead.  */
>  	WARN_ON_ONCE(task_is_stopped_or_traced(tsk));
> @@ -2254,7 +2255,7 @@ bool do_notify_parent(struct task_struct
>  	 * Send with __send_signal as si_pid and si_uid are in the
>  	 * parent's namespaces.
>  	 */
> -	if (valid_signal(sig) && sig)
> +	if (sig)
>  		__send_signal_locked(sig, &info, tsk->parent, PIDTYPE_TGID, false);
>  	__wake_up_parent(tsk, tsk->parent);
>  	spin_unlock_irqrestore(&psig->siglock, flags);
> _
> 
> Patches currently in -mm which might be from oleg@redhat.com are
> 
> exit-kill-unnecessary-thread_group_leader-checks-in-exit_notify-and-do_notify_parent.patch
> complete_signal-kill-always-true-core_state-signal_group_exit-check.patch
> pid-make-sub-init-creation-retryable.patch
> pid-document-the-pidns_adding-checks-in-alloc_pid-and-copy_process.patch
> 

