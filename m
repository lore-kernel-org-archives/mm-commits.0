Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D212631ED93;
	Mon, 14 Sep 2026 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789409727; cv=none; b=jvfJUF85uavMRGyGXRJTM3Ymlw+KjcPB1jUUkxlCdtdCYkewirMPx0SrWEU/s1+rJj5DwKJV7gZkBSU6YL11OHjvp/h/M6KUJuU93jsrsGxHqDWzUwW6mZ+0Msx6AMl0zSd8YUt5IGYJP4ATy8rWLpmf7wGReHvxAHrPvq3dvio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789409727; c=relaxed/simple;
	bh=yeBvKC2LOwf89yHVeSSHjI1k0DaAXsPVPQuDbsxMyZg=;
	h=Date:To:From:Subject:Message-Id; b=ovfxvCbH6GFc88Jo7777wAEQ7eIzbX3LaAp5b+1z04G5pM05McBThPppHRpvfgp6k7ZMNRFty25+BZ0Szkej0iNQnvuKSJsX7jzyBvAJKNpdNhzxuaG9etCyQcwBNP5YlQAAT9ku7LiNyJGCfo3u7GWd6UhIe2wOugRAPj5sMyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WQ2YVaoP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WQ2YVaoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6EA1F000FF;
	Mon, 14 Sep 2026 18:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789409725;
	bh=r2gNGhfigd2h71kFa7KAWNdSkIvZ7GBGekrCie3osg4=;
	h=Date:To:From:Subject;
	b=WQ2YVaoPWq+nr5ZmkX9bBiNSQWpLtLWSCTjkoBGmcpAOv8Xsj0aSMRPw7PGPa2Pyk
	 ZHKkBfWwy1O6O0evbOlvznJMVxVQNB3gvpFo2gBQ1MTbIMC2JwEF3CwpUP2q8KyFL+
	 2ygKqm2izD1Vp/UPOt2kqD6q1I0nzBouOgwNQG4o=
Date: Mon, 14 Sep 2026 11:15:24 -0700
To: mm-commits@vger.kernel.org,thomas.weissschuh@linutronix.de,stable@vger.kernel.org,sashiko-bot@kernel.org,ryan.roberts@arm.com,mark.rutland@arm.com,leitao@debian.org,ekffu200098@gmail.com,dianders@chromium.org,chenhuacai@kernel.org,brauner@kernel.org,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] bootconfig-fix-integer-overflow-in-initrd-size-check.patch removed from -mm tree
Message-Id: <20260914181525.3A6EA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bootconfig: fix integer overflow in initrd size check
has been removed from the -mm tree.  Its filename was
     bootconfig-fix-integer-overflow-in-initrd-size-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

tools-bootconfig-fix-integer-overflow-and-truncation-in-size-checks.patch
bootconfig-reject-unexpected-data-after-null-character.patch
tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch
bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch
bootconfig-move-bootconfig_footer_size-to-include-linux-bootconfigh.patch

