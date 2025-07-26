Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F3122333B
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567815; cv=none; b=gvzC3RipfOzg/PPwANziUboEsAGQTWEx+YqQ0tkWjQ68qmWwIkR5tW9w4Ssyi+uZWtVEwLyAN1pAkrtRtddzAFqgCRnxAYs8Gm8xfPjENFKkWyI9Ji2AVhbhWxGIiatOXhqWcYhTDQeB6Gy5liaZy0jNozCVmZe0n3+2U7RZzTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567815; c=relaxed/simple;
	bh=IyMgQBVt0fi7SJyEOgNAKuSCZHXjcup+3P6ElgLMyDw=;
	h=Date:To:From:Subject:Message-Id; b=UeM0bubGH/DG16Qow/744xY2IzlNYTnCHHuFvYbLEytpqdp7FOxZgTRw90ZTbxakZAxPwHq/Noq3S5t5chs590HeVXyX2ZDRcfqBi8TZjyRqsfBnZSt3TRzXznsNh2YpYz9pMqJHDjN46wn6032cLq9qUcyoAQAEvNzaFWKz86w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tNahwJ3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tNahwJ3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9536FC4CEED;
	Sat, 26 Jul 2025 22:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567815;
	bh=IyMgQBVt0fi7SJyEOgNAKuSCZHXjcup+3P6ElgLMyDw=;
	h=Date:To:From:Subject:From;
	b=tNahwJ3JNkvSHV83WiIlDnI4afe2Ep/sM/9WIezXhL4qlt+f4ZAV9UM1pGQMwxzFU
	 wZAP8Cg0p+1xqrXUak9i2NmAUp7ToqTzKCmOGTjM2xy02Qcyg/2xRWWXMBTPetV2Ti
	 wM0slOz9r77EUqW2t1HSpU8WashjT1eYUA2SVjUM=
Date: Sat, 26 Jul 2025 15:10:15 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-drgn_dump_damon_status-dump-damos-migrate_dests.patch removed from -mm tree
Message-Id: <20250726221015.9536FC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/drgn_dump_damon_status: dump damos->migrate_dests
has been removed from the -mm tree.  Its filename was
     selftests-damon-drgn_dump_damon_status-dump-damos-migrate_dests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/drgn_dump_damon_status: dump damos->migrate_dests
Date: Sun, 20 Jul 2025 10:16:39 -0700

drgn_dump_damon_status.py is a script for dumping DAMON internal status in
json format.  It is being used for seeing if DAMON parameters that are set
using _damon_sysfs.py are actually passed to DAMON in the kernel space. 
It is, however, not dumping full DAMON internal status, and it makes
increasing test coverage difficult.  Add damos->migrate_dests dumping for
more tests.

Link: https://lkml.kernel.org/r/20250720171652.92309-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/drgn_dump_damon_status.py |   14 ++++++++++
 1 file changed, 14 insertions(+)

--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py~selftests-damon-drgn_dump_damon_status-dump-damos-migrate_dests
+++ a/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -117,6 +117,19 @@ def damos_watermarks_to_dict(watermarks)
         ['high', int], ['mid', int], ['low', int],
         ])
 
+def damos_migrate_dests_to_dict(dests):
+    nr_dests = int(dests.nr_dests)
+    node_id_arr = []
+    weight_arr = []
+    for i in range(nr_dests):
+        node_id_arr.append(int(dests.node_id_arr[i]))
+        weight_arr.append(int(dests.weight_arr[i]))
+    return {
+            'node_id_arr': node_id_arr,
+            'weight_arr': weight_arr,
+            'nr_dests': nr_dests,
+            }
+
 def scheme_to_dict(scheme):
     return to_dict(scheme, [
         ['pattern', damos_access_pattern_to_dict],
@@ -125,6 +138,7 @@ def scheme_to_dict(scheme):
         ['quota', damos_quota_to_dict],
         ['wmarks', damos_watermarks_to_dict],
         ['target_nid', int],
+        ['migrate_dests', damos_migrate_dests_to_dict],
         ])
 
 def schemes_to_list(schemes):
_

Patches currently in -mm which might be from sj@kernel.org are


