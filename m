Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CDD01758B
	for <mm-commits@vger.kernel.org>; Sat, 31 May 2025 23:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748732731; cv=none; b=QE3W1lMCYUhYSRRC5azmIHLGhk4qmawUStsxzeeMq/Z8tIxc/PdXjjmHHeIiyALQ6s0AfiZkODHNCtv4WuLXQ7qyWxpeHEvrlPr+Fs1oBxF4KfRUS186Fv74ru056Dg7euqi50136+IaWeAv9lNiydHdpmFDe5WC5nq+Ku/Vdv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748732731; c=relaxed/simple;
	bh=yxhk9E+A6SF21Xso7H3Ggjd/hr8caYad2GGc7+fCQRA=;
	h=Date:To:From:Subject:Message-Id; b=iUMyhKbCGhpYZdB2LXN9tDDcrpN9FN499b3hSjM+YNh/KbFe77oi+rELseop7hzBOT1oAXAGfUrwks4Q1IMLiXSz/NXoQdqMK0vzu3Iz3Eosg3M6+czQikN8VSx33Z5muYvtDW/egtwFEVEbVYZxa/CotJ4f9nnkJv7CQUqLwf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uM88oZ1z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uM88oZ1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4ECC4CEE3;
	Sat, 31 May 2025 23:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748732730;
	bh=yxhk9E+A6SF21Xso7H3Ggjd/hr8caYad2GGc7+fCQRA=;
	h=Date:To:From:Subject:From;
	b=uM88oZ1zKSv7UpCRpGr2Jn8II6MYUfX9BHZRxGy1DN4PL2rSYrEXsoQNVzDTTKfjB
	 4ftxj9dykg9CJREevquXLDzNbL7lbDSMK+r8zO2Ki/e8daei/5bl3EEiLd2WzJof+S
	 JnDctKz68Vxaupp0bsEpLCt83QGHlO5A6f9JZcpg=
Date: Sat, 31 May 2025 16:05:30 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,shuah@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-skip-testcases-if-config_damon_sysfs-is-disabled.patch added to mm-unstable branch
Message-Id: <20250531230530.8B4ECC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: skip testcases if CONFIG_DAMON_SYSFS is disabled
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-_damon_sysfs-skip-testcases-if-config_damon_sysfs-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-skip-testcases-if-config_damon_sysfs-is-disabled.patch

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
From: Enze Li <lienze@kylinos.cn>
Subject: selftests/damon/_damon_sysfs: skip testcases if CONFIG_DAMON_SYSFS is disabled
Date: Sat, 31 May 2025 17:39:37 +0800

When CONFIG_DAMON_SYSFS is disabled, the selftests fail with the following
outputs,

not ok 2 selftests: damon: sysfs_update_schemes_tried_regions_wss_estimation.py # exit=1
not ok 3 selftests: damon: damos_quota.py # exit=1
not ok 4 selftests: damon: damos_quota_goal.py # exit=1
not ok 5 selftests: damon: damos_apply_interval.py # exit=1
not ok 6 selftests: damon: damos_tried_regions.py # exit=1
not ok 7 selftests: damon: damon_nr_regions.py # exit=1
not ok 11 selftests: damon: sysfs_update_schemes_tried_regions_hang.py # exit=1

The root cause of this issue is that all the testcases above do not check
the sysfs interface of DAMON whether it exists or not.  With this patch
applied, all the testcases above now pass successfully.

Link: https://lkml.kernel.org/r/20250531093937.1555159-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-skip-testcases-if-config_damon_sysfs-is-disabled
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -15,6 +15,10 @@ if sysfs_root is None:
     print('Seems sysfs not mounted?')
     exit(ksft_skip)
 
+if not os.path.exists(sysfs_root):
+    print('Seems DAMON disabled?')
+    exit(ksft_skip)
+
 def write_file(path, string):
     "Returns error string if failed, or None otherwise"
     string = '%s' % string
_

Patches currently in -mm which might be from lienze@kylinos.cn are

selftests-damon-_damon_sysfs-skip-testcases-if-config_damon_sysfs-is-disabled.patch

