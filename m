Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9432DF132;
	Tue,  7 Jul 2026 00:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783385482; cv=none; b=gvedsURx1mDebXvozDZ+fqjyO6ojKRzi4kBqq8PGz+Yfh8GU8bRtqgilx2X1O3CLjhUQ+TtuvoJfVo4uymdwJpU1p3Qopt1lSFPESDkvNUko1bdJI1q/f1X0xxtoDWuUO/C7OGZkxaDwa61QG8ztsMAdJ6QO6LhqZLYRT2o6akw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783385482; c=relaxed/simple;
	bh=tibIt/TlXhbu9MudDThB++AaOp3T0J2NMD0/c2Za0rE=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=hj0TWk6M9CWxAhv21LsgjvWJVo0n362bv0e35SU2VSJvorJRq5fakTFx71UvphSvY4x5QfcfMpZlLHfP/YGcr/fxgm3+kZaVwJjDKKqmHokNIABthLuwREOEo4mSjfuUt2H0AC+/DfHW4F2kuAg373xjwx8ObtU8nc1YOd9+Fa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P3vnLQIW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P3vnLQIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9ED1F000E9;
	Tue,  7 Jul 2026 00:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783385480;
	bh=8uOJumz4s0qki0r71srSZl6Uj8heGPfbTOJSjApvouk=;
	h=Date:From:To:Cc:Subject;
	b=P3vnLQIWwam8IAG2S03dhCCtK72bBTkslQRQn7osCFj6SM/HzrbIBrYKukNIiFEqG
	 Vw3ksOcc0k6Hg47K+1519inXpofFXBTgEA2HcdxgaTsD+WW+5MNLVrLzXulgat8Dm9
	 SGijZv4IYlC+0fMUTDItRlEx1CDnd6I+RnHmx0AM=
Date: Mon, 6 Jul 2026 17:51:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 7.2-rc3
Message-Id: <20260706175120.2411eb28603d28ac0424a573@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this batch of MM and non-MM hotfixes, thanks.



The following changes since commit dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-06-17-49

for you to fetch changes up to 039892c35f9d8f5ea00d7c2ed1c25224f28b11d7:

  tools/include: include stdint.h for SIZE_MAX in overflow.h (2026-07-01 19:02:56 -0700)

----------------------------------------------------------------
20 hotfixes.  17 are for MM.  12 are cc:stable and the remaining 8
address post-7.1 issues or aren't considered suitable for backporting.

A two patch series from SJ addresses a couple of quite old DAMON issues.
A two patch series from Yichong Chen fixes tools/virtio build issues.  The
remaining patches are singletons.

----------------------------------------------------------------
Jan Kara (1):
      mm: a second pagecache maintainer

Jinjiang Tu (1):
      fs/proc: fix KPF_KSM reported for all anonymous pages

Ketan (1):
      mm: page_ext: add count limit to page_ext_iter_next to prevent invalid PFN access

Lorenzo Stoakes (1):
      MAINTAINERS: add Lance as an rmap reviewer

Pedro Falcato (1):
      mm: do file ownership checks with the proper mount idmap

Qi Zheng (2):
      mm: shrinker: fix shrinker_info teardown race with expansion
      mm: shrinker: fix NULL pointer dereference in debugfs

Radu Rendec (1):
      mailmap: add entries for Radu Rendec

SJ Park (2):
      mm/damon: add a kernel-doc comment for damon_ctx->probes
      mm/damon: add a kernel-doc comment for damon_ctx->rnd_state

Sarthak Sharma (1):
      selftests/mm: fix ksft_process_madv.sh test category

SeongJae Park (3):
      mm/damon/sysfs-schemes: fix dir put orders in access_pattern_add_dirs()
      mm/damon/sysfs-schemes: put stats for scheme_add_dirs() internal error
      mm/damon/ops-common: handle extreme intervals in damon_hot_score()

Yichong Chen (2):
      tools/virtio: add missing compat definitions for vhost_net_test
      tools/include: include stdint.h for SIZE_MAX in overflow.h

Zenghui Yu (3):
      selftests/mm: pagemap_ioctl: use the correct page size for transact_test()
      selftests/mm: hmm-tests: include linux/mman.h to access MADV_COLLAPSE
      samples/damon/mtier: fail early if address range parameters are invalid

Zi Yan (1):
      mm/compaction: handle free_pages_prepare() properly in compaction_free()

 .mailmap                                        |  4 ++
 MAINTAINERS                                     |  3 +-
 fs/proc/page.c                                  |  2 +-
 include/linux/damon.h                           | 11 +++-
 include/linux/fs.h                              |  5 ++
 include/linux/page_ext.h                        | 19 ++++--
 mm/compaction.c                                 |  7 +--
 mm/damon/ops-common.c                           |  1 +
 mm/damon/sysfs-schemes.c                        | 17 +++---
 mm/filemap.c                                    |  2 +-
 mm/madvise.c                                    |  3 +-
 mm/mincore.c                                    |  3 +-
 mm/shrinker.c                                   | 13 +++-
 mm/shrinker_debug.c                             | 10 ++--
 samples/damon/mtier.c                           |  3 +
 tools/include/linux/overflow.h                  |  1 +
 tools/testing/selftests/mm/hmm-tests.c          |  1 +
 tools/testing/selftests/mm/ksft_process_madv.sh |  2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c      | 12 ++--
 tools/virtio/asm/percpu_types.h                 |  7 +++
 tools/virtio/linux/completion.h                 |  9 +++
 tools/virtio/linux/device.h                     |  1 +
 tools/virtio/linux/dma-mapping.h                |  1 +
 tools/virtio/linux/mod_devicetable.h            | 14 +++++
 tools/virtio/linux/virtio_features.h            | 79 +++++++++++++++++++++++++
 25 files changed, 187 insertions(+), 43 deletions(-)
 create mode 100644 tools/virtio/asm/percpu_types.h
 create mode 100644 tools/virtio/linux/completion.h
 create mode 100644 tools/virtio/linux/mod_devicetable.h
 create mode 100644 tools/virtio/linux/virtio_features.h

