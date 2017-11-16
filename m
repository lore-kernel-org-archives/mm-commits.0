From: akpm@linux-foundation.org
Subject: [patch 070/131] kmemleak: change
 /sys/kernel/debug/kmemleak permissions from 0444 to 0644
Date: Wed, 15 Nov 2017 17:35:30 -0800
Message-ID: <20171116013530.5GUIflORo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39618 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933032AbdKPBfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:35:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, catalin.marinas@arm.com, khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
