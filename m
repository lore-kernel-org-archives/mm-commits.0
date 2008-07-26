From: akpm@linux-foundation.org
Subject: + mm-utilc-must-include-linux-schedh.patch added to -mm tree
Date: Sat, 26 Jul 2008 14:27:07 -0700
Message-ID: <200807262127.m6QLR7nU020379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757761AbYGZV1R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:27:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     mm/util.c must #include <linux/sched.h>
has been added to the -mm tree.  Its filename is
     mm-utilc-must-include-linux-schedh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/util.c must #include <linux/sched.h>
From: Adrian Bunk <bunk@kernel.org>

/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c: In function 'arch_pick_mmap_layout':
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:144: error: dereferencing pointer to incomplete type
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:145: error: 'arch_get_unmapped_area' undeclared (first use in this function)
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:145: error: (Each undeclared identifier is reported only once
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:145: error: for each function it appears in.)
/home/bunk/linux/kernel-2.6/git/linux-2.6/mm/util.c:146: error: 'arch_unmap_area' undeclared (first use in this function)

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/util.c~mm-utilc-must-include-linux-schedh mm/util.c
--- a/mm/util.c~mm-utilc-must-include-linux-schedh
+++ a/mm/util.c
@@ -3,6 +3,7 @@
 #include <linux/string.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/sched.h>
 #include <asm/uaccess.h>
 
 /**
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
mm-utilc-must-include-linux-schedh.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

