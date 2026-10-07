Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C11E3546FC
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338704; cv=none; b=fgh3slZcV+VbC132/pVl6Hd8ebe9xMdbHfPrNuFULsWPGOc6bo8SzMVTrFojrkYLB1Xjo2AcFjDzIW8PgLbTCpyuTAm+Vdcxvx5nEy/337JhwD5xoxMzx/glFgLWRHCBjR18+M9ahN6j3h4ZufSaml2ilbE8ieDQIVv6S47lyro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338704; c=relaxed/simple;
	bh=opubcOfqwGp2cfoKuB5hbP1c39Q1cJf4Pw6LjZ2YkXY=;
	h=Date:To:From:Subject:Message-Id; b=sruRXjWkTPNPRo8BaTWbnmV3eQu6qlVBlNP8D5YlE4x4kgeTOJn2mDYRYVMwfl8xYBpa6ctGK/AqHcv9nlAbVGwovO1YooT4mxdorhKkTs/vL9Z325xoWaNy8JAFm4I4icUTi2T1WRCbO0qzJFbcU4qnrB+kxUWry4Jm/n5pHic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X0vFzxCQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X0vFzxCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5201E1F0089B;
	Wed,  7 Oct 2026 02:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338702;
	bh=m7JJf4gCLbjiMtvwc1sWxWLp41+Wn46K4K27gANNwlg=;
	h=Date:To:From:Subject;
	b=X0vFzxCQ0l2FqNLLadRYH4YgcqF7ZbRz0XxI6WP4Hh/dwKcQCplBwavnNFEgSzJ8t
	 xJ4YAI8VA4hz+gdrGg9gFCvDUf2q6CmGfdkFWaf9U0OSOAKi/VdWZ4MeVN+ekIVGqa
	 M1UfBV7gmRFR/7kd/5NcUsphZq1mWOQdeHEY/JY8=
Date: Tue, 06 Oct 2026 19:05:01 -0700
To: mm-commits@vger.kernel.org,ekffu200098@gmail.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch removed from -mm tree
Message-Id: <20261007020502.5201E1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/bootconfig: consolidate xbc_init() to error message wrapper
has been removed from the -mm tree.  Its filename was
     tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: tools/bootconfig: consolidate xbc_init() to error message wrapper
Date: Fri, 11 Sep 2026 23:13:15 +0900

Use init_xbc_with_error() for all bootconfig initialization in the
bootconfig tool instead of showing errors in different way.

This simplifies the code logic and make it easy to maintain.

Link: https://lore.kernel.org/178913599508.248794.10388592925402087434.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---

 tools/bootconfig/main.c |  100 ++++++++++++++++----------------------
 1 file changed, 43 insertions(+), 57 deletions(-)

--- a/tools/bootconfig/main.c~tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper
+++ a/tools/bootconfig/main.c
@@ -21,6 +21,39 @@
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
+	const char *msg;
+	int ret, pos;
+
+	ret = xbc_init(buf, len, &msg, &pos);
+	if (ret < 0)
+		show_xbc_error(buf, msg, pos);
+
+	return ret;
+}
+
 static int xbc_show_value(struct xbc_node *node, bool semicolon)
 {
 	const char *val, *eol;
@@ -197,7 +230,6 @@ static int load_xbc_from_initrd(int fd,
 	int ret;
 	uint32_t size = 0, csum = 0, rcsum;
 	char magic[BOOTCONFIG_MAGIC_LEN];
-	const char *msg;
 
 	ret = fstat(fd, &stat);
 	if (ret < 0)
@@ -249,52 +281,9 @@ static int load_xbc_from_initrd(int fd,
 		return -EINVAL;
 	}
 
-	ret = xbc_init(*buf, size, &msg, NULL);
-	/* Wrong data */
-	if (ret < 0) {
-		pr_err("parse error: %s.\n", msg);
-		return ret;
-	}
+	ret = init_xbc_with_error(*buf, size);
 
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
-
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
@@ -423,9 +412,8 @@ static int apply_xbc(const char *path, c
 	char *buf, *data;
 	size_t total_size;
 	struct stat stat;
-	const char *msg;
 	uint32_t size, csum;
-	int pos, pad;
+	int pad;
 	int ret, fd;
 
 	ret = load_xbc_file(xbc_path, &buf);
@@ -438,6 +426,13 @@ static int apply_xbc(const char *path, c
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
@@ -446,15 +441,6 @@ static int apply_xbc(const char *path, c
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


