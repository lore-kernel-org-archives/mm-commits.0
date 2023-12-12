Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A2B80031
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b1EflIJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D1DC433C7;
	Tue, 12 Dec 2023 18:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407574;
	bh=6V4N4Ggp5oDXbr5wUO+MQpqWf5E6tBhGPlqC1WLjy5E=;
	h=Date:To:From:Subject:From;
	b=b1EflIJfKIQgz+1PuNgm/foohzAM6Jkb/MzjDxSl/uLThO6iS907LA+Xn1PLMncvq
	 gXB6ox6XpBJcvSreDe+THxY9IKS+B/UR8ZOUNDiyHX1V4dwwzsE7jgwMnztniTLevY
	 U1zDVCphlz47EeGWZTj46KatTyXjmeA+hAzC2RI0=
Date: Tue, 12 Dec 2023 10:59:33 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-test-quota-goals-directory.patch removed from -mm tree
Message-Id: <20231212185934.22D1DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: test quota goals directory
has been removed from the -mm tree.  Its filename was
     selftests-damon-test-quota-goals-directory.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon: test quota goals directory
Date: Thu, 30 Nov 2023 02:36:49 +0000

Add DAMON selftests for testing creation/existence of quota goals
directories and files, and simple valid input writes.

Link: https://lkml.kernel.org/r/20231130023652.50284-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.sh |   27 +++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.sh~selftests-damon-test-quota-goals-directory
+++ a/tools/testing/selftests/damon/sysfs.sh
@@ -150,6 +150,32 @@ test_weights()
 	ensure_file "$weights_dir/age_permil" "exist" "600"
 }
 
+test_goal()
+{
+	goal_dir=$1
+	ensure_dir "$goal_dir" "exist"
+	ensure_file "$goal_dir/target_value" "exist" "600"
+	ensure_file "$goal_dir/current_value" "exist" "600"
+}
+
+test_goals()
+{
+	goals_dir=$1
+	ensure_dir "$goals_dir" "exist"
+	ensure_file "$goals_dir/nr_goals" "exist" "600"
+
+	ensure_write_succ  "$goals_dir/nr_goals" "1" "valid input"
+	test_goal "$goals_dir/0"
+
+	ensure_write_succ  "$goals_dir/nr_goals" "2" "valid input"
+	test_goal "$goals_dir/0"
+	test_goal "$goals_dir/1"
+
+	ensure_write_succ  "$goals_dir/nr_goals" "0" "valid input"
+	ensure_dir "$goals_dir/0" "not_exist"
+	ensure_dir "$goals_dir/1" "not_exist"
+}
+
 test_quotas()
 {
 	quotas_dir=$1
@@ -158,6 +184,7 @@ test_quotas()
 	ensure_file "$quotas_dir/bytes" "exist" 600
 	ensure_file "$quotas_dir/reset_interval_ms" "exist" 600
 	test_weights "$quotas_dir/weights"
+	test_goals "$quotas_dir/goals"
 }
 
 test_access_pattern()
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch

