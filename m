From: akpm@linux-foundation.org
Subject: + fs-remove-unused-fops-from-struct-char_device_struct.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:33:27 -0800
Message-ID: <200802230734.m1N7YGeK018274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471AbYBWHxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:53:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olsajiri@gmail.com, greg@kroah.com


The patch titled
     fs: remove unused fops from struct char_device_struct
has been added to the -mm tree.  Its filename is
     fs-remove-unused-fops-from-struct-char_device_struct.patch

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
Subject: fs: remove unused fops from struct char_device_struct
From: Jiri Olsa <olsajiri@gmail.com>

struct char_device_struct::fops is no longer used: remove it.

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/char_dev.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/char_dev.c~fs-remove-unused-fops-from-struct-char_device_struct fs/char_dev.c
--- a/fs/char_dev.c~fs-remove-unused-fops-from-struct-char_device_struct
+++ a/fs/char_dev.c
@@ -55,7 +55,6 @@ static struct char_device_struct {
 	unsigned int baseminor;
 	int minorct;
 	char name[64];
-	struct file_operations *fops;
 	struct cdev *cdev;		/* will die */
 } *chrdevs[CHRDEV_MAJOR_HASH_SIZE];
 
_

Patches currently in -mm which might be from olsajiri@gmail.com are

uml-remove-unused-sigcontext-accessors.patch
fs-remove-unused-fops-from-struct-char_device_struct.patch
