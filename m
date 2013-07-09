From: akpm@linux-foundation.org
Subject: [merged]
 kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:19:06 -0700
Message-ID: <51dc9a6a.QC9P/5rC7Dyv8FUN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3GIXTG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, eparis@redhat.com, gang.chen@asianux.com

Subject: [merged] kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch removed from -mm tree
To: gang.chen@asianux.com,eparis@redhat.com,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:06 -0700


The patch titled
     Subject: kernel/auditfilter.c: fix leak in audit_add_rule() error path
has been removed from the -mm tree.  Its filename was
     kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch
kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch

