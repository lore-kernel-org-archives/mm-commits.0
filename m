Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A4F207662
	for <mm-commits@vger.kernel.org>; Mon, 24 Feb 2025 10:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740394010; cv=none; b=lPZr1jRy8ZrL5vBdoe57dobPRhb+Vnt8Kzk9hvMfIM0J1jfR6H2Afv3rMflMg7lX+Y4HaRyXpYDcUiI/92J6fbRPcQ7t5OfvAIjy0NpeXQNWDCYqZ/kW8r/+iRP+91a8X9nxdR6TOiBsyxQe784apMnDu0NTgnQI0h2xwHc0cL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740394010; c=relaxed/simple;
	bh=Wvy+EpnPqII0HNiFxLDgYEUP5XldifCm2OP/StDgrPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hRIUqnvbtBHAUmr3UOBA5tOf3rVxPMS7p20AEbruLNcYTKhE3YMY8epwGnNSLqF3pmaSCHnBlP7ZLbaoUw0YeuJUhECNnEVjZcnCcIVPOg4PlPg0ugjvEUhQwWwkreZ1TWuXwQvv3e+apwvyLYGcz8fkQgaT72ubQz8b+R4YFD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GW28w7Ck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GW28w7Ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5A1C4CED6;
	Mon, 24 Feb 2025 10:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740394010;
	bh=Wvy+EpnPqII0HNiFxLDgYEUP5XldifCm2OP/StDgrPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GW28w7CkYryl1hJHxyo7F32EN4j89DBjY51hZB8OQe+qvwYO6VWl2xTJR3nlDz1mn
	 YUC/3Ofu8mWvpXIF5bHINPIqJW9e1Kw6noAZ4hVbmg8QWZL2B+Fz4KR6fCkW/D/m41
	 1WZbt7AZsxTcrS0+68UjjcCOIYvxMDYSW3ot4GftMz2iZ+cTFuFvdRDC+BtD+mV/gw
	 P83HxMtNwimCMVURM4DQaRGkpLbFa28oHe/UfoLXc+3A4lmRokADly66OUClMPAW9R
	 esbFnJ/x73b0R3NGoP7/58EnvDo6bfruVJX0W8W9Ua5AOzQfCJNaWBfBL/cm8g4yJw
	 YoPXqMQHWGNmw==
Date: Mon, 24 Feb 2025 11:46:45 +0100
From: Christian Brauner <brauner@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, oleg@redhat.com, kees@kernel.org, 
	ebiederm@xmission.com, corbet@lwn.net, alexander@mihalicyn.com, mkoutny@suse.com
Subject: Re: + pid-optional-first-fit-pid-allocation.patch added to
 mm-nonmm-unstable branch
Message-ID: <20250224-sojabohnen-benehmen-47cb3c852560@brauner>
References: <20250222002156.BEE65C4CED6@smtp.kernel.org>
 <20250224-gemurmel-gebracht-595943846c93@brauner>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250224-gemurmel-gebracht-595943846c93@brauner>

On Mon, Feb 24, 2025 at 11:41:20AM +0100, Christian Brauner wrote:
> On Fri, Feb 21, 2025 at 04:21:56PM -0800, Andrew Morton wrote:
> > 
> > The patch titled
> >      Subject: pid: Optional first-fit pid allocation
> > has been added to the -mm mm-nonmm-unstable branch.  Its filename is
> >      pid-optional-first-fit-pid-allocation.patch
> > 
> > This patch will shortly appear at
> >      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pid-optional-first-fit-pid-allocation.patch
> > 
> > This patch will later appear in the mm-nonmm-unstable branch at
> >     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > 
> > The -mm tree is included into linux-next via the mm-everything
> > branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > and is updated there every 2-3 working days
> > 
> > ------------------------------------------------------
> > From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
> > Subject: pid: Optional first-fit pid allocation
> > Date: Fri, 21 Feb 2025 18:02:49 +0100
> > 
> > Noone would need to use this allocation strategy (it's slower, pid
> > numbers collide sooner). Its primary purpose are pid namespaces in
> > conjunction with pids.max cgroup limit which keeps (virtual) pid numbers
> > below the given limit. This is for 32-bit userspace programs that may
> > not work well with pid numbers above 65536.
> > 
> > Link: https://lore.kernel.org/r/20241122132459.135120-1-aleksandr.mikhalitsyn@canonical.com/
> > Link: https://lkml.kernel.org/r/20250221170249.890014-3-mkoutny@suse.com
> > Signed-off-by: Michal Koutný <mkoutny@suse.com>
> > Cc: Alexander Mikhalitsyn <alexander@mihalicyn.com>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Eric Biederman <ebiederm@xmission.com>
> > Cc: Jonathan Corbet <corbet@lwn.net>
> > Cc: Kees Cook <kees@kernel.org>
> > Cc: Oleg Nesterov <oleg@redhat.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> 
> Hm, I've never received this patch yet it reverts something and then
> substitutes another approach and has no Acks? Don't get me wrong I'm not
> objecting to it per se but I did not have any chance to actually look at
> it.

Found it. Seems to have been put into another folder for some reason.
