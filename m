From: akpm@linux-foundation.org
Subject: [merged] sysctlc-remove-unused-variable.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:26 -0700
Message-ID: <200906182247.n5IMlQGV006498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755994AbZFRW64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukanto.cse.iitb@gmail.com, jaswinder@kernel.org, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     sysctl.c: remove unused variable
has been removed from the -mm tree.  Its filename was
     sysctlc-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysctl.c: remove unused variable
From: Sukanto Ghosh <sukanto.cse.iitb@gmail.com>

Remoce the unused variable 'val' from __do_proc_dointvec()

The integer has been declared and used as 'val = -val' and there is no
reference to it anywhere.

Signed-off-by: Sukanto Ghosh <sukanto.cse.iitb@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Sukanto Ghosh <sukanto.cse.iitb@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN kernel/sysctl.c~sysctlc-remove-unused-variable kernel/sysctl.c
--- a/kernel/sysctl.c~sysctlc-remove-unused-variable
+++ a/kernel/sysctl.c
@@ -2283,7 +2283,7 @@ static int __do_proc_dointvec(void *tbl_
 		  void *data)
 {
 #define TMPBUFLEN 21
-	int *i, vleft, first=1, neg, val;
+	int *i, vleft, first = 1, neg;
 	unsigned long lval;
 	size_t left, len;
 	
@@ -2336,8 +2336,6 @@ static int __do_proc_dointvec(void *tbl_
 			len = p-buf;
 			if ((len < left) && *p && !isspace(*p))
 				break;
-			if (neg)
-				val = -val;
 			s += len;
 			left -= len;
 
_

Patches currently in -mm which might be from sukanto.cse.iitb@gmail.com are

origin.patch

