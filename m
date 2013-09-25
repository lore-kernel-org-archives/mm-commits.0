From: akpm@linux-foundation.org
Subject: [merged] audit-fix-endless-wait-in-audit_log_start.patch removed
 from -mm tree
Date: Wed, 25 Sep 2013 12:06:12 -0700
Message-ID: <52433424.ELIeghj1F8NITDZK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48651 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3IYTGN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 15:06:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgb@redhat.com, lcapitulino@redhat.com, eparis@redhat.com, dave.kleikamp@oracle.com, dan.duval@oracle.com, chuck.anderson@oracle.com, khlebnikov@openvz.org

Subject: [merged] audit-fix-endless-wait-in-audit_log_start.patch removed from -mm tree
To: khlebnikov@openvz.org,chuck.anderson@oracle.com,dan.duval@oracle.com,dave.kleikamp@oracle.com,eparis@redhat.com,lcapitulino@redhat.com,rgb@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 12:06:12 -0700


The patch titled
     Subject: audit: fix endless wait in audit_log_start()
has been removed from the -mm tree.  Its filename was
     audit-fix-endless-wait-in-audit_log_start.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: audit: fix endless wait in audit_log_start()

After 829199197a43 ("kernel/audit.c: avoid negative sleep durations")
audit emitters will block forever if userspace daemon cannot handle
backlog.  After the timeout waiting loop turns into busy loop and runs
until daemon dies or returns back to work.  This is a minimal patch for
that bug.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Chuck Anderson <chuck.anderson@oracle.com>
Cc: Dan Duval <dan.duval@oracle.com>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/audit.c~audit-fix-endless-wait-in-audit_log_start kernel/audit.c
--- a/kernel/audit.c~audit-fix-endless-wait-in-audit_log_start
+++ a/kernel/audit.c
@@ -1117,9 +1117,10 @@ struct audit_buffer *audit_log_start(str
 
 			sleep_time = timeout_start + audit_backlog_wait_time -
 					jiffies;
-			if ((long)sleep_time > 0)
+			if ((long)sleep_time > 0) {
 				wait_for_auditd(sleep_time);
-			continue;
+				continue;
+			}
 		}
 		if (audit_rate_check() && printk_ratelimit())
 			printk(KERN_WARNING
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch

