Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615EE2248A0;
	Fri, 13 Feb 2026 15:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770995838; cv=none; b=hYsrDEXJxYD1ZfC9BV0f3nPGDWaMrDp0XYM7z7vUo1/DnNKyCJfKnZ5nbVIzsZvtPE7/R2ShHRrsmLvHWTQRgXGnlNejVudYbMEB71UKcV9WBxmSsmwLxI7Nm3SOD3k3QEWHqRzKP/dLsBwgetshW4fjgxHfJaUj51SAWvMZVKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770995838; c=relaxed/simple;
	bh=oDfGuQh7pNJ7KGhH8va5HzkkrySOSNEsTzNlJTele74=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=KYKU/Sx5uc8MzGq9W4yNzU82/fCdIwAce3fbQIz1+Y4C2jLUvEu2pIJwyFZ5fWaY4I03+TpPuBk4Ojut/+uTLVQUy8to4M6QwZHog8yU3HZ/RCTVnS++f6gUzwdS2fsv59q6Kt8vCMfBFQnkMhJTi8yrDIycuR9tYrXeI+8pVI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VcHXH+lN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VcHXH+lN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF69C116C6;
	Fri, 13 Feb 2026 15:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770995838;
	bh=oDfGuQh7pNJ7KGhH8va5HzkkrySOSNEsTzNlJTele74=;
	h=Date:From:To:Cc:Subject:From;
	b=VcHXH+lNC0FO2m9miUA+DC+R8RUBYTHy8B9wgjixzEfTZfRPlpa8f1kzeg5CbXUmt
	 IMD3qenvjSswub+pGI3l5GzL5iBHL5lsVKAdeHoGn3XFZHX1LjlTVRTvW6SSwjpf1+
	 G2y8Iz0EUzikpthXkoj0EJ4IN4GP/v2HvVJ702Mg=
Date: Fri, 13 Feb 2026 07:17:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.0-rc1
Message-Id: <20260213071717.77ff0bf809865bfb7901453a@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this small batch of hotfixes, thanks.


The following changes since commit ae9fd76c111bb4a5293c2831a1ad373605251dd6:

  mm/memory-failure: reject unsupported non-folio compound page (2026-02-05 14:10:00 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-13-07-14

for you to fetch changes up to 61dc9f776705d6db6847c101b98fa4f0e9eb6fa3:

  procfs: fix possible double mmput() in do_procmap_query() (2026-02-12 15:40:16 -0800)

----------------------------------------------------------------
Three MM hotfixes, all three are cc:stable.

----------------------------------------------------------------
Andrii Nakryiko (1):
      procfs: fix possible double mmput() in do_procmap_query()

Harry Yoo (1):
      mm/page_alloc: skip debug_check_no_{obj,locks}_freed with FPI_TRYLOCK

Joshua Hahn (1):
      mm/hugetlb: restore failed global reservations to subpool

 fs/proc/task_mmu.c |  3 ++-
 mm/hugetlb.c       |  9 +++++++++
 mm/page_alloc.c    | 17 +++++++++++------
 3 files changed, 22 insertions(+), 7 deletions(-)

