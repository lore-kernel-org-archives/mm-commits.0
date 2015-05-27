From: akpm@linux-foundation.org
Subject: + init-do_mounts-add-create_dev-failure-log.patch added to -mm
 tree
Date: Wed, 27 May 2015 16:28:18 -0700
Message-ID: <55665312.M3O+0rYweeH0LyJ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbbE0X2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 May 2015 19:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vishnu.ps@samsung.com, dehrenberg@chromium.org, mszeredi@suse.cz, paul.gortmaker@windriver.com, pavel@ucw.cz, snitzer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init/do_mounts.c: add create_dev() failure log
has been added to the -mm tree.  Its filename is
     init-do_mounts-add-create_dev-failure-log.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-do_mounts-add-create_dev-failure-log.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-do_mounts-add-create_dev-failure-log.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: init/do_mounts.c: add create_dev() failure log

If create_dev() function fails to create the root mount device
(/dev/root), then it goes to panic as root device not found but there is
no printk in this case.  So I have added the log in case it fails to
create the root device.  It will help in debugging.

Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Dan Ehrenberg <dehrenberg@chromium.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN init/do_mounts.c~init-do_mounts-add-create_dev-failure-log init/do_mounts.c
--- a/init/do_mounts.c~init-do_mounts-add-create_dev-failure-log
+++ a/init/do_mounts.c
@@ -533,7 +533,8 @@ void __init mount_root(void)
 	}
 #endif
 #ifdef CONFIG_BLOCK
-	create_dev("/dev/root", ROOT_DEV);
+	if (create_dev("/dev/root", ROOT_DEV) < 0)
+		pr_err("Failed to create %s device !\n", "/dev/root");
 	mount_block_root("/dev/root", root_mountflags);
 #endif
 }
_

Patches currently in -mm which might be from vishnu.ps@samsung.com are

init-do_mounts-add-create_dev-failure-log.patch
init-do_mounts-add-create_dev-failure-log-fix.patch

