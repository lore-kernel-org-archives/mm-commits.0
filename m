From: akpm@linux-foundation.org
Subject: [merged] printk-remove-duplicated-check-for-log-level.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:32:46 -0700
Message-ID: <533f08de.iU+2TqfJPsFsxDDm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaDDTcr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, mhocko@suse.cz, kay@vrfy.org, jack@suse.cz, fweisbec@gmail.com, pmladek@suse.cz

Subject: [merged] printk-remove-duplicated-check-for-log-level.patch removed from -mm tree
To: pmladek@suse.cz,fweisbec@gmail.com,jack@suse.cz,kay@vrfy.org,mhocko@suse.cz,rostedt@goodmis.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:46 -0700


The patch titled
     Subject: printk: remove duplicated check for log level
has been removed from the -mm tree.  Its filename was
     printk-remove-duplicated-check-for-log-level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Petr Mladek <pmladek@suse.cz>
Subject: printk: remove duplicated check for log level

The check for the exact log level is already done in printk_get_level.  We
do not need to duplicate it in printk_skip_level.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN include/linux/printk.h~printk-remove-duplicated-check-for-log-level include/linux/printk.h
--- a/include/linux/printk.h~printk-remove-duplicated-check-for-log-level
+++ a/include/linux/printk.h
@@ -24,13 +24,9 @@ static inline int printk_get_level(const
 
 static inline const char *printk_skip_level(const char *buffer)
 {
-	if (printk_get_level(buffer)) {
-		switch (buffer[1]) {
-		case '0' ... '7':
-		case 'd':	/* KERN_DEFAULT */
-			return buffer + 2;
-		}
-	}
+	if (printk_get_level(buffer))
+		return buffer + 2;
+
 	return buffer;
 }
 
_

Patches currently in -mm which might be from pmladek@suse.cz are

origin.patch
linux-next.patch

