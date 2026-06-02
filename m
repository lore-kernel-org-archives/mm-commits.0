Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245C23C4B6F
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439161; cv=none; b=TtGfJjL9JTsmtFpnSjscCAJH7fP3SXG3YQZDbU7JoYzYAFoPVE4nHt355qGwYwLCZgusZpdO4QGgUSZOiOD8C0c8dEkchFBuEAlhWE4d5UZsY7hLiVNkBzXcQFetmyQRcL8V3KZM6cv0aj8crtbGo7KQuxSyrHY5gCAzxQ12R3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439161; c=relaxed/simple;
	bh=lElf+naDEkM+NByDRjj+lUz5jc/y2DMVczqnctT/LW0=;
	h=Date:To:From:Subject:Message-Id; b=R7LFy7ebNbRPwvyjaFnRHcuFJapdP96sDGnkcMMgXoewO5/DITwc10huGtwSeG+ryXzbGp8Z4suwnIHFKSbu0Kca86V8mtEbLaKe6nbthg7IMhKFPUV39b2SPS0FCMgjvdAPYVeCSfa6WTCdx99+muCwdBOwI3RSYO+bYg6a0SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=14+c7pD2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="14+c7pD2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2951F00898;
	Tue,  2 Jun 2026 22:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439160;
	bh=Nw/uHxjAwy1J24zUFb4jmhUkAPbofiYJUBhAWOmzcYE=;
	h=Date:To:From:Subject;
	b=14+c7pD2e2PqfG239+XTrvJQ6i639iOyvj3hDUxEMrDaL7Re0R6Of1i2qFQ5M31rT
	 5kp0DfTpwND8Y/Fi8canpXnidEX7AeRxVgMhP/8wxBuyh1VzVXkROg2l+PzQB7XZ0S
	 qTS39Ok0qF7Jel4x27qy2/igkq+ZXzdg2vxXqTq8=
Date: Tue, 02 Jun 2026 15:25:59 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfssh-test-addr_unit-file-existence.patch removed from -mm tree
Message-Id: <20260602222559.EB2951F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.sh: test addr_unit file existence
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfssh-test-addr_unit-file-existence.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.sh: test addr_unit file existence
Date: Fri, 22 May 2026 08:40:24 -0700

sysfs.sh DAMON selftest is not testing the existence of addr_unit sysfs
file.  Add the test.

Link: https://lore.kernel.org/20260522154026.80546-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-sysfssh-test-addr_unit-file-existence
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -365,6 +365,7 @@ test_context()
 	ensure_dir "$context_dir" "exist"
 	ensure_file "$context_dir/avail_operations" "exit" 400
 	ensure_file "$context_dir/operations" "exist" 600
+	ensure_file "$context_dir/addr_unit" "exist" 600
 	test_monitoring_attrs "$context_dir/monitoring_attrs"
 	test_targets "$context_dir/targets"
 	test_schemes "$context_dir/schemes"
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

