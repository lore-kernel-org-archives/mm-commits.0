From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 013/155] ocfs2: add missing annotations for
 ocfs2_refcount_cache_lock() and ocfs2_refcount_cache_unlock()
Date: Wed, 01 Apr 2020 21:03:45 -0700
Message-ID: <20200402040345.PmK1G7_Tv%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEDq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:03:46 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gechangwei@live.cn, ghe@suse.com, jbi.octave@gmail.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com, linux-mm@kvack.org, mark@fasheh.com, mm-commits@vger.kernel.org, piaojun@huawei.com, torvalds@linux-foundation.org

From: Jules Irenge <jbi.octave@gmail.com>
Subject: ocfs2: add missing annotations for ocfs2_refcount_cache_lock() and ocfs2_refcount_cache_unlock()

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
