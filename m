Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE4C34BA3E;
	Sun,  5 Oct 2025 18:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759688139; cv=none; b=Yp4A+NZT2FVT6f3If4XtrP5WjHj2ad3/ltQXixIf0G+vkEsNUv8V2WWwtS4pckxCuTubAxzMtN0c+2q6jc6lLZXD9VF9pXIwkJ25UnG1MHEsHROcCfR8tdJt4OGbYDiHCgotWnAt2lLhmRUSrRQW8qYnoCEZL4cz0PkICdAYhl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759688139; c=relaxed/simple;
	bh=WrGBOIZjlmquZN7ZYu+iwJ9XEfXTRM1X6w/j88Z/5W8=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=Hx1xU2non5pM7tXKBuVurFk8y5t7us/WTxrr9tF0bqFaOW08MwuRmlBPHjUMj685VbK6cfuMSHgWvb3M49vIa+IhXoyEQm7JCopAVdJVB6/V6mtOq1rjQ89zsIQAz/VuAqv9U3B0DOBayaPlX7QY0V2h5gBW8DFhVBN29UUlx0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IWpo0jZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IWpo0jZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6622C4CEF4;
	Sun,  5 Oct 2025 18:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759688138;
	bh=WrGBOIZjlmquZN7ZYu+iwJ9XEfXTRM1X6w/j88Z/5W8=;
	h=Date:From:To:Cc:Subject:From;
	b=IWpo0jZc/QIF8KOLnFDnHf2LxTHDktEADz4tGQc5ySBtwLUgB/xproCBlAO/TWM3V
	 kDxZw0PPe5+JOuH1uDmsq32y/4jKvFv/gpW5S8sgWJEyAw64StzmXjA5/RX10BVBBF
	 YDA8+K8aWh/Tv1Ems/TXnv4f7qX7jMGH7ZWmiCXE=
Date: Sun, 5 Oct 2025 11:15:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional MM updates for 6.18-rc1
Message-Id: <20251005111538.3996dae46662e46054d46528@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this small and final batch of MM updates for the
6.18-rc development cycle.

No conflicts are seen or anticipated.

Thanks.


The following changes since commit 1367da7eb875d01102d2ed18654b24d261ff5393:

  mm: swap: check for stable address space before operating on the VMA (2025-09-28 11:51:34 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-10-03-16-49

for you to fetch changes up to c14bdcc9f274620492aba7d920cc2641440cf1ba:

  mm/khugepaged: use KMEM_CACHE() (2025-10-03 16:42:44 -0700)

----------------------------------------------------------------
Only two patch series in this pull request:

- The 3 patch series "mm/memory_hotplug: fixup crash during uevent
  handling" from Hannes Reinecke which fixes a race which was causing udev
  to trigger a crash in the memory hotplug code.

- The 2 patch series "mm_slot: following fixup for usage of
  mm_slot_entry()" from Wei Yang adds some touchups to the just-merged
  mm_slot changes.

----------------------------------------------------------------
Anshuman Khandual (1):
      Documentation/mm: drop pxx_mkdevmap() descriptions from page table helpers

Hannes Reinecke (3):
      drivers/base/memory: add node id parameter to add_memory_block()
      mm/memory_hotplug: activate node before adding new memory blocks
      drivers/base: move memory_block_add_nid() into the caller

Lance Yang (1):
      mm: clean up is_guard_pte_marker()

Wei Yang (2):
      mm/ksm: cleanup mm_slot_entry() invocation
      mm/khugepaged: use KMEM_CACHE()

 Documentation/mm/arch_pgtable_helpers.rst |  6 ----
 drivers/base/memory.c                     | 53 ++++++++++++++-----------------
 drivers/base/node.c                       | 10 +++---
 include/linux/memory.h                    |  5 ++-
 mm/khugepaged.c                           |  5 +--
 mm/ksm.c                                  | 27 ++++++++--------
 mm/madvise.c                              |  4 +--
 mm/memory_hotplug.c                       | 32 ++++++++++---------
 8 files changed, 63 insertions(+), 79 deletions(-)


