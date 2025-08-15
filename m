Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B43A184E
	for <mm-commits@vger.kernel.org>; Fri, 15 Aug 2025 00:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755218283; cv=none; b=eTNLqXSWNw/ykVnf6+p9Mwc2eNsJxW7pNS7zRkKyQC5B+C9viS8y1995CTJY92sZqv+AiGgSBkTf9agU2P0iyg72RzW2psnIqxCGoCnxEr5h6oOYqxRCaH7zK2FvrZhsLWfEEfD+VCTAtBwXBvcPZ0OGxD6RhGfEo4wf86KMDCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755218283; c=relaxed/simple;
	bh=vKQxfxiqy8P+pi46/nBYlCRHyl2RM7v24ByDo21YMGA=;
	h=Date:To:From:Subject:Message-Id; b=nMZLaYVIO4shamOTSKBMoh4IY5+N3GfTm8+HXp8UYVWKBK0hqOEznOEV1MyC2WaeW6zrnwr3wqk4bAZ/Q9ODLnkxkzgiLwweCwQkMeSPoYxq0b+gEKZInoCg/SHNddUGFpMeSiZLKS4azF0zuGsBv6LOc7fJ/bTpTP2G2yzFXrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=losi2j24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="losi2j24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF50AC4CEF1;
	Fri, 15 Aug 2025 00:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755218283;
	bh=vKQxfxiqy8P+pi46/nBYlCRHyl2RM7v24ByDo21YMGA=;
	h=Date:To:From:Subject:From;
	b=losi2j24gzJrZdhISp2DCe8BoJfcTFW1qfkptZAcgCIRCFMbWQXEMg2QO1GxaO3si
	 8bOTPYoP6GMh9QmPrbFNqnZsVOAwasUhhcCB4XZ+1m48quCAq9b8uH0UzVg3RqwENn
	 yowIvYZsi8MFX42o7HyUCHIACieU9S7WKIjgvfNg=
Date: Thu, 14 Aug 2025 17:38:02 -0700
To: mm-commits@vger.kernel.org,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + test_firmware-use-str_true_false-helper.patch added to mm-nonmm-unstable branch
Message-Id: <20250815003802.DF50AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: test_firmware: use str_true_false() helper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     test_firmware-use-str_true_false-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/test_firmware-use-str_true_false-helper.patch

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

test_firmware-use-str_true_false-helper.patch

