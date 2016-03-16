From: akpm@linux-foundation.org
Subject: [merged]
 autofs4-fix-coding-style-problem-in-autofs4_get_set_timeout.patch removed
 from -mm tree
Date: Wed, 16 Mar 2016 12:57:49 -0700
Message-ID: <56e9babd.GTNGeBjzVKywHdDK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130AbcCPT5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: fix coding style problem in autofs4_get_set_timeout()
has been removed from the -mm tree.  Its filename was
     autofs4-fix-coding-style-problem-in-autofs4_get_set_timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs4: fix coding style problem in autofs4_get_set_timeout()

Refactor autofs4_get_set_timeout() to eliminate coding style error.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-fix-coding-style-problem-in-autofs4_get_set_timeout fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-fix-coding-style-problem-in-autofs4_get_set_timeout
+++ a/fs/autofs4/root.c
@@ -774,12 +774,16 @@ static int autofs4_dir_mkdir(struct inod
 static inline int autofs4_compat_get_set_timeout(struct autofs_sb_info *sbi,
 						 compat_ulong_t __user *p)
 {
-	int rv;
 	unsigned long ntimeout;
+	int rv;
 
-	if ((rv = get_user(ntimeout, p)) ||
-	     (rv = put_user(sbi->exp_timeout/HZ, p)))
-		return rv;
+	rv = get_user(ntimeout, p);
+	if (rv)
+		goto error;
+
+	rv = put_user(sbi->exp_timeout/HZ, p);
+	if (rv)
+		goto error;
 
 	if (ntimeout > UINT_MAX/HZ)
 		sbi->exp_timeout = 0;
@@ -787,18 +791,24 @@ static inline int autofs4_compat_get_set
 		sbi->exp_timeout = ntimeout * HZ;
 
 	return 0;
+error:
+	return rv;
 }
 #endif
 
 static inline int autofs4_get_set_timeout(struct autofs_sb_info *sbi,
 					  unsigned long __user *p)
 {
-	int rv;
 	unsigned long ntimeout;
+	int rv;
 
-	if ((rv = get_user(ntimeout, p)) ||
-	     (rv = put_user(sbi->exp_timeout/HZ, p)))
-		return rv;
+	rv = get_user(ntimeout, p);
+	if (rv)
+		goto error;
+
+	rv = put_user(sbi->exp_timeout/HZ, p);
+	if (rv)
+		goto error;
 
 	if (ntimeout > ULONG_MAX/HZ)
 		sbi->exp_timeout = 0;
@@ -806,6 +816,8 @@ static inline int autofs4_get_set_timeou
 		sbi->exp_timeout = ntimeout * HZ;
 
 	return 0;
+error:
+	return rv;
 }
 
 /* Return protocol version */
_

Patches currently in -mm which might be from raven@themaw.net are


