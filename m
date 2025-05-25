Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E2817A2F2;
	Sun, 25 May 2025 08:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748160116; cv=none; b=LnDeOeY2TR82VOzi62DBskWMpGrzIkPLtfXCxE53FBy58WMLG1yKl7XF4slbKXOnYw3YhhXfqmxEVZTT+sF7hEGVFav7ICjWDKMzD4WOt5rU3xvf+Oo3bi6jko7QDkjIfEd/oPIZXRo/eG/Is0mxV9yWyXJvsVRhC4yBmZQ5c6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748160116; c=relaxed/simple;
	bh=7don5i3o/5ywXieOjdAns73N9SpJ9k4pSyznIwC6V94=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=KOOsTt5Wt84ALh4wTAjxd1+WiiYL9Wyk1CeO4ixe4l73LhdgrseoSYXqxYblrCqT0Q84P7edokNUJmmBbcgdvKyHmA9A2+hEm9d9AM2uWwMX3WgarVrm/CJJSJpwpmhNb5/soIX24zIOrMVrqtcxQxJxWrRqkDoFvZXC24n6OnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pf/Vbt5H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pf/Vbt5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA720C4CEEA;
	Sun, 25 May 2025 08:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748160114;
	bh=7don5i3o/5ywXieOjdAns73N9SpJ9k4pSyznIwC6V94=;
	h=Date:From:To:Cc:Subject:From;
	b=pf/Vbt5HY/o7ob0uEI8kjf3nl2RPluPaE3vU3nGOILuPMcaPfkPVxuI1Lpmgnfs2j
	 JsWb6EU+ZOClEOu5Glzo/qtfc7f8gDOnNH6ZpNEi1Q+glX0swpF+B+mo6OEp+lWWBo
	 Nr/llrzUTctNDXzlZlWb0oTvarjhg6fAZ2EJ3Mc0=
Date: Sun, 25 May 2025 01:01:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes against 6.15-rc7
Message-Id: <20250525010153.4e008d81730ac2137a80fb77@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Linus, please pull this batch of hotfixes, thanks.


The following changes since commit 75cb1cca2c880179a11c7dd9380b6f14e41a06a4:

  mm: userfaultfd: correct dirty flags set for both present and swap pte (2=
025-05-11 17:29:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-st=
able-2025-05-25-00-58

for you to fetch changes up to 1ec971da1c10e6376411e6d4a3f3b2351217d94f:

  mailmap: add Jarkko's employer email address (2025-05-25 00:53:49 -0700)

----------------------------------------------------------------
22 hotfixes.  13 are cc:stable and the remainder address post-6.14 issues
or aren't considered necessary for -stable kernels.  19 are for MM.

----------------------------------------------------------------
Alexander Gordeev (1):
      kasan: avoid sleepable page allocation from atomic context

Breno Leitao (1):
      memcg: always call cond_resched() after fn()

David Wang (1):
      module: release codetag section when module load fails

Florent Revest (1):
      mm: fix VM_UFFD_MINOR =3D=3D VM_SHADOW_STACK on USERFAULTFD=3Dy && AR=
M64_GCS=3Dy

Ge Yang (1):
      mm/hugetlb: fix kernel NULL pointer dereference when replacing free h=
ugetlb folios

Ignacio Moreno Gonzalez (1):
      mm: mmap: map MAP_STACK to VM_NOHUGEPAGE only if THP is enabled

Jarkko Sakkinen (1):
      mailmap: add Jarkko's employer email address

Kees Cook (2):
      mm: vmalloc: actually use the in-place vrealloc region
      mm: vmalloc: only zero-init on vrealloc shrink

Lance Yang (1):
      MAINTAINERS: add hung-task detector section

Lorenzo Stoakes (4):
      MAINTAINERS: update page allocator section
      MAINTAINERS: add mm reclaim section
      MAINTAINERS: add mm ksm section
      MAINTAINERS: add mm memory policy section

Matthew Wilcox (Oracle) (1):
      highmem: add folio_test_partial_kmap()

Mike Rapoport (Microsoft) (1):
      mm/cma: make detection of highmem_start more robust

Ricardo Ca=F1uelo Navarro (1):
      mm: fix copy_vma() error handling for hugetlb mappings

Suren Baghdasaryan (1):
      alloc_tag: allocate percpu counters for module tags dynamically

Tianyang Zhang (1):
      mm/page_alloc.c: avoid infinite retries caused by cpuset race

Uladzislau Rezki (Sony) (1):
      MAINTAINERS: add myself as vmalloc co-maintainer

Wang Yaxin (1):
      taskstats: fix struct taskstats breaks backward compatibility since v=
ersion 15

Zhang Yi (1):
      mm/truncate: fix out-of-bounds when doing a right-aligned split

 .mailmap                       |  1 +
 MAINTAINERS                    | 66 ++++++++++++++++++++++++++++--
 include/linux/alloc_tag.h      | 12 ++++++
 include/linux/codetag.h        |  8 ++--
 include/linux/highmem.h        | 10 ++---
 include/linux/hugetlb.h        |  5 +++
 include/linux/mm.h             |  2 +-
 include/linux/mman.h           |  2 +
 include/linux/page-flags.h     |  7 ++++
 include/linux/percpu.h         |  4 --
 include/uapi/linux/taskstats.h | 47 ++++++++++++---------
 kernel/module/main.c           |  1 +
 lib/alloc_tag.c                | 87 ++++++++++++++++++++++++++++++---------
 lib/codetag.c                  |  5 ++-
 mm/cma.c                       |  5 ++-
 mm/hugetlb.c                   | 24 ++++++++++-
 mm/kasan/shadow.c              | 92 +++++++++++++++++++++++++++++++++++---=
----
 mm/memcontrol.c                |  6 +--
 mm/mremap.c                    |  3 +-
 mm/page_alloc.c                |  8 ++++
 mm/truncate.c                  | 20 +++++----
 mm/vma.c                       |  1 +
 mm/vmalloc.c                   | 13 +++---
 23 files changed, 338 insertions(+), 91 deletions(-)

