From: akpm@linux-foundation.org
Subject: + proc-sysctl-fix-the-int-overflow-for-jiffies-conversion.patch
 added to -mm tree
Date: Wed, 29 Mar 2017 16:07:21 -0700
Message-ID: <58dc3e29.zoxX70tDjpW3z5L/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40266 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932911AbdC2XHX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 19:07:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fgao@ikuai8.com, acme@redhat.com, adobriyan@gmail.com, edumazet@google.com, jpoimboe@redhat.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: proc/sysctl: fix the int overflow for jiffies conversion
has been added to the -mm tree.  Its filename is
     proc-sysctl-fix-the-int-overflow-for-jiffies-conversion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-sysctl-fix-the-int-overflow-for-jiffies-conversion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-sysctl-fix-the-int-overflow-for-jiffies-conversion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2571,7 +2571,7 @@ static int do_proc_dointvec_jiffies_conv
 					 int write, void *data)
 {
 	if (write) {
-		if (*lvalp > LONG_MAX / HZ)
+		if (*lvalp > INT_MAX / HZ)
 			return 1;
 		*valp = *negp ? -(*lvalp*HZ) : (*lvalp*HZ);
 	} else {
_

Patches currently in -mm which might be from fgao@ikuai8.com are

proc-sysctl-fix-the-int-overflow-for-jiffies-conversion.patch

