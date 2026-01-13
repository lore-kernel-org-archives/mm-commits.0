Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E37A2DA755
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 23:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768345251; cv=none; b=Y5LTHxCpNwq8wCgSfRtpkONmBidaH/0acjhrQC8/R2VgKsdPNNRYZgh0gHMRBLxLXv61kOHl39AhsJM1i63XcfIJ1/oVZ7k/i8Rd2PqBdQVtnfL2CIbP3yxbllWBPAK6QOLjwBt1NQXOZ0qYyOC29defDj3wgkB53EpRLaa4p/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768345251; c=relaxed/simple;
	bh=XNtopabULFdRvhIbNoiaL+pnkLsROWbixO7CXDmVc3w=;
	h=Date:To:From:Subject:Message-Id; b=p3AUQU+x4iW8lC9OdfKHsH1YgDT+aJ1N6a8u6q299DF5/UHtTRWC2GebfZIgjtwKOCG6rc3BAR1nLtEq7S/r6A479MOenw8dDA9v1M+WCmRdGOHtvUpnZQvFPxiDcy7s+03YacKfmGDS8JtraFo9uTO5eUp5x1PkesRg62wVlJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g2jKIc/b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g2jKIc/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362E1C116C6;
	Tue, 13 Jan 2026 23:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768345251;
	bh=XNtopabULFdRvhIbNoiaL+pnkLsROWbixO7CXDmVc3w=;
	h=Date:To:From:Subject:From;
	b=g2jKIc/bjJvesAq0qIzfwQ6EIY4CRITDllEqeY1oPs8tY5AtRkX24dbd7E3O4s/KU
	 VsI6DAHIgu/PMZ3ZoroF95YtUOZx/od6SEkCV2b+8/ziFKMIn3EwuOos5LwKe6P3bY
	 y2006cItrVNsu+elFdIhfeTbp7/kvwSrvirqhDkQ=
Date: Tue, 13 Jan 2026 15:00:50 -0800
To: mm-commits@vger.kernel.org,tglx@kernel.org,mingo@kernel.org,sun.jian.kdev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-main-read-bootconfig-header-with-get_unaligned_le32.patch added to mm-nonmm-unstable branch
Message-Id: <20260113230051.362E1C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init/main: read bootconfig header with get_unaligned_le32()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-main-read-bootconfig-header-with-get_unaligned_le32.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-main-read-bootconfig-header-with-get_unaligned_le32.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Sun Jian <sun.jian.kdev@gmail.com>
Subject: init/main: read bootconfig header with get_unaligned_le32()
Date: Tue, 13 Jan 2026 18:15:32 +0800

get_boot_config_from_initrd() scans up to 3 bytes before initrd_end to
handle GRUB 4-byte alignment.  As a result, the bootconfig header
immediately preceding the magic may be unaligned.

Read the size and checksum fields with get_unaligned_le32() instead of
casting to u32 * and using le32_to_cpu(), avoiding potential unaligned
access and silencing sparse "cast to restricted __le32" warnings.

Sparse warnings (gcc + C=1):
  init/main.c:292:16: warning: cast to restricted __le32
  init/main.c:293:16: warning: cast to restricted __le32

No functional change intended.

Link: https://lkml.kernel.org/r/20260113101532.1630770-1-sun.jian.kdev@gmail.com
Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Cc:
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/init/main.c~init-main-read-bootconfig-header-with-get_unaligned_le32
+++ a/init/main.c
@@ -104,6 +104,7 @@
 #include <linux/pidfs.h>
 #include <linux/ptdump.h>
 #include <linux/time_namespace.h>
+#include <linux/unaligned.h>
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
@@ -270,7 +271,7 @@ static void * __init get_boot_config_fro
 {
 	u32 size, csum;
 	char *data;
-	u32 *hdr;
+	u8 *hdr;
 	int i;
 
 	if (!initrd_end)
@@ -289,9 +290,9 @@ static void * __init get_boot_config_fro
 	return NULL;
 
 found:
-	hdr = (u32 *)(data - 8);
-	size = le32_to_cpu(hdr[0]);
-	csum = le32_to_cpu(hdr[1]);
+	hdr = (u8 *)(data - 8);
+	size = get_unaligned_le32(hdr);
+	csum = get_unaligned_le32(hdr + 4);
 
 	data = ((void *)hdr) - size;
 	if ((unsigned long)data < initrd_start) {
_

Patches currently in -mm which might be from sun.jian.kdev@gmail.com are

init-main-read-bootconfig-header-with-get_unaligned_le32.patch

