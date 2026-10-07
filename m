Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1773DA7CC
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 18:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791396373; cv=none; b=YkV1kWZzm7MyIfUwMAd7T7RDrvFanEXfrAjwMkRzsvecXB8uiXc95nQCsSdxkDlRRba3UKsTWEKR5ZYnLSdK9oD/as2vya9qW07y/wSEu/VS4yjW/lKFZF3NyEO0KfcbKIo3eS+9Bd2EeQbnFIKy9WeF/03zbOtbwtRZySlxp2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791396373; c=relaxed/simple;
	bh=n0QyWhrhm9acceTGuEWxrsWW9BZVMA/qAEKGz3jHlE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pXJfUDvihDXq0+KloWtHtIGHBrSmqfFNy3RjW+3P2IfXks+zaELuN318NJARyBrsWRlXa5q/BHYI2A0qoIIK/+b/238ahrVrQQBih/ndVyavBWm259Mwt2+05cQ7ZtYk3tyh8t9TPY0jgLunnO2rVuU2GUyYx+OkelGavnfSONs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e+M96Qlq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e+M96Qlq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791396370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2fQy0gH4jBuk/GkjYe79GSoXE0kJTpqvpiUcKQbNvg4=;
	b=e+M96QlqPjayqS32EGFkEU5ZnsKFSGv5m9gYdKwTU3hVm78nS57cX6rjjrV0K+0SVwhKiu
	k5KypWhnZmoEGgIILDHEwPzWSH9oFcEdV+ts7dvitweXIqVkAD+XnDQWtcAtt18/5wwU03
	GHUMHsVgiKvtfHcBDZO3zRaqzw4VNG8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-474-TOdfJvT3OjWeiyaxIwrscw-1; Wed,
 07 Oct 2026 14:06:06 -0400
X-MC-Unique: TOdfJvT3OjWeiyaxIwrscw-1
X-Mimecast-MFC-AGG-ID: TOdfJvT3OjWeiyaxIwrscw_1791396365
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5CDC51800BE2;
	Wed,  7 Oct 2026 18:06:05 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 060B21956095;
	Wed,  7 Oct 2026 18:06:03 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Wed,  7 Oct 2026 20:06:05 +0200 (CEST)
Date: Wed, 7 Oct 2026 20:06:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Bradley Morgan <brads@mainlining.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, mm-commits@vger.kernel.org,
	bsingharora@gmail.com
Subject: Re: [to-be-updated]
 taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch removed
 from -mm tree
Message-ID: <asaKCo5lwB3nzWNM@redhat.com>
References: <20261007012108.780B01F0089B@smtp.kernel.org>
 <CB0B268A-5D7E-4FDE-A706-1A7AD877EA93@mainlining.org>
 <20261007101242.050caf151539d660e8bdc100@linux-foundation.org>
 <A2B94D8E-F026-406E-B346-9200FA081EB0@mainlining.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2B94D8E-F026-406E-B346-9200FA081EB0@mainlining.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On 10/07, Bradley Morgan wrote:
>
> Changes since V1:
> - spin_lock_irq() instead of spin_lock_irqsave() (Oleg)

I have already reviewed this version... Let me quote
https://lore.kernel.org/all/anMC3eRoRdaST0Se@redhat.com/

	Acked-by: Oleg Nesterov <oleg@redhat.com>

	However. I won't blame your fix, but I am not sure it actually fixes the
	real problem.

	In the scenario above, if thread B takes ->siglock first (before thread A)
	it will report TASKSTATS_TYPE_TGID/AGROUP without accounting thread A.
	Looks "obviously wrong" but I forgot everything about taskstats.

	And OTOH... for_each_thread() in fill_stats_for_tgid() can't rely on the
	tsk->exit_state check, the same thread can be accounted twice.

So perhaps the changelog should mention that this patch doesn't fix all the
related problems? Or may be you can try to make V3 which fixes them all?

> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -635,7 +635,10 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
>  	if (!stats)
>  		goto err;
>
> +	/* This was racy before, copy the stats under siglock. */

Well, this comment looks strange to me. I'd suggest to drop it.

> +	spin_lock_irq(&tsk->sighand->siglock);
>  	memcpy(stats, tsk->signal->stats, sizeof(*stats));
> +	spin_unlock_irq(&tsk->sighand->siglock);
>  	stats->version = TASKSTATS_VERSION;

Oleg.

