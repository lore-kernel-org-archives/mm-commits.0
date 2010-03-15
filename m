From: akpm@linux-foundation.org
Subject: [merged] cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:08 -0400
Message-ID: <201003150700.o2F70fDj016652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935755Ab0COHBB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:01:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, balbir@linux.vnet.ibm.com, dan@embeddedalley.com, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp, xemul@open


The patch titled
     cgroups: add simple listener of cgroup events to documentation
has been removed from the -mm tree.  Its filename was
     cgroups-add-simple-listener-of-cgroup-events-to-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: add simple listener of cgroup events to documentation
From: "Kirill A. Shutemov" <kirill@shutemov.name>

An example of cgroup notification API usage.

Signed-off-by: Kirill A.  Shutemov <kirill@shutemov.name>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Dan Malek <dan@embeddedalley.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cgroup_event_listener.c |  110 ++++++++++++++++
 1 file changed, 110 insertions(+)

diff -puN /dev/null Documentation/cgroups/cgroup_event_listener.c
--- /dev/null
+++ a/Documentation/cgroups/cgroup_event_listener.c
@@ -0,0 +1,110 @@
+/*
+ * cgroup_event_listener.c - Simple listener of cgroup events
+ *
+ * Copyright (C) Kirill A. Shutemov <kirill@shutemov.name>
+ */
+
+#include <assert.h>
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
+#define USAGE_STR "Usage: cgroup_event_listener <path-to-control-file> <args>\n"
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
+	if (argc != 3) {
+		fputs(USAGE_STR, stderr);
+		return 1;
+	}
+
+	cfd = open(argv[1], O_RDONLY);
+	if (cfd == -1) {
+		fprintf(stderr, "Cannot open %s: %s\n", argv[1],
+				strerror(errno));
+		goto out;
+	}
+
+	ret = snprintf(event_control_path, PATH_MAX, "%s/cgroup.event_control",
+			dirname(argv[1]));
+	if (ret >= PATH_MAX) {
+		fputs("Path to cgroup.event_control is too long\n", stderr);
+		goto out;
+	}
+
+	event_control = open(event_control_path, O_WRONLY);
+	if (event_control == -1) {
+		fprintf(stderr, "Cannot open %s: %s\n", event_control_path,
+				strerror(errno));
+		goto out;
+	}
+
+	efd = eventfd(0, 0);
+	if (efd == -1) {
+		perror("eventfd() failed");
+		goto out;
+	}
+
+	ret = snprintf(line, LINE_MAX, "%d %d %s", efd, cfd, argv[2]);
+	if (ret >= LINE_MAX) {
+		fputs("Arguments string is too long\n", stderr);
+		goto out;
+	}
+
+	ret = write(event_control, line, strlen(line) + 1);
+	if (ret == -1) {
+		perror("Cannot write to cgroup.event_control");
+		goto out;
+	}
+
+	while (1) {
+		uint64_t result;
+
+		ret = read(efd, &result, sizeof(result));
+		if (ret == -1) {
+			if (errno == EINTR)
+				continue;
+			perror("Cannot read from eventfd");
+			break;
+		}
+		assert(ret == sizeof(result));
+
+		ret = access(event_control_path, W_OK);
+		if ((ret == -1) && (errno == ENOENT)) {
+				puts("The cgroup seems to have removed.");
+				ret = 0;
+				break;
+		}
+
+		if (ret == -1) {
+			perror("cgroup.event_control "
+					"is not accessable any more");
+			break;
+		}
+
+		printf("%s %s: crossed\n", argv[1], argv[2]);
+	}
+
+out:
+	if (efd >= 0)
+		close(efd);
+	if (event_control >= 0)
+		close(event_control);
+	if (cfd >= 0)
+		close(cfd);
+
+	return (ret != 0);
+}
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch

