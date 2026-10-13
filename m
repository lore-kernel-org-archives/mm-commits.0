Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00FD4825A2
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865976; cv=none; b=lnMOEEyq1ssPHMlu9/razP+ClLTzjZcEu80VHXBMr6rueRuqmymB92TvNp1nSYvR9nxH8eX5QGFB+lU3Jjs+rlE+0H5HZQnhVdvWMzJ7T6Peyc1VThoxrTtsMlGbucGm6BaSCrnh3Q1/ZkNFF7M+JD6x2rZQx+kJv9SyHjTBktU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865976; c=relaxed/simple;
	bh=MXqy1rleRAJuvjgtx/SHnxy/geKw7+ayzTW54jnJW6I=;
	h=Date:To:From:Subject:Message-Id; b=hNHkKHs4zUEM1GEnSzma40cSRndit9bQhi+4X4DKdvEBCY2ZwkEUbvK+56BmEZ7xnjvHbeA6wpfDh8ZSuThKP53hcVl2ToOVNiwZfXWh2bxkeoYx0V5fhOyt1QmABmLMnpWvigXnE8HtjbjxE7kKm1cV0Cw0SgALHT6Kh6joKCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nTmK8v1B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nTmK8v1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 761D01F00893;
	Tue, 13 Oct 2026 04:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865975;
	bh=CpYgJkNPDqc1MykOpcAczADFRb/fM/s26OdX+dKCVOE=;
	h=Date:To:From:Subject;
	b=nTmK8v1B36k4qIYkxCzF27k2ztsxDU12x5e9uM/dnyryLiVR86G2JNhMojmbAews6
	 InfyhoCe81uhDbaFQdAa04zXg1U219yvLKcWIxgqSxlp3fzbgCmXX5IGR9rhtlqAsH
	 ics/BZmf8lVkPwGTGuI8GkjpMgfhENOW9Rhnr7Ho=
Date: Mon, 12 Oct 2026 21:32:55 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,gutierrez.asier@huawei-partners.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfs_memcg_path_leak-fail-only-for-real-damon-leak.patch removed from -mm tree
Message-Id: <20261013043255.761D01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs_memcg_path_leak: fail only for real DAMON leak
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfs_memcg_path_leak-fail-only-for-real-damon-leak.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: selftests/damon/sysfs_memcg_path_leak: fail only for real DAMON leak
Date: Thu, 17 Sep 2026 07:22:07 -0700

The selftest can fail for any leak if it happens while the test is
running.  Remove the false positive test failures by further checking if
the expected leaking function is called out on the report.

Link: https://lore.kernel.org/20260917142210.90829-10-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 tools/testing/selftests/damon/sysfs_memcg_path_leak.sh |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh~selftests-damon-sysfs_memcg_path_leak-fail-only-for-real-damon-leak
+++ a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
@@ -41,5 +41,12 @@ if [ "$kmemleak_report" = "" ]
 then
 	exit 0
 fi
+if ! echo "$kmemleak_report" | grep "memcg_path_store" --quiet
+then
+	echo "[WARN] memleak found; apparently not from DAMON, though"
+	echo "$kmemleak_report"
+	exit 0
+fi
+
 echo "$kmemleak_report"
 exit 1
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

