From: akpm@linux-foundation.org
Subject: + proc-fix-kflags-to-uflags-copying-in-proc-kpageflags.patch added to -mm tree
Date: Tue, 10 Mar 2009 18:43:09 -0700
Message-ID: <200903110143.n2B1h94k030126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753514AbZCKBqV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 21:46:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com, mpm@selenic.com, stable@kernel.org


The patch titled
     proc: fix kflags to uflags copying in /proc/kpageflags
has been added to the -mm tree.  Its filename is
     proc-fix-kflags-to-uflags-copying-in-proc-kpageflags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

proc-fix-kflags-to-uflags-copying-in-proc-kpageflags.patch
linux-next.patch

