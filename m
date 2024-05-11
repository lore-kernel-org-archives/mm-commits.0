Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9D01CD0C
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467328; cv=none; b=QtMH569EbhEFG6ojS4D0oOkLjDzZrxa6x3LqmhVaAivXvWex30HovlE+t0iOsLz48KMSbYn0fWyKvavFoxyQ0Fj1vVAoTpX5+D74U+7HGGtoQUzlX1pggLlM6Ut2UaP71ukpykaQYSS0vOGlHdlkhda+cdTNeoyIUHrf88HRPsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467328; c=relaxed/simple;
	bh=mlS3v2VkZqjGjQP/Ng2d6ulY6PwUi/pz9ZiThvBjLhs=;
	h=Date:To:From:Subject:Message-Id; b=SsVaXNjYjlV1+iad48ePdkflIeWBfa8FX9fc+YZB+fnkyXsyompNgCe4GbRUveoaLhKCWucxiGkOa7kmSoYHAA8wVtBpUpBe0KIdBHDV1twsgPUUQMriVb4bBmn9q1//Oltw+7iV0cOpfPl3rfXESp/U6XWvS/cSaXjUVt/mzaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=em1ioeCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="em1ioeCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDEBC4AF0C;
	Sat, 11 May 2024 22:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467327;
	bh=mlS3v2VkZqjGjQP/Ng2d6ulY6PwUi/pz9ZiThvBjLhs=;
	h=Date:To:From:Subject:From;
	b=em1ioeCazXDcWXs0jDKA1641s/zKS/8UC5MSkAvShgb7T4oaT76i8Kl6/biS3oZ/l
	 LfgGlQ18atnUoLvVX5OsBF3n3hjn/hs+K4VdsaGSBLMFMXGN8CSzxYtIXit5cOBXfO
	 ReAlJh5Wcx28bEuMPOlc24RR7y2Epscu/tmnfIcA=
Date: Sat, 11 May 2024 15:42:07 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch removed from -mm tree
Message-Id: <20240511224207.ACDEBC4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: check errors from nr_schemes file reads
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: check errors from nr_schemes file reads
Date: Fri, 3 May 2024 11:03:10 -0700

DAMON context staging method in _damon_sysfs.py is not checking the
returned error from nr_schemes file read.  Check it.

Link: https://lkml.kernel.org/r/20240503180318.72798-3-sj@kernel.org
Fixes: f5f0e5a2bef9 ("selftests/damon/_damon_sysfs: implement kdamonds start function")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -341,6 +341,8 @@ class DamonCtx:
         nr_schemes_file = os.path.join(
                 self.sysfs_dir(), 'schemes', 'nr_schemes')
         content, err = read_file(nr_schemes_file)
+        if err is not None:
+            return err
         if int(content) != len(self.schemes):
             err = write_file(nr_schemes_file, '%d' % len(self.schemes))
             if err != None:
_

Patches currently in -mm which might be from sj@kernel.org are


