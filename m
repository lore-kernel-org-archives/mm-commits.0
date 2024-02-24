Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EA679C5
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739414; cv=none; b=XKKzz+j7xXNjKgsRMhsUtAkVwuFu8A58qMg2nPlErraNREybp+qBsAeoeEO3tX0DguQKU2BlW9IPN4p172mzwbP6MttlNs+LoT9WAskCbrNLRbRbTL+yPBFnuVXVQHG/KCBCSu+fzGh4eo3aypsHWgXVVI6R96DKGNb0nJzTGbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739414; c=relaxed/simple;
	bh=aXadwjV3l0i6yshxnXNKe4bTpagNQEp2sRhsFlgtVcw=;
	h=Date:To:From:Subject:Message-Id; b=QJ4R0p3U838LVeMFV0mH1DwB7iJiIEmiVtGHzJ4mXqU2WF4TEStQNMRKZopzJstcWEa/bwBi3NzWELxF0zAxb79KMJ1800qjs//V+cPW3veMSnEfiKSC22nBLJtAU6oCdwN0skKw3RuY36VbG1H+WAcrShiRPLe7tgVkeGA19S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bM847Ip1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bM847Ip1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773B8C433C7;
	Sat, 24 Feb 2024 01:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739414;
	bh=aXadwjV3l0i6yshxnXNKe4bTpagNQEp2sRhsFlgtVcw=;
	h=Date:To:From:Subject:From;
	b=bM847Ip1hvqQ+OoMjcJ2BkC93gjOsQjtYCW2RVGEvRnkkMI8HaPuAMz3U//blGCx+
	 iT16LGy3441tN63ysYhYXLGY7la+1MRA0jEW+VeaezoWV7rE7N16nulqWMYKpPTUeR
	 zI1DAkChPUVJtm7F0NoUeto05KXjNHIu/gYj2NuE=
Date: Fri, 23 Feb 2024 17:50:14 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-effective_bytes-sysfs-file.patch removed from -mm tree
Message-Id: <20240224015014.773B8C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document effective_bytes sysfs file
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-effective_bytes-sysfs-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document effective_bytes sysfs file
Date: Mon, 19 Feb 2024 11:44:15 -0800

Update the DAMON ABI doc for the effective_bytes sysfs file and the
kdamond state file input command for updating the content of the file.

Link: https://lkml.kernel.org/r/20240219194431.159606-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-effective_bytes-sysfs-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -34,7 +34,9 @@ Description:	Writing 'on' or 'off' to th
 		kdamond.  Writing 'update_schemes_tried_bytes' to the file
 		updates only '.../tried_regions/total_bytes' files of this
 		kdamond.  Writing 'clear_schemes_tried_regions' to the file
-		removes contents of the 'tried_regions' directory.
+		removes contents of the 'tried_regions' directory.  Writing
+		'update_schemes_effective_quotas' to the file updates
+		'.../quotas/effective_bytes' files of this kdamond.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
 Date:		Mar 2022
@@ -208,6 +210,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the size
 		quota of the scheme in bytes.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/effective_bytes
+Date:		Feb 2024
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading from this file gets the effective size quota of the
+		scheme in bytes, which adjusted for the time quota and goals.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/reset_interval_ms
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are


