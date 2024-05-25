Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A528F66;
	Sat, 25 May 2024 16:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716653759; cv=none; b=XeetCKyMpAwgOeSJEHEThc0sHzqP0z+0IpuMSCxeld68l/wVvW253YArMQSJigvfOKbRCn6LlLnMt07Omt/DKyheSVIuq5LUnWD/JkoQJV0x5pIKJDXpCsdAqGpxGuNS4cox7m6cYwJBm2pUptzhwsbzpWhahzsbnlXmzjWECOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716653759; c=relaxed/simple;
	bh=l+aDviQghwZhl0H+B/JfTAM+86dh8zBmoZuOzzzDX3g=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=d0k7rGjm8cbJSvY6We/2cmfvmrA2YaRWWDH2JG9EaC0ItF3xqmLeEpfc0CmKu3kPQrU1F2uckcvpTf5kzMAtF930YSmIu5r3fFqHVF7jaMXp59tUEuFc1GM2KLQWzbkqfvRHlv/Aa796V0MzmzsuTft1sjKHB95hyF1FaIMyuLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hSyr3sRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hSyr3sRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78714C2BD11;
	Sat, 25 May 2024 16:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716653758;
	bh=l+aDviQghwZhl0H+B/JfTAM+86dh8zBmoZuOzzzDX3g=;
	h=Date:From:To:Cc:Subject:From;
	b=hSyr3sRbmWGs94KVxDngMq5wkiCnY3WnGQ1VS3pO8nFD+wNjFYkKpyzU5gN17xEv/
	 DJSb3BQDWC/uqb9gpFqIZUmbz8urwvA03l0DUFGJSNI0XBcIqnD17S7kQEKCQ/DZ+c
	 TBHD8ZOF96ZEdV9BvziLiuekVegTDB93d3/QsEKQ=
Date: Sat, 25 May 2024 09:15:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.10-rc1
Message-Id: <20240525091557.9ca6e57ab6d41bf204c12531@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of nilfs2 and mm/ hotfixes, thanks.


The following changes since commit c760b3725e52403dc1b28644fb09c47a83cacea6:

  Merge tag 'mm-nonmm-stable-2024-05-22-17-30' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2024-05-22 18:59:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-05-25-09-13

for you to fetch changes up to 90e823498881fb8a91d83e9a8eed87c8c3ff2176:

  mm/ksm: fix possible UAF of stable_node (2024-05-24 11:55:08 -0700)

----------------------------------------------------------------
16 hotfixes, 11 of which are cc:stable.

A few nilfs2 fixes, the remainder are for MM: a couple of selftests fixes,
various singletons fixing various issues in various parts.

----------------------------------------------------------------
Andrey Konovalov (1):
      kasan, fortify: properly rename memintrinsics

Chengming Zhou (1):
      mm/ksm: fix possible UAF of stable_node

Dev Jain (3):
      selftests/mm: compaction_test: fix bogus test success on Aarch64
      selftests/mm: compaction_test: fix incorrect write of zero to nr_hugepages
      selftests/mm: compaction_test: fix bogus test success and reduce probability of OOM-killer invocation

Hailong.Liu (1):
      mm/vmalloc: fix vmalloc which may return null if called with __GFP_NOFAIL

Miaohe Lin (2):
      mm/huge_memory: don't unpoison huge_zero_folio
      mm/memory-failure: fix handling of dissolved but not taken off from buddy pages

Michael Ellerman (1):
      selftests/mm: fix build warnings on ppc64

Ryusuke Konishi (3):
      nilfs2: fix use-after-free of timer for log writer thread
      nilfs2: fix unexpected freezing of nilfs_segctor_sync()
      nilfs2: fix potential hang in nilfs_detach_log_writer()

Satya Priya Kakitapalli (1):
      mailmap: update email address for Satya Priya

Suren Baghdasaryan (1):
      lib: add version into /proc/allocinfo output

Will Deacon (1):
      arm64: patching: fix handling of execmem addresses

Yuanyuan Zhong (1):
      mm: /proc/pid/smaps_rollup: avoid skipping vma after getting mmap_lock again

 .mailmap                                     |  2 +-
 Documentation/filesystems/proc.rst           |  5 +-
 arch/arm64/kernel/patching.c                 |  2 +-
 fs/nilfs2/segment.c                          | 63 ++++++++++++++++-----
 fs/proc/task_mmu.c                           |  9 ++-
 include/linux/fortify-string.h               | 22 +++++--
 lib/alloc_tag.c                              | 47 ++++++++++-----
 mm/ksm.c                                     |  3 +-
 mm/memory-failure.c                          | 11 +++-
 mm/vmalloc.c                                 |  5 +-
 tools/testing/selftests/mm/compaction_test.c | 85 ++++++++++++++++++++--------
 tools/testing/selftests/mm/gup_test.c        |  1 +
 tools/testing/selftests/mm/uffd-common.h     |  1 +
 13 files changed, 187 insertions(+), 69 deletions(-)

