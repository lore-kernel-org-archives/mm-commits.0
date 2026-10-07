Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B68448B89
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 17:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791395695; cv=none; b=C4egLi94krhvejueESq6gJO8PXh0yuQ7cEmw9I70BLt5aPxzFOTBaI/Fydx5eQ6Ji9kdf03vwMnohT+/yV1wo2oN9KVjfjtgLFdU/WLfGSDugqwFmpBSozQTSjQ2eHTwP9eRAcPttzcYk1FtNnTgN548EPOSTdU1mQPVBJqGvkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791395695; c=relaxed/simple;
	bh=Af9jw6Y94oWun9dv/saij7Nf1Gv3JUJ9Tv+ze0prD8A=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Vvmm2YFkjfiuFeXfMTpteejqYMBeznzfV8vaXQgBv3DwWbv18Ay00xju/gFZW50/vEIvMnuvTx8Byv3uyYuoNg6fjiaHiGqpfL8HSjrL6WPpKA07lJ5WLQ2CTSbpNPeyVoIDL9hopehGJoe03BvKKWEtvs2wWw++lpaFbvzfCq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S6K3o/3d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S6K3o/3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43BC1F000FF;
	Wed,  7 Oct 2026 17:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791395693;
	bh=JuWF0CayfrBfRyMhtTAa+SJe3zP9U/2djDjjOQtMAj0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=S6K3o/3d88O2kiEYF+dBfdDXFjiiQd6TXK0niWzYYuJn0mLzaiY/VtpBKPW5SAGBh
	 QTg+NUUT7oHA3qMU1dAzn9UsRqPGHGw3BBYEZPlrYk3lem6vCi4heHelPG28rJWYXl
	 LXEc2/L3lXvpdOz3lv+uHeh20M7QD3TbavPEWfrI=
Date: Wed, 7 Oct 2026 10:54:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bradley Morgan <brads@mainlining.org>
Cc: mm-commits@vger.kernel.org, oleg@redhat.com, bsingharora@gmail.com
Subject: Re: [to-be-updated]
 taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch removed
 from -mm tree
Message-Id: <20261007105452.a5c7327cc595a4820bf80e73@linux-foundation.org>
In-Reply-To: <A2B94D8E-F026-406E-B346-9200FA081EB0@mainlining.org>
References: <20261007012108.780B01F0089B@smtp.kernel.org>
	<CB0B268A-5D7E-4FDE-A706-1A7AD877EA93@mainlining.org>
	<20261007101242.050caf151539d660e8bdc100@linux-foundation.org>
	<A2B94D8E-F026-406E-B346-9200FA081EB0@mainlining.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 07 Oct 2026 18:19:50 +0100 Bradley Morgan <brads@mainlining.org> wrote:

> >
> >From 137b873cce7721384c9d24f4c0864bb002c8d039 Mon Sep 17 00:00:00 2001
> From: Bradley Morgan <include@grrlz.net>
> Date: Tue, 4 Aug 2026 09:34:00 +0000
> Subject: [PATCH v2] taskstats: copy signal->stats under siglock in
>  taskstats_exit

Thanks.  Please send as a standalone email and cc linux-kernel?  So we
get a nice Link: in the permanent record.  (mm-commits Links: work
though).

> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -635,7 +635,10 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
>  	if (!stats)
>  		goto err;
>  
> +	/* This was racy before, copy the stats under siglock. */

That's not a great comment - we're really not interested in what is
essentially embedded changelogging.

A good comment would explain *why* we're taking the lock.  Briefly
describe what we're excluding against.

> +	spin_lock_irq(&tsk->sighand->siglock);
>  	memcpy(stats, tsk->signal->stats, sizeof(*stats));
> +	spin_unlock_irq(&tsk->sighand->siglock);
>  	stats->version = TASKSTATS_VERSION;

