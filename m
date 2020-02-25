From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?ocfs2-add-missing-annotations-for-ocfs2=5Frefcount=5Fcach?=
 =?US-ASCII?Q?e=5Flock-and-ocfs2=5Frefcount=5Fcache=5Funlock.patch?= added
 to -mm tree
Date: Mon, 24 Feb 2020 18:36:37 -0800
Message-ID: <20200225023637.BUM79kVmU%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728523AbgBYCgi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Feb 2020 21:36:38 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, jbi.octave@gmail.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: Add missing annotations for ocfs2_refcount_cache_lock() and ocfs2_refcount_cache_unlock()
has been added to the -mm tree.  Its filename is
     ocfs2-add-missing-annotations-for-ocfs2_refcount_cache_lock-and-ocfs2_refcount_cache_unlock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-add-missing-annotations-for-ocfs2_refcount_cache_lock-and-ocfs2_refcount_cache_unlock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-add-missing-annotations-for-ocfs2_refcount_cache_lock-and-ocfs2_refcount_cache_unlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: ocfs2: Add missing annotations for ocfs2_refcount_cache_lock() and ocfs2_refcount_cache_unlock()

Sparse reports warnings at ocfs2_refcount_cache_lock()
	and ocfs2_refcount_cache_unlock()

warning: context imbalance in ocfs2_refcount_cache_lock()
	- wrong count at exit
warning: context imbalance in ocfs2_refcount_cache_unlock()
	- unexpected unlock

The root cause is the missing annotation at ocfs2_refcount_cache_lock()
and at ocfs2_refcount_cache_unlock()

Add the missing __acquires(&rf->rf_lock) annotation to
ocfs2_refcount_cache_lock()

Add the missing __releases(&rf->rf_lock) annotation to
ocfs2_refcount_cache_unlock()

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Link: http://lkml.kernel.org/r/20200224204130.18178-1-jbi.octave@gmail.com
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/refcounttree.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ocfs2/refcounttree.c~ocfs2-add-missing-annotations-for-ocfs2_refcount_cache_lock-and-ocfs2_refcount_cache_unlock
+++ a/fs/ocfs2/refcounttree.c
@@ -154,6 +154,7 @@ ocfs2_refcount_cache_get_super(struct oc
 }
 
 static void ocfs2_refcount_cache_lock(struct ocfs2_caching_info *ci)
+__acquires(&rf->rf_lock)
 {
 	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
 
@@ -161,6 +162,7 @@ static void ocfs2_refcount_cache_lock(st
 }
 
 static void ocfs2_refcount_cache_unlock(struct ocfs2_caching_info *ci)
+__releases(&rf->rf_lock)
 {
 	struct ocfs2_refcount_tree *rf = cache_info_to_refcount(ci);
 
_

Patches currently in -mm which might be from jbi.octave@gmail.com are

ocfs2-add-missing-annotations-for-ocfs2_refcount_cache_lock-and-ocfs2_refcount_cache_unlock.patch
