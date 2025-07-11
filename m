Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F472224AED
	for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2025 23:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752275180; cv=none; b=ppSAO1sGGjJEwwN5En88oTr01ahFbWuiZzI3RZ44NGH3CMA4PZWg63ZyK+wc4BRmDfYb8VZ85eHGMcCTVUUXucEy1TBT+hrioCFjozUWmT9LP7FEnh6p1815kEoW7aJL6XkxgVmyfADtZboQOoBOhLtUaXKRlhE5tw0nlBGJyD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752275180; c=relaxed/simple;
	bh=LhZGDLjU8ErSQEfKXMfoYJhKygV+LdY6Q26I8NHLWBs=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=BKnHQryazigmGc+4Ar3OPi42RTpKZBgdwPbLG1rIxD+P+H2wjLUmE6bax0ys6trq0RqnjuhSmGoXahGtx7pyagtXS+igQqZuJNt+Vb+PG94Q35ZTtIvL+zi13pG/2TM/EIwCImkQ5pEFmiZNDRPkcKH9sMPnVYCVLElwo+fvLiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=syuBc9ns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="syuBc9ns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2502C4CEF6;
	Fri, 11 Jul 2025 23:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752275178;
	bh=LhZGDLjU8ErSQEfKXMfoYJhKygV+LdY6Q26I8NHLWBs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=syuBc9nstyvnr+l63LgeUy8Ii9a0OKEsRseG9O2jov8QQLsaZXmdz76JiyiwvcKqS
	 KCnMWh9K9Df2D6gtAZjSrRFWaYphf3/OQjGUXSkN7K3h4lpFWM/1E4KvwqxUHmC30G
	 dn83RNdGM4CeE8Df6aNAooogBFIDWi7UEwamOvQI=
Date: Fri, 11 Jul 2025 16:06:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com,
 mario.limonciello@amd.com, dyoung@redhat.com, dwmw2@infradead.org,
 bhe@redhat.com
Subject: Re: + kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch
 added to mm-nonmm-unstable branch
Message-Id: <20250711160617.077fa359b09a337daf9defc8@linux-foundation.org>
In-Reply-To: <CAJZ5v0jEr1kCdQ2C7waM75oFYiPNeqt4fv90mK3=YSgPqgWstw@mail.gmail.com>
References: <20250710215352.A170CC4CEE3@smtp.kernel.org>
	<CAJZ5v0jEr1kCdQ2C7waM75oFYiPNeqt4fv90mK3=YSgPqgWstw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 11 Jul 2025 10:35:31 +0200 "Rafael J. Wysocki" <rafael@kernel.org> wrote:

> On Thu, Jul 10, 2025 at 11:53 PM Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> >
> > The patch titled
> >      Subject: kexec_core: Drop redundant pm_restore_gfp_mask() call
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      kexec_core-drop-redundant-pm_restore_gfp_mask-call.patch
> 
> This patch depends on
> 
> https://lore.kernel.org/linux-pm/aHCsUAhqRz5zJH2t@MiWiFi-R3L-srv/

I noticed ;)

> so you need to queue up both or let me queue them up.

Well what's your preference?  This was unknowable from the emails as-sent...
