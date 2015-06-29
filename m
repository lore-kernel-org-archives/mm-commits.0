From: akpm@linux-foundation.org
Subject: [merged] init-do_mounts-add-create_dev-failure-log.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:49:08 -0700
Message-ID: <5591af44.Qzhqm/vmdQNQLz+5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbbF2UtJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vishnu.ps@samsung.com, dehrenberg@chromium.org, mszeredi@suse.cz, paul.gortmaker@windriver.com, pavel@ucw.cz, snitzer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init/do_mounts.c: add create_dev() failure log
has been removed from the -mm tree.  Its filename was
     init-do_mounts-add-create_dev-failure-log.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Subject: init/do_mounts.c: add create_dev() failure log

If create_dev() function fails to create the root mount device
(/dev/root), then it goes to panic as root device not found but there is
no printk in this case.  So I have added the log in case it fails to
create the root device.  It will help in debugging.

[akpm@linux-foundation.org: simplify printk(), use pr_emerg(), display errno]
Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Dan Ehrenberg <dehrenberg@chromium.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN init/do_mounts.c~init-do_mounts-add-create_dev-failure-log init/do_mounts.c
--- a/init/do_mounts.c~init-do_mounts-add-create_dev-failure-log
+++ a/init/do_mounts.c
@@ -533,8 +533,13 @@ void __init mount_root(void)
 	}
 #endif
 #ifdef CONFIG_BLOCK
-	create_dev("/dev/root", ROOT_DEV);
-	mount_block_root("/dev/root", root_mountflags);
+	{
+		int err = create_dev("/dev/root", ROOT_DEV);
+
+		if (err < 0)
+			pr_emerg("Failed to create /dev/root: %d\n", err);
+		mount_block_root("/dev/root", root_mountflags);
+	}
 #endif
 }
 
_

Patches currently in -mm which might be from vishnu.ps@samsung.com are

origin.patch

