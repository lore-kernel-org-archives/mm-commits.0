From: akpm@linux-foundation.org
Subject: [obsolete] cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch removed from -mm tree
Date: Wed, 14 Dec 2011 12:06:39 -0800
Message-ID: <20111214200640.16A241E005A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:55233 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758047Ab1LNUGl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2011 15:06:41 -0500
Received: by mail-yw0-f74.google.com with SMTP id j51so241097yhj.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Dec 2011 12:06:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, adityakali@google.com, hannes@cmpxchg.org, htejun@gmail.com, kay.sievers@vrfy.org, kirill@shutemov.name, lizf@cn.fujitsu.com, oleg@redhat.com, paul@paulmenage.org, thockin@hockin.org, mm-commits@vger.kernel.org


The patch titled
     Subject: cgroups: pull up res counter charge failure interpretation to caller
has been removed from the -mm tree.  Its filename was
     cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: cgroups: pull up res counter charge failure interpretation to caller

res_counter_charge() always returns -ENOMEM when the limit is reached and
the charge thus can't happen.

However it's up to the caller to interpret this failure and return the
appropriate error value.  The task counter subsystem will need to report
the user that a fork() has been cancelled because of some limit reached,
not because we are too short on memory.

Fix this by returning -1 when res_counter_charge() fails.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <htejun@gmail.com>
Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/resource_counter.txt |    2 ++
 kernel/res_counter.c                       |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN Documentation/cgroups/resource_counter.txt~cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller Documentation/cgroups/resource_counter.txt
--- a/Documentation/cgroups/resource_counter.txt~cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller
+++ a/Documentation/cgroups/resource_counter.txt
@@ -76,6 +76,8 @@ to work with it.
 	limit_fail_at parameter is set to the particular res_counter element
 	where the charging failed.
 
+	It returns 0 on success and -1 on failure.
+
  d. int res_counter_charge_locked
 			(struct res_counter *rc, unsigned long val)
 
diff -puN kernel/res_counter.c~cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller kernel/res_counter.c
--- a/kernel/res_counter.c~cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller
+++ a/kernel/res_counter.c
@@ -26,7 +26,7 @@ int res_counter_charge_locked(struct res
 {
 	if (counter->usage + val > counter->limit) {
 		counter->failcnt++;
-		return -ENOMEM;
+		return -1;
 	}
 
 	counter->usage += val;
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
reiserfs-delay-reiserfs-lock-until-journal-initialization.patch
reiserfs-dont-lock-journal_init.patch
reiserfs-dont-lock-root-inode-searching.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-add-a-task-counter-subsystem.patch
cgroups-add-a-task-counter-subsystem-fix.patch
cgroup-fix-task-counter-common-ancestor-logic.patch
cgroup-fix-task-counter-common-ancestor-logic-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
selftests-new-x86-breakpoints-selftest.patch

