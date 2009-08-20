From: akpm@linux-foundation.org
Subject: + cgroups-change-css_set-freeing-mechanism-to-be-under-rcu.patch added to -mm tree
Date: Thu, 20 Aug 2009 14:14:16 -0700
Message-ID: <200908202114.n7KLEHBN026415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754457AbZHTVPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 17:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bblum@google.com, ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com, menage@google.com, oleg@redhat.com, paulmck@us.ibm.com


The patch titled
     cgroups: change css_set freeing mechanism to be under RCU
has been added to the -mm tree.  Its filename is
     cgroups-change-css_set-freeing-mechanism-to-be-under-rcu.patch

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
Subject: cgroups: change css_set freeing mechanism to be under RCU
From: Ben Blum <bblum@google.com>

Changes css_set freeing mechanism to be under RCU

This is a prepatch for making the procs file writable. In order to free the
old css_sets for each task to be moved as they're being moved, the freeing
mechanism must be RCU-protected, or else we would have to have a call to
synchronize_rcu() for each task before freeing its old css_set.

Signed-off-by: Ben Blum <bblum@google.com>
Signed-off-by: Paul Menage <menage@google.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup.h |    3 +++
 kernel/cgroup.c        |    8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff -puN include/linux/cgroup.h~cgroups-change-css_set-freeing-mechanism-to-be-under-rcu include/linux/cgroup.h
--- a/include/linux/cgroup.h~cgroups-change-css_set-freeing-mechanism-to-be-under-rcu
+++ a/include/linux/cgroup.h
@@ -260,6 +260,9 @@ struct css_set {
 	 * during subsystem registration (at boot time).
 	 */
 	struct cgroup_subsys_state *subsys[CGROUP_SUBSYS_COUNT];
+
+	/* For RCU-protected deletion */
+	struct rcu_head rcu_head;
 };
 
 /*
diff -puN kernel/cgroup.c~cgroups-change-css_set-freeing-mechanism-to-be-under-rcu kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-change-css_set-freeing-mechanism-to-be-under-rcu
+++ a/kernel/cgroup.c
@@ -267,6 +267,12 @@ static struct hlist_head *css_set_hash(s
 	return &css_set_table[index];
 }
 
+static void free_css_set_rcu(struct rcu_head *obj)
+{
+	struct css_set *cg = container_of(obj, struct css_set, rcu_head);
+	kfree(cg);
+}
+
 /* We don't maintain the lists running through each css_set to its
  * task until after the first call to cgroup_iter_start(). This
  * reduces the fork()/exit() overhead for people who have cgroups
@@ -310,7 +316,7 @@ static void __put_css_set(struct css_set
 	}
 
 	write_unlock(&css_set_lock);
-	kfree(cg);
+	call_rcu(&cg->rcu_head, free_css_set_rcu);
 }
 
 /*
_

Patches currently in -mm which might be from bblum@google.com are

cgroups-add-a-read-only-procs-file-similar-to-tasks-that-shows-only-unique-tgids.patch
cgroups-ensure-correct-concurrent-opening-reading-of-pidlists-across-pid-namespaces.patch
cgroups-use-vmalloc-for-large-cgroups-pidlist-allocations.patch
cgroups-change-css_set-freeing-mechanism-to-be-under-rcu.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-functionality-to-read-write-lock-clone_thread-forking-per-threadgroup-fix.patch
cgroups-add-ability-to-move-all-threads-in-a-process-to-a-new-cgroup-atomically.patch

