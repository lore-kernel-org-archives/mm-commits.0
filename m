From: akpm@linux-foundation.org
Subject: + proc-add-kpageidle-file-fix-4.patch added to -mm tree
Date: Mon, 27 Jul 2015 13:40:30 -0700
Message-ID: <55b6973e.VAwOHalZP2RAV1Dd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbbG0Ukb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jul 2015 16:40:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, fengguang.wu@intel.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-add-kpageidle-file-fix-4
has been added to the -mm tree.  Its filename is
     proc-add-kpageidle-file-fix-4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-add-kpageidle-file-fix-4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-add-kpageidle-file-fix-4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

memcg-export-struct-mem_cgroup.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
memcg-get-rid-of-mem_cgroup_root_css-for-config_memcg.patch
memcg-get-rid-of-extern-for-functions-in-memcontrolh.patch
memcg-restructure-mem_cgroup_can_attach.patch
memcg-tcp_kmem-check-for-cg_proto-in-sock_update_memcg.patch
memcg-add-page_cgroup_ino-helper.patch
memcg-add-page_cgroup_ino-helper-fix.patch
hwpoison-use-page_cgroup_ino-for-filtering-by-memcg.patch
memcg-zap-try_get_mem_cgroup_from_page.patch
proc-add-kpagecgroup-file.patch
mmu-notifier-add-clear_young-callback.patch
mmu-notifier-add-clear_young-callback-fix.patch
proc-add-kpageidle-file.patch
proc-add-kpageidle-file-fix.patch
proc-add-kpageidle-file-fix-2.patch
proc-add-kpageidle-file-fix-3.patch
proc-add-kpageidle-file-fix-4.patch
proc-export-idle-flag-via-kpageflags.patch
proc-add-cond_resched-to-proc-kpage-read-write-loop.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-swap-zswap-maybe_preload-refactoring.patch

