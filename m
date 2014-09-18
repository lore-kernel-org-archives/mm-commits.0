From: akpm@linux-foundation.org
Subject: + include-linux-screen_infoh-remove-unused-orig_-macros.patch
 added to -mm tree
Date: Thu, 18 Sep 2014 14:52:12 -0700
Message-ID: <541b540c.1r3GbXmT+QAMjVmf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaIRVwN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 17:52:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, hpa@zytor.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/screen_info.h: remove unused ORIG_* macros
has been added to the -mm tree.  Its filename is
     include-linux-screen_infoh-remove-unused-orig_-macros.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-screen_infoh-remove-unused-orig_-macros.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-screen_infoh-remove-unused-orig_-macros.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: include/linux/screen_info.h: remove unused ORIG_* macros

The ORIG_* macros definitions to access struct screen_info members and all
of their users were removed 7 years ago by commit 3ea335100014785f
("Remove magic macros for screen_info structure members"), but (only) the
definitions reappeared a few days later in commit ee8e7cfe9d330d6f ("Make
asm-x86/bootparam.h includable from userspace.").

Remove them for good. Amen.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/screen_info.h |    8 --------
 1 file changed, 8 deletions(-)

diff -puN include/linux/screen_info.h~include-linux-screen_infoh-remove-unused-orig_-macros include/linux/screen_info.h
--- a/include/linux/screen_info.h~include-linux-screen_infoh-remove-unused-orig_-macros
+++ a/include/linux/screen_info.h
@@ -5,12 +5,4 @@
 
 extern struct screen_info screen_info;
 
-#define ORIG_X			(screen_info.orig_x)
-#define ORIG_Y			(screen_info.orig_y)
-#define ORIG_VIDEO_MODE		(screen_info.orig_video_mode)
-#define ORIG_VIDEO_COLS 	(screen_info.orig_video_cols)
-#define ORIG_VIDEO_EGA_BX	(screen_info.orig_video_ega_bx)
-#define ORIG_VIDEO_LINES	(screen_info.orig_video_lines)
-#define ORIG_VIDEO_ISVGA	(screen_info.orig_video_isVGA)
-#define ORIG_VIDEO_POINTS       (screen_info.orig_video_points)
 #endif /* _SCREEN_INFO_H */
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
mn10300-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
cris-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
m32r-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
score-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2.patch
alpha-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
include-linux-screen_infoh-remove-unused-orig_-macros.patch
printk-dont-bother-using-log_cpu_max_buf_shift-on-smp.patch
linux-next.patch

