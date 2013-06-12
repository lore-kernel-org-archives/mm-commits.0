From: akpm@linux-foundation.org
Subject: [obsolete]
 kernel-pidc-mask-the-flag-out-to-get-the-actual-value.patch removed from
 -mm tree
Date: Tue, 11 Jun 2013 18:28:18 -0700
Message-ID: <51b7ceb2.wHeVj9aTejgTCB8d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab3FLB2r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 21:28:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ebiederm@xmission.com, raphael.scarv@gmail.com

Subject: [obsolete] kernel-pidc-mask-the-flag-out-to-get-the-actual-value.patch removed from -mm tree
To: raphael.scarv@gmail.com,ebiederm@xmission.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 18:28:16 -0700


The patch titled
     Subject: kernel/pid.c: mask the flag out to get the actual value
has been removed from the -mm tree.  Its filename was
     kernel-pidc-mask-the-flag-out-to-get-the-actual-value.patch

This patch was dropped because it is obsolete

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
kernel-pidc-mask-the-flag-out-to-get-the-actual-value-fix.patch

