Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5684233EAF8
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967413; cv=none; b=q1qgCCN//Zfr9Bu0qkiJayOAETuwxf4eJ/5r+ubuInvsXUajByz5cVUpzJQpzSVHMoPcTiyt+3Y5gyE82sQUEbDGsT+ncdUOlmmvepae1BYg+d2kgr3oRb0JHBo0mZodp1DDfWqgjKOkd7L2K2FF4Y3TwVae+qhTAViy7bvwobc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967413; c=relaxed/simple;
	bh=zGAQ820pW7n5VRgDmsbtdAcGPAGnFMsJVTApzbozrU4=;
	h=Date:To:From:Subject:Message-Id; b=sYZRW/kgvpBuYLnR1x0LADwtHdkhGw7548feNJgT5dGrmeUiKGTUeQN969+JoKz2IxHeRwdCuB8dpb/imo1LqktnSjgKEoLzbRH3G6/P51TdfJj8vVKaRP+9tP4YGyb5/A2GTSm83HnsaKr3VgKZlEdJPv75x3eI9VPSAW5CniU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vYUHeLqn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vYUHeLqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A00FC116D0;
	Wed, 21 Jan 2026 03:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967413;
	bh=zGAQ820pW7n5VRgDmsbtdAcGPAGnFMsJVTApzbozrU4=;
	h=Date:To:From:Subject:From;
	b=vYUHeLqnmpSL2AALSvqeDm0PrL9vhk4A4MPiSLDyEK4atDTV/uBb1xunWcM1ZNZXq
	 tCDa0ebXTPIk8ZLg4O6H4wrUDHh+d5hPS3ZZrtP9QAqu/K96f/M+A14gpoEkZahGmF
	 b7Glv5pJaBZxxtLJP03iLRVX7l7GOdQbCASs/mNw=
Date: Tue, 20 Jan 2026 19:50:12 -0800
To: mm-commits@vger.kernel.org,tglx@kernel.org,mingo@kernel.org,sun.jian.kdev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-main-read-bootconfig-header-with-get_unaligned_le32.patch removed from -mm tree
Message-Id: <20260121035013.2A00FC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init/main: read bootconfig header with get_unaligned_le32()
has been removed from the -mm tree.  Its filename was
     init-main-read-bootconfig-header-with-get_unaligned_le32.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


