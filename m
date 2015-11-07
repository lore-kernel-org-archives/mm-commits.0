From: akpm@linux-foundation.org
Subject: [folded-merged]
 panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch removed from -mm tree
Date: Fri, 06 Nov 2015 16:16:55 -0800
Message-ID: <563d42f7.4y/4l7I7QeglagzJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862AbbKGAQ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 19:16:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, d.hatayama@jp.fujitsu.com, jack@suse.cz, jkosina@suse.cz, kys@microsoft.com, masami.hiramatsu.pt@hitachi.com, prarit@redhat.com, sjenning@redhat.com, vkuznets@redhat.com, xiexiuqi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix
has been removed from the -mm tree.  Its filename was
     panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch

This patch was dropped because it was folded into panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix

tweak comment text

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xie XiuQi <xiexiuqi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/panic.c~panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix kernel/panic.c
--- a/kernel/panic.c~panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix
+++ a/kernel/panic.c
@@ -149,10 +149,10 @@ void panic(const char *fmt, ...)
 	bust_spinlocks(0);
 
 	/*
-	 * We may have ended up killing the CPU holding the lock and still have
-	 * some valuable data in console buffer. Try to acquire the lock and
-	 * release it regardless of the result. The release will also print the
-	 * buffers out.
+	 * We may have ended up stopping the CPU holding the lock (in
+	 * smp_send_stop()) while still having some valuable data in the console
+	 * buffer.  Try to acquire the lock then release it regardless of the
+	 * result.  The release will also print the buffers out.
 	 */
 	console_trylock();
 	console_unlock();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-mmzoneh-reflow-comment.patch
mm-memcontrolc-uninline-mem_cgroup_usage.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out.patch

