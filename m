Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5C61F63DB;
	Fri, 17 Jan 2025 05:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737090805; cv=none; b=KlYZIMHDJQOLRLvkPooYDqXKPkMQ+E07e2aiVfK/ffDEdlpk6mgR00o6YAGokDw0JXmFT321F0UGNuXkNsL73q+KXhatnuzdnrQ+bQaVK4WFXyNz7OLvRhcUQkkrohKoWWcmmMtjwcU//EepvImVSMja6/uI4c2Zrr5e68am1QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737090805; c=relaxed/simple;
	bh=gDijFMa7NL0+tyAHamYHaEIr1TuYlKsPJDYzeDOwtPU=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=UPCr4v7+1tlpiiJUFOi7G+5/xy1eLqEzMCGT2mhx4RkQmETi+q8HRiJRaSjMpB0K1SfAcR+hv910B/2KLrArg1//fdOmBwbr0AOVIB6wgyXkA/JxaAXXLXrDGcgDj3A4is+b5uVoFfvoeKgbxLiPCDT5b4aiPW0YODItdwbm1fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kp2AVpfz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kp2AVpfz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97372C4CEE0;
	Fri, 17 Jan 2025 05:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737090803;
	bh=gDijFMa7NL0+tyAHamYHaEIr1TuYlKsPJDYzeDOwtPU=;
	h=Date:From:To:Cc:Subject:From;
	b=kp2AVpfzpn72B9CI74Iy68ncqPh+uJIrIbGoXIpohLOKkEfPqQHJuGoETKbqtgEeL
	 Pa/nEfgMXvp5J/pPmec1NQjF7zaheedx+DLeNvnAUc5hd7uxJKo6eofqSGJtsDrYoA
	 kIcbtVK4KY70qINBwgNngFzUjp4qLDoQkywZEjTw=
Date: Thu, 16 Jan 2025 21:13:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.13
Message-Id: <20250116211322.19c20e534e96f37c3608792f@linux-foundation.org>
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

The following changes since commit cbc5dde0a461240046e8a41c43d7c3b76d5db952:

  fs/proc: fix softlockup in __read_vmcore (part 2) (2025-01-12 19:03:38 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-01-16-21-11

for you to fetch changes up to b0fce54b8c0d8e5f2b4c243c803c5996e73baee8:

  ocfs2: check dir i_size in ocfs2_find_entry (2025-01-15 21:15:44 -0800)

----------------------------------------------------------------
7 singleton hotfixes.  6 are MM.  2 are cc:stable and the remainder
address post-6.12 issues.

----------------------------------------------------------------
Ethan Carter Edwards (1):
      mailmap: update entry for Ethan Carter Edwards

Karan Sanghavi (1):
      mm: shmem: use signed int for version handling in casefold option

Liu Shixin (1):
      mm: khugepaged: fix call hpage_collapse_scan_file() for anonymous vma

Su Yue (1):
      ocfs2: check dir i_size in ocfs2_find_entry

Suren Baghdasaryan (1):
      alloc_tag: skip pgalloc_tag_swap if profiling is disabled

Yosry Ahmed (1):
      mm: zswap: move allocations during CPU init outside the lock

zihan zhou (1):
      mm: page_alloc: fix missed updates of lowmem_reserve in adjust_managed_page_count

 .mailmap        |  1 +
 fs/ocfs2/dir.c  | 25 +++++++++++++++++++++----
 lib/alloc_tag.c |  3 +++
 mm/khugepaged.c |  4 ++--
 mm/page_alloc.c |  3 +++
 mm/shmem.c      |  2 +-
 mm/zswap.c      | 42 ++++++++++++++++++++++++------------------
 7 files changed, 55 insertions(+), 25 deletions(-)

