Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218C143F8CB
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 17:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791393166; cv=none; b=WtmVLee+/X70DmnqTvGv+QrKO6qn/o0fo+dukHSJwgfJYMPqcl5+V7Dtcf75FblOSsLEuyM/0lqoMksJGkFUMyfUeuqkv67cApf9pItff+7EdcmoXP7ho8E6MAs0NqHWpH4cOnM5aAzhlmK72gAsU7PZh6JdL3TGBiY60qxdMxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791393166; c=relaxed/simple;
	bh=UwMfQG8Q+10r9EDlX7sktnSawviwSWqwCBh4wjJ6nC4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=XWl6n4mJgWnTsqNHzjo0dNTTU734plATMHNYiLkB5k60KXPlgh4Dn4Jw46UA8r0Xs3gP2swjY+/Vjka/LhROebS7R5H3zjdl8za1CkxXcZG0hGMR2Y1BX+Ga8vvN3sFy3WtMRla1JXspgghuLY2TroilC6jouyeBZdfhfg27bVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gCEoe2A6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gCEoe2A6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8371C1F000FF;
	Wed,  7 Oct 2026 17:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791393163;
	bh=ZbkI89XiCxnDrEw+XasKgpbW1WGKhjlepOKKhTUOlP8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gCEoe2A6iyE9wqdL8AfgDRTJZKU62CnxFIx3GH6yqbYInr0LR2Wfk4jm9ZHZvgUj+
	 6pxOt06ACcLPnFj1fXr4IQN2+vV+Cdek1mP74xOKnYXYwhayeGtYMsWPmAoBLpHYtx
	 tyPdVJ8wYwqCrKZh1nUqr/4ipOFmizMuUs7HzUHA=
Date: Wed, 7 Oct 2026 10:12:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bradley Morgan <brads@mainlining.org>
Cc: mm-commits@vger.kernel.org, oleg@redhat.com, bsingharora@gmail.com
Subject: Re: [to-be-updated]
 taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch removed
 from -mm tree
Message-Id: <20261007101242.050caf151539d660e8bdc100@linux-foundation.org>
In-Reply-To: <CB0B268A-5D7E-4FDE-A706-1A7AD877EA93@mainlining.org>
References: <20261007012108.780B01F0089B@smtp.kernel.org>
	<CB0B268A-5D7E-4FDE-A706-1A7AD877EA93@mainlining.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 07 Oct 2026 07:39:03 +0100 Bradley Morgan <brads@mainlining.org> wrote:

> On 7 October 2026 02:21:08 BST, Andrew Morton <akpm@linux-foundation.org>
> wrote:
> >
> >The quilt patch titled
> >     Subject: taskstats: copy signal->stats under siglock in taskstats_exit
> >has been removed from the -mm tree.  Its filename was
> >     taskstats-copy-signal-stats-under-siglock-in-taskstats_exit.patch
> >
> >This patch was dropped because an updated version will be issued
> 
> 
> Any reason? I didn't get let known about this! :)

That's what happens when you change email addresses :(



Begin forwarded message:

Date: Tue, 6 Oct 2026 18:20:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bradley Morgan <include@grrlz.net>
Subject: Re: [PATCH] taskstats: copy signal->stats under siglock in taskstats_exit


On Tue,  4 Aug 2026 09:34:00 +0000 Bradley Morgan <include@grrlz.net> wrote:

> taskstats_exit() copies tsk->signal->stats into the exit reply
> without taking any lock. Every other writer of this struct holds
> sighand->siglock before touching it, and this copy does not.
> 
> The copy happens on the last thread of a thread group that exits.
> group_dead being 1 only says that every thread has dropped
> signal->live, it does not say how far the other threads got in
> do_exit(). One of them can still be inside fill_tgid_exit() adding
> its counters to the struct while the last thread copies it out, so
> the copy can read the struct in the middle of an update.

I managed to lose the v2 of this.  Please resend sometime?  Add
a cc:oleg while in there.

Thanks.

