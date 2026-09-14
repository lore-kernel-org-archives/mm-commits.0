Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A092388E55
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 19:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789412939; cv=none; b=KZPbcVaO13RAFdQfkN0yk4Fsr2h0PP3/h6cnVDQY4EB/JKQMxN5es1gVY2H1q10hcY6JHs6ScV8PhWYd2dtFVfwb2UQkDUM9eYDN6JJEWOA12uixRuzRB+YlK00G7UWLQAyWpn+edpDhgMGZXhc9SXzVaxCqQuHq34Q9nzxU6PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789412939; c=relaxed/simple;
	bh=XXVH0Q3Se0wKTy3SRl1lfKYxIOPB6sBiIepMwUFutkI=;
	h=Date:To:From:Subject:Message-Id; b=aD8P8sobCT0+fPYhlMu4QqI9QNDD9QAqtUTyaakcmEW/y32tYBf5ll6bhF8cJQbPcPdXe1cD58W5YeZ+bpNUv/46urOrN1msM2VkWyueAGAk+l+iXTia9bvVPc5er0Ve2feR27UL8rTWS3E+BjFdtwQhy+OBkqt7tWSiZOznw1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DFpNa2RI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DFpNa2RI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AA81F000FF;
	Mon, 14 Sep 2026 19:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789412936;
	bh=9vXG1wAtfHHQYtsUQvfBzwx3YTMdP7SMgPVdW1w0+r0=;
	h=Date:To:From:Subject;
	b=DFpNa2RIqDX/VxxZJSrWz/Nt5rgt8uDA731n2tn87u0/mmDg6D+AjY0wcBtxFgsJ1
	 JGxWaBeCS20QJ2hThtEqeEB4Vx3WNj8GibcKZitl7fN5Cqe2bV8nMznXARrmKJyU+B
	 +WH5LntHhpI8HEMEd1nKl4NZNp2d86oVi1/ZZlM8=
Date: Mon, 14 Sep 2026 12:08:55 -0700
To: mm-commits@vger.kernel.org,ekffu200098@gmail.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [wrecked] bootconfig-move-bootconfig_footer_size-to-include-linux-bootconfigh.patch removed from -mm tree
Message-Id: <20260914190856.54AA81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: bootconfig: move BOOTCONFIG_FOOTER_SIZE to include/linux/bootconfig.h
has been removed from the -mm tree.  Its filename was
     bootconfig-move-bootconfig_footer_size-to-include-linux-bootconfigh.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: bootconfig: move BOOTCONFIG_FOOTER_SIZE to include/linux/bootconfig.h
Date: Fri, 11 Sep 2026 23:13:33 +0900

BOOTCONFIG_FOOTER_SIZE was defined locally in tools/bootconfig/main.c. 
Move it to include/linux/bootconfig.h so that it can be shared with the
kernel and user-space tools.  Also, use it in init/main.c instead of the
hardcoded (BOOTCONFIG_MAGIC_LEN + 8) expression when checking the initrd
size.

Link: https://lore.kernel.org/178913601321.248794.4786502771058559887.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---

 include/linux/bootconfig.h |    4 ++++
 init/main.c                |    2 +-
 tools/bootconfig/main.c    |    4 ----
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/bootconfig.h~bootconfig-move-bootconfig_footer_size-to-include-linux-bootconfigh
+++ a/include/linux/bootconfig.h
@@ -27,6 +27,10 @@ bool __init cmdline_has_extra_options(vo
 #define BOOTCONFIG_ALIGN	(1 << BOOTCONFIG_ALIGN_SHIFT)
 #define BOOTCONFIG_ALIGN_MASK	(BOOTCONFIG_ALIGN - 1)
 
+/* Bootconfig footer is [size][csum][BOOTCONFIG_MAGIC]. */
+#define BOOTCONFIG_FOOTER_SIZE	\
+	(sizeof(uint32_t) * 2 + BOOTCONFIG_MAGIC_LEN)
+
 /**
  * xbc_calc_checksum() - Calculate checksum of bootconfig
  * @data: Bootconfig data.
--- a/init/main.c~bootconfig-move-bootconfig_footer_size-to-include-linux-bootconfigh
+++ a/init/main.c
@@ -278,7 +278,7 @@ static void * __init get_boot_config_fro
 	int i;
 
 	if (!initrd_end || initrd_end < initrd_start ||
-	    initrd_end - initrd_start < BOOTCONFIG_MAGIC_LEN + 8)
+	    initrd_end - initrd_start < BOOTCONFIG_FOOTER_SIZE)
 		return NULL;
 
 	data = (char *)initrd_end - BOOTCONFIG_MAGIC_LEN;
--- a/tools/bootconfig/main.c~bootconfig-move-bootconfig_footer_size-to-include-linux-bootconfigh
+++ a/tools/bootconfig/main.c
@@ -17,10 +17,6 @@
 
 #define pr_err(fmt, ...) fprintf(stderr, fmt, ##__VA_ARGS__)
 
-/* Bootconfig footer is [size][csum][BOOTCONFIG_MAGIC]. */
-#define BOOTCONFIG_FOOTER_SIZE	\
-	(sizeof(uint32_t) * 2 + BOOTCONFIG_MAGIC_LEN)
-
 static void show_xbc_error(const char *data, const char *msg, int pos)
 {
 	int lin = 1, col, i;
_

Patches currently in -mm which might be from mhiramat@kernel.org are

tools-bootconfig-fix-integer-overflow-and-truncation-in-size-checks.patch
bootconfig-reject-unexpected-data-after-null-character.patch
tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch
bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch

