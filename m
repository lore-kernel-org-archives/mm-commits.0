From: akpm@linux-foundation.org
Subject: + device_cgroup-dont-grab-mutex-in-rcu-callback.patch added to -mm tree
Date: Thu, 14 Feb 2013 11:49:21 -0800
Message-ID: <20130214194922.6ACA931C11E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:34917 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758666Ab3BNTt0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Feb 2013 14:49:26 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so728105ggn.4
        for <mm-commits@vger.kernel.org>; Thu, 14 Feb 2013 11:49:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jerry.snitselaar@oracle.com, aris@redhat.com, james.l.morris@oracle.com, tj@kernel.org


The patch titled
     Subject: device_cgroup: don't grab mutex in rcu callback
has been added to the -mm tree.  Its filename is
     device_cgroup-dont-grab-mutex-in-rcu-callback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jerry Snitselaar <jerry.snitselaar@oracle.com>
Subject: device_cgroup: don't grab mutex in rcu callback

commit 103a197 ("security/device_cgroup: lock assert fails in
dev_exception_clean()") grabs devcgroup_mutex to fix assert failure, but
mutex can't be grabbed in rcu callback.  Since there shouldn't be any
other references when css_free is called, mutex isn't needed for list
cleanup in devcgroup_css_free().

Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Aristeu Rozanski <aris@redhat.com>
Cc: James Morris <james.l.morris@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/device_cgroup.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN security/device_cgroup.c~device_cgroup-dont-grab-mutex-in-rcu-callback security/device_cgroup.c
--- a/security/device_cgroup.c~device_cgroup-dont-grab-mutex-in-rcu-callback
+++ a/security/device_cgroup.c
@@ -159,6 +159,16 @@ static void dev_exception_rm(struct dev_
 	}
 }
 
+static void __dev_exception_clean(struct dev_cgroup *dev_cgroup)
+{
+	struct dev_exception_item *ex, *tmp;
+
+	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
+		list_del_rcu(&ex->list);
+		kfree_rcu(ex, rcu);
+	}
+}
+
 /**
  * dev_exception_clean - frees all entries of the exception list
  * @dev_cgroup: dev_cgroup with the exception list to be cleaned
@@ -167,14 +177,9 @@ static void dev_exception_rm(struct dev_
  */
 static void dev_exception_clean(struct dev_cgroup *dev_cgroup)
 {
-	struct dev_exception_item *ex, *tmp;
-
 	lockdep_assert_held(&devcgroup_mutex);
 
-	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
-		list_del_rcu(&ex->list);
-		kfree_rcu(ex, rcu);
-	}
+	__dev_exception_clean(dev_cgroup);
 }
 
 /*
@@ -215,9 +220,7 @@ static void devcgroup_css_free(struct cg
 	struct dev_cgroup *dev_cgroup;
 
 	dev_cgroup = cgroup_to_devcgroup(cgroup);
-	mutex_lock(&devcgroup_mutex);
-	dev_exception_clean(dev_cgroup);
-	mutex_unlock(&devcgroup_mutex);
+	__dev_exception_clean(dev_cgroup);
 	kfree(dev_cgroup);
 }
 
_

Patches currently in -mm which might be from jerry.snitselaar@oracle.com are

device_cgroup-dont-grab-mutex-in-rcu-callback.patch

