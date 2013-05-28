From: akpm@linux-foundation.org
Subject: +
 mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done.patch
 added to -mm tree
Date: Tue, 28 May 2013 13:30:22 -0700
Message-ID: <51a513de.pEo8fG3qC17OpgIo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3E1UaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 16:30:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, viro@zeniv.linux.org.uk, riel@redhat.com, gang.chen@asianux.com

Subject: + mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done.patch added to -mm tree
To: gang.chen@asianux.com,riel@redhat.com,viro@zeniv.linux.org.uk,walken@google.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 13:30:22 -0700


The patch titled
     Subject: mm/nommu.c: add additional check for vread() just like vwrite() has done
has been added to the -mm tree.  Its filename is
     mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done.patch

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
Subject: mm/nommu.c: add additional check for vread() just like vwrite() has done

vwrite() checks for overflow. vread() should do the same thing.

Since vwrite() checks the source buffer address, vread() should check
the destination buffer address.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/nommu.c~mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done mm/nommu.c
--- a/mm/nommu.c~mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done
+++ a/mm/nommu.c
@@ -282,6 +282,10 @@ EXPORT_SYMBOL(vmalloc_to_pfn);
 
 long vread(char *buf, char *addr, unsigned long count)
 {
+	/* Don't allow overflow */
+	if ((unsigned long) buf + count < count)
+		count = -(unsigned long) buf;
+
 	memcpy(buf, addr, count);
 	return count;
 }
_

Patches currently in -mm which might be from gang.chen@asianux.com are

linux-next.patch
kernel-audit_treec-audit_add_tree_rule-protect-rule-from-kill_rules.patch
kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data.patch
mm-nommuc-add-additional-check-for-vread-just-like-vwrite-has-done.patch

