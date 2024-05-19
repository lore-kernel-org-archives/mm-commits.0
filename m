Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5AC2FB2
	for <mm-commits@vger.kernel.org>; Sun, 19 May 2024 23:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716160924; cv=none; b=GE4MUjDPARMyPFVUFUqDt6jcSpRhIKOHiJkGeaRMsqm5xPVRBOZ4lKTPIfuhjbzuTVh/EnUEGvPD1ZHzJmZRq8LQuNSvad92RyH3RkRlU+NPCHka82iMsa2kFZjRVT2Tyrk2zjpK2eh0a9lByZrVAoasBPJ9h+DjDyMgHWXgvw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716160924; c=relaxed/simple;
	bh=8rjzGoRLLoXO00pURo3ONi6MII/6eVqEuvL3QPCYbNg=;
	h=Date:To:From:Subject:Message-Id; b=VUMpmEd2JXjSiKxEyrZg3RBBmPBeN+b6xopNEwpddiC2Ml2DYRZrUfQFROoU1Oa3fxPovVFcN67Z7/sFyFCua27d65NpWrkmwZlSjqj5zwNwGdzUpg0dOU0yLneYAQtYtXEg+o2M+NEic3OMALXprtAHCcGHkpaEmvhBzHFUjfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QoEQRbH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QoEQRbH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0419DC32781;
	Sun, 19 May 2024 23:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716160924;
	bh=8rjzGoRLLoXO00pURo3ONi6MII/6eVqEuvL3QPCYbNg=;
	h=Date:To:From:Subject:From;
	b=QoEQRbH46RwvkEb3166Vfg5j0VYlkSYdEqzLbc6vwAzYTkCDsl5BgV8ka6/aUnsoo
	 JxUDRsdWFmJ+1+PHwCClYMbB7XDXaE4sVs50csc7f7M9tzXg32LgEHJnMdWY4oA1CS
	 QVf+iZFx3YGGZR3j8yxuuFZ5IkVEIg59ygwPal8c=
Date: Sun, 19 May 2024 16:22:03 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,mcgrof@kernel.org,j.granados@samsung.com,linux@weissschuh.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-constify-ctl_table-arguments-of-utility-functions.patch added to mm-unstable branch
Message-Id: <20240519232204.0419DC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: constify ctl_table arguments of utility functions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-constify-ctl_table-arguments-of-utility-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-constify-ctl_table-arguments-of-utility-functions.patch

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
From: Thomas Weißschuh <linux@weissschuh.net>
Subject: mm/hugetlb: constify ctl_table arguments of utility functions
Date: Sat, 18 May 2024 16:00:04 +0200

The sysctl core is preparing to only expose instances of struct ctl_table
as "const".  This will also affect the ctl_table argument of sysctl
handlers.

As the function prototype of all sysctl handlers throughout the tree
needs to stay consistent that change will be done in one commit.

To reduce the size of that final commit, switch utility functions which
are not bound by "typedef proc_handler" to "const struct ctl_table".

No functional change.

Link: https://lkml.kernel.org/r/20240518-sysctl-const-handler-hugetlb-v1-1-47e34e2871b2@weissschuh.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-constify-ctl_table-arguments-of-utility-functions
+++ a/mm/hugetlb.c
@@ -4911,7 +4911,7 @@ static unsigned int allowed_mems_nr(stru
 }
 
 #ifdef CONFIG_SYSCTL
-static int proc_hugetlb_doulongvec_minmax(struct ctl_table *table, int write,
+static int proc_hugetlb_doulongvec_minmax(const struct ctl_table *table, int write,
 					  void *buffer, size_t *length,
 					  loff_t *ppos, unsigned long *out)
 {
@@ -4928,7 +4928,7 @@ static int proc_hugetlb_doulongvec_minma
 }
 
 static int hugetlb_sysctl_handler_common(bool obey_mempolicy,
-			 struct ctl_table *table, int write,
+			 const struct ctl_table *table, int write,
 			 void *buffer, size_t *length, loff_t *ppos)
 {
 	struct hstate *h = &default_hstate;
_

Patches currently in -mm which might be from linux@weissschuh.net are

mm-hugetlb-constify-ctl_table-arguments-of-utility-functions.patch

