Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAD83CDBB1
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 02:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437641; cv=none; b=u8jFwXaBD0MjS9adhJH/TKQug1ivk86dQo7pJkwJqbPLUDKPiT0sLgxCS0qGrzlA+IyLlnu8/3dn8zTeg2qpPSxDbKKyLqebY9byrj8YxFkn1XfEaBrwF97AduZz/g2LN8kO08n73lk8V/v8qv20ofeW1ZYXRDk6Z7PhnJNYKbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437641; c=relaxed/simple;
	bh=6BrcpZK0KtYK7FJYNMCST8lAPsk06ADFauWhoWaQFT4=;
	h=Date:To:From:Subject:Message-Id; b=MaR+nUTgE2rwOK4cI1AKr23ZkIAIxDDvNAEHjXQbOh1kgVVzxA1oSSb7Oml7W6kXdeDZI+UrDWqWvqe0yH167QxCCa2B5O+5fjtvyqQ2+lSURo/tx3bDLpA4YbsfP1RgcbhxI3e6gSqxrFlOlFMVz8qXJmKJ8V5a1+1z6ivFq4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=df71X4Aw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="df71X4Aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A231F000FF;
	Tue, 15 Sep 2026 02:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789437639;
	bh=CE3wocUNNL2dw6jHlXXKzOe9qzoFtW5Y0+5ApOtOxEk=;
	h=Date:To:From:Subject;
	b=df71X4AwMyCGjLWbST1d+UayWnXPFGEKPhzjj6AfCQUM/sZX15vBhS8eiTqc2P4rU
	 WyNn/+fyMm/Pb+8DYMQyYiA08wrpSwxCJtPXMduYXJ6d7wVrnwIAq2nkLb+rgpb3f+
	 8uVSuBlXI+cah9YTBUOklQ9DpnnCAMMJM5+aBY5w=
Date: Mon, 14 Sep 2026 19:00:38 -0700
To: mm-commits@vger.kernel.org,eva.kurchatova@virtuozzo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-add-script-dir-to-syspath-for-pythonsafepath-compatibility.patch added to mm-new branch
Message-Id: <20260915020039.52A231F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: add script dir to sys.path for PYTHONSAFEPATH compatibility
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-add-script-dir-to-syspath-for-pythonsafepath-compatibility.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-add-script-dir-to-syspath-for-pythonsafepath-compatibility.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

selftests-damon-add-script-dir-to-syspath-for-pythonsafepath-compatibility.patch

