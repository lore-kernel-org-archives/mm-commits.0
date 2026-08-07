Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7F53B7B93
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068066; cv=none; b=QGh05iQ3KA508stk6gk5Sk5pG2iyxHfaLk1kEGdxV2cXph0isdjZwyD4UPlY6b1EM3ZTRVYW87cwViHrDtdam3svnzqeWzsrTUQiZPjND38wSxoebxOTL8veyrzQS2g4ugkHL6a/tFrUHAEaStDLx6a2TjbY8MI2PLEeGY7PT6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068066; c=relaxed/simple;
	bh=bBZ8dHXbpkgdColmUXyHJwBlDMXvsoeb6ma4W+UNhmM=;
	h=Date:To:From:Subject:Message-Id; b=nPYCDSIdB+zRMrZwzZS2PeWTU+3O1ZO1LFdZUz9pXsXtbQ+Z2EGdyM0nbK3jC7S3UqzGQmV40sdtqb/jnUYvXlfRjFYepr0DXX5id8oGlaD5dhcXvyauMpSgD8z1z3PvTYx/qsR7z1huWAQxlaV3xqCZf7316dP1o6p5/06i7h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vD/VUsoS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vD/VUsoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FE51F00A3D;
	Fri,  7 Aug 2026 02:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068062;
	bh=Css3uTuVV0rBHyI0FJ2Qx1Rp/0ZVRFqp0MmOej2Fzb0=;
	h=Date:To:From:Subject;
	b=vD/VUsoS5NUPQJbHLY2xWaZGm/IS/AozRpNzr+di78mcem20CvU5uIgQ5QbyiTJ24
	 7pUSF7lwO5S9xrhARjDI+L6eUpZJwyKBtrmtlMZ1C2z8kLJl7g+NfpO+nBSueBgwm7
	 TExAbhWWT81pxpMFP4b2s25eOg+jrBiEkuYAOqHg=
Date: Thu, 06 Aug 2026 19:01:02 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-hide-private-damon_region-fields.patch removed from -mm tree
Message-Id: <20260807020102.88FE51F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: hide private damon_region fields
has been removed from the -mm tree.  Its filename was
     mm-damon-core-hide-private-damon_region-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: hide private damon_region fields
Date: Tue, 14 Jul 2026 07:35:34 -0700

Patch series "mm/damon/core: hide core-private struct fields".

DAMON core structs hide core-private fields using 'private:' comment tags.
It is incomplete and inconsistent.  The linked list heads in a few
structs, for example, are intended to be hidden, and always be used using
the wrapper macros like damon_for_each_region().  But those were
mistakenly marked as non-private.  A few core layer-only fields were also
mistakenly added as non-private.

This only encourages callers to directly use the private fields.  It is
easy to make mistakes, and difficult to control.  Mark all such DAMON core
struct fields as private.

Patches 1-8 mark the private fields for damon_region, damon_target,
damos_quota_goal, damos_quota, damos_filter, damos, damon_filter and
damon_probe, respectively.  Patch 9 removes DAMON_SYSFS's direct access to
core-private field, damon_ctx->ops.  Finally patch 10 mark the private
fields for damon_ctx.


This patch (of 10):

damon_region->list is intended to be used by only the DAMON core layer. 
But it is mistakenly not marked as private.  Hide it from the callers by
marking it private.

Link: https://lore.kernel.org/20260714143544.101305-1-sj@kernel.org
Link: https://lore.kernel.org/20260714143544.101305-2-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-hide-private-damon_region-fields
+++ a/include/linux/damon.h
@@ -46,7 +46,6 @@ struct damon_size_range {
  * @sampling_addr:	Address of the sample for the next access check.
  * @nr_accesses:	Access frequency of this region.
  * @probe_hits:		Number of probe-positive region samples.
- * @list:		List head for siblings.
  * @age:		Age of this region.
  *
  * For any use case, @ar should be non-zero positive size.  damon_set_regions()
@@ -68,9 +67,11 @@ struct damon_region {
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
 	unsigned char probe_hits[DAMON_MAX_PROBES];
-	struct list_head list;
 	unsigned int age;
-/* private: Internal value for age calculation. */
+/* private: internal use only. */
+	/* List head for siblings. */
+	struct list_head list;
+	/* for age calculation. */
 	unsigned int last_nr_accesses;
 	unsigned char last_probe_hits[DAMON_MAX_PROBES];
 };
_

Patches currently in -mm which might be from sj@kernel.org are


