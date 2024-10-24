Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCF2136E28
	for <mm-commits@vger.kernel.org>; Thu, 24 Oct 2024 02:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729737656; cv=none; b=EW7QhkmR+kav5rv/dC1gMrtsQ/rCdSphr9pZc+qKgoiILn0P2GwjimAm5XB+TEGdVonpCFdYpX2gtjR5f/Y2xOwHUbL32Rtj533OZczhCToSPl23P97iEIggDvmZPu2FTf5FBXM4TjgpR2W0N0+MtINxtHONSJAZtg61PeZ6Gr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729737656; c=relaxed/simple;
	bh=0s2nQUx8evkF/Mwsmed2dgKIKpXhNLzcmO6euxiaZsw=;
	h=Date:To:From:Subject:Message-Id; b=Pc6BulQHXhqlhO4STXZH8nyLK+ll/vrZjV+xrXnwkoXJCuWs3Tr4BBfqc3/Yjif9LJvfnOYd3dU6HoXSgfT0q4M94sa0YZkmJarGFCJR4KNxtvvKAWerWY6bn7FCZPPnodR5WDwhXxIu2VRr9QTUDht1qUnyGLoejxPQ7xBvHPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lUhLRAFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lUhLRAFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1FBC4CEC6;
	Thu, 24 Oct 2024 02:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729737656;
	bh=0s2nQUx8evkF/Mwsmed2dgKIKpXhNLzcmO6euxiaZsw=;
	h=Date:To:From:Subject:From;
	b=lUhLRAFIPq69v8lWUtELafl7WRhHZJ6iFfa4kBHfHII1R/2dbSW4A83DabdPClHnA
	 pqDPQGyHrbaByGUu4dx+zewWzEmJYYscdjp4B2lWWAlM1xykN86DGUBeUfLNxcvTVB
	 Aii8dgZceNn8wHUVIAJILWG0L/tuKcQSWZwYa9Oo=
Date: Wed, 23 Oct 2024 19:40:56 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-fix-seq_buf-size-to-save-memory-when-page_size-is-large.patch added to mm-unstable branch
Message-Id: <20241024024056.8B1FBC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memcontrol: fix seq_buf size to save memory when PAGE_SIZE is large
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memcontrol-fix-seq_buf-size-to-save-memory-when-page_size-is-large.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-fix-seq_buf-size-to-save-memory-when-page_size-is-large.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm/memcontrol: fix seq_buf size to save memory when PAGE_SIZE is large
Date: Mon, 21 Oct 2024 14:00:26 +0100

Previously the seq_buf used for accumulating the memory.stat output was
sized at PAGE_SIZE.  But the amount of output is invariant to PAGE_SIZE;
If 4K is enough on a 4K page system, then it should also be enough on a
64K page system, so we can save 60K on the static buffer used in
mem_cgroup_print_oom_meminfo().  Let's make it so.

This also has the beneficial side effect of removing a place in the code
that assumed PAGE_SIZE is a compile-time constant.  So this helps our
quest towards supporting boot-time page size selection.

Link: https://lkml.kernel.org/r/20241021130027.3615969-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-fix-seq_buf-size-to-save-memory-when-page_size-is-large
+++ a/mm/memcontrol.c
@@ -118,6 +118,7 @@ struct mem_cgroup *vmpressure_to_memcg(s
 	return container_of(vmpr, struct mem_cgroup, vmpressure);
 }
 
+#define SEQ_BUF_SIZE SZ_4K
 #define CURRENT_OBJCG_UPDATE_BIT 0
 #define CURRENT_OBJCG_UPDATE_FLAG (1UL << CURRENT_OBJCG_UPDATE_BIT)
 
@@ -1527,7 +1528,7 @@ void mem_cgroup_print_oom_context(struct
 void mem_cgroup_print_oom_meminfo(struct mem_cgroup *memcg)
 {
 	/* Use static buffer, for the caller is holding oom_lock. */
-	static char buf[PAGE_SIZE];
+	static char buf[SEQ_BUF_SIZE];
 	struct seq_buf s;
 
 	lockdep_assert_held(&oom_lock);
@@ -1553,7 +1554,7 @@ void mem_cgroup_print_oom_meminfo(struct
 	pr_info("Memory cgroup stats for ");
 	pr_cont_cgroup_path(memcg->css.cgroup);
 	pr_cont(":");
-	seq_buf_init(&s, buf, sizeof(buf));
+	seq_buf_init(&s, buf, SEQ_BUF_SIZE);
 	memory_stat_format(memcg, &s);
 	seq_buf_do_printk(&s, KERN_INFO);
 }
@@ -4194,12 +4195,12 @@ static int memory_events_local_show(stru
 int memory_stat_show(struct seq_file *m, void *v)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
-	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	char *buf = kmalloc(SEQ_BUF_SIZE, GFP_KERNEL);
 	struct seq_buf s;
 
 	if (!buf)
 		return -ENOMEM;
-	seq_buf_init(&s, buf, PAGE_SIZE);
+	seq_buf_init(&s, buf, SEQ_BUF_SIZE);
 	memory_stat_format(memcg, &s);
 	seq_puts(m, buf);
 	kfree(buf);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-memcontrol-fix-seq_buf-size-to-save-memory-when-page_size-is-large.patch

