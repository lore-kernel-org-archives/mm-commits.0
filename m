Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A69258A;
	Sun, 20 Apr 2025 04:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745123194; cv=none; b=l/oW1og80olNQN1KPF2+9OPWi0nMNFve/1BL2SSf7dx5yq839i0oLrfHq0AOM88tqdBSq1OLAjmJKovJS0Q3MmGUivU7uzApOmIxv433hkPxJwghA3vYW3hR+3/yUS7xP8C8/P1R3KT9vk3Rt8tzTkz/UNUpzDOpEkwjA+TNTzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745123194; c=relaxed/simple;
	bh=OexycGlnF3hxhAIHaIY2JYwk7C6llKn6YRf+F2al/f8=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=uwo6GTf3xxnewicYc3QzDCBLcmE2A3fsCMI+nxtqzS/bd1Bl5Q2FvvSoWj7pwZEj4kdWj1vPhSHDbtuBqqzvLTk1splqs/+Q6HICxSs/izqOJmLjpGM/D/mQhxzDCepyL3Fmc4f6HlOvRNCjcF/QxtvPFy9d1mv+uEAUPVCsz6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CXHkWV7M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CXHkWV7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F98C4CEE2;
	Sun, 20 Apr 2025 04:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745123193;
	bh=OexycGlnF3hxhAIHaIY2JYwk7C6llKn6YRf+F2al/f8=;
	h=Date:From:To:Cc:Subject:From;
	b=CXHkWV7M7CkKvii+m/oF/Osms6L8FmhTlSdLIDJZpNCYcxlGfYQOZtcU1qanW7bMw
	 MjRKQJ9R9SbaWk/BwcjS3Imy6HHIU0hde/1rrPrKrtVaMQxxkC33cTHK2TReL6x8fq
	 bWI+kX0/zjwo3sj08Oxy5SQ73p76Llx2XW/O3v9w=
Date: Sat, 19 Apr 2025 21:26:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
 linux-mm@kvack.org
Subject: [GIT PULL] hotfixes for 6.15-rc3
Message-Id: <20250419212632.41bd67c6fa1459f817f0ea58@linux-foundation.org>
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


The following changes since commit fc96b232f8e7c0a6c282f47726b2ff6a5fb341d2:

  Merge tag 'pci-v6.15-fixes-2' of git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci (2025-04-17 16:00:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-04-19-21-24

for you to fetch changes up to ea21641b6a79f9cdd64f8339983c71c89949dcb5:

  MAINTAINERS: add section for locking of mm's and VMAs (2025-04-17 20:10:09 -0700)

----------------------------------------------------------------
16 hotfixes.  2 are cc:stable and the remainder address post-6.14 issues
or aren't considered necessary for -stable kernels.

All patches are basically for MM although five are alterations to
MAINTAINERS.

----------------------------------------------------------------
Ahmad Fatoum (1):
      docs: ABI: replace mcroce@microsoft.com with new Meta address

Andreas Gruenbacher (1):
      writeback: fix false warning in inode_to_wb()

Baoquan He (1):
      mm/gup: fix wrongly calculated returned value in fault_in_safe_writeable()

David Hildenbrand (2):
      fs/dax: fix folio splitting issue by resetting old folio order + _nr_pages
      mm/memory: move sanity checks in do_wp_page() after mapcount vs. refcount stabilization

Johannes Weiner (2):
      mm: vmscan: restore high-cpu watermark safety in kswapd
      mm: vmscan: fix kswapd exit condition in defrag_mode

Kirill A. Shutemov (1):
      mm/page_alloc: fix deadlock on cpu_hotplug_lock in __accept_page()

Liam R. Howlett (1):
      MAINTAINERS: add mmap trace events to MEMORY MAPPING

Lorenzo Stoakes (3):
      MAINTAINERS: add memory advice section
      MAINTAINERS: add Pedro as reviewer to the MEMORY MAPPING section
      MAINTAINERS: add section for locking of mm's and VMAs

Muchun Song (1):
      mm: memcontrol: fix swap counter leak from offline cgroup

Oscar Salvador (1):
      mm, hugetlb: increment the number of pages to be reset on HVO

Vlastimil Babka (2):
      MAINTAINERS: update SLAB ALLOCATOR maintainers
      MAINTAINERS: add MM subsection for the page allocator

 CREDITS                                       |  4 +++
 Documentation/ABI/stable/sysfs-block          |  2 +-
 Documentation/ABI/testing/sysfs-kernel-reboot | 10 +++---
 MAINTAINERS                                   | 49 +++++++++++++++++++++++++--
 fs/dax.c                                      |  1 +
 include/linux/backing-dev.h                   |  1 +
 include/linux/mm.h                            | 17 ++++++++++
 include/linux/mmzone.h                        |  5 +--
 mm/gup.c                                      |  4 +--
 mm/hugetlb_vmemmap.c                          |  6 ++--
 mm/internal.h                                 |  1 +
 mm/memcontrol-v1.c                            |  2 +-
 mm/memory.c                                   |  4 +--
 mm/mm_init.c                                  |  1 +
 mm/page_alloc.c                               | 40 ++++++++++++++--------
 mm/vmscan.c                                   | 29 ++++++++++++++--
 16 files changed, 141 insertions(+), 35 deletions(-)

