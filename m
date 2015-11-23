From: akpm@linux-foundation.org
Subject: [merged]
 panic-turn-off-locks-debug-before-releasing-console-lock.patch removed from -mm tree
Date: Mon, 23 Nov 2015 12:15:19 -0800
Message-ID: <565373d7.kppfmBBn5PTcV0x6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbbKWUPU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, bhe@redhat.com, d.hatayama@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, jack@suse.cz, jkosina@suse.cz, kys@microsoft.com, masami.hiramatsu.pt@hitachi.com, pmladek@suse.cz, prarit@redhat.com, sjenning@redhat.com, xiexiuqi@huawei.com, ying.huang@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/panic.c: turn off locks debug before releasing console lock
has been removed from the -mm tree.  Its filename was
     panic-turn-off-locks-debug-before-releasing-console-lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: kernel/panic.c: turn off locks debug before releasing console lock

Commit 08d78658f393 ("panic: release stale console lock to always get the
logbuf printed out") introduced an unwanted bad unlock balance report when
panic() is called directly and not from OOPS (e.g.  from out_of_memory()).
The difference is that in case of OOPS we disable locks debug in
oops_enter() and on direct panic call nobody does that.

Fixes: 08d78658f393 ("panic: release stale console lock to always get the logbuf printed out")
Reported-by: kernel test robot <ying.huang@linux.intel.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Baoquan He <bhe@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/panic.c~panic-turn-off-locks-debug-before-releasing-console-lock kernel/panic.c
--- a/kernel/panic.c~panic-turn-off-locks-debug-before-releasing-console-lock
+++ a/kernel/panic.c
@@ -152,8 +152,11 @@ void panic(const char *fmt, ...)
 	 * We may have ended up stopping the CPU holding the lock (in
 	 * smp_send_stop()) while still having some valuable data in the console
 	 * buffer.  Try to acquire the lock then release it regardless of the
-	 * result.  The release will also print the buffers out.
+	 * result.  The release will also print the buffers out.  Locks debug
+	 * should be disabled to avoid reporting bad unlock balance when
+	 * panic() is not being callled from OOPS.
 	 */
+	debug_locks_off();
 	console_trylock();
 	console_unlock();
 
_

Patches currently in -mm which might be from vkuznets@redhat.com are


