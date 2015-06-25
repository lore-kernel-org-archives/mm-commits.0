From: akpm@linux-foundation.org
Subject: [folded-merged]
 init-do_mounts-add-create_dev-failure-log-fix.patch removed from -mm tree
Date: Thu, 25 Jun 2015 14:54:27 -0700
Message-ID: <558c7893.PENLGw5nnsPTYZuC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbbFYVy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Jun 2015 17:54:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dehrenberg@chromium.org, mszeredi@suse.cz, paul.gortmaker@windriver.com, pavel@ucw.cz, snitzer@redhat.com, vishnu.ps@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init-do_mounts-add-create_dev-failure-log-fix
has been removed from the -mm tree.  Its filename was
     init-do_mounts-add-create_dev-failure-log-fix.patch

This patch was dropped because it was folded into init-do_mounts-add-create_dev-failure-log.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: init-do_mounts-add-create_dev-failure-log-fix

simplify printk(), use pr_emerg(), display errno

Cc: Dan Ehrenberg <dehrenberg@chromium.org>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN init/do_mounts.c~init-do_mounts-add-create_dev-failure-log-fix init/do_mounts.c
--- a/init/do_mounts.c~init-do_mounts-add-create_dev-failure-log-fix
+++ a/init/do_mounts.c
@@ -533,9 +533,13 @@ void __init mount_root(void)
 	}
 #endif
 #ifdef CONFIG_BLOCK
-	if (create_dev("/dev/root", ROOT_DEV) < 0)
-		pr_err("Failed to create %s device !\n", "/dev/root");
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

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
s390-mm-change-hpage_shift-type-to-int.patch
zswap-runtime-enable-disable.patch
prctl-more-prctlpr_set_mm_-checks.patch
proc-fix-page_size-limit-of-proc-pid-cmdline.patch
maintainers-davidlohr-has-moved.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string.patch
radix-tree-replace-preallocated-node-array-with-linked-list.patch
checkpatch-emit-an-error-when-theres-a-diff-in-a-changelog.patch
init-do_mounts-add-create_dev-failure-log.patch

