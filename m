Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92BF22F15E
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846654; cv=none; b=KHFMj0AvuBAVY3FoR60oEZ0WPtttLCabKfs2thk0Xf+RciC5X1PTPOBy/8hI1kgo9K73Gl6aHoXYgemhISMtfhrSiqqqxwuzhlRmKJbw8/YRSKE0S6ubsFS2XkxtjWi5NXW0cKWfirAh3YwM5x8Vws1+2xmLFmXwdOLnxjXlXPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846654; c=relaxed/simple;
	bh=FpV2MWPNj2uaAw/M0Vs+zSawN0oIn5+uD94QoBbYbsE=;
	h=Date:To:From:Subject:Message-Id; b=VTo8xHtHkDcu0SDzSpy4ZsTQiesLv9Z/Nmm/+Fr1RUVjiypOHx1v1vTKfl0Qe9G5cqGb655y70OhjgfAX6K50DZQU2e+92r4v/khpY4KBRPyvQ4s+2/Z6GFb3kf0F7fo/6ENTFMFMcdr6ZlEVBy5cucI49YLTKNPMKZFLXJtc5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eKQJbeI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eKQJbeI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8966BC4CEE4;
	Wed, 21 May 2025 16:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846654;
	bh=FpV2MWPNj2uaAw/M0Vs+zSawN0oIn5+uD94QoBbYbsE=;
	h=Date:To:From:Subject:From;
	b=eKQJbeI+yok+42fYwYWePJEraihQUanU2NW1gx6ANhhnVqnEcXf8PsjduUPs49zKJ
	 UThKcMBkrmvVUN6gblQm8NMxA3rHZhgJSWKClMxRX3yUUcnrw3tsVfhNXezujxXl8a
	 y37VzX3T6Nh0VpOHvlFqelFiydkLXyuU0ze/sVlE=
Date: Wed, 21 May 2025 09:57:34 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch removed from -mm tree
Message-Id: <20250521165734.8966BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: read tried regions directories in order
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: read tried regions directories in order
Date: Mon, 12 May 2025 17:27:14 -0700

Kdamond.update_schemes_tried_regions() reads and stores tried regions
information out of address order.  It makes debugging a test failure
difficult.  Change the behavior to do the reading and writing in the
address order.

Link: https://lkml.kernel.org/r/20250513002715.40126-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -420,11 +420,16 @@ class Kdamond:
                 tried_regions = []
                 tried_regions_dir = os.path.join(
                         scheme.sysfs_dir(), 'tried_regions')
+                region_indices = []
                 for filename in os.listdir(
                         os.path.join(scheme.sysfs_dir(), 'tried_regions')):
                     tried_region_dir = os.path.join(tried_regions_dir, filename)
                     if not os.path.isdir(tried_region_dir):
                         continue
+                    region_indices.append(int(filename))
+                for region_idx in sorted(region_indices):
+                    tried_region_dir = os.path.join(tried_regions_dir,
+                                                    '%d' % region_idx)
                     region_values = []
                     for f in ['start', 'end', 'nr_accesses', 'age']:
                         content, err = read_file(
_

Patches currently in -mm which might be from sj@kernel.org are


