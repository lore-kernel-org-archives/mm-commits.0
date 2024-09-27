Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12EC1E4AE
	for <mm-commits@vger.kernel.org>; Fri, 27 Sep 2024 15:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727451616; cv=none; b=sAA9tiJjBED6mubRmP3hG4RfzJEJv7DV4hL8joGbxTVZbnc3wMxxpOF8J2Q6n5l/DB8zMwFB2MuiiwmepzRknPG3Ge3fbF/hQbcqI4e19UyCVxJBb5vaAG/ZQCBN/8CJsHh+SH9Vw26V7B5DXCkh4qep6UClyCgtAi2S4JiHtaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727451616; c=relaxed/simple;
	bh=dieEWxiI/LkU2WrxqzavGzXSDBDEXjeJu4NLC9VHxLs=;
	h=Date:To:From:Subject:Message-Id; b=i0v29QX9C5Jo1crvbfaYhI/5VN+bcTSocHllzSBgkdmBp8wotDtXZ4PWCAukH1jeN6eOxT4bCZQKNs57UupKCIRGho75/0COoPMgNtzx5RsogAhRSK9keI0oBdcBqCfxKhr4KopphgYW4zcBJyQnPrgsEMbwSNWXWvSbFKU5qeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BKkFBcVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BKkFBcVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38018C4CEC6;
	Fri, 27 Sep 2024 15:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727451616;
	bh=dieEWxiI/LkU2WrxqzavGzXSDBDEXjeJu4NLC9VHxLs=;
	h=Date:To:From:Subject:From;
	b=BKkFBcVb8mK1UpJJJ+rvjZM2nRKcPZmeQ/35TNZbp/1awxP8hFGZWMEz1JTGU59/g
	 bmygDmJeowbF3cXfYcWTdYbfbcEymxeJ/42pQY4iz4HbOw3lU/47uv16kHxyUp4jZ2
	 ySNhvk5sGO7BXorGQ+Tx5wFVvsbZ3y0Fkj6nXQyM=
Date: Fri, 27 Sep 2024 08:40:15 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,mhocko@suse.com,kent.overstreet@linux.dev,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bcachefs-do-not-use-pf_memalloc_noreclaim-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20240927154016.38018C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bcachefs-do-not-use-pf_memalloc_noreclaim-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bcachefs-do-not-use-pf_memalloc_noreclaim-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bcachefs-do-not-use-pf_memalloc_noreclaim-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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

bcachefs-do-not-use-pf_memalloc_noreclaim-fix.patch

