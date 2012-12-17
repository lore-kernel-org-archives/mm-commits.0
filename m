From: akpm@linux-foundation.org
Subject: [folded-merged] binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:45:39 -0800
Message-ID: <20121217234539.BC0CD82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:47802 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2LQXpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:45:40 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so707056yen.2
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:45:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch

This patch was dropped because it was folded into binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes

WARNING: line over 80 characters
#24: FILE: fs/binfmt_elf.c:1604:
+		info->psinfo.data = NULL;	/* So we don't free this wrongly */

ERROR: code indent should use tabs where possible
#26: FILE: fs/binfmt_elf.c:1606:
+        }$

WARNING: please, no spaces at the start of a line
#26: FILE: fs/binfmt_elf.c:1606:
+        }$

total: 1 errors, 2 warnings, 11 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/binfmt_elf.c~binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes
+++ a/fs/binfmt_elf.c
@@ -1602,9 +1602,9 @@ static int fill_note_info(struct elfhdr 
 
 	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
 	if (psinfo == NULL) {
-		info->psinfo.data = NULL;	/* So we don't free this wrongly */
+		info->psinfo.data = NULL; /* So we don't free this wrongly */
 		return 0;
-        }
+	}
 
 	fill_note(&info->psinfo, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
create-non-empty-arch-x86-include-uapi-asm-files.patch
mm-memoryc-suppress-warning.patch
lseek-the-whence-argument-is-called-whence.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
backlight-add-of_find_backlight_by_node-function.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch

