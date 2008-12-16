From: akpm@linux-foundation.org
Subject: + fs-fix-name-overwrite-in-__register_chrdev_region.patch added to -mm tree
Date: Mon, 15 Dec 2008 21:57:10 -0800
Message-ID: <200812160557.mBG5vALU004004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970AbYLPF5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Dec 2008 00:57:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     fs: fix name overwrite in __register_chrdev_region()
has been added to the -mm tree.  Its filename is
     fs-fix-name-overwrite-in-__register_chrdev_region.patch

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

slob-do-not-pass-the-slab-flags-as-gfp-in-kmem_cache_create.patch
linux-next.patch
net-ppp_asynctty_ioctl-remove-dead-code.patch
fs-fix-name-overwrite-in-__register_chrdev_region.patch
memcg-add-inactive_anon_is_low.patch

