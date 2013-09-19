From: akpm@linux-foundation.org
Subject: + audit-fix-endless-wait-in-audit_log_start.patch added to -mm
 tree
Date: Thu, 19 Sep 2013 13:58:19 -0700
Message-ID: <523b656b.2hPLKNne88KMl26G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3ISU6U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 16:58:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgb@redhat.com, lcapitulino@redhat.com, eparis@redhat.com, dave.kleikamp@oracle.com, dan.duval@oracle.com, chuck.anderson@oracle.com, khlebnikov@openvz.org

Subject: + audit-fix-endless-wait-in-audit_log_start.patch added to -mm tree
To: khlebnikov@openvz.org,chuck.anderson@oracle.com,dan.duval@oracle.com,dave.kleikamp@oracle.com,eparis@redhat.com,lcapitulino@redhat.com,rgb@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 13:58:19 -0700


The patch titled
     Subject: audit: fix endless wait in audit_log_start()
has been added to the -mm tree.  Its filename is
     audit-fix-endless-wait-in-audit_log_start.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/audit-fix-endless-wait-in-audit_log_start.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/audit-fix-endless-wait-in-audit_log_start.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
audit-fix-endless-wait-in-audit_log_start.patch
drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch

