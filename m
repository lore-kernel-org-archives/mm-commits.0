Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD574FC8E7
	for <mm-commits@vger.kernel.org>; Wed,  9 Sep 2026 23:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788997565; cv=none; b=OCOa69PACFG/XCjacNBuGqyEKdXgBOdLw2WEvX20EIja9Yi9kI6B7rzd6Jjes0QELjncGOKLB+4VexLxsKmbYXm/+wJSEDwYBRzRS52aJ0Zdup+jQ1GWwWUde0i8R2qWWVIuYN4T2tgkJhHF2/zzca7yt2wQKpQYal7BjHhzk4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788997565; c=relaxed/simple;
	bh=RAkxJftaGWwBuoMNKEn6rlDGVOn6XpAHy7/xsWhvefE=;
	h=Date:To:From:Subject:Message-Id; b=Idz4Xo+Bl0J6KmYwI7EhXAn3gQZpmVo8UJA+2jO4PSyjDaHbZq9/+wRkCSzDJlj7qM/+RDBlu+3WH1sr96CZDAaag1nnDqySJxz/XmdxeK7GWef1M4A5TgTYAa2FModpk1gjXL8E7R4C9N7eyjC1/kJjVVwvEpaxvzkv7jv6u14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IGpeAExU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IGpeAExU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026E31F000FF;
	Wed,  9 Sep 2026 23:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788997564;
	bh=93nFuGlWOVPQCzdwDk8tAdD1m1/Q9KeLng0L0LXwp8E=;
	h=Date:To:From:Subject;
	b=IGpeAExUb2m1n2MXGdHQ/JDF/VtV7q8/lg/wQBqBrI+meWlfMT1aiUn+Ts+JMKvIz
	 9fgQE0djwZ5w9NvqHgjje7akG6cTEHMxyeC6aLr2GmJz74mamWGmyfa7wiCJXml+7h
	 MT6h8ukNpJIaWMiHYDbcgnDlqi3VyYhKQu4PBMhQ=
Date: Wed, 09 Sep 2026 16:46:03 -0700
To: mm-commits@vger.kernel.org,ekffu200098@gmail.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch added to mm-nonmm-unstable branch
Message-Id: <20260909234604.026E31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/bootconfig: consolidate xbc_init() to error message wrapper
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch

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

bootconfig-reject-unexpected-data-after-null-character.patch
tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch
bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch

