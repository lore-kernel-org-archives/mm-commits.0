Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF19222333B
	for <mm-commits@vger.kernel.org>; Sat, 26 Jul 2025 22:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753567815; cv=none; b=X/n7YgTIStHNygA0MXBmC7EBp54cWXXf4GvJhoRYKBuGAfYRRsO7NEMr4JuoPtsHbkOlpo7ooAcsXPMah/CBhXxlHOCdPcGYiqTuuDMAP9V9suTi2SlEp6fW2yv8rxOIvTsWnFNvRYAbM+vazboP1ps5iyzrbF1hNEsdX3uXZcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753567815; c=relaxed/simple;
	bh=fQfofhTf1+TuqEx2XPDRZnEHBvYbeKRMyXpLyWadsTk=;
	h=Date:To:From:Subject:Message-Id; b=dxQjqyFKIHqZgNjKzAWQsgWWmL9kQHL0O7/7g/KLSDY779WKluHqapkjvM1N3iTCWmMbtqAKzz0NtyLC08vueyBnTVOS1TIIWVNJtna4zlvgZ75OuZ8558jHa4yLX7qBPopMs9UC0BHTUB8uE7JhWhwxvEtIllr3EdLs5ijfZe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UIViK9qv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UIViK9qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E4AC4CEED;
	Sat, 26 Jul 2025 22:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753567814;
	bh=fQfofhTf1+TuqEx2XPDRZnEHBvYbeKRMyXpLyWadsTk=;
	h=Date:To:From:Subject:From;
	b=UIViK9qvQtj1Dcd9IGbWaAm3FeorhW0E3ZYIVkDE26gjWJA1lyg9PjCJ0JPoJTNgq
	 LCLLAwmkJPhsC1QGgwnNFJgox1iThRydZfrkDOoNHSWGTAmwa+7poKUH8OfwlRf8Ql
	 J0pUdXXnS5UJzwiyDIYzozmhTG39cwUTIeNkYDu8=
Date: Sat, 26 Jul 2025 15:10:13 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-use-232-1-as-max-nr_accesses-and-age.patch removed from -mm tree
Message-Id: <20250726221014.72E4AC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: use 2**32 - 1 as max nr_accesses and age
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-use-232-1-as-max-nr_accesses-and-age.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: use 2**32 - 1 as max nr_accesses and age
Date: Sun, 20 Jul 2025 10:16:38 -0700

nr_accesses and age are unsigned int.  Use the proper max value.

Link: https://lkml.kernel.org/r/20250720171652.92309-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-use-232-1-as-max-nr_accesses-and-age
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -52,9 +52,9 @@ class DamosAccessPattern:
         if self.size is None:
             self.size = [0, 2**64 - 1]
         if self.nr_accesses is None:
-            self.nr_accesses = [0, 2**64 - 1]
+            self.nr_accesses = [0, 2**32 - 1]
         if self.age is None:
-            self.age = [0, 2**64 - 1]
+            self.age = [0, 2**32 - 1]
 
     def sysfs_dir(self):
         return os.path.join(self.scheme.sysfs_dir(), 'access_pattern')
_

Patches currently in -mm which might be from sj@kernel.org are


