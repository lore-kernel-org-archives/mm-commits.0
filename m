Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5069A48822F
	for <mm-commits@vger.kernel.org>; Thu, 27 Aug 2026 16:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787846915; cv=none; b=N/PXQkAqI7KMptohTZkG3gzgWxih//JCb7K90qlb37RJBefgX80Tr75Zap6oAnB5lNUJtmZysYZcSbgGw+i8bmiiRRJAqFEbhVxEz90pomzWHuUruFzh9scKX/Gim1FTf/hiW0yuE5FQt4z1BcfMi6bwsFv1ZBE3JhrqHUXgon8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787846915; c=relaxed/simple;
	bh=40c5J4RXYGORF674O22Mk1FatQyPX+CGAsKTiGuNJls=;
	h=Date:To:From:Subject:Message-Id; b=Tb5bUBr3ssUHwTeCOjBoNXAEpB+2koWHPcoyqTOLgzV0NbhOo4TzkwWKXZ7z0XKNKLNdXGEjghqRF6xNQB/1nmAU7gvWHGLZMkMbECpK/8AnJvPf2bMvT8d2MCgivyYdd0vVXeKxVw3HtkFQ2pV/ZFK79BOmFDYZJCrBlQmbyQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=POrb8v/d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="POrb8v/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAA41F01561;
	Thu, 27 Aug 2026 16:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787846912;
	bh=BLA3cqdOXjqgAGWBa1o4gAv5EpuI1oikyqhe+HscnzM=;
	h=Date:To:From:Subject;
	b=POrb8v/dS/5h1b0tT9H8ZHl0sUZP3O3R4p4vtu+in0QGhhywcPzddfaHmplcA1JTL
	 3dd/MjTyg2s0aOxnkETmZXXvBh9G+DKBzA4yXyK+R/1WMCUflVLy/1VCng4ghSQMYx
	 5+3QnGRFdUrbLyBNoSQLDpWyJ3eIhOJHQG9lgM6I=
Date: Thu, 27 Aug 2026 09:08:32 -0700
To: mm-commits@vger.kernel.org,yukuai@fygo.io,xiao@kernel.org,song@kernel.org,magiclinan@didiglobal.com,hch@lst.de,akpm@linux-foundation.org,geert+renesas@glider.be,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-cover-all-of-raid.patch added to mm-hotfixes-unstable branch
Message-Id: <20260827160832.9CAA41F01561@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: cover all of RAID
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-cover-all-of-raid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-cover-all-of-raid.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: MAINTAINERS: cover all of RAID
Date: Thu, 27 Aug 2026 09:20:56 +0200

While commit 3626738bc7147d52 ("raid6: move to lib/raid/") handled the
move of RAID6, it didn't take into account there was already more RAID
code under lib/raid/, as XOR got moved over in commit 9e229025e2474115
("xor: move to lib/raid/") before.

Link: https://lore.kernel.org/7a2e5de234cc0286e3fe9bc11b810433775f2280.1787815121.git.geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/20260826205058.a6ff019d0584f75c7f50430b@linux-foundation.org
Cc: Christoph Hellwig <hch@lst.de>
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>
Cc: Xiao Ni <xiao@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-cover-all-of-raid
+++ a/MAINTAINERS
@@ -25128,7 +25128,7 @@ F:	drivers/md/md*
 F:	drivers/md/raid*
 F:	include/linux/raid/
 F:	include/uapi/linux/raid/
-F:	lib/raid/raid6/
+F:	lib/raid/
 
 SOLIDRUN CLEARFOG SUPPORT
 M:	Russell King <linux@armlinux.org.uk>
_

Patches currently in -mm which might be from geert+renesas@glider.be are

maintainers-cover-all-of-raid.patch

