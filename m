Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816C878F5E
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976899; cv=none; b=FfB2vNpciqSJQMPKgjAg5q1cj7TNx2jgqFABJbHFbPrB5UuQLDmp8UpkCrvTnhDGrEuX74x9BlX7stwQeZVBYNcKx6SRHVSdxnFc4egu7TvxZBgJGUkVVW4WmxULe6ZA8Wf1ZUlDLdR5JJzEaLc1oYcE8PX6teCcLISHnQzD1GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976899; c=relaxed/simple;
	bh=NdTipXgsxzfDdtT11BUcxKd1gRQmtpCAYqmFQAP6GVI=;
	h=Date:To:From:Subject:Message-Id; b=CLL0vKDaL2J17aLo7HqGU9RLS/4YABYbqwLs4CCiFSImAtbS1bHPGY5DqD4sjMsNWtuyBUQPiaaN6D56ABG3PzLPeuAZ3EoS2Ybs35B0KtU/lirmXoCEb8bD+lflukayTGRVEBYyRxq6ethP1Zspj7WvwOZFdtPZfMyCFziUU7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iS+cb16b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iS+cb16b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A04C4CEE3;
	Sun, 20 Jul 2025 02:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976899;
	bh=NdTipXgsxzfDdtT11BUcxKd1gRQmtpCAYqmFQAP6GVI=;
	h=Date:To:From:Subject:From;
	b=iS+cb16bBSud5vX6RbwU+Gf8SIccIT38h7HrEoMo8wGlArTRdlJuWx9DOzECq1kBc
	 owpkg+X2vNIgToDwkJ7jfsMcEX5deeohk3s39flHRuSf9HDORlb/PwNRUtKaKOYL6T
	 BmyDCc13xcHPV5T+q+QVmB2pGjAs49g9fAjyZodM=
Date: Sat, 19 Jul 2025 19:01:38 -0700
To: mm-commits@vger.kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-schemes-dests-directory.patch removed from -mm tree
Message-Id: <20250720020139.55A04C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document schemes dests directory
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-schemes-dests-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document schemes dests directory
Date: Tue, 8 Jul 2025 19:59:35 -0500

Document the new DAMOS action destinations sysfs directories on ABI doc.

Link: https://lkml.kernel.org/r/20250709005952.17776-6-bijan311@gmail.com
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bijan Tabatabai <bijantabatab@micron.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   22 ++++++++++++++
 1 file changed, 22 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-schemes-dests-directory
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -431,6 +431,28 @@ Description:	Directory for DAMON operati
 		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters
 		directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/dests/nr_dests
+Date:		Jul 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for setting action destinations of the scheme named
+		'0' to 'N-1' under the dests/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/dests/<D>/id
+Date:		Jul 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the id of
+		the DAMOS action destination.  For DAMOS_MIGRATE_{HOT,COLD}
+		actions, the destination node's node id can be written and
+		read.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/dests/<D>/weight
+Date:		Jul 2025
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the weight
+		of the DAMOS action destination to select as the destination of
+		each action among the destinations.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/stats/nr_tried
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

