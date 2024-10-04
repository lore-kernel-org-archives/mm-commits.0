Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73271DDA1
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 02:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728008672; cv=none; b=kXGyo92xJy71oYK3YrZayA0cYKk8QYlEzpvku0/F8oUOBuPYsctrAWJrZ0IPh6+E2/Cg4T4qn3h1ZWZJileHcQr0kIqOuifVhGlmf7adYb/+j5O7qDyusI0tgsvlMClErC/V8CAdGSxRWCLXBaw0kVcYUyzm9YlG/bpUfUCSQWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728008672; c=relaxed/simple;
	bh=EG+8PTcholiv63XgjDijK3E/CxGELjGJRroecxsO1cU=;
	h=Date:To:From:Subject:Message-Id; b=HFOsdgBgRAZoghUF0drUIN7NWSSn5574oSQcGuj72T0E9pofos9JoUizt1dMp23Y//TJhI1Gjv32RdeXOMzBsAVwZRu6oUMlPAZ/ES86g3Fl4DkF9F4J4qXM+VJ/Quhv7rMepIBjg8PmzmUjcc2eBpqw3/zmtMT0tz69y+jfDpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CVW1EvS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CVW1EvS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0903C4CEC5;
	Fri,  4 Oct 2024 02:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728008670;
	bh=EG+8PTcholiv63XgjDijK3E/CxGELjGJRroecxsO1cU=;
	h=Date:To:From:Subject:From;
	b=CVW1EvS6KvwE2flh1QpA1uJ8kzEKpnvcFMH0qX40KbN4tk3tCOLF+v4XNop9tOEgY
	 bYrTQo+AN3PvOiMZhB2iY8kTe99qXL8EL9XvF0NzLesNENSWbNRjS8PM6DxHQlZDq0
	 39YCiBuHrTsNd6GbGc2jAmCAIMxjTW0tDmX7NUNE=
Date: Thu, 03 Oct 2024 19:24:30 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,mhocko@suse.com,kent.overstreet@linux.dev,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] bcachefs-do-not-use-pf_memalloc_noreclaim-fix.patch removed from -mm tree
Message-Id: <20241004022430.C0903C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bcachefs-do-not-use-pf_memalloc_noreclaim-fix
has been removed from the -mm tree.  Its filename was
     bcachefs-do-not-use-pf_memalloc_noreclaim-fix.patch

This patch was dropped because it was folded into bcachefs-do-not-use-pf_memalloc_noreclaim.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bcachefs-do-not-use-pf_memalloc_noreclaim-fix
Date: Fri Sep 27 08:38:06 AM PDT 2024

fix kerneldoc warnings

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lkml.kernel.org/r/20240927133041.0b54641d@canb.auug.org.au
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/security.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/security/security.c~bcachefs-do-not-use-pf_memalloc_noreclaim-fix
+++ a/security/security.c
@@ -740,6 +740,7 @@ static int lsm_file_alloc(struct file *f
 /**
  * lsm_inode_alloc - allocate a composite inode blob
  * @inode: the inode that needs a blob
+ * @gfp: allocation flags
  *
  * Allocate the inode blob for all the modules
  *
@@ -1678,7 +1679,7 @@ int security_path_notify(const struct pa
 /**
  * security_inode_alloc() - Allocate an inode LSM blob
  * @inode: the inode
- * #gfp: allocation flags
+ * @gfp: allocation flags
  *
  * Allocate and attach a security structure to @inode->i_security.  The
  * i_security field is initialized to NULL when the inode structure is
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bcachefs-do-not-use-pf_memalloc_noreclaim.patch

