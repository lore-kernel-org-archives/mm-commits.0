Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC028460;
	Thu,  3 Apr 2025 05:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743657326; cv=none; b=InwjHy2ljDEa97TnWnF4wxv0F6ODsv7UVe82mKbP+pEUgFdZz7TzNXJrtWvtqOtJyjEY3pxzxoFGSo1li+ZvfX1QPqfIMSHWS3hsXQg+BJ8Rj16I99zbmnli50GXhInDnayTvw2rp+lismH8kWBGmQ9mAw4C/9AkYrZntWzuf8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743657326; c=relaxed/simple;
	bh=UdqMc0MSCECwtGXzuxKTAlq/kl8y9B1xLKOw5nOaOWI=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=YAhE3+O2Bd07BOhQjViNZioni494W67rv0d+U2xhi/FPHZzXRE3i56hwRTYWRDkDYKQQMGOSwRcCkAr/gRk5rFP+7jJKRRfG1WidBnPEZLh2afTJwhYQBCshj+xK4/aHqM6miFNTVBxXo+VAQdCp6HoZE92BxcRym/A/UbKUEmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R5D4N+Tr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R5D4N+Tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A644FC4CEE3;
	Thu,  3 Apr 2025 05:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743657325;
	bh=UdqMc0MSCECwtGXzuxKTAlq/kl8y9B1xLKOw5nOaOWI=;
	h=Date:From:To:Cc:Subject:From;
	b=R5D4N+TrmOjsVd1vkVRrmGMmuWod0nDnXCcVI66D/L+XEUjNvchc86NsEJ20IyvUi
	 jAdFAzKAVns6jvoa2shzFM8MqOcmnav7u4NzAiQAWCAdV/Q08qDKbpFNsZSk2xJHso
	 ctaqC0Au+TqvMdm7JXidNkA+dliSddOnLrtSlxUE=
Date: Wed, 2 Apr 2025 22:15:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.15-rc1
Message-Id: <20250402221524.20f50c3af6f51bafc2dd618d@linux-foundation.org>
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


The following changes since commit 25601e85441dd91cf7973b002f27af4c5b8691ea:

  Merge tag 'char-misc-6.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc (2025-04-01 11:26:08 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-04-02-21-57

for you to fetch changes up to c11bcbc0a517acf69282c8225059b2a8ac5fe628:

  mm: zswap: fix crypto_free_acomp() deadlock in zswap_cpu_comp_dead() (2025-04-01 15:14:43 -0700)

----------------------------------------------------------------
5 hotfixes.  3 are cc:stable and the remainder address post-6.14 issues
or aren't considered necessary for -stable kernels.

All 5 patches are for MM.

----------------------------------------------------------------
Liu Shixin (1):
      mm: page_isolation: avoid calling folio_hstate() without hugetlb_lock

Marc Herbert (1):
      mm/hugetlb: move hugetlb_sysctl_init() to the __init section

Peter Xu (1):
      mm/userfaultfd: fix release hang over concurrent GUP

Yosry Ahmed (1):
      mm: zswap: fix crypto_free_acomp() deadlock in zswap_cpu_comp_dead()

Yu Zhao (1):
      mm/hugetlb_vmemmap: fix memory loads ordering

 fs/userfaultfd.c           | 51 +++++++++++++++++++++++-----------------------
 include/linux/page-flags.h | 37 +++++++++++++++++++++++++++++++++
 include/linux/page_ref.h   |  2 +-
 mm/hugetlb.c               |  2 +-
 mm/page_isolation.c        |  9 +++++++-
 mm/zswap.c                 | 30 +++++++++++++++++++--------
 6 files changed, 94 insertions(+), 37 deletions(-)

