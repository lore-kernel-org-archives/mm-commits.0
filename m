Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD484D107
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GaHxbD1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892A5C433C8;
	Wed, 20 Dec 2023 22:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112561;
	bh=B/U19jhrXFKZUjRYIF0tOK1Imn9BMbFd1f4snHVFMtU=;
	h=Date:To:From:Subject:From;
	b=GaHxbD1kuTg0lOLh1hj5EjqqPvF1M9Kh/CIULCzlj55qOJjCnVpdGWNuOtHqNXXWR
	 27KDua/NJ2hm7OM7MOI6Goq7zfMP2ch1X/LE72GEN53qPOgaTvyFeAlp9WPDQu+NG2
	 WwBq2HLykbYJro7GIR+xNKnoXBLBnJULb/0c8ZJo=
Date: Wed, 20 Dec 2023 14:49:21 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command.patch removed from -mm tree
Message-Id: <20231220224921.892A5C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: implement updat_schemes_tried_bytes command
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: implement updat_schemes_tried_bytes command
Date: Tue, 12 Dec 2023 19:48:08 +0000

Implement update_schemes_tried_bytes command of DAMON sysfs interface in
_damon_sysfs.py.  It is not only making the update, but also read the
updated value from the sysfs interface and store it in the Kdamond python
objects so that the user of the module can easily get the value.

Link: https://lkml.kernel.org/r/20231212194810.54457-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -76,6 +76,7 @@ class Damos:
     # todo: Support quotas, watermarks, stats, tried_regions
     idx = None
     context = None
+    tried_bytes = None
 
     def __init__(self, action='stat', access_pattern=DamosAccessPattern()):
         self.action = action
@@ -284,6 +285,19 @@ class Kdamond:
         err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'on')
         return err
 
+    def update_schemes_tried_bytes(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'state'),
+                'update_schemes_tried_bytes')
+        if err != None:
+            return err
+        for context in self.contexts:
+            for scheme in context.schemes:
+                content, err = read_file(os.path.join(scheme.sysfs_dir(),
+                    'tried_regions', 'total_bytes'))
+                if err != None:
+                    return err
+                scheme.tried_bytes = int(content)
+
 class Kdamonds:
     kdamonds = []
 
_

Patches currently in -mm which might be from sj@kernel.org are


