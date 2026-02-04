Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032C03358C4;
	Wed,  4 Feb 2026 23:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770249520; cv=none; b=bWGK4+ZFp6rXkU7vWCb/coJmLR+/Qy6aPhRBv3AWM1hGq6g5zOKxTez8TckmPuHANFsvWOuQUMVeJ30TFXt0yMICUUWo0pfKkhNHNtirXa33dY4y2coi/tRpeKXGUVTujQ5DsXwcbcblF7kzRt26ZaY7WHFwoLvbjBxGRr0HxdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770249520; c=relaxed/simple;
	bh=0+q5yBjEBxCWAnEr3neKDH0a8j6BW2Co3pHAtWUQvLA=;
	h=Date:From:To:Cc:Subject:Message-Id:Mime-Version:Content-Type; b=bYoyG99fAlMOuawmVWLKpJFTtETx2AhMd42ULb3oZDAUBCFUDgXgG9H2W8WB7AFNTw2YyVc2xj/gpqmjbYchTLbPZ2I6ajx1vb8nO8l37U5gBN7TlxaxRn5zNQnA4aSpTF5nDa+rcRVeEtMmKs7o/n+vBG1HKHqoMaenXjQMXpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IPdNxj6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IPdNxj6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BB9C4CEF7;
	Wed,  4 Feb 2026 23:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770249519;
	bh=0+q5yBjEBxCWAnEr3neKDH0a8j6BW2Co3pHAtWUQvLA=;
	h=Date:From:To:Cc:Subject:From;
	b=IPdNxj6oAVxasjCuy8JPMWwNu4FtiFC26S9z2bxvBUym0W9iDE4aZFWngtHQhA5/V
	 22r5ux8MtPJStsKvm/LSVkMNMNOJlWHc8XIuFr5kZ+RM6HwVW3It4EWNAFg8q7Avu1
	 cCX87zYpogJqAsju+OkFc4pBl138N0ZBYSsyUihc=
Date: Wed, 4 Feb 2026 15:58:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes against 6.19-rc8
Message-Id: <20260204155838.05fd9b9d9b43b493fd0b74a4@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Linus, please pull this small batch of hotfixes, thanks.



The following changes since commit bd58782995a2e6a07fd07255f3cc319f40b131c9:

  vmcoreinfo: make hwerr_data visible for debugging (2026-01-26 19:03:49 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-04-15-55

for you to fetch changes up to 1a47837bfafed7e9ef93f5dfdea6d70869b0c3ab:

  Documentation: document liveupdate cmdline parameter (2026-02-02 18:43:56 -0800)

----------------------------------------------------------------
5 hotfixes.  2 are cc:stable, 2 are for MM.

All are singletons - please see the changelogs for details.

----------------------------------------------------------------
Alexander Mikhalitsyn (1):
      mailmap: update Alexander Mikhalitsyn's emails

Andrew Cooper (1):
      x86/kfence: fix booting on 32bit non-PAE systems

Kairui Song (1):
      mm, shmem: prevent infinite loop on truncate race

Li Chen (1):
      Documentation: document liveupdate cmdline parameter

Pratyush Yadav (Google) (1):
      liveupdate: luo_file: do not clear serialized_data on unfreeze

 .mailmap                                        |  1 +
 Documentation/admin-guide/kernel-parameters.txt |  5 +++++
 arch/x86/include/asm/kfence.h                   |  7 ++++---
 kernel/liveupdate/luo_file.c                    |  2 --
 mm/shmem.c                                      | 23 ++++++++++++++---------
 5 files changed, 24 insertions(+), 14 deletions(-)

