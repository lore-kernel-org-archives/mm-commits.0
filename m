Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DF138F82;
	Fri, 26 Jul 2024 21:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722029776; cv=none; b=jR99HW5NG+YrUErGLAmn5brChi/fl8nw2Ym8pZWcQh/5co6t/g+MYrGbH/ka8K8wGCxpew5kPiSYWGCwqb4iCdLSmGtWD23taNg/AjFYQRgtCs4rFZd19L3BWmuf/6oZ+HwheZvB4/qDp0cxZobvv83mIhpjp8z6KxLGBrr4J7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722029776; c=relaxed/simple;
	bh=JNsZ6MEcoHsNdkYIZD1Nv902TWnUmDtLFa2vdZ5xNAQ=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=TuoVo4aeVjhPSWradJUfahJn+7BkKCd5SByrZIJoJLWMN1RRzuTCzQMsJ2TZHyRhx9MlDwkWBhEK2VynwYJCGPiqpZMzcSFeF2PBYVqqRAyauO8HEOkduLBtqPGDuyIsTYqyU6esBPVO0jV5roitGRgBYmUBat3xawELt+3R/jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BjT8++HQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BjT8++HQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F68C32782;
	Fri, 26 Jul 2024 21:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722029776;
	bh=JNsZ6MEcoHsNdkYIZD1Nv902TWnUmDtLFa2vdZ5xNAQ=;
	h=Date:From:To:Cc:Subject:From;
	b=BjT8++HQUy9MsXZhALq6Ls0NPiVPzLYBFTR9kMcNKOe3oogx2CiTAhlS2haZA6q0Q
	 ko0NjyizYT7DZYR40IcM6G4tgLwYb+4AZSZdEvexbXz1nEBpaatxEAGw47jwi2zuCp
	 2BnoF9eW89ciLq8KkC1UvuBMeiQi9nu6vjsAN5fY=
Date: Fri, 26 Jul 2024 14:36:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.11-rc1
Message-Id: <20240726143615.93c57975048105d2883f3d4a@linux-foundation.org>
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

The following changes since commit 1722389b0d863056d78287a120a1d6cadb8d4f7b:

  Merge tag 'net-6.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2024-07-25 13:32:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-07-26-14-33

for you to fetch changes up to 4811f7af6090e8f5a398fbdd766f903ef6c0d787:

  nilfs2: handle inconsistent state in nilfs_btnode_create_block() (2024-07-26 14:33:10 -0700)

----------------------------------------------------------------
11 hotfixes, 7 of which are cc:stable.  7 are MM, 4 are other.

----------------------------------------------------------------
Dev Jain (1):
      selftests/mm: skip test for non-LPA2 and non-LVA systems

Gavin Shan (1):
      mm/huge_memory: avoid PMD-size page cache if needed

James Clark (2):
      MAINTAINERS: mailmap: update James Clark's email address
      dt-bindings: arm: update James Clark's email address

Li Zhijian (1):
      mm/page_alloc: fix pcp->count race between drain_pages_zone() vs __rmqueue_pcplist()

Ram Tummala (1):
      mm: fix old/young bit handling in the faulting path

Roman Gushchin (1):
      mm: memcg: add cacheline padding after lruvec in mem_cgroup_per_node

Ross Lagerwall (1):
      decompress_bunzip2: fix rare decompression failure

Ryusuke Konishi (1):
      nilfs2: handle inconsistent state in nilfs_btnode_create_block()

Suren Baghdasaryan (1):
      alloc_tag: outline and export free_reserved_page()

Yang Shi (1):
      mm: huge_memory: use !CONFIG_64BIT to relax huge page alignment on 32 bit machines

 .mailmap                                           |  1 +
 .../bindings/arm/arm,coresight-dummy-sink.yaml     |  2 +-
 .../bindings/arm/arm,coresight-dummy-source.yaml   |  2 +-
 MAINTAINERS                                        |  4 +--
 fs/nilfs2/btnode.c                                 | 25 ++++++++++++----
 fs/nilfs2/btree.c                                  |  4 +--
 include/linux/huge_mm.h                            | 12 ++++++--
 include/linux/memcontrol.h                         |  1 +
 include/linux/mm.h                                 | 16 +---------
 lib/decompress_bunzip2.c                           |  3 +-
 mm/huge_memory.c                                   | 14 +++++++--
 mm/memory.c                                        |  2 +-
 mm/page_alloc.c                                    | 35 +++++++++++++++++-----
 tools/testing/selftests/mm/va_high_addr_switch.c   | 16 +++++++++-
 14 files changed, 95 insertions(+), 42 deletions(-)

