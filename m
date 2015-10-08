From: akpm@linux-foundation.org
Subject: + fs-kdev_t-old-new_valid_dev-can-be-boolean.patch added to -mm
 tree
Date: Thu, 08 Oct 2015 14:59:48 -0700
Message-ID: <5616e754.xu2YoQ10l+IpZzqs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452AbbJHV7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2015 17:59:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/kdev_t.h: old/new_valid_dev() can return bool
has been added to the -mm tree.  Its filename is
     fs-kdev_t-old-new_valid_dev-can-be-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-kdev_t-old-new_valid_dev-can-be-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-kdev_t-old-new_valid_dev-can-be-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: include/linux/kdev_t.h: old/new_valid_dev() can return bool

Make old/new_valid_dev return bool due to these two particular functions
only using either one or zero as their return value.

No functional change.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kdev_t.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/kdev_t.h~fs-kdev_t-old-new_valid_dev-can-be-boolean include/linux/kdev_t.h
--- a/include/linux/kdev_t.h~fs-kdev_t-old-new_valid_dev-can-be-boolean
+++ a/include/linux/kdev_t.h
@@ -20,7 +20,7 @@
 	})
 
 /* acceptable for old filesystems */
-static inline int old_valid_dev(dev_t dev)
+static inline bool old_valid_dev(dev_t dev)
 {
 	return MAJOR(dev) < 256 && MINOR(dev) < 256;
 }
@@ -35,7 +35,7 @@ static inline dev_t old_decode_dev(u16 v
 	return MKDEV((val >> 8) & 255, val & 255);
 }
 
-static inline int new_valid_dev(dev_t dev)
+static inline bool new_valid_dev(dev_t dev)
 {
 	return 1;
 }
_

Patches currently in -mm which might be from bywxiaobai@163.com are

kernel-watchdog-is_hardlockup-can-be-boolean.patch
mm-page_alloc-remove-unused-parameter-in-init_currently_empty_zone.patch
mm-vmscan-make-inactive_anon_is_low_global-return-directly.patch
mm-oom_kill-introduce-is_sysrq_oom-helper.patch
mm-compaction-add-an-is_via_compact_memory-helper-function.patch
mm-vmscan-make-inactive_anon-file_is_low-return-bool.patch
mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool.patch
fs-kdev_t-remove-unused-huge_valid_dev-function.patch
fs-kdev_t-old-new_valid_dev-can-be-boolean.patch
fs-vfs-remove-unnecessary-new_valid_dev-check.patch
fs-btrfs-remove-unnecessary-new_valid_dev-check.patch
fs-exofs-remove-unnecessary-new_valid_dev-check.patch
fs-ext2-remove-unnecessary-new_valid_dev-check.patch
fs-ext4-remove-unnecessary-new_valid_dev-check.patch
fs-f2fs-remove-unnecessary-new_valid_dev-check.patch
fs-hpfs-remove-unnecessary-new_valid_dev-check.patch
fs-jfs-remove-unnecessary-new_valid_dev-check.patch
fs-ncpfs-remove-unnecessary-new_valid_dev-check.patch
fs-nfs-remove-unnecessary-new_valid_dev-check.patch
fs-nilfs2-remove-unnecessary-new_valid_dev-check.patch
fs-reiserfs-remove-unnecessary-new_valid_dev-check.patch
fs-stat-remove-unnecessary-new_valid_dev-check.patch
fs-ubifs-remove-unnecessary-new_valid_dev-check.patch

