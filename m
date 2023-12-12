Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662498002D
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tA0X+ysa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F00DC433C8;
	Tue, 12 Dec 2023 18:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407576;
	bh=/92QXVEkw7wn4JZENPmJ4Af+rtOR2GOji6eBhllnh1o=;
	h=Date:To:From:Subject:From;
	b=tA0X+ysau/v4lpdfbzbFns/+2Ba0AEhnAPemy6QuJR/uuJsU0uq2u9xekUW3xbaCh
	 p1WUoelRtLJsPIusnhQlvZ/YiMEUIbAbrtfntbixZG0+p3kK163voATlwbBUt5KeMc
	 sembcnrDjPwSnSLASEnXCKKcqozVYLq59C0IiF48=
Date: Tue, 12 Dec 2023 10:59:35 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendanhiggins@google.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-damos-quota-goals.patch removed from -mm tree
Message-Id: <20231212185936.2F00DC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document DAMOS quota goals
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-damos-quota-goals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document DAMOS quota goals
Date: Thu, 30 Nov 2023 02:36:51 +0000

Update DAMON ABI document for the newly added DAMON sysfs files and inputs
for DAMOS quota goals.

Link: https://lkml.kernel.org/r/20231130023652.50284-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   33 +++++++++++---
 1 file changed, 27 insertions(+), 6 deletions(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-damos-quota-goals
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -25,12 +25,14 @@ Description:	Writing 'on' or 'off' to th
 		stops, respectively.  Reading the file returns the keywords
 		based on the current status.  Writing 'commit' to this file
 		makes the kdamond reads the user inputs in the sysfs files
-		except 'state' again.  Writing 'update_schemes_stats' to the
-		file updates contents of schemes stats files of the kdamond.
-		Writing 'update_schemes_tried_regions' to the file updates
-		contents of 'tried_regions' directory of every scheme directory
-		of this kdamond.  Writing 'update_schemes_tried_bytes' to the
-		file updates only '.../tried_regions/total_bytes' files of this
+		except 'state' again.  Writing 'commit_schemes_quota_goals' to
+		this file makes the kdamond reads the quota goal files again.
+		Writing 'update_schemes_stats' to the file updates contents of
+		schemes stats files of the kdamond.  Writing
+		'update_schemes_tried_regions' to the file updates contents of
+		'tried_regions' directory of every scheme directory of this
+		kdamond.  Writing 'update_schemes_tried_bytes' to the file
+		updates only '.../tried_regions/total_bytes' files of this
 		kdamond.  Writing 'clear_schemes_tried_regions' to the file
 		removes contents of the 'tried_regions' directory.
 
@@ -212,6 +214,25 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the quotas
 		charge reset interval of the scheme in milliseconds.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/nr_goals
+Date:		Nov 2023
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for setting automatic tuning of the scheme's
+		aggressiveness named '0' to 'N-1' under the goals/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/target_value
+Date:		Nov 2023
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the target
+		value of the goal metric.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/current_value
+Date:		Nov 2023
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the current
+		value of the goal metric.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch

