Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE97219CCF7
	for <mm-commits@vger.kernel.org>; Sun,  1 Mar 2026 19:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772393662; cv=none; b=B34PbrHfwQQHD21S6rGVYfOdOMrTPkpU3lZwOTZ+gay0zcdYHLUB6diPcN5PkvI2H2qyLy95hiN22RGAoMdxgQrJawi5lw42urQcmj3qFPeU8G2724G4ANCb+nm9r3lW8Ls0pNeF/7eBh2hO/JCyFpdhPjo5PcGMNL7nSJcwfJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772393662; c=relaxed/simple;
	bh=ykkxzQDv5g5oxht/zuPJ8SZNWmtQFbj5dOtGPtOCSAg=;
	h=Date:To:From:Subject:Message-Id; b=KyifwGpETR+rrM38Pk+DemzAm7E3HvBv1oYxuYbRoPbhGWcdpT7KjIWrgB1gqFuhuyvQxgE/VgDtabb2aK2skAgmCi5kbRiBAIjfpDauS7rOOgNa0N753sJdIhe2VVIU+/hJTmhsigro3Rf4gR+xM7qk0Jw1k3vnU2CApNKwMuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=smvkJ6Wz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="smvkJ6Wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73501C2BC86;
	Sun,  1 Mar 2026 19:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772393662;
	bh=ykkxzQDv5g5oxht/zuPJ8SZNWmtQFbj5dOtGPtOCSAg=;
	h=Date:To:From:Subject:From;
	b=smvkJ6WzUvuceLaUBtZ07N6OuLMk7vSKvxS5QEnwlnJUHdPlV07UVYK3h/+wLAAE6
	 yGJ7rsWHTKIWi4VJNwGt4UOweD1byNLWCvh1xt0ResseaqjcNIgcaYFKcoNFrEB/qn
	 9GNqpfPHIBPJ5W7vVpi7+9NFxjxLbNbUcA6b7Yio=
Date: Sun, 01 Mar 2026 11:34:21 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + crash_dump-use-sysfs_emit-in-sysfs-show-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20260301193422.73501C2BC86@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: crash_dump: use sysfs_emit in sysfs show functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     crash_dump-use-sysfs_emit-in-sysfs-show-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/crash_dump-use-sysfs_emit-in-sysfs-show-functions.patch

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
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: crash_dump: use sysfs_emit in sysfs show functions
Date: Sun, 1 Mar 2026 13:51:07 +0100

Replace sprintf() with sysfs_emit() in sysfs show functions.  sysfs_emit()
is preferred for formatting sysfs output because it provides safer bounds
checking.  No functional changes.

Link: https://lkml.kernel.org/r/20260301125106.911980-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_dump_dm_crypt.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/kernel/crash_dump_dm_crypt.c~crash_dump-use-sysfs_emit-in-sysfs-show-functions
+++ a/kernel/crash_dump_dm_crypt.c
@@ -6,6 +6,7 @@
 #include <linux/cc_platform.h>
 #include <linux/configfs.h>
 #include <linux/module.h>
+#include <linux/sysfs.h>
 
 #define KEY_NUM_MAX 128	/* maximum dm crypt keys */
 #define KEY_SIZE_MAX 256	/* maximum dm crypt key size */
@@ -189,7 +190,7 @@ static inline struct config_key *to_conf
 
 static ssize_t config_key_description_show(struct config_item *item, char *page)
 {
-	return sprintf(page, "%s\n", to_config_key(item)->description);
+	return sysfs_emit(page, "%s\n", to_config_key(item)->description);
 }
 
 static ssize_t config_key_description_store(struct config_item *item,
@@ -265,7 +266,7 @@ static struct config_item *config_keys_m
 
 static ssize_t config_keys_count_show(struct config_item *item, char *page)
 {
-	return sprintf(page, "%d\n", key_count);
+	return sysfs_emit(page, "%d\n", key_count);
 }
 
 CONFIGFS_ATTR_RO(config_keys_, count);
@@ -274,7 +275,7 @@ static bool is_dm_key_reused;
 
 static ssize_t config_keys_reuse_show(struct config_item *item, char *page)
 {
-	return sprintf(page, "%d\n", is_dm_key_reused);
+	return sysfs_emit(page, "%d\n", is_dm_key_reused);
 }
 
 static ssize_t config_keys_reuse_store(struct config_item *item,
@@ -321,7 +322,7 @@ static bool restore;
 
 static ssize_t config_keys_restore_show(struct config_item *item, char *page)
 {
-	return sprintf(page, "%d\n", restore);
+	return sysfs_emit(page, "%d\n", restore);
 }
 
 static ssize_t config_keys_restore_store(struct config_item *item,
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

crash_dump-dont-log-dm-crypt-key-bytes-in-read_key_from_user_keying.patch
fork-replace-simple_strtoul-with-kstrtoul-in-coredump_filter_setup.patch
crash_dump-remove-redundant-less-than-zero-check.patch
crash_dump-fix-typo-in-function-name-read_key_from_user_keying.patch
crash_dump-use-sysfs_emit-in-sysfs-show-functions.patch

