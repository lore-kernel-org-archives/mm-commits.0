Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318A363C11
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 20:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A2MJfMs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C125CC433C7;
	Tue, 12 Dec 2023 20:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702412960;
	bh=vuvZnvGFo6luAyxuHbGNt+o5pW17DxF2k16X99/9IiM=;
	h=Date:To:From:Subject:From;
	b=A2MJfMs7q2wns7bm1kzyrbIfS2ynzJ1DTPDyHA56Xm44QCxe7BpKGCWWmhVFHGB7k
	 viRD2jE1W31CnANiYU/dBruFc4W3sQHHZKqLkgadk/UBtCXQANiMExQrP0DSxyWnHn
	 D6WKMHYmMfRcH4o0kCuNXh1P8Uf7mefhaHIDOjzw=
Date: Tue, 12 Dec 2023 12:29:20 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command.patch added to mm-unstable branch
Message-Id: <20231212202920.C125CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: implement updat_schemes_tried_bytes command
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command.patch

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

mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch
selftests-damon-implement-a-python-module-for-test-purpose-damon-sysfs-controls.patch
selftests-damon-_damon_sysfs-implement-kdamonds-start-function.patch
selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-sysfs-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug.patch

