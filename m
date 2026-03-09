Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F99387362
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 09:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773050303; cv=none; b=dlBBIVyaQeKqoWHJk4OxMC+Oq9k1yM4H+QMt73C/WtDHgQ8NWyco/PlFoHCXTmaSTofYa5r+2dPzLgCIEWzikZ2E56dh4HPmisZenAG336a0IEjHsTo8dm5lnAlOFCFF6/127Kjqm1CTU5vFMUxDVUaxoxhkMxa14v7uoA2n7mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773050303; c=relaxed/simple;
	bh=TKtS+mWpfNFlIw9PvyYvUy6md/YBVnYJn8E5SEV4WJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tq1x29Nu7ohrTe003+KP2KcIPDuMPErkyl5TY0Dpr2br7aGBBngEdYI/W4rYqAksqp9ldUnVamwpQ6A3pwZYLyr6L2Y9fiJZ/FTIToffcJG8pha2Td9bSxaqOc+gbHQQ0uFWAZKGinyoTykvcZ3g9UeflKCrlYeqCZeo1TMhjEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i0AjcZzY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i0AjcZzY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773050301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q29TAPJjZcqFDUsZTpin10HBszzZCi1LeR65DfvcJOs=;
	b=i0AjcZzYWdQJQz6JVcbUo4N5czVU0hdFmlG1qrsBTXsysthSggWHp9YdFR86gp/ehZNzxE
	nv/Tg4/LVkIkkua681a8Mnl7SCAxR5KHHQ70xdf2aXBokv7ADQEsAPCivkuiK347/a5b7k
	zk7HxHI6d2Um9weqNHV8HWoGA9WimCo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-397-rMahIKGjPQCdQ64YCE1v4g-1; Mon,
 09 Mar 2026 05:58:16 -0400
X-MC-Unique: rMahIKGjPQCdQ64YCE1v4g-1
X-Mimecast-MFC-AGG-ID: rMahIKGjPQCdQ64YCE1v4g_1773050293
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1519F1956089;
	Mon,  9 Mar 2026 09:58:13 +0000 (UTC)
Received: from fedora (unknown [10.45.224.43])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id E9D93180075D;
	Mon,  9 Mar 2026 09:58:05 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon,  9 Mar 2026 10:58:12 +0100 (CET)
Date: Mon, 9 Mar 2026 10:58:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, vschneid@redhat.com,
	vincent.guittot@linaro.org, surenb@google.com,
	stable@vger.kernel.org, rppt@kernel.org, rostedt@goodmis.org,
	peterz@infradead.org, mingo@redhat.com, mhocko@suse.com,
	mgorman@suse.de, lorenzo.stoakes@oracle.com,
	liam.howlett@oracle.com, kees@kernel.org, Kartikey406@gmail.com,
	juri.lelli@redhat.com, dietmar.eggemann@arm.com, david@kernel.org,
	bsegall@google.com, brauner@kernel.org
Subject: Re: + kernel-fork-validate-exit_signal-in-clone-syscall.patch added
 to mm-nonmm-unstable branch
Message-ID: <aa6ZrCZoEYgsPXka@redhat.com>
References: <20260308213116.7E884C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260308213116.7E884C116C6@smtp.kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 03/08, Andrew Morton wrote:
>
> From: Deepanshu Kartikey <kartikey406@gmail.com>
> Subject: kernel/fork: validate exit_signal in clone() syscall
> Date: Sat, 7 Mar 2026 12:12:02 +0530
>
> When a child process exits, it sends exit_signal to its parent via
> do_notify_parent().  The clone() syscall constructs exit_signal as:
>
>   (lower_32_bits(clone_flags) & CSIGNAL)
>
> CSIGNAL is 0xff, so values in the range 65-255 are possible.  However,
> valid_signal() only accepts signals up to _NSIG (64 on x86_64), causing a
> WARN_ON in do_notify_parent() when the process exits:
>
>   WARNING: kernel/signal.c:2174 do_notify_parent+0xc7e/0xd70

Aaah. Thanks Deepanshu! My bad, please see below.

> The comment above kernel_clone() states that callers are expected to
> validate exit_signal.

Yes, and man 2 clone says:

      The termination signal is specified in the low byte of flags (clone()) or in cl_args.exit_signal (clone3()).
      If no signal (i.e., zero) is specified, then the parent process is not signaled when the child terminates.

it doesn't document that nonzero non-valid signal acts as .exit_signal == 0.

> --- a/kernel/fork.c~kernel-fork-validate-exit_signal-in-clone-syscall
> +++ a/kernel/fork.c
> @@ -2800,7 +2800,8 @@ SYSCALL_DEFINE5(clone, unsigned long, cl
>  		.stack		= newsp,
>  		.tls		= tls,
>  	};
> -
> +	if (!valid_signal(args.exit_signal))
> +		return -EINVAL;
>  	return kernel_clone(&args);

Well, kernel_clone() has more users which doesn't validate .exit_signal,
say sys_ia32_clone().

we need to move the valid_signal() check from copy_clone_args_from_user()
to kernel_clone() or copy_process()...

So. This should fix my

	[PATCH] do_notify_parent: sanitize the valid_signal() checks
	https://lore.kernel.org/all/aZsfg0Y055yuAvsq@redhat.com/

do_notify_parent-sanitize-the-valid_signal-checks.patch in -mm tree.

Somehow I was very sure that copy_process() paths already have the valid_signal()
check but my memory fooled me.

But this is a user visible change which can cause other bug reports...
Perhaps we should revert do_notify_parent-sanitize-the-valid_signal-checks.patch
and this patch?

Even if I think that the new valid_signal() check "fixes" the undocumented
behaviour, unlikely there is a sane application which passes non-valid exit
signal to sys_clone(). But who knows...

Oleg.

