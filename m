Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633EA1CF83
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 02:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728008772; cv=none; b=VtVkUevOo9Ddjql44mCwZQhAuFHVERUk26R4voPPF/J5dt9woRUn8zFNukOXIJ7MnfuYfquA9es3/qtMJASDAyxCQwG7+fYEc+gRyYmjALm7Lt4LfW83ZYHUO71eGXm5TErYK2gAvJwdVeFOp4MEpStsIr7SHfaBO7dTPiVheck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728008772; c=relaxed/simple;
	bh=DgQ7bFKIvZwGDkMZK9MfuR/Myhx/9LiH62Qmgy5Ga/0=;
	h=Date:To:From:Subject:Message-Id; b=chMI7Ni0OK3sEAwoGR0326Nx6fPfFNVkpsTcJKaiVRbVw+iTJ2me7gU/idvCJJcT8nsMLr71kJs+Idp5mPAR7BlYejoBUtYA90sG7QNzTXkr43Uh2onS8ZR/s7mw5sEFJdIUeof/+4LUdZPiglWC6Dw9m7nV8v9h+ZLAlOrMYhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f/nf7UKL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f/nf7UKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA50C4CEC5;
	Fri,  4 Oct 2024 02:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728008771;
	bh=DgQ7bFKIvZwGDkMZK9MfuR/Myhx/9LiH62Qmgy5Ga/0=;
	h=Date:To:From:Subject:From;
	b=f/nf7UKLTf9vUTvvyy/oRp7nN1Q5bNFVhp/kVmO+I2vHed7f3oIYSQv+O08DglO90
	 DQGPd/peBc5kgmUcXEAP55qXwyJQbqf32wP4Dpp4QUEZlACFT6Yv43i2oJ/sKggiMH
	 JdNxSSK+kAVm3HYKsuoqpy4w2+15j1XCZ6I+Kjlg=
Date: Thu, 03 Oct 2024 19:26:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,serge@hallyn.com,paul@paul-moore.com,laoar.shao@gmail.com,kent.overstreet@linux.dev,jmorris@namei.org,jack@suse.cz,hch@lst.de,dchinner@redhat.com,brauner@kernel.org,mhocko@suse.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-mm-introduce-pf_memalloc_noreclaim-pf_memalloc_nowarn.patch removed from -mm tree
Message-Id: <20241004022611.BCA50C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Revert "mm: introduce PF_MEMALLOC_NORECLAIM, PF_MEMALLOC_NOWARN"
has been removed from the -mm tree.  Its filename was
     revert-mm-introduce-pf_memalloc_noreclaim-pf_memalloc_nowarn.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


