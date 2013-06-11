From: akpm@linux-foundation.org
Subject: + kernel-pidc-mask-the-flag-out-to-get-the-actual-value.patch
 added to -mm tree
Date: Tue, 11 Jun 2013 15:46:01 -0700
Message-ID: <51b7a8a9.cPo2U0HUMVSBDm+y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab3FKWqC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 18:46:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ebiederm@xmission.com, raphael.scarv@gmail.com

Subject: + kernel-pidc-mask-the-flag-out-to-get-the-actual-value.patch added to -mm tree
To: raphael.scarv@gmail.com,ebiederm@xmission.com
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 15:46:01 -0700


The patch titled
     Subject: kernel/pid.c: mask the flag out to get the actual value
has been added to the -mm tree.  Its filename is
     kernel-pidc-mask-the-flag-out-to-get-the-actual-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Raphael S. Carvalho" <raphael.scarv@gmail.com>
Subject: kernel/pid.c: mask the flag out to get the actual value

This patch shouldn't be applied if those branches must only be taken when
the pid_allocation(PIDNS_HASH_ADDING) flag was turned off.  Otherwise, we
must turn the PIDNS_HASH_ADDING flag (1U << 31) off before getting into
the switch-cases.

Signed-off-by: Raphael S. Carvalho <raphael.scarv@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN kernel/pid.c~kernel-pidc-mask-the-flag-out-to-get-the-actual-value kernel/pid.c
--- a/kernel/pid.c~kernel-pidc-mask-the-flag-out-to-get-the-actual-value
+++ a/kernel/pid.c
@@ -264,7 +264,10 @@ void free_pid(struct pid *pid)
 		struct upid *upid = pid->numbers + i;
 		struct pid_namespace *ns = upid->ns;
 		hlist_del_rcu(&upid->pid_chain);
-		switch(--ns->nr_hashed) {
+
+		/* We must turn the PIDNS_HASH_ADDING flag off to
+		   get the actual value of nr_hashed */
+		switch ((--ns->nr_hashed) & ~(PIDNS_HASH_ADDING)) {
 		case 1:
 			/* When all that is left in the pid namespace
 			 * is the reaper wake up the reaper.  The reaper
_

Patches currently in -mm which might be from raphael.scarv@gmail.com are

kernel-auditfilterc-fixing-build-warning.patch
kernel-pidc-move-statement.patch
kernel-pidc-mask-the-flag-out-to-get-the-actual-value.patch

