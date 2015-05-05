From: akpm@linux-foundation.org
Subject: + kernfs-do-not-account-ino_ida-allocations-to-memcg.patch added
 to -mm tree
Date: Tue, 05 May 2015 14:26:53 -0700
Message-ID: <5549359d.YAuThJFa1fHeCVff%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946008AbbEEV0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2015 17:26:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, cl@linux.com, gregkh@linuxfoundation.org, gthelen@google.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mhocko@suse.cz, penberg@kernel.org, rientjes@google.com, stable@vger.kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernfs: do not account ino_ida allocations to memcg
has been added to the -mm tree.  Its filename is
     kernfs-do-not-account-ino_ida-allocations-to-memcg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernfs-do-not-account-ino_ida-allocations-to-memcg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: kernfs: do not account ino_ida allocations to memcg

root->ino_ida is used for kernfs inode number allocations. Since IDA has
a layered structure, different IDs can reside on the same layer, which
is currently accounted to some memory cgroup. The problem is that each
kmem cache of a memory cgroup has its own directory on sysfs (under
/sys/fs/kernel/<cache-name>/cgroup). If the inode number of such a
directory or any file in it gets allocated from a layer accounted to the
cgroup which the cache is created for, the cgroup will get pinned for
good, because one has to free all kmem allocations accounted to a cgroup
in order to release it and destroy all its kmem caches. That said we
must not account layers of ino_ida to any memory cgroup.

Since per net init operations may create new sysfs entries directly
(e.g. lo device) or indirectly (nf_conntrack creates a new kmem cache
per each namespace, which, in turn, creates new sysfs entries), an easy
way to reproduce this issue is by creating network namespace(s) from
inside a kmem-active memory cgroup.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>	[4.0.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/kernfs/dir.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/kernfs/dir.c~kernfs-do-not-account-ino_ida-allocations-to-memcg fs/kernfs/dir.c
--- a/fs/kernfs/dir.c~kernfs-do-not-account-ino_ida-allocations-to-memcg
+++ a/fs/kernfs/dir.c
@@ -518,7 +518,14 @@ static struct kernfs_node *__kernfs_new_
 	if (!kn)
 		goto err_out1;
 
-	ret = ida_simple_get(&root->ino_ida, 1, 0, GFP_KERNEL);
+	/*
+	 * If the ino of the sysfs entry created for a kmem cache gets
+	 * allocated from an ida layer, which is accounted to the memcg that
+	 * owns the cache, the memcg will get pinned forever. So do not account
+	 * ino ida allocations.
+	 */
+	ret = ida_simple_get(&root->ino_ida, 1, 0,
+			     GFP_KERNEL | __GFP_NOACCOUNT);
 	if (ret < 0)
 		goto err_out2;
 	kn->ino = ret;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

gfp-add-__gfp_noaccount.patch
kernfs-do-not-account-ino_ida-allocations-to-memcg.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
fix-a-misaligned-load-inside-ptrace_attach.patch
change-wait_on_bit-to-take-an-unsigned-long-not-a-void.patch
change-all-uses-of-jobctl_-from-int-to-long.patch

