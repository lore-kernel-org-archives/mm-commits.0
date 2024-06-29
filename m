Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279F915E81
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628311; cv=none; b=A1rrPs8izRJL7W0q6Fk6iZLNLfGURQyAJsR2cHaK7CCrY02FZ4DVKbh9T839+BAaS0qyOUemnvWE7o4YFgLhIJ1ZH9NGJXcuFvq1AhPMTI3cBqSDg2kmnWqe9f1MDhk3h/hcFl89c520hk+fO2BSWjW5a0zYNXr8SQZW+7W1mtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628311; c=relaxed/simple;
	bh=+yD1sEiBt6xbP/Fv29MBjmh+qVfrkcMaaSnYdqexEI8=;
	h=Date:To:From:Subject:Message-Id; b=lVfYskybMNi5tHcrUK0WLXlxwRFfIKvrCy8Whlw92IHrlnZnt37ns7I45z5n86WBhIqk0j4alyYxUBrBozv5d4fYB/EVWNgC7r4/wGDoOnC0Di+M6vJphrVmuIzZFEQV5DU5c2Plzs7GnhOgeI4hhNRynPtwj6CGohF6AsCJSu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jI5XcHxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jI5XcHxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F378BC32781;
	Sat, 29 Jun 2024 02:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628311;
	bh=+yD1sEiBt6xbP/Fv29MBjmh+qVfrkcMaaSnYdqexEI8=;
	h=Date:To:From:Subject:From;
	b=jI5XcHxqX9GyR3yXWpa+MfLLjDVj3+X7fWwZeMsajEilT+d+r+Rn/lyEt5WPOMobz
	 TX35qGY7nzaeuZ891KK79A959Vcqxhv+ZgPExBrR5XTVftlpyPIT7DfrxAFJENP79/
	 FFiuqblRXWTDuD1g+T0VTYe2Ik+c0vMPQzT7g9rE=
Date: Fri, 28 Jun 2024 19:31:50 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] _damon_sysfs-implement-commit-for-online-parameters-update.patch removed from -mm tree
Message-Id: <20240629023150.F378BC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: _damon_sysfs: implement commit() for online parameters update
has been removed from the -mm tree.  Its filename was
     _damon_sysfs-implement-commit-for-online-parameters-update.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: _damon_sysfs: implement commit() for online parameters update
Date: Tue, 25 Jun 2024 11:05:37 -0700

Users can update DAMON parameters while it is running, using 'commit'
DAMON sysfs interface command.  For testing the feature in future tests,
implement a function for doing that on the test-purpose DAMON sysfs
interface wrapper Python module.

Link: https://lkml.kernel.org/r/20240625180538.73134-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   19 ++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~_damon_sysfs-implement-commit-for-online-parameters-update
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -481,6 +481,25 @@ class Kdamond:
                     goal.effective_bytes = int(content)
         return None
 
+    def commit(self):
+        nr_contexts_file = os.path.join(self.sysfs_dir(),
+                'contexts', 'nr_contexts')
+        content, err = read_file(nr_contexts_file)
+        if err is not None:
+            return err
+        if int(content) != len(self.contexts):
+            err = write_file(nr_contexts_file, '%d' % len(self.contexts))
+            if err is not None:
+                return err
+
+        for context in self.contexts:
+            err = context.stage()
+            if err is not None:
+                return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'commit')
+        return err
+
+
     def commit_schemes_quota_goals(self):
         for context in self.contexts:
             for scheme in context.schemes:
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch

