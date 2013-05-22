From: akpm@linux-foundation.org
Subject: + kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch added to -mm tree
Date: Wed, 22 May 2013 14:19:00 -0700
Message-ID: <519d3644.wAav0qbRVDjDYztp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab3EVVTB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 May 2013 17:19:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, gang.chen@asianux.com

Subject: + kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch added to -mm tree
To: gang.chen@asianux.com,eparis@redhat.com,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 22 May 2013 14:19:00 -0700


The patch titled
     Subject: kernel/auditfilter.c: fix leak in audit_add_rule() error path
has been added to the -mm tree.  Its filename is
     kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: kernel/auditfilter.c: fix leak in audit_add_rule() error path

If both 'tree' and 'watch' are valid we must call audit_put_tree(), just
like the preceding code within audit_add_rule().

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditfilter.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/auditfilter.c~kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path kernel/auditfilter.c
--- a/kernel/auditfilter.c~kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path
+++ a/kernel/auditfilter.c
@@ -865,6 +865,12 @@ static inline int audit_add_rule(struct
 		err = audit_add_watch(&entry->rule, &list);
 		if (err) {
 			mutex_unlock(&audit_filter_mutex);
+			/*
+			 * normally audit_add_tree_rule() will free it
+			 * on failure
+			 */
+			if (tree)
+				audit_put_tree(tree);
 			goto error;
 		}
 	}
_

Patches currently in -mm which might be from gang.chen@asianux.com are

linux-next.patch
kernel-audit_treec-audit_add_tree_rule-protect-rule-from-kill_rules.patch
kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch

