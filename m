Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D89B215F6A
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188314; cv=none; b=GP6FfDyJ9wS7EeIrgaiLuybRAZF7g0t+txX8YG/fny8jB8zc2MdvExU0Z4hxd5NfupJQxkuwMSexPVRC0/LsiAcQIwq3qC6hpYObl2zQ3jwnkTF5Hu+szEkecIcpVdfKmdEqcTq8eg74RttPN15Skv//NqJo6YhsLAO0BGJKXKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188314; c=relaxed/simple;
	bh=APJeq0TCkxFVBvOA2muy1ahrUg+W51UiOMWg8IbNhVc=;
	h=Date:To:From:Subject:Message-Id; b=q3ShofrWn63oMTv9IqxDkV3Vx1Q5DWerGF+naS7IchOrspRCboM697TV49LrvFNla/ZnYacXhFTfgoU38kH9tDbS8XMN1B6/fbhcNQQhnNXu+FA530x94p3GJWsh+8uTp0tAia6dGz6Jg0uX/1ZVh/LWm9msR/d7vOYLpBeOz/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qPDKS+0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qPDKS+0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C996C4CEEC;
	Mon, 17 Mar 2025 05:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188314;
	bh=APJeq0TCkxFVBvOA2muy1ahrUg+W51UiOMWg8IbNhVc=;
	h=Date:To:From:Subject:From;
	b=qPDKS+0GlkDiOhIzSyUI4rDyOWFIdeX/6G1C6VgHJoJNbkmHpBhsoZcsQlh/BLi/t
	 oKsVpYTr+CTLrhzPyyl6vhBXzTG7rIaKPodWejinSb3A0jfeOyBbdsM00Ck89hUkcz
	 E9Fiz9D4Fkw6Ef4ST87gs8QQy0QjJQhXdb2DioaY=
Date: Sun, 16 Mar 2025 22:11:53 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,souravpanda@google.com,shivankg@amd.com,shakeel.butt@linux.dev,sfr@canb.auug.org.au,richard.weiyang@gmail.com,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hca@linux.ibm.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] types-move-struct-rcuwait-into-typesh.patch removed from -mm tree
Message-Id: <20250317051154.0C996C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: types: move struct rcuwait into types.h
has been removed from the -mm tree.  Its filename was
     types-move-struct-rcuwait-into-typesh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: types: move struct rcuwait into types.h
Date: Thu, 13 Feb 2025 14:46:43 -0800

Move rcuwait struct definition into types.h so that rcuwait can be used
without including rcuwait.h which includes other headers.  Without this
change mm_types.h can't use rcuwait due to a the following circular
dependency:

mm_types.h -> rcuwait.h -> signal.h -> mm_types.h

Link: https://lkml.kernel.org/r/20250213224655.1680278-7-surenb@google.com
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Shivank Garg <shivankg@amd.com>
  Link: https://lkml.kernel.org/r/5e19ec93-8307-47c2-bb13-3ddf7150624e@amd.com
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcuwait.h |   13 +------------
 include/linux/types.h   |   12 ++++++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

--- a/include/linux/rcuwait.h~types-move-struct-rcuwait-into-typesh
+++ a/include/linux/rcuwait.h
@@ -4,18 +4,7 @@
 
 #include <linux/rcupdate.h>
 #include <linux/sched/signal.h>
-
-/*
- * rcuwait provides a way of blocking and waking up a single
- * task in an rcu-safe manner.
- *
- * The only time @task is non-nil is when a user is blocked (or
- * checking if it needs to) on a condition, and reset as soon as we
- * know that the condition has succeeded and are awoken.
- */
-struct rcuwait {
-	struct task_struct __rcu *task;
-};
+#include <linux/types.h>
 
 #define __RCUWAIT_INITIALIZER(name)		\
 	{ .task = NULL, }
--- a/include/linux/types.h~types-move-struct-rcuwait-into-typesh
+++ a/include/linux/types.h
@@ -248,5 +248,17 @@ typedef void (*swap_func_t)(void *a, voi
 typedef int (*cmp_r_func_t)(const void *a, const void *b, const void *priv);
 typedef int (*cmp_func_t)(const void *a, const void *b);
 
+/*
+ * rcuwait provides a way of blocking and waking up a single
+ * task in an rcu-safe manner.
+ *
+ * The only time @task is non-nil is when a user is blocked (or
+ * checking if it needs to) on a condition, and reset as soon as we
+ * know that the condition has succeeded and are awoken.
+ */
+struct rcuwait {
+	struct task_struct __rcu *task;
+};
+
 #endif /*  __ASSEMBLY__ */
 #endif /* _LINUX_TYPES_H */
_

Patches currently in -mm which might be from surenb@google.com are


