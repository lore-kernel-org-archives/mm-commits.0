From: akpm@linux-foundation.org
Subject: + wrong-timeout-value-in-sk_wait_data-v2.patch added to -mm tree
Date: Thu, 24 May 2007 15:27:46 -0700
Message-ID: <200705242227.l4OMRkPv004894@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:59066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752985AbXEXWdp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 May 2007 18:33:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vvs@sw.ru, davem@davemloft.net


The patch titled
     "wrong timeout value" in sk_wait_data()
has been added to the -mm tree.  Its filename is
     wrong-timeout-value-in-sk_wait_data-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: "wrong timeout value" in sk_wait_data()
From: Vasily Averin <vvs@sw.ru>

sys_setsockopt() do not check properly timeout values for
SO_RCVTIMEO/SO_SNDTIMEO, for example it's possible to set negative timeout
values.  POSIX do not defines behaviour for sys_setsockopt in case negative
timeouts, but requires that setsockopt() shall fail with -EDOM if the send
and receive timeout values are too big to fit into the timeout fields in
the socket structure.

In current implementation negative timeout can lead to error messages like
"schedule_timeout: wrong timeout value".

Proposed patch:

- checks tv_usec and returns -EDOM if it is wrong

- do not allows to set negative timeout values (sets 0 instead) and
  outputs ratelimited information message about such attempts.

Signed-off-by: Vasily Averin <vvs@sw.ru>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/sock.c |   12 ++++++++++++
 1 files changed, 12 insertions(+)

diff -puN net/core/sock.c~wrong-timeout-value-in-sk_wait_data-v2 net/core/sock.c
--- a/net/core/sock.c~wrong-timeout-value-in-sk_wait_data-v2
+++ a/net/core/sock.c
@@ -206,7 +206,19 @@ static int sock_set_timeout(long *timeo_
 		return -EINVAL;
 	if (copy_from_user(&tv, optval, sizeof(tv)))
 		return -EFAULT;
+	if (tv.tv_usec < 0 || tv.tv_usec >= USEC_PER_SEC)
+		return -EDOM;
 
+	if (tv.tv_sec < 0) {
+		static int warned = 0;
+		*timeo_p = 0;
+		if (warned < 10 && net_ratelimit())
+			warned++;
+			printk(KERN_INFO "sock_set_timeout: `%s' (pid %d) "
+			       "tries to set negative timeout\n",
+			        current->comm, current->pid);
+		return 0;
+	}
 	*timeo_p = MAX_SCHEDULE_TIMEOUT;
 	if (tv.tv_sec == 0 && tv.tv_usec == 0)
 		return 0;
_

Patches currently in -mm which might be from vvs@sw.ru are

wrong-timeout-value-in-sk_wait_data-v2.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
i2o_cfg_passthru-cleanup.patch
i2o_cfg_passthru-cleanup-fix.patch
wrong-memory-access-in-i2o_block_device_lock.patch
i2o-message-leak-in-i2o_msg_post_wait_mem.patch
i2o-proc-reading-oops.patch
i2o-debug-output-cleanup.patch
