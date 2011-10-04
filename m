From: akpm@google.com
Subject: + cgroups-add-res_counter_write_u64-api.patch added to -mm tree
Date: Tue, 04 Oct 2011 15:01:20 -0700
Message-ID: <201110042201.p94M1Kv0026128@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:52681 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab1JDWBp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 18:01:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, htejun@gmail.com, kay.sievers@vrfy.org, kirill@shutemov.name, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org


The patch titled
     Subject: cgroups: add res_counter_write_u64() API
has been added to the -mm tree.  Its filename is
     cgroups-add-res_counter_write_u64-api.patch

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
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: cgroups: add res_counter_write_u64() API

Extend the resource counter API with a mirror of res_counter_read_u64() to
make it handy to update a resource counter value from a cgroup subsystem
u64 value file.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <htejun@gmail.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 include/linux/res_counter.h |    2 ++
 kernel/res_counter.c        |   25 +++++++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff -puN include/linux/res_counter.h~cgroups-add-res_counter_write_u64-api include/linux/res_counter.h
--- a/include/linux/res_counter.h~cgroups-add-res_counter_write_u64-api
+++ a/include/linux/res_counter.h
@@ -82,6 +82,8 @@ int res_counter_memparse_write_strategy(
 int res_counter_write(struct res_counter *counter, int member,
 		      const char *buffer, write_strategy_fn write_strategy);
 
+void res_counter_write_u64(struct res_counter *counter, int member, u64 val);
+
 /*
  * the field descriptors. one for each member of res_counter
  */
diff -puN kernel/res_counter.c~cgroups-add-res_counter_write_u64-api kernel/res_counter.c
--- a/kernel/res_counter.c~cgroups-add-res_counter_write_u64-api
+++ a/kernel/res_counter.c
@@ -168,12 +168,26 @@ int res_counter_memparse_write_strategy(
 	return 0;
 }
 
+void res_counter_write_u64(struct res_counter *counter, int member, u64 val)
+{
+	unsigned long long *target;
+	unsigned long flags;
+
+	/*
+	 * We need the lock to protect against concurrent add/dec on 32 bits.
+	 * No need to ifdef it's seldom used.
+	 */
+	spin_lock_irqsave(&counter->lock, flags);
+	target = res_counter_member(counter, member);
+	*target = val;
+	spin_unlock_irqrestore(&counter->lock, flags);
+}
+
 int res_counter_write(struct res_counter *counter, int member,
 		      const char *buf, write_strategy_fn write_strategy)
 {
 	char *end;
-	unsigned long flags;
-	unsigned long long tmp, *val;
+	unsigned long long tmp;
 
 	if (write_strategy) {
 		if (write_strategy(buf, &tmp))
@@ -183,9 +197,8 @@ int res_counter_write(struct res_counter
 		if (*end != '\0')
 			return -EINVAL;
 	}
-	spin_lock_irqsave(&counter->lock, flags);
-	val = res_counter_member(counter, member);
-	*val = tmp;
-	spin_unlock_irqrestore(&counter->lock, flags);
+
+	res_counter_write_u64(counter, member, tmp);
+
 	return 0;
 }
_
Subject: Subject: cgroups: add res_counter_write_u64() API

Patches currently in -mm which might be from fweisbec@gmail.com are

origin.patch
linux-next.patch
cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch
cgroups-fix-ordering-of-calls-in-cgroup_attach_proc.patch
cgroups-add-res_counter_write_u64-api.patch
cgroups-new-resource-counter-inheritance-api.patch
cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch
cgroups-new-cancel_attach_task-subsystem-callback.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch
cgroups-add-res-counter-common-ancestor-searching.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-add-a-task-counter-subsystem.patch

