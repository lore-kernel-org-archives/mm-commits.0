Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDAF21A43A
	for <mm-commits@vger.kernel.org>; Fri, 10 Jan 2025 22:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549777; cv=none; b=C8iyYNbpX74QPKTP3N7PlAazeV6OO5q2lOVpOecZVU4iZgipBMHJq86W3Bot+x9DcOdwI8VYxCHuWC20Jmd228vWhlp0RqXU/ZxMMYvDIgvBcMaGD7+w1Dk6/FmTr0NGYvIu0jOq34pGbkCcPdeU9/wuCIut/FXfuIoecBiYnWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549777; c=relaxed/simple;
	bh=3+ovh0y5gcnpmfBwkOSISxBOqZXqaZ9A73tG3fw9Mwk=;
	h=Date:To:From:Subject:Message-Id; b=EDRY+5DkBnwoL8waBFS2HA+aL6hdhSf5DDWNqdSeShtqtxXTL1zYKffpRdHXg4k5ziqDqg5gyPmspySaU/vINIcP1PdwjEYqtdUtFa+C0FsEECK27okHZ2q3OxFdnlvojwJAtBb6klBmpFhEw4BrSWWeKDZTdBQhGZL6lkl1kGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gE+IoKIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gE+IoKIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6169DC4CED6;
	Fri, 10 Jan 2025 22:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736549776;
	bh=3+ovh0y5gcnpmfBwkOSISxBOqZXqaZ9A73tG3fw9Mwk=;
	h=Date:To:From:Subject:From;
	b=gE+IoKIzR1gTOkpPbvRI9TzFkC2M91oMioBaYrDv2CjejE8BoQkNa69FVxG9GIpse
	 NGwixR/RhkWpSGE2JLRzTGOXCrq3aPgaLdXsuXGrd2eot3EdepSZxOtSn6MIQxao4m
	 OO5KjVSljgVO9OfqqDTZCbhG33QSr7kjJaCU4n2U=
Date: Fri, 10 Jan 2025 14:56:15 -0800
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-start-update-snapshot-example.patch added to mm-unstable branch
Message-Id: <20250110225616.6169DC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/start: update snapshot example
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-start-update-snapshot-example.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-start-update-snapshot-example.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/start: update snapshot example
Date: Fri, 10 Jan 2025 10:52:31 -0800

Two of DAMON user-space tool (damo) commands that are used for examples on
DAMON getting started document, namely 'damo show' and 'damo report heats'
are deprecated[1,2], and replaced by new commands that provides same
functions with unified and simplified user interfaces.  Also the example
output of 'damo show' is outdated.  'damo schemes' command is not
deprecated, but users are recommended to use 'damo start' or 'damo tune'
instead.

Update the examples to use the replacements, recommendations, and
up-to-date output formats.

[1] https://git.kernel.org/sj/damo/c/3272e0ac94ecc5e1
[2] https://git.kernel.org/sj/damo/c/da3ec66bbdd9e87d

Link: https://lkml.kernel.org/r/20250110185232.54907-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Yunjeong Mun <yunjeong.mun@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/start.rst |   67 ++++++++++-------
 1 file changed, 40 insertions(+), 27 deletions(-)

--- a/Documentation/admin-guide/mm/damon/start.rst~docs-admin-guide-mm-damon-start-update-snapshot-example
+++ a/Documentation/admin-guide/mm/damon/start.rst
@@ -42,32 +42,45 @@ the execution. ::
 
     $ git clone https://github.com/sjp38/masim; cd masim; make
     $ sudo damo start "./masim ./configs/stairs.cfg --quiet"
-    $ sudo ./damo show
-    0   addr [85.541 TiB  , 85.541 TiB ) (57.707 MiB ) access 0 %   age 10.400 s
-    1   addr [85.541 TiB  , 85.542 TiB ) (413.285 MiB) access 0 %   age 11.400 s
-    2   addr [127.649 TiB , 127.649 TiB) (57.500 MiB ) access 0 %   age 1.600 s
-    3   addr [127.649 TiB , 127.649 TiB) (32.500 MiB ) access 0 %   age 500 ms
-    4   addr [127.649 TiB , 127.649 TiB) (9.535 MiB  ) access 100 % age 300 ms
-    5   addr [127.649 TiB , 127.649 TiB) (8.000 KiB  ) access 60 %  age 0 ns
-    6   addr [127.649 TiB , 127.649 TiB) (6.926 MiB  ) access 0 %   age 1 s
-    7   addr [127.998 TiB , 127.998 TiB) (120.000 KiB) access 0 %   age 11.100 s
-    8   addr [127.998 TiB , 127.998 TiB) (8.000 KiB  ) access 40 %  age 100 ms
-    9   addr [127.998 TiB , 127.998 TiB) (4.000 KiB  ) access 0 %   age 11 s
-    total size: 577.590 MiB
-    $ sudo ./damo stop
+    $ sudo damo report access
+    heatmap: 641111111000000000000000000000000000000000000000000000[...]33333333333333335557984444[...]7
+    # min/max temperatures: -1,840,000,000, 370,010,000, column size: 3.925 MiB
+    0   addr 86.182 TiB   size 8.000 KiB   access 0 %   age 14.900 s
+    1   addr 86.182 TiB   size 8.000 KiB   access 60 %  age 0 ns
+    2   addr 86.182 TiB   size 3.422 MiB   access 0 %   age 4.100 s
+    3   addr 86.182 TiB   size 2.004 MiB   access 95 %  age 2.200 s
+    4   addr 86.182 TiB   size 29.688 MiB  access 0 %   age 14.100 s
+    5   addr 86.182 TiB   size 29.516 MiB  access 0 %   age 16.700 s
+    6   addr 86.182 TiB   size 29.633 MiB  access 0 %   age 17.900 s
+    7   addr 86.182 TiB   size 117.652 MiB access 0 %   age 18.400 s
+    8   addr 126.990 TiB  size 62.332 MiB  access 0 %   age 9.500 s
+    9   addr 126.990 TiB  size 13.980 MiB  access 0 %   age 5.200 s
+    10  addr 126.990 TiB  size 9.539 MiB   access 100 % age 3.700 s
+    11  addr 126.990 TiB  size 16.098 MiB  access 0 %   age 6.400 s
+    12  addr 127.987 TiB  size 132.000 KiB access 0 %   age 2.900 s
+    total size: 314.008 MiB
+    $ sudo damo stop
 
 The first command of the above example downloads and builds an artificial
 memory access generator program called ``masim``.  The second command asks DAMO
-to execute the artificial generator process start via the given command and
-make DAMON monitors the generator process.  The third command retrieves the
-current snapshot of the monitored access pattern of the process from DAMON and
-shows the pattern in a human readable format.
-
-Each line of the output shows which virtual address range (``addr [XX, XX)``)
-of the process is how frequently (``access XX %``) accessed for how long time
-(``age XX``).  For example, the fifth region of ~9 MiB size is being most
-frequently accessed for last 300 milliseconds.  Finally, the fourth command
-stops DAMON.
+to start the program via the given command and make DAMON monitors the newly
+started process.  The third command retrieves the current snapshot of the
+monitored access pattern of the process from DAMON and shows the pattern in a
+human readable format.
+
+The first line of the output shows the relative access temperature (hotness) of
+the regions in a single row hetmap format.  Each column on the heatmap
+represents regions of same size on the monitored virtual address space.  The
+position of the colun on the row and the number on the column represents the
+relative location and access temperature of the region.  ``[...]`` means
+unmapped huge regions on the virtual address spaces.  The second line shows
+additional information for better understanding the heatmap.
+
+Each line of the output from the third line shows which virtual address range
+(``addr XX size XX``) of the process is how frequently (``access XX %``)
+accessed for how long time (``age XX``).  For example, the evelenth region of
+~9.5 MiB size is being most frequently accessed for last 3.7 seconds.  Finally,
+the fourth command stops DAMON.
 
 Note that DAMON can monitor not only virtual address spaces but multiple types
 of address spaces including the physical address space.
@@ -95,7 +108,7 @@ Visualizing Recorded Patterns
 You can visualize the pattern in a heatmap, showing which memory region
 (x-axis) got accessed when (y-axis) and how frequently (number).::
 
-    $ sudo damo report heats --heatmap stdout
+    $ sudo damo report heatmap
     22222222222222222222222222222222222222211111111111111111111111111111111111111100
     44444444444444444444444444444444444444434444444444444444444444444444444444443200
     44444444444444444444444444444444444444433444444444444444444444444444444444444200
@@ -160,6 +173,6 @@ Data Access Pattern Aware Memory Managem
 Below command makes every memory region of size >=4K that has not accessed for
 >=60 seconds in your workload to be swapped out. ::
 
-    $ sudo damo schemes --damos_access_rate 0 0 --damos_sz_region 4K max \
-                        --damos_age 60s max --damos_action pageout \
-                        <pid of your workload>
+    $ sudo damo start --damos_access_rate 0 0 --damos_sz_region 4K max \
+                      --damos_age 60s max --damos_action pageout \
+                      <pid of your workload>
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch
mm-damon-clarify-trying-vs-applying-on-damos_stat-kernel-doc-comment.patch
docs-mm-damon-design-add-statistics-section.patch
docs-admin-guide-mm-damon-usage-link-damos-stat-design-doc.patch
mm-damon-ask-apply_scheme-to-report-filter-passed-region-internal-bytes.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-normal-actions.patch
mm-damon-paddr-report-filter-passed-bytes-back-for-damos_stat-action.patch
mm-damon-core-implement-per-scheme-ops-handled-filter-passed-bytes-stat.patch
mm-damon-syfs-schemes-implement-per-scheme-filter-passed-bytes-stat.patch
docs-mm-damon-design-document-sz_ops_filter_passed.patch
docs-admin-guide-mm-damon-usage-document-sz_ops_filter_passed.patch
docs-abi-damon-document-per-scheme-filter-passed-bytes-stat-file.patch
mm-damon-core-pass-per-region-filter-passed-bytes-to-damos_walk_control-walk_fn.patch
mm-damon-sysfs-schemes-expose-per-region-filter-passed-bytes.patch
docs-mm-damon-design-document-per-region-sz_filter_passed-stat.patch
docs-admin-guide-mm-damon-usage-document-sz_filtered_out-of-scheme-tried-region-directories.patch
docs-abi-damon-document-per-region-damos-filter-passed-bytes-stat-file.patch
docs-translations-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-fixup-damos_filter-kernel-doc.patch
mm-damon-core-add-damos_filter-allow-field.patch
mm-damon-core-support-damos_filter-allow.patch
mm-damon-paddr-support-damos_filter-allow.patch
mm-damon-add-allow-argument-to-damos_new_filter.patch
mm-damon-sysfs-schemes-add-a-file-for-setting-damos_filter-allow.patch
docs-mm-damon-design-document-allow-reject-damos-filter-behaviors.patch
docs-abi-damon-document-damos-filter-allow-sysfs-file.patch
docs-admin-guide-mm-damon-usage-omit-damos-filter-details-in-favor-of-design-doc.patch
docs-admin-guide-mm-damon-usage-document-damos-filter-allow-sysfs-file.patch
docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

