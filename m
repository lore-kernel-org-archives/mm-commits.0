Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BD970808;
	Thu, 11 Dec 2025 21:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765487506; cv=none; b=f018v5fYaI6YEWK/uL2uJJbNrCyADTN1REKawl6S4NvU5k/lAuTbqDImng4uul1QFe4+mCq653HNmduJemPOt79d54H9Ztcdh7f6NNHeqBj0GgSp67Zh9x6bNbMkCrq5b/zAc1rC+rWIJsfjmdRQrP1IikND4SgwghSGWlY4dlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765487506; c=relaxed/simple;
	bh=XfWChLIq0U5zTAEZDWkGgBN6OS3uU0puWnQSlLEXHEU=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=o28DH2W6kaVQKsrsGqEqsDT7Pj2nlYn5X/U1P0pPLLJH8y/CXtN05/asMMVDJ2V6G2r68i/NClBuEZPCsTjSWJzDiudmDJz/qJbSMS0auPAwS+ndMRtnEYzp4E5+XSpu6NSf5ttzQwY039C8zxW4Vrdk+qFM/Tokn+0KOqIQSx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A7npviBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A7npviBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1076CC4CEF7;
	Thu, 11 Dec 2025 21:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765487506;
	bh=XfWChLIq0U5zTAEZDWkGgBN6OS3uU0puWnQSlLEXHEU=;
	h=Date:From:To:Cc:Subject:From;
	b=A7npviByx79r+2lwvsaoRYS71wzj04sSvrud/blEramhGNT1WNyNYqfiXjh3Vbae7
	 kwBLBrsz+1LqJMutFapSLzWLraGQSJjwTlUBrR0QNzLsXcB5upoX2RzBkjvEer/3WW
	 BsKcwyAfaNgZjlCLItXvzcoWzWnaEXUSeC5sMHN4=
Date: Thu, 11 Dec 2025 13:11:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional non-MM updates for 6.19-rc1
Message-Id: <20251211131145.512b1694cf5f46d959cfef76@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please merge this small batch of followup non-MM patches for the
upcoming -rc cycle,

No conflicts were seen in a test merge.

Thanks.


The following changes since commit aa514a297a0c175239f24a2e582ebd37f0727494:

  calibrate: update header inclusion (2025-11-27 14:24:45 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-12-11-11-47

for you to fetch changes up to 601cc399a01049efa76be8f496541315dc9cf914:

  mm: memfd_luo: add CONFIG_SHMEM dependency (2025-12-10 16:07:44 -0800)

----------------------------------------------------------------
There are no significant series in this small merge.  Please see the
individual changelogs for details.

----------------------------------------------------------------
Ahmet Eray Karadag (3):
      ocfs2: add ocfs2_emergency_state helper and apply to setattr
      ocfs2: convert remaining read-only checks to ocfs2_emergency_state
      ocfs2: invalidate inode if i_mode is zero after block read

Ally Heev (1):
      checkpatch: add uninitialized pointer with __free attribute check

Andy Shevchenko (1):
      args: fix documentation to reflect the correct numbers

Arnd Bergmann (2):
      mm: shmem: avoid build warning for CONFIG_SHMEM=n
      mm: memfd_luo: add CONFIG_SHMEM dependency

Dan Carpenter (1):
      liveupdate: luo_file: don't use invalid list iterator

Deepanshu Kartikey (1):
      ocfs2: validate inline xattr size and entry count in ocfs2_xattr_ibody_list

Dmitry Antipov (1):
      ocfs2: fix memory leak in ocfs2_merge_rec_left()

Edward Adam Davis (1):
      ocfs2: check tl_used after reading it from trancate log inode

Gustavo A. R. Silva (1):
      ocfs2: avoid -Wflex-array-member-not-at-end warning

Lalit Shankar Chowdhury (1):
      fs/fat: remove unnecessary wrapper fat_max_cache()

Pasha Tatashin (1):
      liveupdate: luo_core: fix redundant bound check in luo_ioctl()

Prithvi Tambewagh (1):
      ocfs2: fix kernel BUG in ocfs2_find_victim_chain

Thorsten Blum (1):
      ocfs2: replace deprecated strcpy with strscpy

 Documentation/dev-tools/checkpatch.rst | 23 ++++++++++++++++++++
 fs/fat/cache.c                         |  7 +------
 fs/ocfs2/alloc.c                       | 12 ++++++-----
 fs/ocfs2/buffer_head_io.c              |  2 +-
 fs/ocfs2/cluster/nodemanager.c         |  3 ++-
 fs/ocfs2/dir.c                         | 10 ++++-----
 fs/ocfs2/file.c                        | 14 +++++++++----
 fs/ocfs2/inode.c                       | 11 ++++++++--
 fs/ocfs2/move_extents.c                |  2 +-
 fs/ocfs2/namei.c                       |  3 ++-
 fs/ocfs2/ocfs2.h                       | 18 ++++++++++++++++
 fs/ocfs2/resize.c                      |  4 ++--
 fs/ocfs2/stackglue.c                   |  3 ++-
 fs/ocfs2/suballoc.c                    | 13 +++++++++++-
 fs/ocfs2/super.c                       |  2 +-
 fs/ocfs2/xattr.c                       | 38 ++++++++++++++++++++++++++++++----
 include/linux/args.h                   |  4 ++--
 kernel/liveupdate/Kconfig              |  1 +
 kernel/liveupdate/luo_core.c           |  4 +---
 kernel/liveupdate/luo_file.c           |  7 +++++--
 mm/shmem.c                             | 11 ++++++++--
 scripts/checkpatch.pl                  |  6 ++++++
 22 files changed, 154 insertions(+), 44 deletions(-)


