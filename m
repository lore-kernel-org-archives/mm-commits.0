Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C3F8460;
	Thu,  3 Apr 2025 05:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743657352; cv=none; b=Nxaei+mP7sDZR4/xibnbvwwioQaBPKGsMj6sfF91PnaE6KYLa+z5Lq9hCADX+QF9To5tvOBg91/SCxKgnLRo6da+Y/zo0wrT/b3n+5gn6+cV8SLgIR5IzV+brkera1rAMl1pgePvQRSHovX3dFpEo5norP5PIUV/iJU+X5PfqiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743657352; c=relaxed/simple;
	bh=9Uo8OyaMiPKcyfNuYPU/mQOe58fUo5WXbR7MlZclq24=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=t516Xjurqu/oX45aWMTcRlx4O9/wQo/ORZiJjl1l3tJTvnIW0Fje/LE85IzvQQgNG2cvtIUiVKb4aIBtMwvk1SOnv2wRmtYIOuovWRCLsqLIghmjvGkupa+UbbW9lpBocrExonbI3A3GFig1I24IjGATNNZkMTBq8k2i8CEIsU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SD21SrxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SD21SrxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFB3C4CEE3;
	Thu,  3 Apr 2025 05:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743657351;
	bh=9Uo8OyaMiPKcyfNuYPU/mQOe58fUo5WXbR7MlZclq24=;
	h=Date:From:To:Cc:Subject:From;
	b=SD21SrxR0V6V9kWYxhDK1fg/cBoCWX7zfLKUAOpdQZ6TiIQwQKnYVia9HJP4twAv1
	 fMCtP1ymjzEVZsF5KGigQY7lBPf7HP/fKNRs17PsKoy5B0FsJA2D8dIVjzT9hK803N
	 WJBvwiMTtrpulclhDiE45TkZBS6GS74PRO1JDI7A=
Date: Wed, 2 Apr 2025 22:15:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] Additional non-MM updates for 6.15-rc1
Message-Id: <20250402221551.4d682cf5ee222b9e5b6a1a8b@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this second set of non-MM updates, thanks.


The following changes since commit 25601e85441dd91cf7973b002f27af4c5b8691ea:

  Merge tag 'char-misc-6.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc (2025-04-01 11:26:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-04-02-22-12

for you to fetch changes up to 8b46fdaea819a679da176b879e7b0674a1161a5e:

  lib: scatterlist: fix sg_split_phys to preserve original scatterlist offsets (2025-04-01 15:20:46 -0700)

----------------------------------------------------------------
One bugfix and a couple of small late-arriving updates.

----------------------------------------------------------------
Kent Overstreet (1):
      lib/sort.c: add _nonatomic() variants with cond_resched()

Nicolas Schier (1):
      mailmap: add an entry for Nicolas Schier

T Pratham (1):
      lib: scatterlist: fix sg_split_phys to preserve original scatterlist offsets

 .mailmap             |   2 +
 include/linux/sort.h |  11 ++++++
 lib/sg_split.c       |   2 -
 lib/sort.c           | 110 ++++++++++++++++++++++++++++++++++++---------------
 4 files changed, 92 insertions(+), 33 deletions(-)

