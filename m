From: akpm@linux-foundation.org
Subject: + init-do_mountsc-print-error-code-on-mount-failure.patch added to -mm tree
Date: Tue, 13 Mar 2012 15:33:44 -0700
Message-ID: <20120313223344.CA77CA00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:34307 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964792Ab2CMWdr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Mar 2012 18:33:47 -0400
Received: by wibhj13 with SMTP id hj13so55136wib.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Mar 2012 15:33:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bernhard@bwalle.de


The patch titled
     Subject: init/do_mounts.c: print error code on mount failure
has been added to the -mm tree.  Its filename is
     init-do_mountsc-print-error-code-on-mount-failure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bernhard Walle <bernhard@bwalle.de>
Subject: init/do_mounts.c: print error code on mount failure

Printing the error code makes it easier to debug the cause of a mount
failure.  For example I had the problem that the root file system could
not be mounted read-writeable because my SD card was write-protected. 
Without an error code it looks like the SD card was not detected at all.

Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN init/do_mounts.c~init-do_mountsc-print-error-code-on-mount-failure init/do_mounts.c
--- a/init/do_mounts.c~init-do_mountsc-print-error-code-on-mount-failure
+++ a/init/do_mounts.c
@@ -373,8 +373,8 @@ retry:
 #ifdef CONFIG_BLOCK
 		__bdevname(ROOT_DEV, b);
 #endif
-		printk("VFS: Cannot open root device \"%s\" or %s\n",
-				root_device_name, b);
+		printk("VFS: Cannot open root device \"%s\" or %s: error %d\n",
+				root_device_name, b, err);
 		printk("Please append a correct \"root=\" boot option; here are the available partitions:\n");
 
 		printk_all_partitions();
_
Subject: Subject: init/do_mounts.c: print error code on mount failure

Patches currently in -mm which might be from bernhard@bwalle.de are

linux-next.patch
init-do_mountsc-print-error-code-on-mount-failure.patch

