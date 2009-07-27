From: akpm@linux-foundation.org
Subject: + fs-ramfs-file-nommuc-needs-include-linux-schedh.patch added to -mm tree
Date: Mon, 27 Jul 2009 16:09:32 -0700
Message-ID: <200907272309.n6RN9WKb005059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832AbZG0XKk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Jul 2009 19:10:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: catalin.marinas@arm.com, dhowells@redhat.com


The patch titled
     fs/ramfs/file-nommu.c needs include/linux/sched.h
has been added to the -mm tree.  Its filename is
     fs-ramfs-file-nommuc-needs-include-linux-schedh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ramfs/file-nommu.c needs include/linux/sched.h
From: Catalin Marinas <catalin.marinas@arm.com>

This file makes use of various macros defined in files like asm/current.h
or asm-generic/resource.h.  All these files can be included via sched.h. 
The building of the !MMU ARM kernel (with additional patches) fails
without this change.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/ramfs/file-nommu.c~fs-ramfs-file-nommuc-needs-include-linux-schedh fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~fs-ramfs-file-nommuc-needs-include-linux-schedh
+++ a/fs/ramfs/file-nommu.c
@@ -20,6 +20,7 @@
 #include <linux/ramfs.h>
 #include <linux/pagevec.h>
 #include <linux/mman.h>
+#include <linux/sched.h>
 
 #include <asm/uaccess.h>
 #include "internal.h"
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
fs-ramfs-file-nommuc-needs-include-linux-schedh.patch
linux-next.patch

