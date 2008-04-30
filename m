From: akpm@linux-foundation.org
Subject: - fs-remove-unused-fops-from-struct-char_device_struct.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:51 -0700
Message-ID: <200804300539.m3U5dpvL028884@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753749AbYD3Fjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olsajiri@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     fs: remove unused fops from struct char_device_struct
has been removed from the -mm tree.  Its filename was
     fs-remove-unused-fops-from-struct-char_device_struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

