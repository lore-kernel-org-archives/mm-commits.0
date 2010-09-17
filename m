From: akpm@linux-foundation.org
Subject: + audit-add-support-to-match-lsm-labels-on-user-audit-messages.patch added to -mm tree
Date: Fri, 17 Sep 2010 13:52:50 -0700
Message-ID: <201009172052.o8HKqoGJ009474@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937Ab0IQUxD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Sep 2010 16:53:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mitr@redhat.com, eparis@redhat.com, viro@zeniv.linux.org.uk


The patch titled
     audit: add support to match lsm labels on user audit messages
has been added to the -mm tree.  Its filename is
     audit-add-support-to-match-lsm-labels-on-user-audit-messages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: audit: add support to match lsm labels on user audit messages
From: Miloslav Trmac <mitr@redhat.com>

Add support for matching by security label (e.g.  SELinux context) of the
sender of an user-space audit record.

The audit filter code already allows user space to configure such filters,
but they were ignored during evaluation.  This patch implements evaluation
of these filters.

For example, after application of this patch, PAM authentication logs
caused by cron can be disabled using
	auditctl -a user,never -F subj_type=crond_t

Signed-off-by: Miloslav Trmac <mitr@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditfilter.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN kernel/auditfilter.c~audit-add-support-to-match-lsm-labels-on-user-audit-messages kernel/auditfilter.c
--- a/kernel/auditfilter.c~audit-add-support-to-match-lsm-labels-on-user-audit-messages
+++ a/kernel/auditfilter.c
@@ -1252,6 +1252,18 @@ static int audit_filter_user_rules(struc
 		case AUDIT_LOGINUID:
 			result = audit_comparator(cb->loginuid, f->op, f->val);
 			break;
+		case AUDIT_SUBJ_USER:
+		case AUDIT_SUBJ_ROLE:
+		case AUDIT_SUBJ_TYPE:
+		case AUDIT_SUBJ_SEN:
+		case AUDIT_SUBJ_CLR:
+			if (f->lsm_rule)
+				result = security_audit_rule_match(cb->sid,
+								   f->type,
+								   f->op,
+								   f->lsm_rule,
+								   NULL);
+			break;
 		}
 
 		if (!result)
_

Patches currently in -mm which might be from mitr@redhat.com are

audit-add-support-to-match-lsm-labels-on-user-audit-messages.patch

