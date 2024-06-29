Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242B615E81
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628309; cv=none; b=BCrVdk7Z1OqPPxDIablYpGrSYt0VTwLMRnx0hrPp/kH3rHKhw4FbaIMq7eW2Lr+NGUuz1OzZq8p9u/YdoFVDIHuOCcpT+0E7KOgF8qjTYfOmtAhdDm0Q1mo2LgoSMLJbb8vUWaI3CTAKI1WuB1LSp6Mry6ZNupMM8H2aruyj/PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628309; c=relaxed/simple;
	bh=8YbYg5/BYkW4wiWj5rDPcjIpnJI7OEMlD2dKjSDee94=;
	h=Date:To:From:Subject:Message-Id; b=fFTtofhg6OiSv5KPD0DQwsLoZ5xjUwrauyWwy269YjjDQ2Pv5fNg5qstsum25qnMR39hHCy0Gq01CoEFyjLTg8iZWCYxpSWAa3aTnpQngOUcbvugUp52lJlLPjesOLocrL8bpDdwcyodubblmAhJtISEqvNetpfBy/JihD9MFL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jthUNngs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jthUNngs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08CFC32781;
	Sat, 29 Jun 2024 02:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628309;
	bh=8YbYg5/BYkW4wiWj5rDPcjIpnJI7OEMlD2dKjSDee94=;
	h=Date:To:From:Subject:From;
	b=jthUNngs3CvdSjj5Tr1cpOInYensQH+3zgua+0F9y0XJLUetvtcvOasSEqk2q1bNd
	 q6isLCAl6y6JatAZQql+Z4TaCt7JdvPk/S224Ykv5VXLqhbzk5jSK4YJxtu7FTnl5y
	 3EwEpWUDg8Rba8vHqVr3axa/gTwGH43UwXgqLvWA=
Date: Fri, 28 Jun 2024 19:31:48 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-implement-kdamonds-stop-function.patch removed from -mm tree
Message-Id: <20240629023148.F08CFC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: implement kdamonds stop function
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-implement-kdamonds-stop-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: implement kdamonds stop function
Date: Tue, 25 Jun 2024 11:05:35 -0700

Implement DAMON stop function on the test-purpose DAMON sysfs interface
wrapper Python module, _damon_sysfs.py.  This feature will be used by
future DAMON tests that need to start/stop DAMON multiple times.

Link: https://lkml.kernel.org/r/20240625180538.73134-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-implement-kdamonds-stop-function
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -406,6 +406,10 @@ class Kdamond:
         err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'on')
         return err
 
+    def stop(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'off')
+        return err
+
     def update_schemes_tried_regions(self):
         err = write_file(os.path.join(self.sysfs_dir(), 'state'),
                          'update_schemes_tried_regions')
@@ -511,3 +515,10 @@ class Kdamonds:
             if err is not None:
                 return err
         return None
+
+    def stop(self):
+        for kdamond in self.kdamonds:
+            err = kdamond.stop()
+            if err is not None:
+                return err
+        return None
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix.patch
mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet-fix-2.patch

