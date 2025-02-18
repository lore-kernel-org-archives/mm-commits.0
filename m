Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427CA1AF0CB
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 06:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739860851; cv=none; b=QzfqhSP4kA+9NKTxVBSPRqjdYJl+0wLRL+9Kl9jPnfDlgZ03CXsBJye84zi8ZYxmhDN5hCNj9ti8JRl+jc93WBQhNEzG2hsJ7SWJr6FYlgARIThRkOdJReVBxYvc3bB+rTmORQv5iHoOw1t6MIy/gp3vNv4/TWDGSfftBwtikPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739860851; c=relaxed/simple;
	bh=Ywf5K2o+XJsmaoE3L3goWJR6oSpw2DsLhtJoKCgsKOA=;
	h=Date:To:From:Subject:Message-Id; b=YDLylwztmZE/X4zhCf+0TSltVvZMmLfA2z38y6qgO2lVmzZRoA3uEfBivv1wDJAZ9B4TBFSwIFQFvmCp8RuceLZofO2VTFBdehaX1EoeGIN5bBUxjIsOnjNMPssKUJomGhoCdSTSoMmh6UOjzP8Gas4ezzYeX4WYGrABdv/HnBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Fr/rbsjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Fr/rbsjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22F1C4CEE2;
	Tue, 18 Feb 2025 06:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739860850;
	bh=Ywf5K2o+XJsmaoE3L3goWJR6oSpw2DsLhtJoKCgsKOA=;
	h=Date:To:From:Subject:From;
	b=Fr/rbsjmP3CotNsDk5aRq+N5okNnfNFmakexKtgL1xLHxMr5UBtUen322XXQqcioS
	 potGfGSJ7jw/DWf838kpeswZdTHrme+W5MDWDksuPUxkhk4iUo5GVCQfeqVO/hSY9q
	 1HETUkcyN9gSZsCLqnLwioa5dXMUHBj9Ng9wvynY=
Date: Mon, 17 Feb 2025 22:40:50 -0800
To: mm-commits@vger.kernel.org,florian.fainelli@broadcom.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-mm-fix-build-warnings-with-musl-libc.patch removed from -mm tree
Message-Id: <20250218064050.B22F1C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm: fix build warnings with musl-libc
has been removed from the -mm tree.  Its filename was
     tools-mm-fix-build-warnings-with-musl-libc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Florian Fainelli <florian.fainelli@broadcom.com>
Subject: tools/mm: fix build warnings with musl-libc
Date: Mon, 10 Feb 2025 12:05:18 -0800

musl-libc warns about the following:

/home/florian/dev/buildroot/output/arm64/rpi4-b/host/aarch64-buildroot-linux-musl/sysroot/usr/include/sys/errno.h:1:2: attention: #warning redirecting incorrect #include <sys/errno.h> to <errno.h> [-Wcpp]
    1 | #warning redirecting incorrect #include <sys/errno.h> to <errno.h>
      |  ^~~~~~~
/home/florian/dev/buildroot/output/arm64/rpi4-b/host/aarch64-buildroot-linux-musl/sysroot/usr/include/sys/fcntl.h:1:2: attention: #warning redirecting incorrect #include <sys/fcntl.h> to <fcntl.h> [-Wcpp]
    1 | #warning redirecting incorrect #include <sys/fcntl.h> to <fcntl.h>
      |  ^~~~~~~

include errno.h and fcntl.h directly.

Link: https://lkml.kernel.org/r/20250210200518.1137295-1-florian.fainelli@broadcom.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page-types.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/mm/page-types.c~tools-mm-fix-build-warnings-with-musl-libc
+++ a/tools/mm/page-types.c
@@ -24,8 +24,8 @@
 #include <signal.h>
 #include <inttypes.h>
 #include <sys/types.h>
-#include <sys/errno.h>
-#include <sys/fcntl.h>
+#include <errno.h>
+#include <fcntl.h>
 #include <sys/mount.h>
 #include <sys/statfs.h>
 #include <sys/mman.h>
_

Patches currently in -mm which might be from florian.fainelli@broadcom.com are


