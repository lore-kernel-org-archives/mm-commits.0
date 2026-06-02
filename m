Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022C33C4175
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439160; cv=none; b=So3Uz9ulkMQU/s3LaWN+xVN8U7giEeawoZAR+w8tydnBu0s4nSxMWhjlLnJtXNMPMjH39gXQ5eQMeMR0eBxowLj9rNvv2lMCZNUUO6qO/ZqMfqkHa80iNdmWss4X/LNPeffffFlLV3w5QFiMNW9HpsrwOdwdp1KUzltBlRMTxT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439160; c=relaxed/simple;
	bh=iVOLUSNqRaHAAIN8SgWmYdluH003mrr25qeoi4eHlJs=;
	h=Date:To:From:Subject:Message-Id; b=e6V/BtjLVYt13G46X7+9q2nwOEGN9YGoRn8WJbVRzAFREgbwxpH80H6l+DTpF02i+ff0jf/urma4NavYn0AC+PgUY7c0JJFF+s/hjFB86Wng2HApyz9AZ0xHs4WN9alanI9/twxR/Kg7nDVR8MW1z6RY7JCDpBN4WXyUByAIL5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b0mu5UDm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b0mu5UDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42931F00893;
	Tue,  2 Jun 2026 22:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439158;
	bh=OAng7gkh0HLdIFY7CYXq4FyreQ7FL9FDQ4Shi3aS7f4=;
	h=Date:To:From:Subject;
	b=b0mu5UDm5RtN3vtG68RffIKeRzHvi9Ou4+u+Q061fHytz8J97+GpUjaTfEyCOIk0h
	 lGxmI4d/1aZgRVwS+DXofB1jiv2ZdBVSj8uAveCiBZgNwszJKjy9KQeHLv3KvbI20t
	 5cE2wuzAoYF1PHwTeQivUeYTDUfZ2ZxuzxqeDP+4=
Date: Tue, 02 Jun 2026 15:25:58 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-sysfssh-test-monitoring-intervals-goal-dir.patch removed from -mm tree
Message-Id: <20260602222558.C42931F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.sh: test monitoring intervals goal dir
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfssh-test-monitoring-intervals-goal-dir.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/sysfs.sh: test monitoring intervals goal dir
Date: Fri, 22 May 2026 08:40:23 -0700

sysfs.sh DAMON selftest is not testing monitoring intervals goal
directory.  Add the test.

Link: https://lore.kernel.org/20260522154026.80546-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-sysfssh-test-monitoring-intervals-goal-dir
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -282,6 +282,17 @@ test_targets()
 	ensure_dir "$targets_dir/1" "not_exist"
 }
 
+
+test_intervals_goal()
+{
+	goal_dir=$1
+	ensure_dir "$goal_dir" "exist"
+	ensure_file "$goal_dir/access_bp" "exist" "600"
+	ensure_file "$goal_dir/aggrs" "exist" "600"
+	ensure_file "$goal_dir/min_sample_us" "exist" "600"
+	ensure_file "$goal_dir/max_sample_us" "exist" "600"
+}
+
 test_intervals()
 {
 	intervals_dir=$1
@@ -289,6 +300,7 @@ test_intervals()
 	ensure_file "$intervals_dir/aggr_us" "exist" "600"
 	ensure_file "$intervals_dir/sample_us" "exist" "600"
 	ensure_file "$intervals_dir/update_us" "exist" "600"
+	test_intervals_goal "$intervals_dir/intervals_goal"
 }
 
 test_damon_filter()
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
maintainers-add-testing-abi-documents-for-mm.patch

