From: akpm@linux-foundation.org
Subject: [patch 010/114] proc/sysctl: fix the int overflow for
 jiffies conversion
Date: Mon, 08 May 2017 15:54:58 -0700
Message-ID: <20170508225458.emUQx9hf-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45764 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbdEHWzA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:55:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: acme@redhat.com, adobriyan@gmail.com, akpm@linux-foundation.org, edumazet@google.com, fgao@ikuai8.com, jpoimboe@redhat.com, mingo@kernel.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Gao Feng <fgao@ikuai8.com>
Subject: proc/sysctl: fix the int overflow for jiffies conversion

do_proc_dointvec_jiffies_conv() uses LONG_MAX/HZ as the max value to avoid
overflow.  But actually the *valp is int type, so it still causes
overflow.

For example,
echo 2147483647 > ./sys/net/ipv4/tcp_keepalive_time
Then,
cat ./sys/net/ipv4/tcp_keepalive_time
The output is "-1", it is not expected.

Now use INT_MAX/HZ as the max value instead LONG_MAX/HZ to fix it.

Link: http://lkml.kernel.org/r/1490109532-9228-1-git-send-email-fgao@ikuai8.com
Signed-off-by: Gao Feng <fgao@ikuai8.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl.c~proc-sysctl-fix-the-int-overflow-for-jiffies-conversion kernel/sysctl.c
--- a/kernel/sysctl.c~proc-sysctl-fix-the-int-overflow-for-jiffies-conversion
+++ a/kernel/sysctl.c
@@ -2576,7 +2576,7 @@ static int do_proc_dointvec_jiffies_conv
 					 int write, void *data)
 {
 	if (write) {
-		if (*lvalp > LONG_MAX / HZ)
+		if (*lvalp > INT_MAX / HZ)
 			return 1;
 		*valp = *negp ? -(*lvalp*HZ) : (*lvalp*HZ);
 	} else {
_
