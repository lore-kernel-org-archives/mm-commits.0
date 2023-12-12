Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D7B63C11
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 20:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OuqYlN5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B885CC433C8;
	Tue, 12 Dec 2023 20:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702412956;
	bh=b7vD5wWyaKEwGvaj0tX1CAmm3BRt+2+M7EE1hx2vvho=;
	h=Date:To:From:Subject:From;
	b=OuqYlN5czsMc0JUU1YKXeQz24EWIDkEE2fF7Cyg+kyzXEU+4bxJCZViILfjVa5ksr
	 +S0qKU64NtOA0uDLxtXQ33ybRQQbQVD99jDbcKYM323rLlKy/CQWxaZeo4/w/xVajN
	 hRACuOfm3VANfzV8kjvoUzEeGkHhmAWxYax2AiLI=
Date: Tue, 12 Dec 2023 12:29:15 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-implement-a-python-module-for-test-purpose-damon-sysfs-controls.patch added to mm-unstable branch
Message-Id: <20231212202916.B885CC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon: implement a python module for test-purpose DAMON sysfs controls
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-implement-a-python-module-for-test-purpose-damon-sysfs-controls.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-implement-a-python-module-for-test-purpose-damon-sysfs-controls.patch

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
Subject: selftests/damon: implement a python module for test-purpose DAMON sysfs controls
Date: Tue, 12 Dec 2023 19:48:06 +0000

Patch series "selftests/damon: add Python-written DAMON functionality
tests", v2.

DAMON exports most of its functionality via its sysfs interface.  Hence
most DAMON functionality tests could be implemented using the interface. 
However, because the interfaces require simple but multiple operations for
many controls, writing all such tests from the scratch could be repetitive
and time consuming.

Implement a minimum DAMON sysfs control module, and a couple of DAMON
functionality tests using the control module.  The first test is for
ensuring minimum accuracy of data access monitoring, and the second test
is for finding if a previously found and fixed bug is introduced again.

Note that the DAMON sysfs control module is only for avoiding duplicating
code in tests.  For convenient and general control of DAMON, users should
use DAMON user-space tools that developed for the purpose, such as
damo[1].

[1] https://github.com/damonitor/damo

Patches Sequence
----------------

This patchset is constructed with five patches.  The first three patches
implement a Python-written test implementation-purpose DAMON sysfs control
module.  The implementation is incrementally done in the sequence of the
basic data structure (first patch) first, kdamonds start command (second
patch) next, and finally DAMOS tried bytes update command (third patch).

Then two patches for implementing selftests using the module follows.  The
fourth patch implements a basic functionality test of DAMON for working
set estimation accuracy.  Finally, the fifth patch implements a corner
case test for a previously found bug.


This patch (of 5):

Implement a python module for DAMON sysfs controls.  The module is aimed
to be useful for writing DAMON functionality tests in future. 
Nonetheless, this module is only representing a subset of DAMON sysfs
files.  Following commits will implement more DAMON sysfs controls.

Link: https://lkml.kernel.org/r/20231212194810.54457-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20231212194810.54457-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |  102 ++++++++++++++++
 1 file changed, 102 insertions(+)

--- /dev/null
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -0,0 +1,102 @@
+# SPDX-License-Identifier: GPL-2.0
+
+class DamosAccessPattern:
+    size = None
+    nr_accesses = None
+    age = None
+    scheme = None
+
+    def __init__(self, size=None, nr_accesses=None, age=None):
+        self.size = size
+        self.nr_accesses = nr_accesses
+        self.age = age
+
+        if self.size == None:
+            self.size = [0, 2**64 - 1]
+        if self.nr_accesses == None:
+            self.nr_accesses = [0, 2**64 - 1]
+        if self.age == None:
+            self.age = [0, 2**64 - 1]
+
+class Damos:
+    action = None
+    access_pattern = None
+    # todo: Support quotas, watermarks, stats, tried_regions
+    idx = None
+    context = None
+
+    def __init__(self, action='stat', access_pattern=DamosAccessPattern()):
+        self.action = action
+        self.access_pattern = access_pattern
+        self.access_pattern.scheme = self
+
+class DamonTarget:
+    pid = None
+    # todo: Support target regions if test is made
+    idx = None
+    context = None
+
+    def __init__(self, pid):
+        self.pid = pid
+
+class DamonAttrs:
+    sample_us = None
+    aggr_us = None
+    update_us = None
+    min_nr_regions = None
+    max_nr_regions = None
+    context = None
+
+    def __init__(self, sample_us=5000, aggr_us=100000, update_us=1000000,
+            min_nr_regions=10, max_nr_regions=1000):
+        self.sample_us = sample_us
+        self.aggr_us = aggr_us
+        self.update_us = update_us
+        self.min_nr_regions = min_nr_regions
+        self.max_nr_regions = max_nr_regions
+
+class DamonCtx:
+    ops = None
+    monitoring_attrs = None
+    targets = None
+    schemes = None
+    kdamond = None
+    idx = None
+
+    def __init__(self, ops='paddr', monitoring_attrs=DamonAttrs(), targets=[],
+            schemes=[]):
+        self.ops = ops
+        self.monitoring_attrs = monitoring_attrs
+        self.monitoring_attrs.context = self
+
+        self.targets = targets
+        for idx, target in enumerate(self.targets):
+            target.idx = idx
+            target.context = self
+
+        self.schemes = schemes
+        for idx, scheme in enumerate(self.schemes):
+            scheme.idx = idx
+            scheme.context = self
+
+class Kdamond:
+    state = None
+    pid = None
+    contexts = None
+    idx = None      # index of this kdamond between siblings
+    kdamonds = None # parent
+
+    def __init__(self, contexts=[]):
+        self.contexts = contexts
+        for idx, context in enumerate(self.contexts):
+            context.idx = idx
+            context.kdamond = self
+
+class Kdamonds:
+    kdamonds = []
+
+    def __init__(self, kdamonds=[]):
+        self.kdamonds = kdamonds
+        for idx, kdamond in enumerate(self.kdamonds):
+            kdamond.idx = idx
+            kdamond.kdamonds = self
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-make-damon_start-waits-until-kdamond_fn-starts.patch
selftests-damon-implement-a-python-module-for-test-purpose-damon-sysfs-controls.patch
selftests-damon-_damon_sysfs-implement-kdamonds-start-function.patch
selftests-damon-_damon_sysfs-implement-updat_schemes_tried_bytes-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-sysfs-command.patch
selftests-damon-add-a-test-for-update_schemes_tried_regions-hang-bug.patch

