Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9FD191F94
	for <mm-commits@vger.kernel.org>; Tue, 14 Jul 2026 01:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783992269; cv=none; b=BHUibQ4jVtXW/YJm+4YasSTu864od7fc8s7rlLne3CH0b/an1XqPakcw24Aq9jAVYcSwYcHWz2ozeQqbZqy4vkFk1+8//xEdGwFbRzuhvl8V26rgA547x3vhn7Yba+QP6fRyoT+gHaL3UK/fdYCFNzhMNLMchxHzRlb8sXH7H/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783992269; c=relaxed/simple;
	bh=dDAYvxV89E2Bk1ff9bIlBDEIZvbkMTmp2LbrsdWKkcs=;
	h=Date:To:From:Subject:Message-Id; b=mVP13uP3QVV6Gb34O7CLXxEKsSyFamqAQgjlp+yyJivE3+JJYJUVRcG7D8ozE4PLuO24f0Pt90stO5KzV3kuP9Beo3xhmXwqNpvVvXRagC6vFoDCo8yiTC422oVYU+EiWJIzSiUjUUyH7k8vmTT+glfT+YpOyfxp3GU5V0n/VBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fjMzQK4t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fjMzQK4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B70D1F000E9;
	Tue, 14 Jul 2026 01:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783992267;
	bh=uAfNHTVF57qAGJA42A4kWYa62SKFX91N8iOiKkKAvs0=;
	h=Date:To:From:Subject;
	b=fjMzQK4tnCkjyLlbJSjB4yGWCPd+YZTCGGL0EIEkDQdtoQPIRA3Qdrb46k0UW/Tpi
	 mCyeum7e99d+LKvcVr61MYYc0FtT4Nl9y5C5RHe1ueHpaCPea4OwfVECQTlevbKASg
	 n9vz2s0SkMf+SmmWYnehqsuynqS0BHcbV6MdyFWQ=
Date: Mon, 13 Jul 2026 18:24:27 -0700
To: mm-commits@vger.kernel.org,balbirs@nvidia.com,akpm@linux-foundation.org,cyyzero16@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-acct-share-netlink-helpers.patch added to mm-nonmm-unstable branch
Message-Id: <20260714012427.8B70D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/acct: share netlink helpers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     selftests-acct-share-netlink-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-acct-share-netlink-helpers.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Yiyang Chen <cyyzero16@gmail.com>
Subject: selftests/acct: share netlink helpers
Date: Mon, 13 Jul 2026 01:13:31 +0800

Extract the duplicated generic netlink boilerplate (netlink_open,
send_request, get_family_id, and NLA walker macros) from cgroupstats.c and
taskstats_fill_stats_tgid.c into a shared netlink_helper.{h,c}.

Link: https://lore.kernel.org/a2adf27308b5cd90d50b59e8519b87da49486bee.1783876192.git.cyyzero16@gmail.com
Signed-off-by: Yiyang Chen <cyyzero16@gmail.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/acct/.gitignore                  |    1 
 tools/testing/selftests/acct/Makefile                    |   10 
 tools/testing/selftests/acct/cgroupstats.c               |  133 ---------
 tools/testing/selftests/acct/netlink_helper.c            |  116 ++++++++
 tools/testing/selftests/acct/netlink_helper.h            |   44 +++
 tools/testing/selftests/acct/taskstats_fill_stats_tgid.c |  134 ----------
 6 files changed, 184 insertions(+), 254 deletions(-)

--- a/tools/testing/selftests/acct/cgroupstats.c~selftests-acct-share-netlink-helpers
+++ a/tools/testing/selftests/acct/cgroupstats.c
@@ -6,139 +6,19 @@
 #include <linux/cgroupstats.h>
 #include <linux/genetlink.h>
 #include <linux/netlink.h>
+#include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <sys/mount.h>
 #include <sys/socket.h>
 #include <sys/types.h>
-#include <sys/mount.h>
-#include <time.h>
 #include <unistd.h>
 
+#include "netlink_helper.h"
 #include "kselftest.h"
 
-#ifndef NLA_ALIGN
-#define NLA_ALIGNTO 4
-#define NLA_ALIGN(len) (((len) + NLA_ALIGNTO - 1) & ~(NLA_ALIGNTO - 1))
-#define NLA_HDRLEN ((int)NLA_ALIGN(sizeof(struct nlattr)))
-#endif
-
-#define RECV_TIMEOUT_SEC 2
-
-static void *nla_data(const struct nlattr *na)
-{
-	return (void *)((char *)na + NLA_HDRLEN);
-}
-
-static int netlink_open(void)
-{
-	struct timeval tv = { .tv_sec = RECV_TIMEOUT_SEC };
-	struct sockaddr_nl addr = {
-		.nl_family = AF_NETLINK,
-		.nl_pid = getpid(),
-	};
-	int fd;
-
-	fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
-	if (fd < 0)
-		return -errno;
-
-	/*
-	 * Ensure that a missing kernel reply fails the individual test
-	 * case instead of hanging the whole test binary.
-	 */
-	if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv)) < 0) {
-		int err = -errno;
-
-		close(fd);
-		return err;
-	}
-
-	if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
-		int err = -errno;
-
-		close(fd);
-		return err;
-	}
-
-	return fd;
-}
-
-static int send_request(int fd, void *buf, size_t len)
-{
-	struct sockaddr_nl addr = {
-		.nl_family = AF_NETLINK,
-	};
-
-	if (sendto(fd, buf, len, 0, (struct sockaddr *)&addr, sizeof(addr)) < 0)
-		return -errno;
-
-	return 0;
-}
-
-static int get_family_id(int fd, const char *name)
-{
-	struct {
-		struct nlmsghdr nlh;
-		struct genlmsghdr genl;
-		char buf[256];
-	} req = { 0 };
-	char resp[8192];
-	struct nlmsghdr *nlh;
-	struct genlmsghdr *genl;
-	struct nlattr *na;
-	int len;
-	int rem;
-	int ret;
-
-	req.nlh.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
-	req.nlh.nlmsg_type = GENL_ID_CTRL;
-	req.nlh.nlmsg_flags = NLM_F_REQUEST;
-	req.nlh.nlmsg_seq = 1;
-	req.nlh.nlmsg_pid = getpid();
-
-	req.genl.cmd = CTRL_CMD_GETFAMILY;
-	req.genl.version = 1;
-
-	na = (struct nlattr *)((char *)&req + NLMSG_ALIGN(req.nlh.nlmsg_len));
-	na->nla_type = CTRL_ATTR_FAMILY_NAME;
-	na->nla_len = NLA_HDRLEN + strlen(name) + 1;
-	memcpy(nla_data(na), name, strlen(name) + 1);
-	req.nlh.nlmsg_len = NLMSG_ALIGN(req.nlh.nlmsg_len) + NLA_ALIGN(na->nla_len);
-
-	ret = send_request(fd, &req, req.nlh.nlmsg_len);
-	if (ret)
-		return ret;
-
-	len = recv(fd, resp, sizeof(resp), 0);
-	if (len < 0)
-		return -errno;
-
-	for (nlh = (struct nlmsghdr *)resp; NLMSG_OK(nlh, len);
-	     nlh = NLMSG_NEXT(nlh, len)) {
-		if (nlh->nlmsg_type == NLMSG_ERROR) {
-			struct nlmsgerr *err = NLMSG_DATA(nlh);
-
-			return err->error ? err->error : -ENOENT;
-		}
-
-		genl = (struct genlmsghdr *)NLMSG_DATA(nlh);
-		rem = nlh->nlmsg_len - NLMSG_HDRLEN - GENL_HDRLEN;
-		na = (struct nlattr *)((char *)genl + GENL_HDRLEN);
-		while (rem >= (int)sizeof(*na) &&
-		       na->nla_len >= (int)sizeof(*na) &&
-		       na->nla_len <= rem) {
-			if (na->nla_type == CTRL_ATTR_FAMILY_ID)
-				return *(uint16_t *)nla_data(na);
-			rem -= NLA_ALIGN(na->nla_len);
-			na = (struct nlattr *)((char *)na + NLA_ALIGN(na->nla_len));
-		}
-	}
-
-	return -ENOENT;
-}
-
 static int send_cgroupstats_cmd(int fd, int family_id, uint32_t cgroup_fd,
 				int flags)
 {
@@ -203,15 +83,12 @@ static int recv_cgroupstats_response(int
 
 		rem = nlh->nlmsg_len - NLMSG_HDRLEN - GENL_HDRLEN;
 		na = (struct nlattr *)((char *)genl + GENL_HDRLEN);
-		while (rem >= (int)sizeof(*na) &&
-		       na->nla_len >= (int)sizeof(*na) &&
-		       na->nla_len <= rem) {
+		while (nla_ok(na, rem)) {
 			if (na->nla_type == CGROUPSTATS_TYPE_CGROUP_STATS) {
 				memcpy(stats, nla_data(na), sizeof(*stats));
 				return 0;
 			}
-			rem -= NLA_ALIGN(na->nla_len);
-			na = (struct nlattr *)((char *)na + NLA_ALIGN(na->nla_len));
+			na = nla_next(na, &rem);
 		}
 	}
 
--- a/tools/testing/selftests/acct/.gitignore~selftests-acct-share-netlink-helpers
+++ a/tools/testing/selftests/acct/.gitignore
@@ -1,4 +1,5 @@
 acct_syscall
 taskstats_fill_stats_tgid
+cgroupstats
 config
 process_log
--- a/tools/testing/selftests/acct/Makefile~selftests-acct-share-netlink-helpers
+++ a/tools/testing/selftests/acct/Makefile
@@ -3,7 +3,17 @@ TEST_GEN_PROGS := acct_syscall
 TEST_GEN_PROGS += taskstats_fill_stats_tgid
 TEST_GEN_PROGS += cgroupstats
 
+NETLINK_HELPER_PROGS := cgroupstats taskstats_fill_stats_tgid
+
 CFLAGS += -Wall
 LDLIBS += -lpthread
 
 include ../lib.mk
+
+$(NETLINK_HELPER_PROGS): %: %.c netlink_helper.c netlink_helper.h
+	$(call msg,CC,,$@)
+	$(Q)$(LINK.c) $< netlink_helper.c $(LDLIBS) -o $@
+
+$(addprefix $(OUTPUT)/,$(NETLINK_HELPER_PROGS)): $(OUTPUT)/%: %.c netlink_helper.c netlink_helper.h
+	$(call msg,CC,,$@)
+	$(Q)$(LINK.c) $< netlink_helper.c $(LDLIBS) -o $@
diff --git a/tools/testing/selftests/acct/netlink_helper.c a/tools/testing/selftests/acct/netlink_helper.c
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/acct/netlink_helper.c
@@ -0,0 +1,116 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <errno.h>
+#include <stdint.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <sys/time.h>
+#include <unistd.h>
+#include <linux/genetlink.h>
+
+#include "netlink_helper.h"
+
+int netlink_open(void)
+{
+	struct timeval tv = { .tv_sec = ACCT_RCV_TIMEOUT_SEC };
+	struct sockaddr_nl addr = {
+		.nl_family = AF_NETLINK,
+		.nl_pid = getpid(),
+	};
+	int fd;
+
+	fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
+	if (fd < 0)
+		return -errno;
+
+	if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv)) < 0) {
+		int err = -errno;
+
+		close(fd);
+		return err;
+	}
+
+	if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
+		int err = -errno;
+
+		close(fd);
+		return err;
+	}
+
+	return fd;
+}
+
+int send_request(int fd, void *buf, size_t len)
+{
+	struct sockaddr_nl addr = {
+		.nl_family = AF_NETLINK,
+	};
+
+	if (sendto(fd, buf, len, 0, (struct sockaddr *)&addr, sizeof(addr)) < 0)
+		return -errno;
+
+	return 0;
+}
+
+/*
+ * Resolve the generic netlink family ID for @name.
+ * Returns the family ID (>= 0) on success, negative errno on failure.
+ */
+int get_family_id(int fd, const char *name)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct genlmsghdr genl;
+		char buf[256];
+	} req = { 0 };
+	char resp[8192];
+	struct nlmsghdr *nlh;
+	struct genlmsghdr *genl;
+	struct nlattr *na;
+	int len;
+	int rem;
+	int ret;
+
+	req.nlh.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
+	req.nlh.nlmsg_type = GENL_ID_CTRL;
+	req.nlh.nlmsg_flags = NLM_F_REQUEST;
+	req.nlh.nlmsg_seq = 1;
+	req.nlh.nlmsg_pid = getpid();
+
+	req.genl.cmd = CTRL_CMD_GETFAMILY;
+	req.genl.version = 1;
+
+	na = (struct nlattr *)((char *)&req + NLMSG_ALIGN(req.nlh.nlmsg_len));
+	na->nla_type = CTRL_ATTR_FAMILY_NAME;
+	na->nla_len = NLA_HDRLEN + strlen(name) + 1;
+	memcpy(nla_data(na), name, strlen(name) + 1);
+	req.nlh.nlmsg_len = NLMSG_ALIGN(req.nlh.nlmsg_len) + NLA_ALIGN(na->nla_len);
+
+	ret = send_request(fd, &req, req.nlh.nlmsg_len);
+	if (ret)
+		return ret;
+
+	len = recv(fd, resp, sizeof(resp), 0);
+	if (len < 0)
+		return -errno;
+
+	for (nlh = (struct nlmsghdr *)resp; NLMSG_OK(nlh, len);
+	     nlh = NLMSG_NEXT(nlh, len)) {
+		if (nlh->nlmsg_type == NLMSG_ERROR) {
+			struct nlmsgerr *err = NLMSG_DATA(nlh);
+
+			return err->error ? err->error : -ENOENT;
+		}
+
+		genl = (struct genlmsghdr *)NLMSG_DATA(nlh);
+		rem = nlh->nlmsg_len - NLMSG_HDRLEN - GENL_HDRLEN;
+		na = (struct nlattr *)((char *)genl + GENL_HDRLEN);
+		while (nla_ok(na, rem)) {
+			if (na->nla_type == CTRL_ATTR_FAMILY_ID)
+				return *(uint16_t *)nla_data(na);
+			na = nla_next(na, &rem);
+		}
+	}
+
+	return -ENOENT;
+}
diff --git a/tools/testing/selftests/acct/netlink_helper.h a/tools/testing/selftests/acct/netlink_helper.h
new file mode 100644
--- /dev/null
+++ a/tools/testing/selftests/acct/netlink_helper.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Shared generic netlink helpers for the acct selftests.
+ */
+#ifndef ACSELFTESTS_ACCT_NETLINK_HELPER_H
+#define ACSELFTESTS_ACCT_NETLINK_HELPER_H
+
+#include <stdbool.h>
+#include <linux/netlink.h>
+
+#ifndef NLA_ALIGNTO
+#define NLA_ALIGNTO 4
+#define NLA_ALIGN(len) (((len) + NLA_ALIGNTO - 1) & ~(NLA_ALIGNTO - 1))
+#define NLA_HDRLEN ((int)NLA_ALIGN(sizeof(struct nlattr)))
+#endif
+
+/* Fail an individual test case instead of hanging the whole binary. */
+#define ACCT_RCV_TIMEOUT_SEC 2
+
+static inline void *nla_data(const struct nlattr *na)
+{
+	return (void *)((char *)na + NLA_HDRLEN);
+}
+
+static inline bool nla_ok(const struct nlattr *na, int remaining)
+{
+	return remaining >= (int)sizeof(*na) &&
+	       na->nla_len >= sizeof(*na) &&
+	       na->nla_len <= remaining;
+}
+
+static inline struct nlattr *nla_next(const struct nlattr *na, int *remaining)
+{
+	int aligned_len = NLA_ALIGN(na->nla_len);
+
+	*remaining -= aligned_len;
+	return (struct nlattr *)((char *)na + aligned_len);
+}
+
+int netlink_open(void);
+int send_request(int fd, void *buf, size_t len);
+int get_family_id(int fd, const char *name);
+
+#endif /* ACSELFTESTS_ACCT_NETLINK_HELPER_H */
--- a/tools/testing/selftests/acct/taskstats_fill_stats_tgid.c~selftests-acct-share-netlink-helpers
+++ a/tools/testing/selftests/acct/taskstats_fill_stats_tgid.c
@@ -16,14 +16,9 @@
 #include <time.h>
 #include <unistd.h>
 
+#include "netlink_helper.h"
 #include "kselftest.h"
 
-#ifndef NLA_ALIGN
-#define NLA_ALIGNTO 4
-#define NLA_ALIGN(len) (((len) + NLA_ALIGNTO - 1) & ~(NLA_ALIGNTO - 1))
-#define NLA_HDRLEN ((int)NLA_ALIGN(sizeof(struct nlattr)))
-#endif
-
 #define BUSY_NS (200ULL * 1000 * 1000)
 
 struct worker_ctx {
@@ -35,26 +30,6 @@ struct worker_ctx {
 
 static unsigned long busy_sink;
 
-static void *taskstats_nla_data(const struct nlattr *na)
-{
-	return (void *)((char *)na + NLA_HDRLEN);
-}
-
-static bool taskstats_nla_ok(const struct nlattr *na, int remaining)
-{
-	return remaining >= (int)sizeof(*na) &&
-	       na->nla_len >= sizeof(*na) &&
-	       na->nla_len <= remaining;
-}
-
-static struct nlattr *taskstats_nla_next(const struct nlattr *na, int *remaining)
-{
-	int aligned_len = NLA_ALIGN(na->nla_len);
-
-	*remaining -= aligned_len;
-	return (struct nlattr *)((char *)na + aligned_len);
-}
-
 static uint64_t timespec_diff_ns(const struct timespec *start,
 				 const struct timespec *end)
 {
@@ -84,99 +59,6 @@ static void burn_cpu_for_ns(uint64_t run
 	busy_sink = acc;
 }
 
-static int netlink_open(void)
-{
-	struct sockaddr_nl addr = {
-		.nl_family = AF_NETLINK,
-		.nl_pid = getpid(),
-	};
-	int fd;
-
-	fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_GENERIC);
-	if (fd < 0)
-		return -errno;
-
-	if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
-		int err = -errno;
-
-		close(fd);
-		return err;
-	}
-
-	return fd;
-}
-
-static int send_request(int fd, void *buf, size_t len)
-{
-	struct sockaddr_nl addr = {
-		.nl_family = AF_NETLINK,
-	};
-
-	if (sendto(fd, buf, len, 0, (struct sockaddr *)&addr, sizeof(addr)) < 0)
-		return -errno;
-
-	return 0;
-}
-
-static int get_family_id(int fd, const char *name)
-{
-	struct {
-		struct nlmsghdr nlh;
-		struct genlmsghdr genl;
-		char buf[256];
-	} req = { 0 };
-	char resp[8192];
-	struct nlmsghdr *nlh;
-	struct genlmsghdr *genl;
-	struct nlattr *na;
-	int len;
-	int rem;
-	int ret;
-
-	req.nlh.nlmsg_len = NLMSG_LENGTH(GENL_HDRLEN);
-	req.nlh.nlmsg_type = GENL_ID_CTRL;
-	req.nlh.nlmsg_flags = NLM_F_REQUEST;
-	req.nlh.nlmsg_seq = 1;
-	req.nlh.nlmsg_pid = getpid();
-
-	req.genl.cmd = CTRL_CMD_GETFAMILY;
-	req.genl.version = 1;
-
-	na = (struct nlattr *)((char *)&req + NLMSG_ALIGN(req.nlh.nlmsg_len));
-	na->nla_type = CTRL_ATTR_FAMILY_NAME;
-	na->nla_len = NLA_HDRLEN + strlen(name) + 1;
-	memcpy(taskstats_nla_data(na), name, strlen(name) + 1);
-	req.nlh.nlmsg_len = NLMSG_ALIGN(req.nlh.nlmsg_len) + NLA_ALIGN(na->nla_len);
-
-	ret = send_request(fd, &req, req.nlh.nlmsg_len);
-	if (ret)
-		return ret;
-
-	len = recv(fd, resp, sizeof(resp), 0);
-	if (len < 0)
-		return -errno;
-
-	for (nlh = (struct nlmsghdr *)resp; NLMSG_OK(nlh, len);
-	     nlh = NLMSG_NEXT(nlh, len)) {
-		if (nlh->nlmsg_type == NLMSG_ERROR) {
-			struct nlmsgerr *err = NLMSG_DATA(nlh);
-
-			return err->error ? err->error : -ENOENT;
-		}
-
-		genl = (struct genlmsghdr *)NLMSG_DATA(nlh);
-		rem = nlh->nlmsg_len - NLMSG_HDRLEN - GENL_HDRLEN;
-		na = (struct nlattr *)((char *)genl + GENL_HDRLEN);
-		while (taskstats_nla_ok(na, rem)) {
-			if (na->nla_type == CTRL_ATTR_FAMILY_ID)
-				return *(uint16_t *)taskstats_nla_data(na);
-			na = taskstats_nla_next(na, &rem);
-		}
-	}
-
-	return -ENOENT;
-}
-
 static int get_taskstats(int fd, int family_id, uint16_t attr_type, uint32_t id,
 			 struct taskstats *stats)
 {
@@ -209,7 +91,7 @@ static int get_taskstats(int fd, int fam
 	na = (struct nlattr *)((char *)&req + NLMSG_ALIGN(req.nlh.nlmsg_len));
 	na->nla_type = attr_type;
 	na->nla_len = NLA_HDRLEN + sizeof(id);
-	memcpy(taskstats_nla_data(na), &id, sizeof(id));
+	memcpy(nla_data(na), &id, sizeof(id));
 	req.nlh.nlmsg_len = NLMSG_ALIGN(req.nlh.nlmsg_len) + NLA_ALIGN(na->nla_len);
 
 	ret = send_request(fd, &req, req.nlh.nlmsg_len);
@@ -231,21 +113,21 @@ static int get_taskstats(int fd, int fam
 		genl = (struct genlmsghdr *)NLMSG_DATA(nlh);
 		rem = nlh->nlmsg_len - NLMSG_HDRLEN - GENL_HDRLEN;
 		na = (struct nlattr *)((char *)genl + GENL_HDRLEN);
-		while (taskstats_nla_ok(na, rem)) {
+		while (nla_ok(na, rem)) {
 			if (na->nla_type == TASKSTATS_TYPE_AGGR_PID ||
 			    na->nla_type == TASKSTATS_TYPE_AGGR_TGID) {
-				nested = (struct nlattr *)taskstats_nla_data(na);
+				nested = (struct nlattr *)nla_data(na);
 				nrem = na->nla_len - NLA_HDRLEN;
-				while (taskstats_nla_ok(nested, nrem)) {
+				while (nla_ok(nested, nrem)) {
 					if (nested->nla_type == TASKSTATS_TYPE_STATS) {
-						memcpy(stats, taskstats_nla_data(nested),
+						memcpy(stats, nla_data(nested),
 						       sizeof(*stats));
 						return 0;
 					}
-					nested = taskstats_nla_next(nested, &nrem);
+					nested = nla_next(nested, &nrem);
 				}
 			}
-			na = taskstats_nla_next(na, &rem);
+			na = nla_next(na, &rem);
 		}
 	}
 
_

Patches currently in -mm which might be from cyyzero16@gmail.com are

taskstats-remove-dead-taskstats_exit_mutex-declaration.patch
taskstats-return-ebadf-when-cgroupstats-receives-an-invalid-fd.patch
selftests-acct-add-cgroupstats-functional-test.patch
selftests-acct-share-netlink-helpers.patch

