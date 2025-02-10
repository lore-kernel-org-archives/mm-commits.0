Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAAF25A2A1
	for <mm-commits@vger.kernel.org>; Mon, 10 Feb 2025 22:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739227601; cv=none; b=nn7/LxcFTHEokSOfTmYuBrBaS7FY82lDSlIoJjmFo/h8KXL72+4D0IImlOOIwEyJtMrsrPqTP6baoD3uvrXCmP6ssSq1bEoc1CvXy4YIb8nk3gAwNHZfTqvlQWR5dUV4E43G2NyVcm4mbsgT3UqiIC6havQE/w8eF0Ve/seWf1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739227601; c=relaxed/simple;
	bh=9WN2CVJvWsF8l/YVZrIZhr+OsDRzo1zgCxm3wLH6dGg=;
	h=Date:To:From:Subject:Message-Id; b=YHZlFBU01D6mmBW8D04eymjO5YGl8JwWMF6FiIx3a2WeZZMX+sKdLdhhN6M7/cnjSw2OmETk7A4+Z9eUCIvx2fetq0P9Wjc6CsROO+BLZMLYtfLTphoFKlrntIyvcT9ZcFBSfhTGSwNTtgw03IxBozNOkQ7GduzTKdRo2U7cjSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZTxZn3Ht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZTxZn3Ht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1316C4CED1;
	Mon, 10 Feb 2025 22:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739227600;
	bh=9WN2CVJvWsF8l/YVZrIZhr+OsDRzo1zgCxm3wLH6dGg=;
	h=Date:To:From:Subject:From;
	b=ZTxZn3HtJUvHNYYIiaLz52fW1Rq9BCQ67eKBRLaIAKi47KNUZUnA4wbauISM6M0f4
	 ZpkyQPv/GY2M2d8JWVdmIPTUXBWiDoBN7Z95+ioMgyb8AXa1EAch/vwjUjJ+ookHIk
	 1Zvbid+C5j3/5CWdWoTXstcHajPOQ6b7uni8qEIE=
Date: Mon, 10 Feb 2025 14:46:39 -0800
To: mm-commits@vger.kernel.org,florian.fainelli@broadcom.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-fix-build-warnings-with-musl-libc.patch added to mm-hotfixes-unstable branch
Message-Id: <20250210224640.C1316C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm: fix build warnings with musl-libc
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-mm-fix-build-warnings-with-musl-libc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-fix-build-warnings-with-musl-libc.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

tools-mm-fix-build-warnings-with-musl-libc.patch

