From: akpm@linux-foundation.org
Subject: [folded-merged] proc-add-kpageidle-file-fix-4.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 15:05:52 -0700
Message-ID: <55f0ad40.wxrDUa6kT4LVw0PK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbbIIWFx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:05:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, fengguang.wu@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-add-kpageidle-file-fix-4
has been removed from the -mm tree.  Its filename was
     proc-add-kpageidle-file-fix-4.patch

This patch was dropped because it was folded into proc-add-kpageidle-file.patch

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: proc-add-kpageidle-file-fix-4

Not all architectures support 8-byte get_user.

Fixes: proc-add-kpageidle-file
Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/page.c~proc-add-kpageidle-file-fix-4 fs/proc/page.c
--- a/fs/proc/page.c~proc-add-kpageidle-file-fix-4
+++ a/fs/proc/page.c
@@ -454,7 +454,7 @@ static ssize_t kpageidle_write(struct fi
 	for (; pfn < end_pfn; pfn++) {
 		bit = pfn % KPMBITS;
 		if (bit == 0) {
-			if (get_user(idle_bitmap, in)) {
+			if (copy_from_user(&idle_bitmap, in, sizeof(u64))) {
 				ret = -EFAULT;
 				break;
 			}
_

Patches currently in -mm which might be from vdavydov@parallels.com are

memcg-add-page_cgroup_ino-helper.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
proc-add-kpageidle-file.patch
proc-add-kpageidle-file-fix-5.patch
proc-add-kpageidle-file-fix-6.patch
proc-add-kpageidle-file-fix-6-fix-2.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch

