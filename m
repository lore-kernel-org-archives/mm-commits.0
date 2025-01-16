Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8701898ED
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006290; cv=none; b=LztfzyRBYTo3BLnwActhXSQYr5e4oMm54HqxtYzY/UbOnSY6kpIe0GnzUOLcV2FTAjekDToyjuW7iJf2z4J6LbPBUJhV+8XaVs5Dnp5NLtcLkhm0MXp2pRLqnIaGB4Ui6Gx3FpcgSJa+9SnariT0HBURovUODtQM3CfOyZBRpAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006290; c=relaxed/simple;
	bh=EyaoL9BdFx2fM3Fi/aUEfTbzgYXTBz5jAH6jaf9zo/4=;
	h=Date:To:From:Subject:Message-Id; b=tQFvVD7h30pUpwYeikWTGjap1GbzEBSN+iovSHuGVb2H7ZR1bqwEyIgNYlJ0rVqcp72OYpFC8D69tPsTOekDMtIZQJmWTBWmjXkY8HIndyQQuNVtx9wGuYsk9egOsLKJ4AJS4tthkH5oUwVVGw9K9vR3T8XhaFk6cewsvdMweoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jvEQBgNl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jvEQBgNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE9AC4CED6;
	Thu, 16 Jan 2025 05:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006290;
	bh=EyaoL9BdFx2fM3Fi/aUEfTbzgYXTBz5jAH6jaf9zo/4=;
	h=Date:To:From:Subject:From;
	b=jvEQBgNlZy+5rfH3nJqjPlxSADzSNV1z/7lyUZYy/H1EvPFNT0AfbfiYqTKKv1cwK
	 DgiPR4vD9cRxdk+sgjSxPpI1IOjFYrA67Ry1qrPioYZnuhGWe+ZLsl6cj8Pf+CUn1w
	 3ZhO+RSZxc1iwemY9jTYnyvk/EuIwVOVNc/xIJYc=
Date: Wed, 15 Jan 2025 21:44:49 -0800
To: mm-commits@vger.kernel.org,yunjeong.mun@sk.com,honggyu.kim@sk.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-start-update-snapshot-example.patch removed from -mm tree
Message-Id: <20250116054450.7AE9AC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/start: update snapshot example
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-start-update-snapshot-example.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


