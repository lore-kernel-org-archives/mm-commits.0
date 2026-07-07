Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD56D2D47E9
	for <mm-commits@vger.kernel.org>; Tue,  7 Jul 2026 19:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783452019; cv=none; b=IUv+O5+hgJTLwx8P8docQVkJhhJDDLGB8gpWU/Bbc/BhXleuQUS8rw+B2PJ2bO1XfM3oRUUC/52r7ziTWJGf0ZLvVWcY5AAGJZGeEQQLuKPcT0tXcSk3uojHnD0u7R9wdaUReLTtE899TuPlaPxgMAtgfn2jl677JP22rgnl6lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783452019; c=relaxed/simple;
	bh=L3AcA5Kts2EJoGwtMICYhoaR/2ETKSqpe1VCwQ8rrrI=;
	h=Date:To:From:Subject:Message-Id; b=WtxJZVQy9sNS8h01V/Qx0X8DEyWO6z12d5ESgMIEt74158VcDIlsm9P9VDadSbfJ54rCJGGt3/j1Ruxvvs3695nSnRGmh7NykOUW9YQ4z9ELQ1ic8IcqFRFrgsoTmqT3ROX4kEvsrr9yLPNZsF2obgi14OKsZATkYsW7yVKsfRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DilSL4LJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DilSL4LJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA0E1F000E9;
	Tue,  7 Jul 2026 19:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783452017;
	bh=yytq7R/WNoaIVM7aFOtzAynfJwqJA6Tb4M0OL19GDCU=;
	h=Date:To:From:Subject;
	b=DilSL4LJpv20dzG4PQWNls0rMN6h+CalcArTQWbq57mMJnFb0v0kj66TIbsQ9XLq5
	 xQIDURXYjQX12/kTcykyaxQsca/s5vPLnAwK0l7r71uQULc6AH5Agtl9cD+bHPoaWD
	 qt6SzAqdBkA9BC5L9y88laTh8OuXX6Vg+TZujV4k=
Date: Tue, 07 Jul 2026 12:20:17 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,zhen.ni@easystack.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-add-page_owner_filter-userspace-tool.patch added to mm-unstable branch
Message-Id: <20260707192017.8BA0E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm: add page_owner_filter userspace tool
has been added to the -mm mm-unstable branch.  Its filename is
     tools-mm-add-page_owner_filter-userspace-tool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-add-page_owner_filter-userspace-tool.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Zhen Ni <zhen.ni@easystack.cn>
Subject: tools/mm: add page_owner_filter userspace tool
Date: Tue, 7 Jul 2026 19:54:10 +0800

Add a userspace filtering tool for page_owner that supports per-fd
filtering with print_mode and NUMA node filters.

Features:
- Three print modes: stack (default), handle, stack_handle
- NUMA node filtering with flexible formats (single: 0, multiple: 0,1,2,
  range: 0-3, mixed: 0,2-3)
- Per-file-descriptor filter state for independent filtering

Usage examples:
  # Filter by print mode
  ./page_owner_filter -m handle
  ./page_owner_filter -m stack_handle

  # Filter by NUMA node
  ./page_owner_filter -n 0
  ./page_owner_filter -n 0-3

  # Combined filters
  ./page_owner_filter -m stack -n 0,1,2
  ./page_owner_filter -m handle -n 0,2-3

The tool validates inputs before sending commands to the kernel and
provides clear error messages when the kernel does not support
per-fd filtering.

Link: https://lore.kernel.org/20260707115411.1714314-4-zhen.ni@easystack.cn
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/Makefile            |    4 
 tools/mm/page_owner_filter.c |  310 +++++++++++++++++++++++++++++++++
 2 files changed, 312 insertions(+), 2 deletions(-)

--- a/tools/mm/Makefile~tools-mm-add-page_owner_filter-userspace-tool
+++ a/tools/mm/Makefile
@@ -3,7 +3,7 @@
 #
 include ../scripts/Makefile.include
 
-BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test
+BUILD_TARGETS=page-types slabinfo page_owner_sort page_owner_filter thp_swap_allocator_test
 INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps
 
 LIB_DIR = ../lib/api
@@ -23,7 +23,7 @@ $(LIBS):
 	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
 
 clean:
-	$(RM) page-types slabinfo page_owner_sort thp_swap_allocator_test
+	$(RM) page-types slabinfo page_owner_sort page_owner_filter thp_swap_allocator_test
 	make -C $(LIB_DIR) clean
 
 sbindir ?= /usr/sbin
diff --git a/tools/mm/page_owner_filter.c a/tools/mm/page_owner_filter.c
new file mode 100644
--- /dev/null
+++ a/tools/mm/page_owner_filter.c
@@ -0,0 +1,310 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * User-space helper to filter page_owner output per-fd
+ *
+ * Example use:
+ *   ./page_owner_filter -m handle
+ *   ./page_owner_filter -m stack_handle
+ *   ./page_owner_filter -n 0,1,2
+ *
+ * See Documentation/mm/page_owner.rst
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <ctype.h>
+#include <getopt.h>
+#include <signal.h>
+
+#define MAX_CMD_LEN	512
+
+static void usage(const char *prog)
+{
+	fprintf(stderr, "Usage: %s [OPTIONS]\n", prog);
+	fprintf(stderr, "\nOptions:\n");
+	fprintf(stderr, "  -m, --mode MODE      : print_mode (stack, handle, or stack_handle)\n");
+	fprintf(stderr, "  -n, --nid NID_LIST   : NUMA node IDs (comma-separated or ranges)\n");
+	fprintf(stderr, "  -o, --output FILE    : output file (default: stdout)\n");
+	fprintf(stderr, "  -h, --help           : show this help message\n");
+	fprintf(stderr, "\nExamples:\n");
+	fprintf(stderr, "  %s -m stack\n", prog);
+	fprintf(stderr, "  %s -m handle\n", prog);
+	fprintf(stderr, "  %s -m stack_handle\n", prog);
+	fprintf(stderr, "  %s -m stack -o output.txt\n", prog);
+	fprintf(stderr, "  %s -n 0,1,2\n", prog);
+	fprintf(stderr, "  %s -m stack -n 0\n", prog);
+}
+
+static int validate_mode(const char *mode)
+{
+	if (strcmp(mode, "stack") == 0 ||
+	    strcmp(mode, "handle") == 0 ||
+	    strcmp(mode, "stack_handle") == 0)
+		return 0;
+
+	fprintf(stderr, "Error: Invalid mode '%s'\n", mode);
+	fprintf(stderr, "Valid modes: stack, handle, stack_handle\n");
+	return -1;
+}
+
+static int validate_nid_list(const char *nid_list)
+{
+	const char *p;
+	int i = 0;
+	int has_digit = 0;
+	int in_range = 0;
+	int prev_num = 0;
+	int curr_num = 0;
+
+	if (!nid_list || strlen(nid_list) == 0)
+		return 0;
+
+	for (p = nid_list; *p; p++) {
+		if (*p == ',') {
+			if (!has_digit) {
+				fprintf(stderr, "Error: Invalid nid_list format\n");
+				return -1;
+			}
+			if (in_range && prev_num > curr_num) {
+				fprintf(stderr,
+					"Error: Invalid range %d-%d (start must be <= end)\n",
+					prev_num, curr_num);
+				return -1;
+			}
+			i = 0;
+			has_digit = 0;
+			in_range = 0;
+			prev_num = 0;
+			curr_num = 0;
+			continue;
+		}
+
+		if (*p == '-') {
+			if (!has_digit) {
+				fprintf(stderr,
+					"Error: Invalid nid_list format ");
+				fprintf(stderr,
+					"(dash without preceding number)\n");
+				return -1;
+			}
+			if (in_range) {
+				fprintf(stderr, "Error: Multiple dashes in nid_list\n");
+				return -1;
+			}
+			prev_num = curr_num;
+			curr_num = 0;
+			i = 0;
+			has_digit = 0;
+			in_range = 1;
+			continue;
+		}
+
+		if (!isdigit((unsigned char)*p)) {
+			fprintf(stderr, "Error: Invalid character '%c' in nid_list\n", *p);
+			return -1;
+		}
+
+		if (i > 5) {
+			fprintf(stderr, "Error: NID too long (max 65536)\n");
+			return -1;
+		}
+		curr_num = curr_num * 10 + (*p - '0');
+		i++;
+		has_digit = 1;
+	}
+
+	if (!has_digit) {
+		fprintf(stderr, "Error: Invalid nid_list format\n");
+		return -1;
+	}
+
+	if (in_range && prev_num > curr_num) {
+		fprintf(stderr,
+			"Error: Invalid range %d-%d (start must be <= end)\n",
+			prev_num, curr_num);
+		return -1;
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	const char *output_file = NULL;
+	char filter_cmd[MAX_CMD_LEN];
+	FILE *output = NULL;
+	int fd = -1;
+	ssize_t ret;
+	char buf[4096];
+	int opt;
+	size_t cmd_len = 0;
+
+	signal(SIGPIPE, SIG_IGN);
+
+	static struct option long_options[] = {
+		{"mode",	required_argument, 0, 'm'},
+		{"nid",		required_argument, 0, 'n'},
+		{"output",	required_argument, 0, 'o'},
+		{"help",	no_argument,	   0, 'h'},
+		{0, 0, 0, 0}
+	};
+
+	filter_cmd[0] = '\0';
+
+	if (argc > 1) {
+		for (int i = 1; i < argc; i++) {
+			if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
+				usage(argv[0]);
+				return 0;
+			}
+		}
+	}
+
+	/* Check if page_owner exists and is readable */
+	if (access("/sys/kernel/debug/page_owner", F_OK) != 0) {
+		if (errno == ENOENT)
+			fprintf(stderr, "Error: /sys/kernel/debug/page_owner does not exist\n");
+		else
+			perror("Error accessing /sys/kernel/debug/page_owner");
+		fprintf(stderr, "Make sure page_owner is enabled in kernel\n");
+		return 1;
+	}
+
+	while ((opt = getopt_long(argc, argv, "m:n:o:h", long_options, NULL)) != -1) {
+		int len;
+
+		switch (opt) {
+		case 'm': {
+			const char *mode = optarg;
+
+			if (validate_mode(mode) < 0)
+				return 1;
+			len = snprintf(filter_cmd + cmd_len, MAX_CMD_LEN - cmd_len,
+				       "%smode=%s", cmd_len > 0 ? " " : "", mode);
+			if (len < 0 || cmd_len + len >= MAX_CMD_LEN) {
+				fprintf(stderr, "Error: Command too long\n");
+				return 1;
+			}
+			cmd_len += len;
+			break;
+		}
+		case 'n': {
+			const char *nid_list = optarg;
+
+			if (validate_nid_list(nid_list) < 0)
+				return 1;
+			len = snprintf(filter_cmd + cmd_len, MAX_CMD_LEN - cmd_len,
+				       "%snid=%s", cmd_len > 0 ? " " : "", nid_list);
+			if (len < 0 || cmd_len + len >= MAX_CMD_LEN) {
+				fprintf(stderr, "Error: Command too long\n");
+				return 1;
+			}
+			cmd_len += len;
+			break;
+		}
+		case 'o':
+			output_file = optarg;
+			break;
+		case 'h':
+			/* Already handled above */
+			break;
+		default:
+			usage(argv[0]);
+			return 1;
+		}
+	}
+
+	/* At least one filter must be specified */
+	if (cmd_len == 0) {
+		fprintf(stderr, "Error: At least one filter (-m or -n) must be specified\n\n");
+		usage(argv[0]);
+		return 1;
+	}
+
+	/* Open page_owner for read-write - this will fail if kernel doesn't support write */
+	fd = open("/sys/kernel/debug/page_owner", O_RDWR);
+	if (fd < 0) {
+		if (errno == EACCES || errno == EPERM) {
+			fprintf(stderr, "Error: /sys/kernel/debug/page_owner ");
+			fprintf(stderr, "does not support write access\n");
+			fprintf(stderr, "This kernel does not support ");
+			fprintf(stderr, "per-fd filtering.\n");
+			fprintf(stderr, "Please ensure you have a kernel with ");
+			fprintf(stderr, "per-fd filtering support.\n");
+		} else {
+			perror("Error opening /sys/kernel/debug/page_owner");
+		}
+		return 1;
+	}
+
+	if (output_file) {
+		output = fopen(output_file, "w");
+		if (!output) {
+			perror("open output file");
+			close(fd);
+			return 1;
+		}
+	} else {
+		output = stdout;
+	}
+
+	ret = write(fd, filter_cmd, strlen(filter_cmd));
+
+	if (ret < 0) {
+		if (errno == EINVAL) {
+			fprintf(stderr, "Error: Kernel rejected the filter command.\n");
+			fprintf(stderr, "Possible causes:\n");
+			fprintf(stderr, "  - Kernel does not support per-fd filtering\n");
+			fprintf(stderr, "  - NUMA node has no memory\n");
+			fprintf(stderr, "  - Unknown reason\n");
+		} else {
+			perror("write filter command");
+		}
+		goto out;
+	}
+
+	if ((size_t)ret != strlen(filter_cmd))
+		fprintf(stderr, "Warning: Partial write (%zd/%zu)\n", ret, strlen(filter_cmd));
+
+	/* Read and display filtered output */
+	ret = 0;
+	while ((ret = read(fd, buf, sizeof(buf))) > 0) {
+		size_t written = fwrite(buf, 1, ret, output);
+
+		if (written != (size_t)ret) {
+			if (errno == EPIPE) {
+				/* Pipe closed, treat as success */
+				ret = 0;
+				goto out;
+			}
+			perror("write output");
+			ret = -1;
+			goto out;
+		}
+	}
+
+	if (ret < 0) {
+		perror("read page_owner");
+		goto out;
+	}
+
+	if (fflush(output)) {
+		if (errno == EPIPE) {
+			/* Pipe closed, treat as success */
+			ret = 0;
+		} else {
+			perror("flush output");
+			ret = -1;
+		}
+	}
+
+out:
+	close(fd);
+	if (output != stdout)
+		fclose(output);
+	return ret < 0 ? 1 : 0;
+}
_

Patches currently in -mm which might be from zhen.ni@easystack.cn are

mm-page_owner-add-print_mode-filter.patch
mm-page_owner-add-numa-node-filter.patch
tools-mm-add-page_owner_filter-userspace-tool.patch
mm-page_owner-document-page_owner-filter.patch

