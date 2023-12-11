Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329865246
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zh6xPPLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F3EC433C7;
	Mon, 11 Dec 2023 00:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256139;
	bh=V/0l2b6K6hthBYAXWc7soUDLw8cO2w/P9J0ASq4RDt4=;
	h=Date:To:From:Subject:From;
	b=zh6xPPLFM3qa7Dn+K3dmT8irb1pHnha4R9UqgKtWZRQ87PyddtzOsx4t7frqK2IHi
	 uDJ/yWf3JhjDibbEj2RL0U6tU9Q6AwBTb2LgHZG6v3e3dtWcJEy+k0KJw3vvhJG6MD
	 s+Ik5b8BPZWxnDwJx5uaXu6Gk+fVpkOtyEDqjrdk=
Date: Sun, 10 Dec 2023 16:55:38 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,ddrokosov@salutedevices.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-introduce-new-samples-subdir-for-cgroup.patch removed from -mm tree
Message-Id: <20231211005538.F1F3EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples: introduce new samples subdir for cgroup
has been removed from the -mm tree.  Its filename was
     samples-introduce-new-samples-subdir-for-cgroup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dmitry Rokosov <ddrokosov@salutedevices.com>
Subject: samples: introduce new samples subdir for cgroup
Date: Thu, 23 Nov 2023 10:19:43 +0300

Patch series "samples: introduce cgroup events listeners", v3.

To begin with, this patch series relocates the cgroup example code to the
samples/cgroup directory, which is the appropriate location for such code
snippets.

Furthermore, a new memcg events listener is introduced.  This listener is
a simple yet effective tool for monitoring memory events and managing
counter changes during runtime.

Additionally, as per Andrew Morton's suggestion, a helpful reminder
comment is included in the memcontrol implementation.  This comment serves
to ensure that the samples code is updated whenever new events are added.


This patch (of 3):

Move the cgroup_event_listener for cgroup v1 to the samples directory. 
This suggestion was proposed by Andrew Morton during the discussion [1].

Link: https://lore.kernel.org/all/20231106140934.3f5d4960141562fe8da53906@linux-foundation.org/ [1]
Link: https://lkml.kernel.org/r/20231123071945.25811-1-ddrokosov@salutedevices.com
Link: https://lkml.kernel.org/r/20231123071945.25811-2-ddrokosov@salutedevices.com
Signed-off-by: Dmitry Rokosov <ddrokosov@salutedevices.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                            |    1 
 samples/Kconfig                        |    6 +
 samples/Makefile                       |    1 
 samples/cgroup/Makefile                |    5 +
 samples/cgroup/cgroup_event_listener.c |   83 +++++++++++++++++++++++
 tools/cgroup/Makefile                  |   11 ---
 tools/cgroup/cgroup_event_listener.c   |   83 -----------------------
 7 files changed, 96 insertions(+), 94 deletions(-)

--- a/MAINTAINERS~samples-introduce-new-samples-subdir-for-cgroup
+++ a/MAINTAINERS
@@ -5339,6 +5339,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/memcontrol.c
 F:	mm/swap_cgroup.c
+F:	samples/cgroup/*
 F:	tools/testing/selftests/cgroup/memcg_protection.m
 F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
 F:	tools/testing/selftests/cgroup/test_kmem.c
--- /dev/null
+++ a/samples/cgroup/cgroup_event_listener.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * cgroup_event_listener.c - Simple listener of cgroup events
+ *
+ * Copyright (C) Kirill A. Shutemov <kirill@shutemov.name>
+ */
+
+#include <assert.h>
+#include <err.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <libgen.h>
+#include <limits.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <sys/eventfd.h>
+
+#define USAGE_STR "Usage: cgroup_event_listener <path-to-control-file> <args>"
+
+int main(int argc, char **argv)
+{
+	int efd = -1;
+	int cfd = -1;
+	int event_control = -1;
+	char event_control_path[PATH_MAX];
+	char line[LINE_MAX];
+	int ret;
+
+	if (argc != 3)
+		errx(1, "%s", USAGE_STR);
+
+	cfd = open(argv[1], O_RDONLY);
+	if (cfd == -1)
+		err(1, "Cannot open %s", argv[1]);
+
+	ret = snprintf(event_control_path, PATH_MAX, "%s/cgroup.event_control",
+			dirname(argv[1]));
+	if (ret >= PATH_MAX)
+		errx(1, "Path to cgroup.event_control is too long");
+
+	event_control = open(event_control_path, O_WRONLY);
+	if (event_control == -1)
+		err(1, "Cannot open %s", event_control_path);
+
+	efd = eventfd(0, 0);
+	if (efd == -1)
+		err(1, "eventfd() failed");
+
+	ret = snprintf(line, LINE_MAX, "%d %d %s", efd, cfd, argv[2]);
+	if (ret >= LINE_MAX)
+		errx(1, "Arguments string is too long");
+
+	ret = write(event_control, line, strlen(line) + 1);
+	if (ret == -1)
+		err(1, "Cannot write to cgroup.event_control");
+
+	while (1) {
+		uint64_t result;
+
+		ret = read(efd, &result, sizeof(result));
+		if (ret == -1) {
+			if (errno == EINTR)
+				continue;
+			err(1, "Cannot read from eventfd");
+		}
+		assert(ret == sizeof(result));
+
+		ret = access(event_control_path, W_OK);
+		if ((ret == -1) && (errno == ENOENT)) {
+			puts("The cgroup seems to have removed.");
+			break;
+		}
+
+		if (ret == -1)
+			err(1, "cgroup.event_control is not accessible any more");
+
+		printf("%s %s: crossed\n", argv[1], argv[2]);
+	}
+
+	return 0;
+}
--- /dev/null
+++ a/samples/cgroup/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0
+
+userprogs-always-y += cgroup_event_listener
+
+userccflags += -I usr/include
--- a/samples/Kconfig~samples-introduce-new-samples-subdir-for-cgroup
+++ a/samples/Kconfig
@@ -285,6 +285,12 @@ config SAMPLE_KMEMLEAK
           Build a sample program which have explicitly leaks memory to test
           kmemleak
 
+config SAMPLE_CGROUP
+	bool "Build cgroup sample code"
+	depends on CGROUPS && CC_CAN_LINK && HEADERS_INSTALL
+	help
+	  Build samples that demonstrate the usage of the cgroup API.
+
 source "samples/rust/Kconfig"
 
 endif # SAMPLES
--- a/samples/Makefile~samples-introduce-new-samples-subdir-for-cgroup
+++ a/samples/Makefile
@@ -3,6 +3,7 @@
 
 subdir-$(CONFIG_SAMPLE_AUXDISPLAY)	+= auxdisplay
 subdir-$(CONFIG_SAMPLE_ANDROID_BINDERFS) += binderfs
+subdir-$(CONFIG_SAMPLE_CGROUP) += cgroup
 obj-$(CONFIG_SAMPLE_CONFIGFS)		+= configfs/
 obj-$(CONFIG_SAMPLE_CONNECTOR)		+= connector/
 obj-$(CONFIG_SAMPLE_FANOTIFY_ERROR)	+= fanotify/
--- a/tools/cgroup/cgroup_event_listener.c
+++ /dev/null
@@ -1,83 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * cgroup_event_listener.c - Simple listener of cgroup events
- *
- * Copyright (C) Kirill A. Shutemov <kirill@shutemov.name>
- */
-
-#include <assert.h>
-#include <err.h>
-#include <errno.h>
-#include <fcntl.h>
-#include <libgen.h>
-#include <limits.h>
-#include <stdio.h>
-#include <string.h>
-#include <unistd.h>
-
-#include <sys/eventfd.h>
-
-#define USAGE_STR "Usage: cgroup_event_listener <path-to-control-file> <args>"
-
-int main(int argc, char **argv)
-{
-	int efd = -1;
-	int cfd = -1;
-	int event_control = -1;
-	char event_control_path[PATH_MAX];
-	char line[LINE_MAX];
-	int ret;
-
-	if (argc != 3)
-		errx(1, "%s", USAGE_STR);
-
-	cfd = open(argv[1], O_RDONLY);
-	if (cfd == -1)
-		err(1, "Cannot open %s", argv[1]);
-
-	ret = snprintf(event_control_path, PATH_MAX, "%s/cgroup.event_control",
-			dirname(argv[1]));
-	if (ret >= PATH_MAX)
-		errx(1, "Path to cgroup.event_control is too long");
-
-	event_control = open(event_control_path, O_WRONLY);
-	if (event_control == -1)
-		err(1, "Cannot open %s", event_control_path);
-
-	efd = eventfd(0, 0);
-	if (efd == -1)
-		err(1, "eventfd() failed");
-
-	ret = snprintf(line, LINE_MAX, "%d %d %s", efd, cfd, argv[2]);
-	if (ret >= LINE_MAX)
-		errx(1, "Arguments string is too long");
-
-	ret = write(event_control, line, strlen(line) + 1);
-	if (ret == -1)
-		err(1, "Cannot write to cgroup.event_control");
-
-	while (1) {
-		uint64_t result;
-
-		ret = read(efd, &result, sizeof(result));
-		if (ret == -1) {
-			if (errno == EINTR)
-				continue;
-			err(1, "Cannot read from eventfd");
-		}
-		assert(ret == sizeof(result));
-
-		ret = access(event_control_path, W_OK);
-		if ((ret == -1) && (errno == ENOENT)) {
-			puts("The cgroup seems to have removed.");
-			break;
-		}
-
-		if (ret == -1)
-			err(1, "cgroup.event_control is not accessible any more");
-
-		printf("%s %s: crossed\n", argv[1], argv[2]);
-	}
-
-	return 0;
-}
--- a/tools/cgroup/Makefile
+++ /dev/null
@@ -1,11 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-# Makefile for cgroup tools
-
-CFLAGS = -Wall -Wextra
-
-all: cgroup_event_listener
-%: %.c
-	$(CC) $(CFLAGS) -o $@ $^
-
-clean:
-	$(RM) cgroup_event_listener
_

Patches currently in -mm which might be from ddrokosov@salutedevices.com are


