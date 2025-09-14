Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7513233987
	for <mm-commits@vger.kernel.org>; Sun, 14 Sep 2025 00:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757810113; cv=none; b=fNSMCg4CXQoR64U2hsCz6XciuaTxp87Uv3JcP1ruUapG6HMrhOv9C2KXKGZFpsfpgLuipsOcGmMFx77q+6qZVWVnChsHRef1FvV5FVWD8XNPLwfebrze8Rxt07zihiHKhJ09TNA6FM/4qn9B9i5HMUXnRcsvzbK9bsbHAu0CLpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757810113; c=relaxed/simple;
	bh=bQkCsByTQUI2FUXvbVOXj7kLC1OKDHYtMjNFhxpnONU=;
	h=Date:To:From:Subject:Message-Id; b=qcI14JivwHCHq1bAtK/lexAqEFI1PqSqrlYLpkW3mVF3LfapQPr6VIE00vxmyEbxByVRtRG5hJdpvHXqW3qX8UxhefhfhVDCAYLTDW6Rku+5iI4pjrltVjOp3Lmg2b0B7OdoPHRTNOI8J9QuyAGMR5i0omUDswQCwMPAgOjjhFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dSU8quWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dSU8quWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4119DC4CEEB;
	Sun, 14 Sep 2025 00:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757810113;
	bh=bQkCsByTQUI2FUXvbVOXj7kLC1OKDHYtMjNFhxpnONU=;
	h=Date:To:From:Subject:From;
	b=dSU8quWNl+poFhzH7Mmqz/0rfLnyIiZ2ZuXNvcNDc0uPydkhb8zL60D4rSTMGBOyu
	 ZNpoa0GAXYS/H7PIC/JWnDKAeTNTCn0YNnNI4dLWE1ZVcVWkvfMsnvl/CtCZChBcTo
	 fdtkzqQMhhCevQHOQPN+wZStkqO3p7akIuZtiPCc=
Date: Sat, 13 Sep 2025 17:35:12 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] test_firmware-use-str_true_false-helper.patch removed from -mm tree
Message-Id: <20250914003513.4119DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: test_firmware: use str_true_false() helper
has been removed from the -mm tree.  Its filename was
     test_firmware-use-str_true_false-helper.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: test_firmware: use str_true_false() helper
Date: Thu, 14 Aug 2025 17:50:33 +0800

Replace ternary (condition ?  "true" : "false") expressions with the
str_true_false() helper from string_choices.h.  This improves readability
by replacing the three-operand ternary with a single function call,
ensures consistent string output, and allows potential string
deduplication by the linker, resulting in a slightly smaller binary.

Link: https://lkml.kernel.org/r/20250814095033.244034-1-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_firmware.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/lib/test_firmware.c~test_firmware-use-str_true_false-helper
+++ a/lib/test_firmware.c
@@ -26,6 +26,7 @@
 #include <linux/kthread.h>
 #include <linux/vmalloc.h>
 #include <linux/efi_embedded_fw.h>
+#include <linux/string_choices.h>
 
 MODULE_IMPORT_NS("TEST_FIRMWARE");
 
@@ -304,17 +305,17 @@ static ssize_t config_show(struct device
 			"FW_ACTION_NOUEVENT");
 	len += scnprintf(buf + len, PAGE_SIZE - len,
 			"into_buf:\t\t%s\n",
-			test_fw_config->into_buf ? "true" : "false");
+			str_true_false(test_fw_config->into_buf));
 	len += scnprintf(buf + len, PAGE_SIZE - len,
 			"buf_size:\t%zu\n", test_fw_config->buf_size);
 	len += scnprintf(buf + len, PAGE_SIZE - len,
 			"file_offset:\t%zu\n", test_fw_config->file_offset);
 	len += scnprintf(buf + len, PAGE_SIZE - len,
 			"partial:\t\t%s\n",
-			test_fw_config->partial ? "true" : "false");
+			str_true_false(test_fw_config->partial));
 	len += scnprintf(buf + len, PAGE_SIZE - len,
 			"sync_direct:\t\t%s\n",
-			test_fw_config->sync_direct ? "true" : "false");
+			str_true_false(test_fw_config->sync_direct));
 	len += scnprintf(buf + len, PAGE_SIZE - len,
 			"read_fw_idx:\t%u\n", test_fw_config->read_fw_idx);
 	if (test_fw_config->upload_name)
_

Patches currently in -mm which might be from visitorckw@gmail.com are


