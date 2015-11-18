From: akpm@linux-foundation.org
Subject: + panic-turn-off-locks-debug-before-releasing-console-lock.patch
 added to -mm tree
Date: Wed, 18 Nov 2015 12:45:36 -0800
Message-ID: <564ce370.6UFt/FDU0LryPJV+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951AbbKRUpi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Nov 2015 15:45:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, bhe@redhat.com, d.hatayama@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, jack@suse.cz, jkosina@suse.cz, kys@microsoft.com, masami.hiramatsu.pt@hitachi.com, pmladek@suse.cz, prarit@redhat.com, sjenning@redhat.com, xiexiuqi@huawei.com, ying.huang@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/panic.c: turn off locks debug before releasing console lock
has been added to the -mm tree.  Its filename is
     panic-turn-off-locks-debug-before-releasing-console-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/panic-turn-off-locks-debug-before-releasing-console-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/panic-turn-off-locks-debug-before-releasing-console-lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

panic-turn-off-locks-debug-before-releasing-console-lock.patch

