Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6662E737E;
	Thu,  8 Oct 2026 04:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791435163; cv=none; b=ulYtJqTJ3bMhFjwq0J4bBnr/OgF8nYJX+0xLwB3xgWDV8TpZ4PyWMdFGc6GR444GdXkePYZT6Ua/nMyKH6Vv6yd62PHV/lKlTweOV14sVqYA8FPrhSKMNcgUoA+KTKiJmQMME8BAQVxrap3cDW5XHVt3bX11/moM87rKDPdKqoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791435163; c=relaxed/simple;
	bh=nYuaXI0WvYdUNdDoFqQ8mm/JRWt31TA/Liyvw3vELMg=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=Mn2gnNjB1gykcwRoACnbO0veKkPZAnVNAkC01TMWKNOjehAA1f9oF//RFsWT6MzXFt0x8oFiMrOYSzn7cfKeElVDWK6nReAt+A7NQV2EpQRUc8jTFLYaB1Vwby7uDOXDaJ3Z5/s3hhVKnbKYsDM8kNv465HX15CwICrxS4i3vd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fVPs4xde; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fVPs4xde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6493F1F000FF;
	Thu,  8 Oct 2026 04:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791435161;
	bh=Lz6NwmBv4G2rCkGI87SBT6ZAwtyKhNjtPQCSipSuiTw=;
	h=Date:From:To:Cc:Subject;
	b=fVPs4xdevullPh5Bb4mHpoS2UTtAnakdFgtts7y4Aa+qXZfI7+cTOGXA0Jjqm00ei
	 Ggo74/zddKHZHaLT+3dd9QkNSDl8PdEiXZLUfZh2NBvT46yvYyQqgR6wUNDDTIPSAG
	 gd4Y8m56fE7hhlxG9FTUWy4XkWzchZ7x1OYmUInI=
Date: Wed, 7 Oct 2026 21:52:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL]  MM hotfixes for 7.3-rc7
Message-Id: <20261007215240.377006c9206afa07f769e92f@linux-foundation.org>
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


The following changes since commit ff47652a4b66c067c765a7ad464d930b5a9367cc:

  Merge tag 'cifs-fixes-7.3-rc6' of https://git.manguebit.org/linux (2026-10-02 14:04:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-10-07-21-48

for you to fetch changes up to 80ce29104123be4d61b5912dae543c70af0fcb75:

  mailmap: update entry for Andy Yan (2026-10-06 16:44:19 -0700)

----------------------------------------------------------------
7 hotfixes.  4 are cc:stable.

- Update .mailmap entries for Andy Yan and John Garry.

- Fix read-only MAP_SHARED /dev/zero mappings so they retain shared-file
  semantics instead of being treated as anonymous memory, also avoiding a
  CONFIG_DEBUG_VM assertion.

- Fix 32-bit build warnings in the hugetlb-mmap selftest caused by using the
  wrong printf format for size_t values.

- Fix a boot-time crash when early function tracing causes CPA to free kernel
  page tables before the workqueues used for deferred freeing are available.

- Fix two MREMAP_DONTUNMAP locked_vm accounting leaks: one caused by an
  mlock-on-fault VMA self-merging, and one caused by partially remapping a
  locked VMA.

----------------------------------------------------------------
Andy Yan (1):
      mailmap: update entry for Andy Yan

Carlos Llamas (1):
      selftests/mm: cleanup -Wformat issues in hugetlb-mmap

John Garry (1):
      mailmap: update addresses for John Garry

Lorenzo Stoakes (ARM) (3):
      mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP self-merge
      mm/mremap: fix locked_vm leak by splitting VMA for MREMAP_DONTUNMAP
      drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero correctly

Mikhail Gavrilov (1):
      mm: don't schedule deferred kernel page table freeing while booting

 .mailmap                                  |  4 +-
 drivers/char/mem.c                        |  2 +-
 mm/mremap.c                               | 70 +++++++++++++++++++++++--------
 mm/pgtable-generic.c                      | 20 ++++++++-
 mm/vma.c                                  | 21 ++++++++--
 mm/vma.h                                  |  7 +++-
 tools/testing/selftests/mm/hugetlb-mmap.c |  4 +-
 tools/testing/vma/tests/vma.c             | 10 ++---
 8 files changed, 106 insertions(+), 32 deletions(-)

