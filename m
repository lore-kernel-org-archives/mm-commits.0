Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D03834FF41;
	Wed,  4 Feb 2026 04:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770181148; cv=none; b=h98FRTWbiVSzJfilO7BN+qq2K8kQqHBBjE+1X2onzbQsuCN4v0gsf079VbdtokJmHuzbaAb57hO8kPASqAcIcdFy0I/AUiykiF+Ke04icDAAboy3SdDCWEeQqpRymf4sj6DeI+UOldvN2voBKaez1AK2vk58niSJdRXqupYfoP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770181148; c=relaxed/simple;
	bh=FgaMbdOeBD5fqKOuTtyHB1XTW01hQpt6J3ovXnHSN0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6YmfCpHHurnAORTgTiX36D8NigOjyVefQ6f5PgBHqQo/Iq8AXrEoKNf5VqrRc8VTVHVWACpJb3HNJjKdX7Sgutpalx2dOC7F+6zfFC+Vfukr22ewLgeex7qWX/uawIlGKHjC5cjvd3fAUKSttTlHCnT7TEghNmg2W+RVvbhd3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r5bFU0dS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r5bFU0dS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7812C4CEF7;
	Wed,  4 Feb 2026 04:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770181148;
	bh=FgaMbdOeBD5fqKOuTtyHB1XTW01hQpt6J3ovXnHSN0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r5bFU0dSqSJpsU1IrACWgtWflsp/2EdBvkVJYdCN/u0ECnVPOnzqLD9WtRdcil7YD
	 QQOs7/7aRUydgNB2tgzWw8ZG95gnve7i0gZ7kGvZ26Q5YHx0J3KfZyJuyFZwGcHfJY
	 XRufToswL5nWy1eHhXdZGKIJnO4d1g8JlWm5Un8qWwBU3pHz+c/SsRCQZSttNXW1xd
	 1dWpLrV4Inh87z6emLQuj3pY2daTZaq2M6eN1uPJBDW6tGEn5QpwFql2g1ABAD/mm5
	 4YXJ+kb5vCmChK1eWoXTLCHeDa6G5UGKJ/mUG5b9pNakVS0moh7jnV3bv8xU1hBMmv
	 /WWMxHwkXOqMA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	mm-commits@vger.kernel.org,
	qin.yuA@h3c.com,
	damon@lists.linux.dev
Subject: Re: + mm-damon-remove-redudnant-mmu-notifier-call-in-pmdp-mkold.patch added to mm-new branch
Date: Tue,  3 Feb 2026 20:58:59 -0800
Message-ID: <20260204045900.15700-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260203232611.00B57C116D0@smtp.kernel.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Andrew,

On Tue, 03 Feb 2026 15:26:10 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      Subject: mm/damon: remove redudnant mmu notifier call in pmdp mkold
> has been added to the -mm mm-new branch.  Its filename is
>      mm-damon-remove-redudnant-mmu-notifier-call-in-pmdp-mkold.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-remove-redudnant-mmu-notifier-call-in-pmdp-mkold.patch
> 
> This patch will later appear in the mm-new branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> Note, mm-new is a provisional staging ground for work-in-progress
> patches, and acceptance into mm-new is a notification for others take
> notice and to finish up reviews.  Please do not hesitate to respond to
> review feedback and post updated versions to replace or incrementally
> fixup patches in mm-new.
> 
> The mm-new branch of mm.git is not included in linux-next
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next via various
> branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there most days
> 
> ------------------------------------------------------
> From: qinyu <qin.yuA@h3c.com>
> Subject: mm/damon: remove redudnant mmu notifier call in pmdp mkold

Could you please update the suject to use 'mm/damon/ops-common:' as the prefix?


Thanks,
SJ

[...]
