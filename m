From: akpm@linux-foundation.org
Subject: [patch 21/28] kmemleak: add scheduling point to kmemleak_scan()
Date: Wed, 29 Nov 2017 16:11:08 -0800
Message-ID: <5a1f4c9c.QpYu2SBbU5scUdTD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60762 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752959AbdK3ALK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:11:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, xieyisheng1@huawei.com, catalin.marinas@arm.com, mhocko@kernel.org

From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: kmemleak: add scheduling point to kmemleak_scan()

kmemleak_scan() will scan struct page for each node and it can be really
large and resulting in a soft lockup.  We have seen a soft lockup when do
scan while compile kernel:

 [  220.561051] watchdog: BUG: soft lockup - CPU#53 stuck for 22s! [bash:10287]
 [...]
 [  220.753837] Call Trace:
 [  220.756296]  kmemleak_scan+0x21a/0x4c0
 [  220.760034]  kmemleak_write+0x312/0x350
 [  220.763866]  ? do_wp_page+0x147/0x4c0
 [  220.767521]  full_proxy_write+0x5a/0xa0
 [  220.771351]  __vfs_write+0x33/0x150
 [  220.774833]  ? __inode_security_revalidate+0x4c/0x60
 [  220.779782]  ? selinux_file_permission+0xda/0x130
 [  220.784479]  ? _cond_resched+0x15/0x30
 [  220.788221]  vfs_write+0xad/0x1a0
 [  220.791529]  SyS_write+0x52/0xc0
 [  220.794758]  do_syscall_64+0x61/0x1a0
 [  220.798411]  entry_SYSCALL64_slow_path+0x25/0x25

Fix this by adding cond_resched every MAX_SCAN_SIZE.

Link: http://lkml.kernel.org/r/1511439788-20099-1-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/kmemleak.c~kmemleak-add-scheduling-point-to-kmemleak_scan mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-add-scheduling-point-to-kmemleak_scan
+++ a/mm/kmemleak.c
@@ -1523,6 +1523,8 @@ static void kmemleak_scan(void)
 			if (page_count(page) == 0)
 				continue;
 			scan_block(page, page + 1, NULL);
+			if (!(pfn % (MAX_SCAN_SIZE / sizeof(*page))))
+				cond_resched();
 		}
 	}
 	put_online_mems();
_
