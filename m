Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C8B23EAB0;
	Tue, 24 Mar 2026 01:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774314009; cv=none; b=aqUmKIzPVRuBD2z1fmaQV8XV5G3kpepemforyrfy78mNDrsfnWNWFPsnsdmkvqI2NhqDCXAnErSAWXVMebJHYMFIq54jCWnqUtdloFGTNFcv0QPzo1Gx4iXl5mV313r5zax+lM24dqKIDfX7010glIzKha91G9zzcjazd+4wQI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774314009; c=relaxed/simple;
	bh=1M/+ZL3YVbiZ1VmIZKgVEENFjtm//36Vc792xqujAVM=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=qqeZSj46FDO28E1tOPj0wilyqF2F/BmcnFc6ru8FpVOdMOiDfcT820vTTC5FViqAR+mgBz1tKkIFRFLQJ+u9TCx2fUKaotblO/69xMdwsoAPrpaPYEtvwvxlenUeVFPS/TsEWtTjcZfT3/vXToooBlVczZeA7egwYeFrAkeB4C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LcMfJHMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LcMfJHMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCA7C2BCB0;
	Tue, 24 Mar 2026 01:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774314008;
	bh=1M/+ZL3YVbiZ1VmIZKgVEENFjtm//36Vc792xqujAVM=;
	h=Date:From:To:Cc:Subject:From;
	b=LcMfJHMG7UV0nKYomJpJIw5mjaC+sj3HzgQCJUrnWRBy4Hrjp2TJ/UlRy1gWEir6p
	 sggXOsQI7H2owR6Gz3Z0BhemlKrNaBhjeQb6qIVKNHnDcpBHHy4X0w9ZQajn3F0RZv
	 te4xfLiIQ1B1r6spQqdnXhwKRnIu5FRv8mydft5o=
Date: Mon, 23 Mar 2026 18:00:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.0-rc6
Message-Id: <20260323180007.d3f7db6a8b5dc59e72cb5f62@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit f0caa1d49cc07b30a7e2f104d3853ec6dc1c3cad:

  Merge tag 'hid-for-linus-2026031701' of git://git.kernel.org/pub/scm/linux/kernel/git/hid/hid (2026-03-17 13:55:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-23-17-56

for you to fetch changes up to 84481e705ab07ed46e56587fe846af194acacafe:

  mm/damon/stat: monitor all System RAM resources (2026-03-23 09:35:05 -0700)

----------------------------------------------------------------
6 hotfixes.  2 are cc:stable.  All are for MM.

All are singletons - please see the changelogs for details.

----------------------------------------------------------------
Lorenzo Stoakes (Oracle) (2):
      mm/rmap: clear vma->anon_vma on error
      mm/zswap: add missing kunmap_local()

Muhammad Usama Anjum (1):
      mailmap: update email address for Muhammad Usama Anjum

SeongJae Park (2):
      mm/damon/core: avoid use of half-online-committed context
      mm/damon/stat: monitor all System RAM resources

Sergey Senozhatsky (1):
      zram: do not slot_free() written-back slots

 .mailmap                      |  1 +
 drivers/block/zram/zram_drv.c | 39 ++++++++++++-------------------
 include/linux/damon.h         |  6 +++++
 mm/damon/core.c               |  8 +++++++
 mm/damon/stat.c               | 53 ++++++++++++++++++++++++++++++++++++++++---
 mm/rmap.c                     |  7 ++++++
 mm/zswap.c                    |  8 ++++++-
 7 files changed, 93 insertions(+), 29 deletions(-)

