Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6934596E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291525; cv=none; b=aiJkWWJ/iTlCnMKzHmPJzN3NslkRVUtDWjUVzYU75IyCie2L0P3OLtrHa3GkHJf8wHXmfWGdLPXB3LxSxZaqYhzzTOWIyLEqDvc8E/hrBsmmsPI9bxirgec4nufCvjtpE0XK7tGF5J+++uvcNA6lBgH6MpSvYrVZKY0rwcX3ojk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291525; c=relaxed/simple;
	bh=0NLdLxiNH/b04ycmUOv4geioDfdMnXrwAFWG/CgfviY=;
	h=Date:To:From:Subject:Message-Id; b=l3Sb4FaXoulX1AZug09W7WSexVt9CmoULBiJnDOdxWfb0C14BN8AK9X2wz6d9/bthlikY6BPXSlMgAzGKyVCegqzuAtY7KPgp6NO0kzWLGnamCEPSccDLdbcUeisa8YIUPkkwRR7VRLwVqIAgzZT2FrKllqzp3feAa5kRZ3isPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ruxy+rth; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ruxy+rth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66051C32782;
	Tue, 25 Jun 2024 04:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291525;
	bh=0NLdLxiNH/b04ycmUOv4geioDfdMnXrwAFWG/CgfviY=;
	h=Date:To:From:Subject:From;
	b=Ruxy+rth4m4PUkWPOY7jwB3i2zx9xOwGwF229zSpHCvFvrrVXn67SXt7/FDQPLAtf
	 Ey1ZHdEO9RUqNRoafTi85NzJ5LVvWzOnvd85UHLXPiqjUVvw1mN5ztmaH+tPJgyZzE
	 K3FuZzCn43CSreA8Gv3L/V0TLfwNkF1IOnJJp8yA=
Date: Mon, 24 Jun 2024 21:58:44 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,mcgrof@kernel.org,j.granados@samsung.com,linux@weissschuh.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-constify-ctl_table-arguments-of-utility-functions.patch removed from -mm tree
Message-Id: <20240625045845.66051C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: constify ctl_table arguments of utility functions
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-constify-ctl_table-arguments-of-utility-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
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


