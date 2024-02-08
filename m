Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717DE383BB
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 20:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707424523; cv=none; b=p4W+QZ0GYGSB+rDa3+QmMG6kwWwfeQD5piFb7Vj4pfpPIjQqGIci9fqlPmqYxcK8ECyMVtJUn2VqKUqta9B3I9u0r2nQy5R9Ls89Mt/FM1D5JAt/wgopsC4e3cC8jWu3f7KaBuBwEgFo0bC7/8J+08jjb7Wqe8NH/BWzp32i7Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707424523; c=relaxed/simple;
	bh=cYiWio3SwLho5r9EhzRLz8a40tAogt8qH31SpKNmh/o=;
	h=Date:To:From:Subject:Message-Id; b=hGdcP/N57amWRhcICv1ZST12Rs/FL16F0YUTk0O7TR9KT0yrf4fGOHWy/jdvSpds50/u5JB+AcOL9FUjcGmEJdcgkvfblRBYN5VfVOZuBjn+tvE2pRZh1WU2XzsOwuHt3EFOCRk/JpEi92gI4Cft9XUlwwaJw1RSDfJxbzQG3JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bDwrVFs8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bDwrVFs8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4400C433C7;
	Thu,  8 Feb 2024 20:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707424523;
	bh=cYiWio3SwLho5r9EhzRLz8a40tAogt8qH31SpKNmh/o=;
	h=Date:To:From:Subject:From;
	b=bDwrVFs8BCg9Bc1WCEAivP6OVM6He8/I62aY34N/ZAVpZ5SHi9tb+hbGMzMhV5wCL
	 fUaQAm2ZkUznPF5Kg2lynzJJAxycSF7fpocI72xLgZS6Ob0Jivs9AXtD0jD4MCypjT
	 Hd/G+TWSPVPeMVmf9g1lzA0uu1eEHrkBZmhaFwHk=
Date: Thu, 08 Feb 2024 12:35:22 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-maintainers-drop-unreachable-project-mirror-site.patch added to mm-nonmm-unstable branch
Message-Id: <20240208203522.E4400C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: MAINTAINERS: drop unreachable project mirror site
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-maintainers-drop-unreachable-project-mirror-site.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-maintainers-drop-unreachable-project-mirror-site.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: MAINTAINERS: drop unreachable project mirror site
Date: Thu, 8 Feb 2024 18:30:18 +0900

The hosting site where the nilfs project had a mirror site continues to be
in trouble, so we have decided not to use that site.  This will reflect it
in the MAINTAINERS file.

Link: https://lkml.kernel.org/r/20240208093018.6334-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~nilfs2-maintainers-drop-unreachable-project-mirror-site
+++ a/MAINTAINERS
@@ -15431,7 +15431,6 @@ M:	Ryusuke Konishi <konishi.ryusuke@gmai
 L:	linux-nilfs@vger.kernel.org
 S:	Supported
 W:	https://nilfs.sourceforge.io/
-W:	https://nilfs.osdn.jp/
 T:	git https://github.com/konis/nilfs2.git
 F:	Documentation/filesystems/nilfs2.rst
 F:	fs/nilfs2/
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-convert-segment-buffer-to-use-kmap_local.patch
nilfs2-convert-nilfs_copy_buffer-to-use-kmap_local.patch
nilfs2-convert-metadata-file-common-code-to-use-kmap_local.patch
nilfs2-convert-sufile-to-use-kmap_local.patch
nilfs2-convert-persistent-object-allocator-to-use-kmap_local.patch
nilfs2-convert-dat-to-use-kmap_local.patch
nilfs2-move-nilfs_bmap_write-call-out-of-nilfs_write_inode_common.patch
nilfs2-do-not-acquire-rwsem-in-nilfs_bmap_write.patch
nilfs2-convert-ifile-to-use-kmap_local.patch
nilfs2-localize-highmem-mapping-for-checkpoint-creation-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-finalization-within-cpfile.patch
nilfs2-localize-highmem-mapping-for-checkpoint-reading-within-cpfile.patch
nilfs2-remove-nilfs_cpfile_getput_checkpoint.patch
nilfs2-convert-cpfile-to-use-kmap_local.patch
nilfs2-maintainers-drop-unreachable-project-mirror-site.patch

