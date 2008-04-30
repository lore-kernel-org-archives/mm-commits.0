From: akpm@linux-foundation.org
Subject: - proc-print-more-information-when-removing-non-empty-directories.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:45:40 -0700
Message-ID: <200804300545.m3U5je74029527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757774AbYD3Fqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:46:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     proc: print more information when removing non-empty directories
has been removed from the -mm tree.  Its filename was
     proc-print-more-information-when-removing-non-empty-directories.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: print more information when removing non-empty directories
From: Alexey Dobriyan <adobriyan@sw.ru>

This usually saves one recompile to insert similar printk like below. :)

Sample nastygram:

remove_proc_entry: removing non-empty directory '/proc/foo', leaking at least 'bar'
------------[ cut here ]------------
WARNING: at fs/proc/generic.c:776 remove_proc_entry+0x18a/0x200()
Modules linked in: foo(-) container fan battery dock sbs ac sbshc backlight ipv6 loop af_packet amd_rng sr_mod i2c_amd8111 i2c_amd756 cdrom i2c_core button thermal processor
Pid: 3034, comm: rmmod Tainted: G   M     2.6.25-rc1 #5

Call Trace:
 [<ffffffff80231974>] warn_on_slowpath+0x64/0x90
 [<ffffffff80232a6e>] printk+0x4e/0x60
 [<ffffffff802d6c8a>] remove_proc_entry+0x18a/0x200
 [<ffffffff8045cd88>] mutex_lock_nested+0x1c8/0x2d0
 [<ffffffff8025f0f0>] __try_stop_module+0x0/0x40
 [<ffffffff8025effd>] sys_delete_module+0x14d/0x200
 [<ffffffff8045df3d>] lockdep_sys_exit_thunk+0x35/0x67
 [<ffffffff8031c307>] __up_read+0x27/0xa0
 [<ffffffff8045decc>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020b6ab>] system_call_after_swapgs+0x7b/0x80

---[ end trace 10ef850597e89c54 ]---

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/proc/generic.c~proc-print-more-information-when-removing-non-empty-directories fs/proc/generic.c
--- a/fs/proc/generic.c~proc-print-more-information-when-removing-non-empty-directories
+++ a/fs/proc/generic.c
@@ -777,7 +777,12 @@ continue_removing:
 		if (S_ISDIR(de->mode))
 			parent->nlink--;
 		de->nlink = 0;
-		WARN_ON(de->subdir);
+		if (de->subdir) {
+			printk(KERN_WARNING "%s: removing non-empty directory "
+			       "'%s/%s', leaking at least '%s'\n", __func__,
+			       de->parent->name, de->name, de->subdir->name);
+			WARN_ON(1);
+		}
 		if (atomic_dec_and_test(&de->count))
 			free_proc_entry(de);
 		break;
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
single_open-seq_release-leak-diagnostics.patch

