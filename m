From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?kmemleak-change-sys-kernel-debug-kmemleak-permissions-fro?=
 =?US-ASCII?Q?m-0444-to-0644.patch?= removed from -mm tree
Date: Thu, 16 Nov 2017 12:02:16 -0800
Message-ID: <20171116200216.UqtcpBLxb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46632 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbdKPUCR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:02:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: change /sys/kernel/debug/kmemleak permissions from 0444 to 0644
has been removed from the -mm tree.  Its filename was
     kmemleak-change-sys-kernel-debug-kmemleak-permissions-from-0444-to-0644.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: kmemleak: change /sys/kernel/debug/kmemleak permissions from 0444 to 0644

Kmemleak can be tweaked at runtime by writing commands into debugfs file. 
Root can use it anyway, but without the write-bit this interface isn't
obvious.

Link: http://lkml.kernel.org/r/150728996582.744328.11541332857988399411.stgit@buzz
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kmemleak.c~kmemleak-change-sys-kernel-debug-kmemleak-permissions-from-0444-to-0644 mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-change-sys-kernel-debug-kmemleak-permissions-from-0444-to-0644
+++ a/mm/kmemleak.c
@@ -2104,7 +2104,7 @@ static int __init kmemleak_late_init(voi
 		return -ENOMEM;
 	}
 
-	dentry = debugfs_create_file("kmemleak", S_IRUGO, NULL, NULL,
+	dentry = debugfs_create_file("kmemleak", 0644, NULL, NULL,
 				     &kmemleak_fops);
 	if (!dentry)
 		pr_warn("Failed to create the debugfs kmemleak file\n");
_

Patches currently in -mm which might be from khlebnikov@yandex-team.ru are

proc-do-not-show-vmexe-bigger-than-total-executable-virtual-memory.patch

