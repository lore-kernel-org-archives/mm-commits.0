Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801F333987
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 05:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738129233; cv=none; b=OY5dgRTLJN6twnJG0Kg5LpbuDakyPh2Aj0XJdRbMUN5WizoJqis15YswEK2nbTzXXUKYLyuLQSUl9LqzTYZgjzyyH9slssTmb9BeQIdTsMHmgJzxRk5MKs3vtAjOcYZkhZNiWelgC+z2AEQ5j4/wRJdJRhO8KhE3Z2JY+XpzNcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738129233; c=relaxed/simple;
	bh=3xGdnV5Fl6tFv6ckzBw2X3OI3JKxQogvJrraejXjwuE=;
	h=Date:To:From:Subject:Message-Id; b=jUIY1kbnX+7IecHh1PPXh0A5+acrfRocD2bvtxOGpBVM3402RI8jVZ/N/kYTwequgUL3a3l7rEff91h6uO3EaqPRXdpx3hDZE1v380OO0n2o5JZFVR1xJ4z8EXWhjO7eO4L/Ny/bVr284Erwl9VFkcd5UyGtbZghDll5DG3IMHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uFxpn3lO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uFxpn3lO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB38C4CED3;
	Wed, 29 Jan 2025 05:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738129232;
	bh=3xGdnV5Fl6tFv6ckzBw2X3OI3JKxQogvJrraejXjwuE=;
	h=Date:To:From:Subject:From;
	b=uFxpn3lOmeuFGKZU7DkxGxDoeH9yseO/drb12+O2bjx6xhjvX5d/PsaKiqzTHDwu1
	 kdYFAMCeG7drOMgft+dj1bA6B1aGz09qjzlayaNUQdndhZ+u8/Axqu54eLShRgjIbA
	 CgeYAF0LyJfY8GIHCTYq1VxFUJ0S4DiXEPIL8FDc=
Date: Tue, 28 Jan 2025 21:40:32 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,eahariha@linux.microsoft.com,djwong@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xfs-convert-timeouts-to-secs_to_jiffies-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20250129054032.DBB38C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xfs-convert-timeouts-to-secs_to_jiffies-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xfs-convert-timeouts-to-secs_to_jiffies-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xfs-convert-timeouts-to-secs_to_jiffies-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: xfs-convert-timeouts-to-secs_to_jiffies-fix
Date: Tue Jan 28 09:39:26 PM PST 2025

80-col fix, per Christoph

Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_sysfs.c~xfs-convert-timeouts-to-secs_to_jiffies-fix
+++ a/fs/xfs/xfs_sysfs.c
@@ -686,7 +686,8 @@ xfs_error_sysfs_init_class(
 		if (init[i].retry_timeout == XFS_ERR_RETRY_FOREVER)
 			cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
 		else
-			cfg->retry_timeout = secs_to_jiffies(init[i].retry_timeout);
+			cfg->retry_timeout =
+					secs_to_jiffies(init[i].retry_timeout);
 	}
 	return 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-extract-calculated-pressure-balance-as-a-function-fix.patch
xfs-convert-timeouts-to-secs_to_jiffies-fix.patch
lib-plistc-add-shortcut-for-plist_requeue-fix.patch

