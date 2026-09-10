Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628A8457E72;
	Thu, 10 Sep 2026 21:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789075666; cv=none; b=iNUNRK/Ga3gfhoW92N+CplMHY1clxn0hNvX9yLa80Yveqz3KlTtMJh6HgmwqHFqgqMY+/plWVNHK6gR045hPz8dXJ/QaKHpqgYRgFbt4CBJ3a+H8/90UTZWKbaNwjHCNPlYnFmJOWEwuZsm6x3TpyLKXUfhAGTbSnhHOjuso/PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789075666; c=relaxed/simple;
	bh=7tAqaRehMHEU8uWxnjoXz+mryo06HhA4C4Db1j+UyOg=;
	h=Date:To:From:Subject:Message-Id; b=PEnPmRs21p7H879CcETkcvx+YIUfSqkdkZUy9m5mhuPTd6TTfuVElqdjPmZDqoUSSHlc2V1r+7+7+yXFoYrIW2e6OOvqEpI2D6f8D1xO4UJq2ZfH1PP18TvRtapfTxeHck3x+tznQUodf2Tzuhw+8WZSymKptkQocCkrmA7Fv0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a86RSJ7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a86RSJ7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5981F000FF;
	Thu, 10 Sep 2026 21:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789075665;
	bh=LcbLrY4y6WN8w69xeReRON/wjrhqI2NlULJquItNuxE=;
	h=Date:To:From:Subject;
	b=a86RSJ7F5S+GRZI633oFTBHsCOy1/agRqYSYVz1YVk/2dB58MQU2jUXMtnAq6/bXd
	 EKssgAFf83xXeSHlj6NRH4V8FiPg+e04H8zDd2apRyCYWe6Q1iuO76jMbwLuSKM8Tw
	 s2jevRKcGOinW39JGz20CyqNMJFbO/sAoWrUovug=
Date: Thu, 10 Sep 2026 14:27:44 -0700
To: mm-commits@vger.kernel.org,thomas.weissschuh@linutronix.de,stable@vger.kernel.org,sashiko-bot@kernel.org,ryan.roberts@arm.com,mark.rutland@arm.com,leitao@debian.org,ekffu200098@gmail.com,dianders@chromium.org,chenhuacai@kernel.org,brauner@kernel.org,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bootconfig-fix-integer-overflow-in-initrd-size-check.patch added to mm-nonmm-unstable branch
Message-Id: <20260910212744.DA5981F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bootconfig: fix integer overflow in initrd size check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bootconfig-fix-integer-overflow-in-initrd-size-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootconfig-fix-integer-overflow-in-initrd-size-check.patch

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
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: bootconfig: fix integer overflow in initrd size check
Date: Fri, 11 Sep 2026 00:15:34 +0900

Sashiko reported that in get_boot_config_from_initrd(), a crafted initrd
with a huge bootconfig size (such as 0xFFFFFFFF) can cause the pointer
arithmetic:

    data = ((void *)hdr) - size;

to wrap around on 32-bit systems (or when pointer subtraction overflows). 
Because data wraps around, the subsequent bounds check:

    if ((unsigned long)data < initrd_start)

evaluates to false, bypassing the check.  The kernel then calls
xbc_calc_checksum(data, size), which attempts to read 4GB of memory,
hitting unmapped pages and triggering a fatal kernel page fault during
early boot.  Furthermore, on 64-bit systems with an initrd > 4.29 GB, an
unbounded 32-bit size can similarly bypass the initrd_start check.

Fix this by:
1. Ensuring the initrd is at least large enough to contain the bootconfig
   footer and verifying hdr is within the initrd bounds.
2. Checking that size does not exceed XBC_DATA_MAX and does not exceed
   the available space between initrd_start and hdr before performing
   pointer subtraction.

Link: https://lore.kernel.org/178905333479.213925.1358412668943562406.stgit@devnote2
Fixes: de462e5f1071 ("bootconfig: Fix to remove bootconfig data from initrd while boot")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260910010137.EE0431F000FF@smtp.kernel.org/
Assisted-by: Antigravity:gemini-3.8-flash
Cc: Breno Leitao <leitao@debian.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/init/main.c~bootconfig-fix-integer-overflow-in-initrd-size-check
+++ a/init/main.c
@@ -277,7 +277,8 @@ static void * __init get_boot_config_fro
 	u8 *hdr;
 	int i;
 
-	if (!initrd_end)
+	if (!initrd_end || initrd_end < initrd_start ||
+	    initrd_end - initrd_start < BOOTCONFIG_MAGIC_LEN + 8)
 		return NULL;
 
 	data = (char *)initrd_end - BOOTCONFIG_MAGIC_LEN;
@@ -294,16 +295,26 @@ static void * __init get_boot_config_fro
 
 found:
 	hdr = (u8 *)(data - 8);
+	if ((unsigned long)hdr < initrd_start)
+		return NULL;
+
 	size = get_unaligned_le32(hdr);
 	csum = get_unaligned_le32(hdr + 4);
 
-	data = ((void *)hdr) - size;
-	if ((unsigned long)data < initrd_start) {
-		pr_err("bootconfig size %d is greater than initrd size %ld\n",
+	if (size > XBC_DATA_MAX) {
+		pr_err("bootconfig size %u is greater than max size %d\n",
+			size, XBC_DATA_MAX);
+		return NULL;
+	}
+
+	if (size > ((unsigned long)hdr - initrd_start)) {
+		pr_err("bootconfig size %u is greater than initrd size %lu\n",
 			size, initrd_end - initrd_start);
 		return NULL;
 	}
 
+	data = ((void *)hdr) - size;
+
 	if (xbc_calc_checksum(data, size) != csum) {
 		pr_err("bootconfig checksum failed\n");
 		return NULL;
@@ -394,12 +405,6 @@ static void __init setup_boot_config(voi
 		return;
 	}
 
-	if (size >= XBC_DATA_MAX) {
-		pr_err("bootconfig size %ld greater than max size %d\n",
-			(long)size, XBC_DATA_MAX);
-		return;
-	}
-
 	ret = xbc_init(data, size, &msg, &pos);
 	if (ret < 0) {
 		if (pos < 0)
_

Patches currently in -mm which might be from mhiramat@kernel.org are

bootconfig-reject-unexpected-data-after-null-character.patch
tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch
bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch
tools-bootconfig-fix-integer-overflow-and-truncation-in-size-checks.patch
bootconfig-fix-integer-overflow-in-initrd-size-check.patch

