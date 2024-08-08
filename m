Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB83BE40;
	Thu,  8 Aug 2024 03:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723087689; cv=none; b=QRn1ZeRZTUwGlD+72jNldssSYnzbw8DZi7OfHjxAKVklUZ3sCpoNzYEn8bLjkXNFNSQTwh4TCLPLemWHUPGsvs6Mu6g80OcsJVbjSZ98kbuj9JY1M8fPSm0tJcgIToLdKAz8LHuos3o8jTvErwVrgKSznZs8WwKinxfQsfCDD58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723087689; c=relaxed/simple;
	bh=4yRXFZT9akHxi1OR9qiv1FNm7VAzJ/7I0NfB8LIrAao=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=UmpyZFCKnr+BNYcGdOj62XlIBe8hjiyg2/tj30OKPPSwcQ/hR4S8MNewKKKirXA8ApnrZ2feyXAkVa7lg/Gm7mbxza1TTq26+QCm7K74XtNB9wALSPJZ8Q83ScR/bplqrmnjXz9Pgb5UaFgUw57fIuiZKxESJOaXLxFWq1HIxQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f1xePQd5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f1xePQd5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B331C32781;
	Thu,  8 Aug 2024 03:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723087688;
	bh=4yRXFZT9akHxi1OR9qiv1FNm7VAzJ/7I0NfB8LIrAao=;
	h=Date:From:To:Cc:Subject:From;
	b=f1xePQd5xsWoN3aVu9cpW9xhWzlth8mxdoeRT72enCc7IU8ZePEp9ZdQx1tUuzbFr
	 1UVdaCVVSTbD6xcMdk+anIwCol0rWIgYWj+8WiU0ZKyv15RInNTotu2foZ9HenWbK2
	 iA4eF2SK4/qvOOxfjnXy+j/zQBZcuScBD96B2QYk=
Date: Wed, 7 Aug 2024 20:28:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: [GIT PULL] hotfixes for 6.11-rc2
Message-Id: <20240807202807.2787ceac0ca8a603be90d3c5@linux-foundation.org>
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


The following changes since commit 8400291e289ee6b2bf9779ff1c83a291501f017b:

  Linux 6.11-rc1 (2024-07-28 14:19:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-08-07-18-32

for you to fetch changes up to 6d45e1c948a8b7ed6ceddb14319af69424db730c:

  padata: Fix possible divide-by-0 panic in padata_mt_helper() (2024-08-07 18:33:56 -0700)

----------------------------------------------------------------
9 hotfixes.  5 are cc:stable, 4 either pertain to post-6.10 material or
aren't considered necessary for earlier kernels.  5 are MM and 4 are
non-MM.  No identifiable theme here - please see the individual changelogs.

----------------------------------------------------------------
Andrey Konovalov (1):
      kcov: properly check for softirq context

Baolin Wang (2):
      mm: shmem: avoid allocating huge pages larger than MAX_PAGECACHE_ORDER for shmem
      mm: shmem: fix incorrect aligned index when checking conflicts

David Heidelberg (1):
      mailmap: update entry for David Heidelberg

Muchun Song (1):
      mm: list_lru: fix UAF for memory cgroup

Nico Pache (1):
      selftests: mm: add s390 to ARCH check

Petr Vorel (1):
      MAINTAINERS: Update LTP members and web

Shakeel Butt (1):
      memcg: protect concurrent access to mem_cgroup_idr

Waiman Long (1):
      padata: Fix possible divide-by-0 panic in padata_mt_helper()

 .mailmap                            |  1 +
 MAINTAINERS                         |  4 +++-
 kernel/kcov.c                       | 15 ++++++++++++---
 kernel/padata.c                     |  7 +++++++
 mm/list_lru.c                       | 28 ++++++++++++++++++++++------
 mm/memcontrol.c                     | 22 ++++++++++++++++++++--
 mm/shmem.c                          | 14 +++++---------
 tools/testing/selftests/mm/Makefile |  2 +-
 8 files changed, 71 insertions(+), 22 deletions(-)

