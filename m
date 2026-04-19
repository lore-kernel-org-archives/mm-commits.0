Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271BF1448D5;
	Sun, 19 Apr 2026 18:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776625087; cv=none; b=pj7+ahAjTVeuOIC21GvJsYWNsCiDoaKIPqMe0zejik4XWpL6Zgm0Sn+ytoZeLrDTHps5OVm2rnRaz7IIPam4EMlswPXaBfBCR/xC1W8M2vlMVjfp6G2BwPGGKfPxC5FM85yeGShN78KDHC/YMSXHFp6oGwXG1WTpLmTBJ9TujMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776625087; c=relaxed/simple;
	bh=CAqM4bvw0YeWw9r12e8drmX/Cr6gR/EV7mWkDbWCPAM=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=tuMaqUh5cO8f3d/1V9Jxwq5insX9FUSVKBQv7VOpcxF+qgXeAgyjn6wYTUS8+HpUfdXsNrnFt+SETpka5GYfNPBFTGqrfmcOybOhYkC+wVnbd3LuravmBNzqrIHCg5GeTpTQ155kehmaX2At4qQCxIDrJPGzK4m2ibhPLDbWfiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MeaOdJvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MeaOdJvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6C8C2BCAF;
	Sun, 19 Apr 2026 18:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776625086;
	bh=CAqM4bvw0YeWw9r12e8drmX/Cr6gR/EV7mWkDbWCPAM=;
	h=Date:From:To:Cc:Subject:From;
	b=MeaOdJvr6yNYSLhouxj3bvt2us4R072sqt/YzQkN/NPtq9eFOHSzvs6CrSJaaxkxL
	 bcfTRffRMeu+y0n3Giw+uHYUbNHpQm82gISjcuxQRdrCnwcoNEHAa0le7syt6ShEkb
	 tuouqFcuONrH4wmeoNymsn+oE3KMXbx3j05M0rU8=
Date: Sun, 19 Apr 2026 11:58:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.1-rc1
Message-Id: <20260419115803.3114199cdc346ba9654958f9@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 7bc5da4842bed3252d26e742213741a4d0ac1b14:

  ocfs2: fix out-of-bounds write in ocfs2_write_end_inline (2026-04-06 11:13:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-19-00-14

for you to fetch changes up to 95093e5cb4c5b50a5b1a4b79f2942b62744bd66a:

  mm/damon/core: disallow non-power of two min_region_sz on damon_start() (2026-04-18 23:24:27 -0700)

----------------------------------------------------------------
7 hotfixes.  6 are cc:stable and all are for MM.  Please see the
individual changelogs for details.

----------------------------------------------------------------
Breno Leitao (1):
      mm: blk-cgroup: fix use-after-free in cgwb_release_workfn()

Joshua Hahn (1):
      mm/mempolicy: fix weighted interleave auto sysfs name

Matthew Brost (1):
      mm/zone_device: do not touch device folio after calling ->folio_free()

Matthew Wilcox (Oracle) (1):
      mm: call ->free_folio() directly in folio_unmap_invalidate()

SeongJae Park (2):
      mm/damon/core: disallow time-quota setting zero esz
      mm/damon/core: disallow non-power of two min_region_sz on damon_start()

Uladzislau Rezki (Sony) (1):
      mm/vmalloc: take vmap_purge_lock in shrinker

 mm/backing-dev.c |  5 +++--
 mm/damon/core.c  | 13 ++++++++++---
 mm/filemap.c     |  3 ++-
 mm/internal.h    |  1 -
 mm/mempolicy.c   |  8 +++++---
 mm/memremap.c    |  2 +-
 mm/truncate.c    |  6 +++++-
 mm/vmalloc.c     |  1 +
 8 files changed, 27 insertions(+), 12 deletions(-)

