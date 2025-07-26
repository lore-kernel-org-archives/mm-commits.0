Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA50F2264C6
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567816; cv=none; b=TUFl5PB8fryqURmmFEPh3bVzGpTlxRlujr4cxYCBl1txn7nutfCjnUnf5ln/wWDEz3No1UES8R6IuHoD2b8NVxLmFYkqPq1582CiXEydd2ufnlne2zVB2yj7vVbEZjjMma1X+A1M+PQ7UU3TLIXLGysCMVK4eVsg5k+q2XZwEeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567816; c=relaxed/simple;
	bh=053bgJ2g7dMt1zxTjeyr3cfGhDZrECCLltW0ec3A6AU=;
	h=Date:To:From:Subject:Message-Id; b=mQSKMwUFMial7bmkcN/B2kH/XQEBe77WDaotObMDhY4TZ7LNIBm0ryIS3cVZS5o6cd4HXCOgE26YbNoe9iO6mMtIRFlsF354jL41/nDijmKqWHBgUMIlins9HX9murCJqskPUGxDwegpIagQORlJObbNLwnoEOyVznWwXSzGZW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vnSzSnMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vnSzSnMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF87CC4CEED;
	Sat, 26 Jul 2025 22:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567816;
	bh=053bgJ2g7dMt1zxTjeyr3cfGhDZrECCLltW0ec3A6AU=;
	h=Date:To:From:Subject:From;
	b=vnSzSnMBe67UV4D4S7YJ/uATKQU10nQUlEXdUydg6MUFKe83K57z72nR+Y45jyfag
	 8rOEgPJnNsFxgak20fYrgyWH5v7qIFbw5DBUdf0BCy6HeqndJ95XY7a8qjLO3vuitW
	 nYCydbgRCXCGp3iI9rJCaLmsN/vAYZylW2tVqRSE=
Date: Sat, 26 Jul 2025 15:10:16 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-drgn_dump_damon_status-dump-ctx-opsid.patch removed from -mm tree
Message-Id: <20250726221016.AF87CC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/drgn_dump_damon_status: dump ctx->ops.id
has been removed from the -mm tree.  Its filename was
     selftests-damon-drgn_dump_damon_status-dump-ctx-opsid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/drgn_dump_damon_status: dump ctx->ops.id
Date: Sun, 20 Jul 2025 10:16:40 -0700

drgn_dump_damon_status.py is a script for dumping DAMON internal status in
json format.  It is being used for seeing if DAMON parameters that are set
using _damon_sysfs.py are actually passed to DAMON in the kernel space. 
It is, however, not dumping full DAMON internal status, and it makes
increasing test coverage difficult.  Add ctx->ops.id dumping for more
tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/drgn_dump_damon_status.py |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py~selftests-damon-drgn_dump_damon_status-dump-ctx-opsid
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -25,6 +25,11 @@ def to_dict(object, attr_name_converter)
         d[attr_name] = converter(getattr(object, attr_name))
     return d
 
+def ops_to_dict(ops):
+    return to_dict(ops, [
+        ['id', int],
+        ])
+
 def intervals_goal_to_dict(goal):
     return to_dict(goal, [
         ['access_bp', int],
@@ -148,6 +153,7 @@ def schemes_to_list(schemes):
 
 def damon_ctx_to_dict(ctx):
     return to_dict(ctx, [
+        ['ops', ops_to_dict],
         ['attrs', attrs_to_dict],
         ['adaptive_targets', targets_to_list],
         ['schemes', schemes_to_list],
_

Patches currently in -mm which might be from sj@kernel.org are


