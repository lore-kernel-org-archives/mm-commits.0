From: akpm@linux-foundation.org
Subject: - fs-fix-name-overwrite-in-__register_chrdev_region.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:06 -0800
Message-ID: <200901072216.n07MG6WB015811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754050AbZAGWQJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fs: fix name overwrite in __register_chrdev_region()
has been removed from the -mm tree.  Its filename was
     fs-fix-name-overwrite-in-__register_chrdev_region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: fix name overwrite in __register_chrdev_region()
From: Cyrill Gorcunov <gorcunov@gmail.com>

It's possible to register a chrdev with a name size exactly the same as
was allocated in structure.  It seems it was not intended behaviour.

At least chrdev_show does not like it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/char_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/char_dev.c~fs-fix-name-overwrite-in-__register_chrdev_region fs/char_dev.c
--- a/fs/char_dev.c~fs-fix-name-overwrite-in-__register_chrdev_region
+++ a/fs/char_dev.c
@@ -120,7 +120,7 @@ __register_chrdev_region(unsigned int ma
 	cd->major = major;
 	cd->baseminor = baseminor;
 	cd->minorct = minorct;
-	strncpy(cd->name,name, 64);
+	strlcpy(cd->name, name, sizeof(cd->name));
 
 	i = major_to_index(major);
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
linux-next.patch
memcg-add-inactive_anon_is_low.patch

