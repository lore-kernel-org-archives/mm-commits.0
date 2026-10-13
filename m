Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211D547045E
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865912; cv=none; b=haE1ZJfoyvbDEGO4PGjZR7LK9/a9Cmf+KRtv0jrd+FJlkaDR8PTFvjTY0ELRDAWFSRR4KPfnFtttSJmga1ry4szq8ujBUpKPi+w1wI2Da6eQsd4Nbu8uT4c89x7OjXRXdcvhE4skxPslUJwGqZYaF1Wx1hFwj7hIm+MNOUilkgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865912; c=relaxed/simple;
	bh=86+0YeJrxKDVIkSQXCe6oPSQs1F5dJJ8MDlQPBIL8sQ=;
	h=Date:To:From:Subject:Message-Id; b=nJp1luhYfk+5aDvN0j1b7LXZroc8VUO/w+q+Yq0vneg6wvJ2rI0OtYQBlvStjoA9FHjzW84v+MKjKpP8BzcjdyuFJ4dUlcJ72CwwjeyQUllLeKFqCsXqdCI5tRrmWPEmCsmhBPSFbqc65FSusQjaytyFkyrzyVcrpm8iXBPZ/Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oPUDedLz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oPUDedLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF0E1F000FF;
	Tue, 13 Oct 2026 04:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865910;
	bh=u3uAV48MWkhvhjIyvn8AiuXC66sd1ao2/d8WHDbmGiI=;
	h=Date:To:From:Subject;
	b=oPUDedLzvyUwkTQ9J3E/7MJ01p365k6TOdjZuVy1WtQA/w7NQ6SYTbiJtwB8f0dAE
	 1i3CyoWsaiX7Uv3geggVp9NfGBc6vHLomp8V4H8znq7xjSXdzXg2CBcLTf8sUV3C0E
	 m0pBHVeFs8Hw+/zyXzSG5gOS67qo6XLxgntCYTNg=
Date: Mon, 12 Oct 2026 21:31:49 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,lianux.mm@gmail.com,liam@infradead.org,kunwu.chan@gmail.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,aethernet65535@gmail.com,eva.kurchatova@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-add-script-dir-to-syspath-for-pythonsafepath-compatibility.patch removed from -mm tree
Message-Id: <20261013043149.EEF0E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon: add script dir to sys.path for PYTHONSAFEPATH compatibility
has been removed from the -mm tree.  Its filename was
     selftests-damon-add-script-dir-to-syspath-for-pythonsafepath-compatibility.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Subject: selftests/damon: add script dir to sys.path for PYTHONSAFEPATH compatibility
Date: Mon, 14 Sep 2026 07:19:48 -0700

Running these tests under Python's safe path mode, either with -P on the
interpreter command line or with PYTHONSAFEPATH set in the environment,
stops the script's own directory being prepended to sys.path.  Some
distributions (RHEL, for example) build the tests with -P in the shebang.

This breaks all 7 DAMON Python selftests that import the _damon_sysfs
helper module located in the same directory:

  ModuleNotFoundError: No module named '_damon_sysfs'

Fix this by explicitly adding the script's directory to sys.path before
importing _damon_sysfs, following the same pattern used in commit
c3b3eb565bd7 ("tools: ynl: add script dir to sys.path") which fixed the
identical issue for the YNL tools.

Link: https://lore.kernel.org/20260914141952.91465-4-sj@kernel.org
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
---

 tools/testing/selftests/damon/damon_nr_regions.py                                  |    3 +++
 tools/testing/selftests/damon/damos_apply_interval.py                              |    3 +++
 tools/testing/selftests/damon/damos_quota.py                                       |    3 +++
 tools/testing/selftests/damon/damos_quota_goal.py                                  |    3 +++
 tools/testing/selftests/damon/damos_tried_regions.py                               |    3 +++
 tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py           |    3 +++
 tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py |    3 +++
 7 files changed, 21 insertions(+)

--- a/tools/testing/selftests/damon/damon_nr_regions.py~selftests-damon-add-script-dir-to-syspath-for-pythonsafepath-compatibility
+++ a/tools/testing/selftests/damon/damon_nr_regions.py
@@ -1,9 +1,12 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 
+import os
 import subprocess
+import sys
 import time
 
+sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
 
 def test_nr_regions(real_nr_regions, min_nr_regions, max_nr_regions):
--- a/tools/testing/selftests/damon/damos_apply_interval.py~selftests-damon-add-script-dir-to-syspath-for-pythonsafepath-compatibility
+++ a/tools/testing/selftests/damon/damos_apply_interval.py
@@ -1,9 +1,12 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 
+import os
 import subprocess
+import sys
 import time
 
+sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
 
 def main():
--- a/tools/testing/selftests/damon/damos_quota_goal.py~selftests-damon-add-script-dir-to-syspath-for-pythonsafepath-compatibility
+++ a/tools/testing/selftests/damon/damos_quota_goal.py
@@ -1,9 +1,12 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 
+import os
 import subprocess
+import sys
 import time
 
+sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
 
 def main():
--- a/tools/testing/selftests/damon/damos_quota.py~selftests-damon-add-script-dir-to-syspath-for-pythonsafepath-compatibility
+++ a/tools/testing/selftests/damon/damos_quota.py
@@ -1,9 +1,12 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 
+import os
 import subprocess
+import sys
 import time
 
+sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
 
 def main():
--- a/tools/testing/selftests/damon/damos_tried_regions.py~selftests-damon-add-script-dir-to-syspath-for-pythonsafepath-compatibility
+++ a/tools/testing/selftests/damon/damos_tried_regions.py
@@ -1,9 +1,12 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 
+import os
 import subprocess
+import sys
 import time
 
+sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
 
 def main():
--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py~selftests-damon-add-script-dir-to-syspath-for-pythonsafepath-compatibility
+++ a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py
@@ -1,9 +1,12 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 
+import os
 import subprocess
+import sys
 import time
 
+sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
 
 def main():
--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py~selftests-damon-add-script-dir-to-syspath-for-pythonsafepath-compatibility
+++ a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
@@ -1,9 +1,12 @@
 #!/usr/bin/env python3
 # SPDX-License-Identifier: GPL-2.0
 
+import os
 import subprocess
+import sys
 import time
 
+sys.path.append(os.path.dirname(os.path.abspath(__file__)))
 import _damon_sysfs
 
 def pass_wss_estimation(sz_region):
_

Patches currently in -mm which might be from eva.kurchatova@virtuozzo.com are


