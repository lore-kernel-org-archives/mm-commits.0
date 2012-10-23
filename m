From: akpm@linux-foundation.org
Subject: + binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch added to -mm tree
Date: Tue, 23 Oct 2012 15:56:54 -0700
Message-ID: <20121023225655.C787920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:33895 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933725Ab2JWW46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 18:56:58 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so69150lbo.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 15:56:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@linux.intel.com


The patch titled
     Subject: binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1601,9 +1601,9 @@ static int fill_note_info(struct elfhdr 
 
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

revert-tools-testing-selftests-epoll-test_epollc-fix-build.patch
revert-epoll-support-for-disabling-items-and-a-self-test-app.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
mm.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
drivers-edac-amd64_edacc-__amd64_set_scrub_rate-avoid-overindexing-scrubrates.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
fat-exportfs-rebuild-inode-if-ilookup-fails-fix.patch
procfs-add-vmflags-field-in-smaps-output-v3-fix.patch
random-fix-debug-format-strings-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

