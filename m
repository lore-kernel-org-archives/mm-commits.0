Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E175372EC3;
	Tue,  7 Apr 2026 03:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775533208; cv=none; b=StmsTlYig/cPnOYOT1vxrobVjsu0LDY1uyk/YLHkuDwx5AXgotFocjecKYkNCUkjrGqrdyVkAv/zocO8W5HpbdTrzjEQuBPyVbH3my/Ldxwf5/9pL4mcgmNPSGYNfyZ82k0CroEZtzlHQUgHDXP15zv6wH5vG0CJJetIsdAEs0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775533208; c=relaxed/simple;
	bh=shTerlkN7e+DreHUemklMoHDvYCzvsR93XdO9+oDo9U=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=ba3uLevLU18yYDPfRt5ZBMZ5J3AIdLFdT0kaXdOXmtnD98+2TIS3ORQOBp4JqQSRN5XC1l8ZZSUz9rWe2taOx6UyOVo4iLZFn9dEdAOuAfvArJ2Eo5uqxeCRZG5Nw+U7OSw4XgXxXto2sMpeaGa93TYPpycuhDe2BCwJNkTEFJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QrOAana3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QrOAana3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9F7C116C6;
	Tue,  7 Apr 2026 03:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775533207;
	bh=shTerlkN7e+DreHUemklMoHDvYCzvsR93XdO9+oDo9U=;
	h=Date:From:To:Cc:Subject:From;
	b=QrOAana3JSLgWYEfqxH92/RCsysvuQ8v6+2JXXsG0Q2rQlbYuTj6GAqs8ibcaU3J8
	 mnnatmWxkgovPtlUk4unsFYkDUY71Ct0wyd+mz2tNpyGkREADZYcSjLZYxaLCsK7lD
	 CMLyWkLNyEFtrQJPtyNI/DJyBP2J/D8oq2omEnIw=
Date: Mon, 6 Apr 2026 20:40:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes against 7.0-rc7
Message-Id: <20260406204005.a7bd01cfb84ce72be88c9c4f@linux-foundation.org>
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


The following changes since commit 2697dd8ae721db4f6a53d4f4cbd438212a80f8dc:

  mm/mseal: update VMA end correctly on merge (2026-03-27 20:48:38 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-06-15-27

for you to fetch changes up to 7bc5da4842bed3252d26e742213741a4d0ac1b14:

  ocfs2: fix out-of-bounds write in ocfs2_write_end_inline (2026-04-06 11:13:43 -0700)

----------------------------------------------------------------
8 hotfixes.  All are cc:stable and 7 are for MM.

All are singletons - please see the changelogs for details.

----------------------------------------------------------------
Baolin Wang (1):
      mm: filemap: fix nr_pages calculation overflow in filemap_map_pages()

Hao Li (1):
      mm/memory_hotplug: maintain N_NORMAL_MEMORY during hotplug

Joanne Koong (1):
      mm: reinstate unconditional writeback start in balance_dirty_pages()

Joseph Qi (1):
      ocfs2: fix out-of-bounds write in ocfs2_write_end_inline

Leo Timmins (1):
      liveupdate: propagate file deserialization failures

Sechang Lim (1):
      mm/vma: fix memory leak in __mmap_region()

SeongJae Park (2):
      mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails
      mm/damon/stat: deallocate damon_call() failure leaking damon_ctx

 fs/ocfs2/inode.c                | 10 ++++++++++
 kernel/liveupdate/luo_session.c |  9 +++++++--
 mm/damon/stat.c                 |  7 +++++++
 mm/damon/sysfs.c                |  3 ++-
 mm/filemap.c                    | 11 ++++++++---
 mm/memory_hotplug.c             | 20 ++++++++++++++++++++
 mm/page-writeback.c             | 21 +++++++++++++++++++++
 mm/vma.c                        |  7 +++++++
 8 files changed, 82 insertions(+), 6 deletions(-)

