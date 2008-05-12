From: akpm@linux-foundation.org
Subject: + shrink-struct-pid-by-removing-padding-on-64-bit-builds.patch added to -mm tree
Date: Mon, 12 May 2008 16:20:40 -0700
Message-ID: <200805122320.m4CNKesM014264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371AbYELXVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 19:21:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, ebiederm@xmission.com


The patch titled
     shrink struct pid by removing padding on 64 bit builds
has been added to the -mm tree.  Its filename is
     shrink-struct-pid-by-removing-padding-on-64-bit-builds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: shrink struct pid by removing padding on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

When struct pid is built on a 64 bit platform gcc has to insert padding to
maintain the correct alignment, by simply reordering its members the
memory usage shrinks from 88 bytes to 80.

I've successfully run with this patch on my desktop AMD64 machine.

There are no significant kernel size changes to a default config.X86_64
on the latest git v2.6.26-rc1

   text    data     bss     dec     hex filename
5404828  976760  734280 7115868  6c945c vmlinux
5404811  976760  734280 7115851  6c944b vmlinux.pid-patch

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/pid.h~shrink-struct-pid-by-removing-padding-on-64-bit-builds include/linux/pid.h
--- a/include/linux/pid.h~shrink-struct-pid-by-removing-padding-on-64-bit-builds
+++ a/include/linux/pid.h
@@ -57,10 +57,10 @@ struct upid {
 struct pid
 {
 	atomic_t count;
+	unsigned int level;
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
 	struct rcu_head rcu;
-	unsigned int level;
 	struct upid numbers[1];
 };
 
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

shrink-struct-pid-by-removing-padding-on-64-bit-builds.patch

