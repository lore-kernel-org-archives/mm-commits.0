Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA591E9B0B
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801605; cv=none; b=Rg3Gv4Og4oB12hzUg7HbTQzrqdLUcYVy8kZylSc1OdepZAum8idlFRLUmWG83mxQ9Uaf9f+dHlHxV9rCnbdmu8rSFzjN5XfPY6shbDRDksqlZwG20FT+8QUGkzOww8gkhxZCaYrJORVz/CbzlUPLWTIk7ZPBW21CIKwUAYWMVfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801605; c=relaxed/simple;
	bh=tSGOPjvkcSCAE9GadBqMK/Tmhtb4SokqPsTB2VOJ55k=;
	h=Date:To:From:Subject:Message-Id; b=SyPNn70AhV9OnMRYWcjx3yYaGfayBxxkr3JAUJsVVWGqkX0arjCPxgqiktzuOJh1GI4icd/xkr7HTmjd4ggzZgt2D/oFGrxwxhLj3YLAxQivn3Yok/f48nfxTHid75D289zo0a4OUr4Ki/YUKt4czolsWHRIT45pFiC820lC5Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UDHy/qxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UDHy/qxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380B8C4CEEB;
	Sat, 13 Sep 2025 22:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801605;
	bh=tSGOPjvkcSCAE9GadBqMK/Tmhtb4SokqPsTB2VOJ55k=;
	h=Date:To:From:Subject:From;
	b=UDHy/qxgfGGFeL1r2Qh2xjBOQzcgaehn5hNCBedQMJ5NlioK87PjK2rx8zIV6moFy
	 wJRB6T4KK3P4Dk45rdFddZT+R1TTsBB8T2IpZaTvJd4Eda4roCHTfIUu3YLfBy2J6q
	 HI/BWAaIfUCwnzRmTiTEenaWQfGsfwfTNp/1iwXI=
Date: Sat, 13 Sep 2025 15:13:24 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,honggyu.kim@sk.com,ekffu200098@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] selftests-damon-test-no-op-commit-broke-damon-status-fix.patch removed from -mm tree
Message-Id: <20250913221325.380B8C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: change wrong json.dump usage to json.dumps
has been removed from the -mm tree.  Its filename was
     selftests-damon-test-no-op-commit-broke-damon-status-fix.patch

This patch was dropped because it was folded into selftests-damon-test-no-op-commit-broke-damon-status.patch

------------------------------------------------------
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: selftests/damon: change wrong json.dump usage to json.dumps
Date: Sat, 16 Aug 2025 10:40:33 +0900

To print drgn status to stdout json.dumps should be used without
json.dump.  Change incorrect function call by typo.

Link: https://lkml.kernel.org/r/20250816014033.190451-1-ekffu200098@gmail.com
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs_no_op_commit_break.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py~selftests-damon-test-no-op-commit-broke-damon-status-fix
+++ a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
@@ -62,8 +62,8 @@ def main():
         exit(1)
 
     if before_commit_status != after_commit_status:
-        print(f'before: {json.dump(before_commit_status, indent=2)}')
-        print(f'after: {json.dump(after_commit_status, indent=2)}')
+        print(f'before: {json.dumps(before_commit_status, indent=2)}')
+        print(f'after: {json.dumps(after_commit_status, indent=2)}')
         exit(1)
 
     kdamonds.stop()
_

Patches currently in -mm which might be from ekffu200098@gmail.com are

mm-damon-update-expired-description-of-damos_action.patch
docs-mm-damon-design-fix-typo-s-sz_trtied-sz_tried.patch
selftests-damon-test-no-op-commit-broke-damon-status.patch
mm-damon-tests-core-kunit-add-damos_commit_filter-test.patch

