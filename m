Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2423A8F7
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732939657; cv=none; b=Tw/XgdE4YoA3ncrgTVmGUiWah9wZAyJwrm/9WbCD14/RuS/VV5b2GJga6SVM0dAugG0PELsebfuoXsLwKLLRdn03U8JFzPEuzqJ4HBn+l1+ValIll5sSnzul0C3acTJ3oC2XE+X3n0ClSiAMeY16GAA9p6Lq+ViEYokx207RLQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732939657; c=relaxed/simple;
	bh=uUyFkSnuTys+knaW4WkvVIBYgz6+fXprXEgblwW+r9Y=;
	h=Date:To:From:Subject:Message-Id; b=NIx2IC/+NhZDBVzDIzceHSJ+lkHvCsCA6RVTrCjlJaVsiAvT5I2w82B5IRbyh+IbLKDK8mhVedc1RykW/KJlt1FuPvljAOdleOAaQAV5W1uXB9N0ZxGqX3mNQMXi/C7aRDq0cldf6iatDoqxx13d/OuGSPvLEfAoWL+lD1oid5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=G2idtML0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="G2idtML0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D09C4CECC;
	Sat, 30 Nov 2024 04:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732939657;
	bh=uUyFkSnuTys+knaW4WkvVIBYgz6+fXprXEgblwW+r9Y=;
	h=Date:To:From:Subject:From;
	b=G2idtML0NpwvJTm9qonMbVvy+d3QQtSf5oLUKDaQFuM4cW+2menkmDmQe3rzbyXVV
	 /gmKCnJ4AhKntfMqVRGfo7y/U+3NjdzoKFwI+F8e1RehR5oDMGUsVC2cQOczJeODYs
	 beGukHsycqEfmd1xbkbz3tk+87hAioCXNd+6nlP4=
Date: Fri, 29 Nov 2024 20:07:36 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,kerensun@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prefer-unsigned-int-to-bare-use-of-unsigned.patch added to mm-unstable branch
Message-Id: <20241130040736.F2D09C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: prefer 'unsigned int' to bare use of 'unsigned'
has been added to the -mm mm-unstable branch.  Its filename is
     mm-prefer-unsigned-int-to-bare-use-of-unsigned.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prefer-unsigned-int-to-bare-use-of-unsigned.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Keren Sun <kerensun@google.com>
Subject: mm: prefer 'unsigned int' to bare use of 'unsigned'
Date: Fri, 15 Nov 2024 15:57:42 -0800

Patch series "mm: fix format issues and param types"

Change the param 'mode' from type 'unsigned' to 'unsigned int' in
memcg_event_wake() and memcg_oom_wake_function(), and for the param 'nid'
in VM_BUG_ON().

Link: https://lkml.kernel.org/r/20241115235744.1419580-2-kerensun@google.com
Signed-off-by: Keren Sun <kerensun@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memcontrol-v1.c~mm-prefer-unsigned-int-to-bare-use-of-unsigned
+++ a/mm/memcontrol-v1.c
@@ -899,7 +899,7 @@ static void memcg_event_remove(struct wo
  *
  * Called with wqh->lock held and interrupts disabled.
  */
-static int memcg_event_wake(wait_queue_entry_t *wait, unsigned mode,
+static int memcg_event_wake(wait_queue_entry_t *wait, unsigned int mode,
 			    int sync, void *key)
 {
 	struct mem_cgroup_event *event =
@@ -1202,7 +1202,7 @@ struct oom_wait_info {
 };
 
 static int memcg_oom_wake_function(wait_queue_entry_t *wait,
-	unsigned mode, int sync, void *arg)
+	unsigned int mode, int sync, void *arg)
 {
 	struct mem_cgroup *wake_memcg = (struct mem_cgroup *)arg;
 	struct mem_cgroup *oom_wait_memcg;
@@ -1644,7 +1644,7 @@ static unsigned long mem_cgroup_node_nr_
 	unsigned long nr = 0;
 	enum lru_list lru;
 
-	VM_BUG_ON((unsigned)nid >= nr_node_ids);
+	VM_BUG_ON((unsigned int)nid >= nr_node_ids);
 
 	for_each_lru(lru) {
 		if (!(BIT(lru) & lru_mask))
_

Patches currently in -mm which might be from kerensun@google.com are

mm-prefer-unsigned-int-to-bare-use-of-unsigned.patch
mm-remove-unnecessary-whitespace-before-a-quoted-newline.patch
mm-remove-the-non-useful-else-after-a-break-in-a-if-statement.patch

