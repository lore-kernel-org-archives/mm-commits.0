From: akpm@linux-foundation.org
Subject: + fs-ramfs-dont-use-module_init-for-non-modular-core-code.patch
 added to -mm tree
Date: Mon, 13 Jan 2014 12:03:13 -0800
Message-ID: <52d44681.sBiJUbFIDgMoIg/n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaAMUDO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 15:03:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.gortmaker@windriver.com

Subject: + fs-ramfs-dont-use-module_init-for-non-modular-core-code.patch added to -mm tree
To: paul.gortmaker@windriver.com
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 12:03:13 -0800


The patch titled
     Subject: fs/ramfs: don't use module_init for non-modular core code
has been added to the -mm tree.  Its filename is
     fs-ramfs-dont-use-module_init-for-non-modular-core-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ramfs-dont-use-module_init-for-non-modular-core-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ramfs-dont-use-module_init-for-non-modular-core-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: fs/ramfs: don't use module_init for non-modular core code

The ramfs is always built in.  It will never be modular, so using
module_init as an alias for __initcall is rather misleading.

Fix this up now, so that we can relocate module_init from init.h into
module.h in the future.  If we don't do this, we'd have to add module.h to
obviously non-modular code, and that would be a worse thing.

Note that direct use of __initcall is discouraged, vs.  one of the
priority categorized subgroups.  As __initcall gets mapped onto
device_initcall, our use of fs_initcall (which makes sense for fs code)
will thus change this registration from level 6-device to level 5-fs (i.e.
 slightly earlier).  However no observable impact of that small difference
has been observed during testing, or is expected.

Also note that this change uncovers a missing semicolon bug in the
registration of the initcall.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ramfs/inode.c~fs-ramfs-dont-use-module_init-for-non-modular-core-code fs/ramfs/inode.c
--- a/fs/ramfs/inode.c~fs-ramfs-dont-use-module_init-for-non-modular-core-code
+++ a/fs/ramfs/inode.c
@@ -275,4 +275,4 @@ int __init init_ramfs_fs(void)
 
 	return err;
 }
-module_init(init_ramfs_fs)
+fs_initcall(init_ramfs_fs);
_

Patches currently in -mm which might be from paul.gortmaker@windriver.com are

fs-ramfs-dont-use-module_init-for-non-modular-core-code.patch
printk-flush-conflicting-continuation-line.patch
printk-flush-conflicting-continuation-line-fix.patch
linux-next.patch

