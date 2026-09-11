Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80BC38A702
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 22:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789166226; cv=none; b=Fi7+tYYwnOsT+zO1XCAFAnrkJIF1ccBbOnfFHpklW4Fr5eRQldcShvdqhBm3XIHfLPglSll1pqC4Vh9EespLMFAsLjmd5vyVxzgFX7Qezx8hvyQGtdAo7pFLNUlwfCsuICpr0BrtWDp/MEgdloh37rfVDBz/s6BZmqqEq+XPajU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789166226; c=relaxed/simple;
	bh=p+cRtF0pSzhJPP+Sfe+erqLqNDeOBuR1Wp5o8wcwSsI=;
	h=Date:To:From:Subject:Message-Id; b=EYk3mEUeUCg+SsfC5hlC97I2WsHJjRAqZyCoysxZy9ToVB2YOjvJm8bA8txqNPhrWtKZCg7HAFEk9I4V/bdh5jkUq02fcoDjUpGfZWvdh2FAamA+N8sDsEyIvb5gyq+G41Yv3Vq+PSTPTaCJUnlqrO/4B3nu04GZSm4CDAjIkh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ciW3ztHc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ciW3ztHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A491F00893;
	Fri, 11 Sep 2026 22:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789166224;
	bh=5FlZj+OmiCairX9m9/qoE/xxpkuH3sXAwX2B/Z7kDwY=;
	h=Date:To:From:Subject;
	b=ciW3ztHcutmYa0FAuiwfpSVc07D2a4pBcN2AKXlASrFpO/vSg66haDwMh4gA98wto
	 7FkU5cuMwjZ/NWVvzEzzHBbBg8Qa/gFue3D39JcyLeeJQwCT7bR1/wyo4wsywMG0Vv
	 6k7hpc9zcuxVt7DcRy+q34pH/sUk04HAatjUAqpE=
Date: Fri, 11 Sep 2026 15:37:03 -0700
To: mm-commits@vger.kernel.org,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch removed from -mm tree
Message-Id: <20260911223704.68A491F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/bootconfig: consolidate xbc_init() to error message wrapper
has been removed from the -mm tree.  Its filename was
     tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: tools/bootconfig: consolidate xbc_init() to error message wrapper
Date: Thu, 10 Sep 2026 00:53:53 +0900

Use init_xbc_with_error() for all bootconfig initialization in the
bootconfig tool instead of showing errors in different way.

This simplifies the code logic and make it easy to maintain.

Link: https://lore.kernel.org/178896923375.177508.14682854552827605824.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/bootconfig/main.c |  108 +++++++++++++++++---------------------
 1 file changed, 51 insertions(+), 57 deletions(-)

--- a/tools/bootconfig/main.c~tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper
+++ a/tools/bootconfig/main.c
@@ -21,6 +21,47 @@
 #define BOOTCONFIG_FOOTER_SIZE	\
 	(sizeof(uint32_t) * 2 + BOOTCONFIG_MAGIC_LEN)
 
+static void show_xbc_error(const char *data, const char *msg, int pos)
+{
+	int lin = 1, col, i;
+
+	if (pos < 0) {
+		pr_err("Error: %s.\n", msg);
+		return;
+	}
+
+	/* Note that pos starts from 0 but lin and col should start from 1. */
+	col = pos + 1;
+	for (i = 0; i < pos; i++) {
+		if (data[i] == '\n') {
+			lin++;
+			col = pos - i;
+		}
+	}
+	pr_err("Parse Error: %s at %d:%d\n", msg, lin, col);
+
+}
+
+static int init_xbc_with_error(char *buf, int len)
+{
+	char *copy = malloc(len);
+	const char *msg;
+	int ret, pos;
+
+	if (!copy)
+		return -ENOMEM;
+
+	memcpy(copy, buf, len);
+	/* We do not terminate the copy with \0 for sanity checking */
+
+	ret = xbc_init(buf, len, &msg, &pos);
+	if (ret < 0)
+		show_xbc_error(copy, msg, pos);
+	free(copy);
+
+	return ret;
+}
+
 static int xbc_show_value(struct xbc_node *node, bool semicolon)
 {
 	const char *val, *eol;
@@ -187,7 +228,6 @@ static int load_xbc_from_initrd(int fd,
 	int ret;
 	uint32_t size = 0, csum = 0, rcsum;
 	char magic[BOOTCONFIG_MAGIC_LEN];
-	const char *msg;
 
 	ret = fstat(fd, &stat);
 	if (ret < 0)
@@ -238,52 +278,9 @@ static int load_xbc_from_initrd(int fd,
 		return -EINVAL;
 	}
 
-	ret = xbc_init(*buf, size, &msg, NULL);
-	/* Wrong data */
-	if (ret < 0) {
-		pr_err("parse error: %s.\n", msg);
-		return ret;
-	}
-
-	return size;
-}
-
-static void show_xbc_error(const char *data, const char *msg, int pos)
-{
-	int lin = 1, col, i;
-
-	if (pos < 0) {
-		pr_err("Error: %s.\n", msg);
-		return;
-	}
-
-	/* Note that pos starts from 0 but lin and col should start from 1. */
-	col = pos + 1;
-	for (i = 0; i < pos; i++) {
-		if (data[i] == '\n') {
-			lin++;
-			col = pos - i;
-		}
-	}
-	pr_err("Parse Error: %s at %d:%d\n", msg, lin, col);
+	ret = init_xbc_with_error(*buf, size);
 
-}
-
-static int init_xbc_with_error(char *buf, int len)
-{
-	char *copy = strdup(buf);
-	const char *msg;
-	int ret, pos;
-
-	if (!copy)
-		return -ENOMEM;
-
-	ret = xbc_init(buf, len, &msg, &pos);
-	if (ret < 0)
-		show_xbc_error(copy, msg, pos);
-	free(copy);
-
-	return ret;
+	return ret < 0 ? ret : size;
 }
 
 static int show_xbc_kernel_cmdline(void)
@@ -412,9 +409,8 @@ static int apply_xbc(const char *path, c
 	char *buf, *data;
 	size_t total_size;
 	struct stat stat;
-	const char *msg;
 	uint32_t size, csum;
-	int pos, pad;
+	int pad;
 	int ret, fd;
 
 	ret = load_xbc_file(xbc_path, &buf);
@@ -427,6 +423,13 @@ static int apply_xbc(const char *path, c
 		size++;
 	csum = xbc_calc_checksum(buf, size);
 
+	/* Verify the data format */
+	ret = init_xbc_with_error(buf, size);
+	if (ret < 0) {
+		free(buf);
+		return ret;
+	}
+
 	/* Backup the bootconfig data */
 	data = calloc(size + BOOTCONFIG_ALIGN + BOOTCONFIG_FOOTER_SIZE, 1);
 	if (!data) {
@@ -435,15 +438,6 @@ static int apply_xbc(const char *path, c
 	}
 	memcpy(data, buf, size);
 
-	/* Check the data format */
-	ret = xbc_init(buf, size, &msg, &pos);
-	if (ret < 0) {
-		show_xbc_error(data, msg, pos);
-		free(data);
-		free(buf);
-
-		return ret;
-	}
 	printf("Apply %s to %s\n", xbc_path, path);
 	xbc_get_info(&ret, NULL);
 	printf("\tNumber of nodes: %d\n", ret);
_

Patches currently in -mm which might be from mhiramat@kernel.org are

bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch
tools-bootconfig-fix-integer-overflow-and-truncation-in-size-checks.patch
bootconfig-fix-integer-overflow-in-initrd-size-check.patch

