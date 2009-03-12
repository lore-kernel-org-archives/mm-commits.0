From: akpm@linux-foundation.org
Subject: [merged] proc-fix-kflags-to-uflags-copying-in-proc-kpageflags.patch removed from -mm tree
Date: Thu, 12 Mar 2009 13:16:37 -0700
Message-ID: <200903122016.n2CKGb5F032560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750860AbZCLUfT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 16:35:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     proc: fix kflags to uflags copying in /proc/kpageflags
has been removed from the -mm tree.  Its filename was
     proc-fix-kflags-to-uflags-copying-in-proc-kpageflags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: fix kflags to uflags copying in /proc/kpageflags
From: Wu Fengguang <fengguang.wu@intel.com>

Fix kpf_copy_bit(src,dst) to be kpf_copy_bit(dst,src) to match the actual
call patterns, e.g.  kpf_copy_bit(kflags, KPF_LOCKED, PG_locked).

This misplacement of src/dst only affected reporting of PG_writeback,
PG_reclaim and PG_buddy.  For others kflags==uflags so not affected.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/page.c~proc-fix-kflags-to-uflags-copying-in-proc-kpageflags fs/proc/page.c
--- a/fs/proc/page.c~proc-fix-kflags-to-uflags-copying-in-proc-kpageflags
+++ a/fs/proc/page.c
@@ -80,7 +80,7 @@ static const struct file_operations proc
 #define KPF_RECLAIM    9
 #define KPF_BUDDY     10
 
-#define kpf_copy_bit(flags, srcpos, dstpos) (((flags >> srcpos) & 1) << dstpos)
+#define kpf_copy_bit(flags, dstpos, srcpos) (((flags >> srcpos) & 1) << dstpos)
 
 static ssize_t kpageflags_read(struct file *file, char __user *buf,
 			     size_t count, loff_t *ppos)
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
linux-next.patch
ramfs-add-support-for-mode=-mount-option.patch

