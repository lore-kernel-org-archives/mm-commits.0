From: akpm@linux-foundation.org
Subject: +
 kmemleak-change-sys-kernel-debug-kmemleak-permissions-from-0444-to-0644.patch added to -mm tree
Date: Tue, 10 Oct 2017 15:16:17 -0700
Message-ID: <59dd46b1.UHwu9AnpVZp5I2km%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36296 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751415AbdJJWQS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 18:16:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@yandex-team.ru, catalin.marinas@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemleak: change /sys/kernel/debug/kmemleak permissions from 0444 to 0644
has been added to the -mm tree.  Its filename is
     kmemleak-change-sys-kernel-debug-kmemleak-permissions-from-0444-to-0644.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmemleak-change-sys-kernel-debug-kmemleak-permissions-from-0444-to-0644.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmemleak-change-sys-kernel-debug-kmemleak-permissions-from-0444-to-0644.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kmemleak-change-sys-kernel-debug-kmemleak-permissions-from-0444-to-0644.patch

