Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B3F3D9DCD
	for <mm-commits@vger.kernel.org>; Fri, 11 Sep 2026 22:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789167569; cv=none; b=SchM2bVs7U5RJwxsnqOyh2Np9Cx6BvEzY9SzzWtzOg+ZBiNK2Bl7IekTLZWe0zXJkG3sAMWcoeNxt681JICMBHCYPyvNhZJnTq8bRy8Yh/McV/AAVSwCzVYVZHUoZ5juuNZSvxLMF1IyfOGwsjSeuo0A8TyAb3WyjkizW01PszE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789167569; c=relaxed/simple;
	bh=Qfpd4yZ3MnncM9Aos4mixsNAlGRD8wyiAG3GD5uOt78=;
	h=Date:To:From:Subject:Message-Id; b=GhuSsnNb4TJYZFGVkpP+Umml4gj7KTIevaEhBWENPVTFokzPrr0ePkH+yi5NHiKvYciLX5I3HygFA71l2o9s7S4sFXRyHllATBdv4zxNvfSrhg4+nns3vobLUqHy3Zx85q2Ee2py4aajf2/IUVNaNN6dbkj+CVL7Aa3CPSvnYpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RODXhc2Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RODXhc2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100E31F000FF;
	Fri, 11 Sep 2026 22:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789167568;
	bh=VFfPIZvFN7PLFWRSPlgfa69tFzeZxlsWNXDmw5rYcdI=;
	h=Date:To:From:Subject;
	b=RODXhc2YajneMu0EHtaZfs9KSDQ+X0AJUPX0waorG2/MmDdUSNzTq3oZv+gWRRuUt
	 HBYu3X5rYcNmeKF6djipFe8TpV/G11FVrHg3CcwGhgHcEpYOlTz8XgrmGaNO7pxF8b
	 s/BaA/otOR+VnBO/Y0niqGHLK08AGx4NyvLX9Yvo=
Date: Fri, 11 Sep 2026 15:59:27 -0700
To: mm-commits@vger.kernel.org,ekffu200098@gmail.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + bootconfig-move-bootconfig_footer_size-to-include-linux-bootconfigh.patch added to mm-nonmm-unstable branch
Message-Id: <20260911225928.100E31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: bootconfig: move BOOTCONFIG_FOOTER_SIZE to include/linux/bootconfig.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bootconfig-move-bootconfig_footer_size-to-include-linux-bootconfigh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bootconfig-move-bootconfig_footer_size-to-include-linux-bootconfigh.patch

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
Subject: bootconfig: move BOOTCONFIG_FOOTER_SIZE to include/linux/bootconfig.h
Date: Fri, 11 Sep 2026 23:13:33 +0900

BOOTCONFIG_FOOTER_SIZE was defined locally in tools/bootconfig/main.c. 
Move it to include/linux/bootconfig.h so that it can be shared with the
kernel and user-space tools.  Also, use it in init/main.c instead of the
hardcoded (BOOTCONFIG_MAGIC_LEN + 8) expression when checking the initrd
size.

Link: https://lore.kernel.org/178913601321.248794.4786502771058559887.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Suggested-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
bootconfig-fix-integer-overflow-in-initrd-size-check.patch
bootconfig-reject-unexpected-data-after-null-character.patch
tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch
bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch
bootconfig-move-bootconfig_footer_size-to-include-linux-bootconfigh.patch

