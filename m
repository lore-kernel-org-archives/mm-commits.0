Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5D53939B5
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 10:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773053268; cv=none; b=iBgz+0ytz7a6ImO/05aEzBYdrjHzNNLbgI0ToyAWh10nkslaQFW3oxAlP/RmuwN7cRR8c2MZBk4l3SKBQlwL+S7H0lDyAWKzIH7iNAzFwboPG9WUtyITkhPN8htvKM1+5FXzKqlgUyeAR2feli2EMsEzhUt4erfGMeLIGXHzy/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773053268; c=relaxed/simple;
	bh=dyJlDWhgWsRCO+gOiZRFkno+qqdcOrlbb349BcivbQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5/QRhIYuJmmb8nsp2pPa1VH5h9/iPwGWx3e9uMMEeoPQDiXVmUBVw/E0/hg5CmUGw1b9IJ+Peqy54ZSWVxGoGn2Df442mJ+lpRRQRYINEUjgUt10rd4RqX2Veu5fMZIUKTjCXH5iHnPks+DjoXKD5M8kl9OeNVe+Ri+GN+4XD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hMPCmrTg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hMPCmrTg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773053265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZdZOwrPl3gvdedWKPAiRadD+I0w5wetF5I5tAZO3Dbo=;
	b=hMPCmrTg+VuPc502PS4islPNGbAWLRwscBRsnpCCeyeAsoOVHoDFlyrrmw16xpMXXQgdWf
	AFpq+3rVzTreM4oKPogS94tPijPa890R1lUk6POyL5pbH4AnjpE0ry3Vhy2a2vRaJLVweh
	78UdJ8u7+LSoSvjNrHD6nypwT7b5isk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-148-iC7wUawuNbSyMSJyzcZlpA-1; Mon,
 09 Mar 2026 06:47:39 -0400
X-MC-Unique: iC7wUawuNbSyMSJyzcZlpA-1
X-Mimecast-MFC-AGG-ID: iC7wUawuNbSyMSJyzcZlpA_1773053257
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B834918005B6;
	Mon,  9 Mar 2026 10:47:36 +0000 (UTC)
Received: from fedora (unknown [10.45.224.43])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id A27F6180049D;
	Mon,  9 Mar 2026 10:47:29 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon,  9 Mar 2026 11:47:36 +0100 (CET)
Date: Mon, 9 Mar 2026 11:47:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	vschneid@redhat.com, vincent.guittot@linaro.org, surenb@google.com,
	stable@vger.kernel.org, rppt@kernel.org, rostedt@goodmis.org,
	peterz@infradead.org, mingo@redhat.com, mhocko@suse.com,
	mgorman@suse.de, lorenzo.stoakes@oracle.com,
	liam.howlett@oracle.com, kees@kernel.org, juri.lelli@redhat.com,
	dietmar.eggemann@arm.com, david@kernel.org, bsegall@google.com,
	brauner@kernel.org
Subject: Re: + kernel-fork-validate-exit_signal-in-clone-syscall.patch added
 to mm-nonmm-unstable branch
Message-ID: <aa6lQIECL7dChKkI@redhat.com>
References: <20260308213116.7E884C116C6@smtp.kernel.org>
 <aa6ZrCZoEYgsPXka@redhat.com>
 <CADhLXY6zH2A88dSDeTdsQJ77dEOPX5fkHu7PvhKL1beXGxs6Tw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADhLXY6zH2A88dSDeTdsQJ77dEOPX5fkHu7PvhKL1beXGxs6Tw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On 03/09, Deepanshu Kartikey wrote:
>
> > Well, kernel_clone() has more users which doesn't validate .exit_signal,
> > say sys_ia32_clone().
> >
> > we need to move the valid_signal() check from copy_clone_args_from_user()
> > to kernel_clone() or copy_process()...
> >
> > So. This should fix my
> >
> >         [PATCH] do_notify_parent: sanitize the valid_signal() checks
> >         https://lore.kernel.org/all/aZsfg0Y055yuAvsq@redhat.com/
> >
> > do_notify_parent-sanitize-the-valid_signal-checks.patch in -mm tree.
> >
> > Somehow I was very sure that copy_process() paths already have the valid_signal()
> > check but my memory fooled me.
> >
> > But this is a user visible change which can cause other bug reports...
> > Perhaps we should revert do_notify_parent-sanitize-the-valid_signal-checks.patch
> > and this patch?
> >
> > Even if I think that the new valid_signal() check "fixes" the undocumented
> > behaviour, unlikely there is a sane application which passes non-valid exit
> > signal to sys_clone(). But who knows...
> >
> > Oleg.
> >
>
> Hi Oleg,
>
> Thank you for the review.
>
> You are correct that fixing only the clone() syscall is incomplete.
> sys_ia32_clone() and other kernel_clone() callers would remain
> unprotected. I will send a v2 with the valid_signal() check moved
> to kernel_clone() to cover all callers.
>
> Regarding your do_notify_parent patch — since v2 will fix the root
> cause at kernel_clone(), your patch in the -mm tree can be dropped.

Well. my patch can be dropped with or without your v2. It is just
a cleanup and I still think it is a good cleanup...

But without your fix it is wrong. From the changelog:

	The "sig" argument of do_notify_parent() must always be valid

this is not true because (contrary to what I thought) sys_clone doesn't
validate exit_signal. The

	WARN_ON_ONCE(!valid_signal(sig))

added by that patch allowed to notice the problem you are trying to fix.

But again, this (your patch) is a user-visible change, and I am worried
even if I think this change is good.

Oleg.

