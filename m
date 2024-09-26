Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1FD17F397
	for <mm-commits@vger.kernel.org>; Thu, 26 Sep 2024 20:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727381319; cv=none; b=hypLRCBqU4DVPHmwfZJup/7tx4rwJpJlgsVqy/rHiulz19dJpwdpoHeE2cGFKzLmkAaV+g0XGxyczzSjWh946gKzR5KvGmuBRGQWovRhRbSMCcqVF5rw3bIqu3Nhu1WE5F9Oga5A4OsIuPV0FEzXMpe7f2OLT2tj/jsDgbX7j9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727381319; c=relaxed/simple;
	bh=S78cbMWFrLECDZwIhsjX1xnfwzTBxzvbIOtuX3nSGj8=;
	h=Date:To:From:Subject:Message-Id; b=hsAsHRiB5ed1r9qdJNIpwJPZh64iypOcTiQ+lhz7bSaVLrN5t+YDGyOgwOD7tMwzuxX1x1KL2FUoCrOsb31Y490++dgu+17GhHN0o3Rl9xq/z9iOrBjF+b61V823+1cnw5XF1lhyy6OzzdL2HFd8XK5hsAOUnMNj2+qSrsgbEV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZQYoeF1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZQYoeF1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C83C4CEC5;
	Thu, 26 Sep 2024 20:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727381319;
	bh=S78cbMWFrLECDZwIhsjX1xnfwzTBxzvbIOtuX3nSGj8=;
	h=Date:To:From:Subject:From;
	b=ZQYoeF1Xg977WH4ELZnT+PVg3ZmzjPD8UvJsLcBcIP5fRB3LqJTbEBLjnQQEQseeK
	 c0qokmVQ+zmlLU0u5TDF0bxZLmNrHL1l4fKRImBDJ0uIyVDrJQmsz8GcZuiTauc4qn
	 GsrPXElw/VUyOqWmSPIEmA01gnJ8eegf6ZJ7pNX0=
Date: Thu, 26 Sep 2024 13:08:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,serge@hallyn.com,paul@paul-moore.com,laoar.shao@gmail.com,kent.overstreet@linux.dev,jmorris@namei.org,jack@suse.cz,hch@lst.de,dchinner@redhat.com,brauner@kernel.org,mhocko@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-introduce-pf_memalloc_noreclaim-pf_memalloc_nowarn.patch added to mm-hotfixes-unstable branch
Message-Id: <20240926200839.45C83C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "mm: introduce PF_MEMALLOC_NORECLAIM, PF_MEMALLOC_NOWARN"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-mm-introduce-pf_memalloc_noreclaim-pf_memalloc_nowarn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-introduce-pf_memalloc_noreclaim-pf_memalloc_nowarn.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Michal Hocko <mhocko@suse.com>
Subject: Revert "mm: introduce PF_MEMALLOC_NORECLAIM, PF_MEMALLOC_NOWARN"
Date: Thu, 26 Sep 2024 19:11:51 +0200

This reverts commit eab0af905bfc3e9c05da2ca163d76a1513159aa4.

There is no existing user of those flags.  PF_MEMALLOC_NOWARN is dangerous
because a nested allocation context can use GFP_NOFAIL which could cause
unexpected failure.  Such a code would be hard to maintain because it
could be deeper in the call chain.

PF_MEMALLOC_NORECLAIM has been added even when it was pointed out [1] that
such a allocation contex is inherently unsafe if the context doesn't fully
control all allocations called from this context.

While PF_MEMALLOC_NOWARN is not dangerous the way PF_MEMALLOC_NORECLAIM is
it doesn't have any user and as Matthew has pointed out we are running out
of those flags so better reclaim it without any real users.

[1] https://lore.kernel.org/all/ZcM0xtlKbAOFjv5n@tiehlicka/

Link: https://lkml.kernel.org/r/20240926172940.167084-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h    |    4 ++--
 include/linux/sched/mm.h |   17 ++++-------------
 2 files changed, 6 insertions(+), 15 deletions(-)

--- a/include/linux/sched.h~revert-mm-introduce-pf_memalloc_noreclaim-pf_memalloc_nowarn
+++ a/include/linux/sched.h
@@ -1681,8 +1681,8 @@ extern struct pid *cad_pid;
 						 * I am cleaning dirty pages from some other bdi. */
 #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
-#define PF_MEMALLOC_NORECLAIM	0x00800000	/* All allocation requests will clear __GFP_DIRECT_RECLAIM */
-#define PF_MEMALLOC_NOWARN	0x01000000	/* All allocation requests will inherit __GFP_NOWARN */
+#define PF__HOLE__00800000	0x00800000
+#define PF__HOLE__01000000	0x01000000
 #define PF__HOLE__02000000	0x02000000
 #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
 #define PF_MCE_EARLY		0x08000000      /* Early kill for mce process policy */
--- a/include/linux/sched/mm.h~revert-mm-introduce-pf_memalloc_noreclaim-pf_memalloc_nowarn
+++ a/include/linux/sched/mm.h
@@ -251,25 +251,16 @@ static inline gfp_t current_gfp_context(
 {
 	unsigned int pflags = READ_ONCE(current->flags);
 
-	if (unlikely(pflags & (PF_MEMALLOC_NOIO |
-			       PF_MEMALLOC_NOFS |
-			       PF_MEMALLOC_NORECLAIM |
-			       PF_MEMALLOC_NOWARN |
-			       PF_MEMALLOC_PIN))) {
+	if (unlikely(pflags & (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS | PF_MEMALLOC_PIN))) {
 		/*
-		 * Stronger flags before weaker flags:
-		 * NORECLAIM implies NOIO, which in turn implies NOFS
+		 * NOIO implies both NOIO and NOFS and it is a weaker context
+		 * so always make sure it makes precedence
 		 */
-		if (pflags & PF_MEMALLOC_NORECLAIM)
-			flags &= ~__GFP_DIRECT_RECLAIM;
-		else if (pflags & PF_MEMALLOC_NOIO)
+		if (pflags & PF_MEMALLOC_NOIO)
 			flags &= ~(__GFP_IO | __GFP_FS);
 		else if (pflags & PF_MEMALLOC_NOFS)
 			flags &= ~__GFP_FS;
 
-		if (pflags & PF_MEMALLOC_NOWARN)
-			flags |= __GFP_NOWARN;
-
 		if (pflags & PF_MEMALLOC_PIN)
 			flags &= ~__GFP_MOVABLE;
 	}
_

Patches currently in -mm which might be from mhocko@suse.com are

bcachefs-do-not-use-pf_memalloc_noreclaim.patch
revert-mm-introduce-pf_memalloc_noreclaim-pf_memalloc_nowarn.patch

