Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DA5747F;
	Thu,  4 Jul 2024 05:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720070850; cv=none; b=eISi9iUDstb0dcqex1XrFTIXKGo31uz0h6ihfnqCJksy47lhf6nfLNniZNwy41/hHibdpKacFQPi+PtnX7FSCPFRRDhVZfwfl+gR9qmDAoVJz3TE2FQnd8j3YQ3BqDPo654ngv+eTXj7nHobaDa2KRv+82p+WHRx6ez3kYc8f18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720070850; c=relaxed/simple;
	bh=r5+3Vb8FY/N72pkicyFI6kvK7pUtXXQwTF9Engm7t2M=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=cr6x6EKY/BDQvGubvLXHtzX6a6jAD2jiewZ+sY7//IAQ+0QC/kckC6qaqMwkV30SaFREUTTU4GxoL4R46RKPT71sq+t3NngwPu2wv55YWJF7JPbt7ThxVKYTrU6DFSApQpCjpLGAVOXjNX41STixcxAEf68fRQCkVXNmBkYhKNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FeHwnrwS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FeHwnrwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71191C3277B;
	Thu,  4 Jul 2024 05:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720070849;
	bh=r5+3Vb8FY/N72pkicyFI6kvK7pUtXXQwTF9Engm7t2M=;
	h=Date:From:To:Cc:Subject:From;
	b=FeHwnrwSMr88LvAFd1FA1uOzOPaTayQZOVa5U5xciix/Qu75w66OsfvrijnDA1FE/
	 DjtOG7ITsYwK/X6hAc+3lSSnwn1MKwerNr31ZO8f9B1/LhWS/eza5KlRq0IwNV122Y
	 kxcdJbWmga2n6l0hy6yg3CoZ4uOPK95w6I6plD+0=
Date: Wed, 3 Jul 2024 22:27:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 mm-commits@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.10-rc7
Message-Id: <20240703222728.d5ef62a48ebf19260832ee73@linux-foundation.org>
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

The following changes since commit 22a40d14b572deb80c0648557f4bd502d7e83826:

  Linux 6.10-rc6 (2024-06-30 14:40:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2024-07-03-22-23

for you to fetch changes up to 93aef9eda1cea9e84ab2453fcceb8addad0e46f1:

  nilfs2: fix incorrect inode allocation from reserved inodes (2024-07-03 12:29:25 -0700)

----------------------------------------------------------------
6 hotfies, all cc:stable.  Some fixes for longstanding nilfs2 issues and
three unrelated MM fixes.

----------------------------------------------------------------
Jan Kara (2):
      Revert "mm/writeback: fix possible divide-by-zero in wb_dirty_limits(), again"
      mm: avoid overflows in dirty throttling logic

Jinliang Zheng (1):
      mm: optimize the redundant loop of mm_update_owner_next()

Ryusuke Konishi (3):
      nilfs2: fix inode number range checks
      nilfs2: add missing check for inode numbers on directory entries
      nilfs2: fix incorrect inode allocation from reserved inodes

 fs/nilfs2/alloc.c     | 19 +++++++++++++++----
 fs/nilfs2/alloc.h     |  4 ++--
 fs/nilfs2/dat.c       |  2 +-
 fs/nilfs2/dir.c       |  6 ++++++
 fs/nilfs2/ifile.c     |  7 ++-----
 fs/nilfs2/nilfs.h     | 10 ++++++++--
 fs/nilfs2/the_nilfs.c |  6 ++++++
 fs/nilfs2/the_nilfs.h |  2 +-
 kernel/exit.c         |  2 ++
 mm/page-writeback.c   | 32 +++++++++++++++++++++++++++-----
 10 files changed, 70 insertions(+), 20 deletions(-)

