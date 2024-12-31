Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FB7A35
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 00:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735604122; cv=none; b=NyaZwP33nxf5xOGkzYQ6R0poVo1RXKM5lLWEk5jS+ifUNyOcwceqkyd209n6zv11dgqOJAGPku6qCuDzw2jSyoKgaM9tiw51n5qgrRU5rw9D6gtxbva4HNDgyT+MULBA951MpffqNSRjnTeb8p7f4ZXMffDfeOeosG4Orzs6oUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735604122; c=relaxed/simple;
	bh=FatllkVJk19Fn36eBUApNmy7aTlsxId2RtohxHohhpc=;
	h=Date:To:From:Subject:Message-Id; b=qqXF2dbGU2sP1pmAcK/xm8gMHvRPJrBpPVZ98raeHKxauK43R3MiQelI+hDXSItl+rQIz2JGKnoy3VL1O6NXLoGLQBVwYnoFn9E6m3FYH+TBdkvoyjSDPhwHBpemfu9XpJjdCtyvj5UxP1rloYKDVgvZoUlo5N2UdWEofZQTUtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QqDX9T+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QqDX9T+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753A8C4CED0;
	Tue, 31 Dec 2024 00:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735604121;
	bh=FatllkVJk19Fn36eBUApNmy7aTlsxId2RtohxHohhpc=;
	h=Date:To:From:Subject:From;
	b=QqDX9T+CNYd2iyEShnMj43NL05IId4VeUI4TZKUtFOPiWLFb/s3Zb9EdfEJKHzcfZ
	 YwDTfUgZZOE2t/qC3t6Oi/DR9N/IKT03m02TcIzTT8XkhKln2Rc4sm8KtaNVW28mzS
	 AL+LbcNn+A+JOq6u2smG2Ofd2xZT/TdF44eAeCoU=
Date: Mon, 30 Dec 2024 16:15:20 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,r.thapliyal@samsung.com,jack@suse.cz,elver@google.com,brauner@kernel.org,maninder1.s@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-list_debugc-add-object-information-in-case-of-invalid-object.patch added to mm-unstable branch
Message-Id: <20241231001521.753A8C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/list_debug.c: add object information in case of invalid object
has been added to the -mm mm-unstable branch.  Its filename is
     lib-list_debugc-add-object-information-in-case-of-invalid-object.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-list_debugc-add-object-information-in-case-of-invalid-object.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Maninder Singh <maninder1.s@samsung.com>
Subject: lib/list_debug.c: add object information in case of invalid object
Date: Mon, 30 Dec 2024 15:40:43 +0530

As of now during link list corruption it prints about cluprit address and
its wrong value, but sometime it is not enough to catch the actual issue
point.

If it prints allocation and free path of that corrupted node, it will be a
lot easier to find and fix the issues.

Adding the same information when data mismatch is found in link list
debug data:

[   14.243055]  slab kmalloc-32 start ffff0000cda19320 data offset 32 pointer offset 8 size 32 allocated at add_to_list+0x28/0xb0
[   14.245259]     __kmalloc_cache_noprof+0x1c4/0x358
[   14.245572]     add_to_list+0x28/0xb0
...
[   14.248632]     do_el0_svc_compat+0x1c/0x34
[   14.249018]     el0_svc_compat+0x2c/0x80
[   14.249244]  Free path:
[   14.249410]     kfree+0x24c/0x2f0
[   14.249724]     do_force_corruption+0xbc/0x100
...
[   14.252266]     el0_svc_common.constprop.0+0x40/0xe0
[   14.252540]     do_el0_svc_compat+0x1c/0x34
[   14.252763]     el0_svc_compat+0x2c/0x80
[   14.253071] ------------[ cut here ]------------
[   14.253303] list_del corruption. next->prev should be ffff0000cda192a8, but was 6b6b6b6b6b6b6b6b. (next=ffff0000cda19348)
[   14.254255] WARNING: CPU: 3 PID: 84 at lib/list_debug.c:65 __list_del_entry_valid_or_report+0x158/0x164

Moved prototype of mem_dump_obj() to bug.h, as mm.h can not be included in
bug.h.

Link: https://lkml.kernel.org/r/20241230101043.53773-1-maninder1.s@samsung.com
Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Marco Elver <elver@google.com>
Cc: Rohit Thapliyal <r.thapliyal@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/open.c           |    2 +-
 fs/super.c          |    2 +-
 include/linux/bug.h |   10 +++++++++-
 include/linux/mm.h  |    6 ------
 lib/list_debug.c    |   22 +++++++++++-----------
 5 files changed, 22 insertions(+), 20 deletions(-)

--- a/fs/open.c~lib-list_debugc-add-object-information-in-case-of-invalid-object
+++ a/fs/open.c
@@ -1504,7 +1504,7 @@ static int filp_flush(struct file *filp,
 {
 	int retval = 0;
 
-	if (CHECK_DATA_CORRUPTION(file_count(filp) == 0,
+	if (CHECK_DATA_CORRUPTION(file_count(filp) == 0, filp,
 			"VFS: Close: file count is 0 (f_op=%ps)",
 			filp->f_op)) {
 		return 0;
--- a/fs/super.c~lib-list_debugc-add-object-information-in-case-of-invalid-object
+++ a/fs/super.c
@@ -647,7 +647,7 @@ void generic_shutdown_super(struct super
 		 */
 		fscrypt_destroy_keyring(sb);
 
-		if (CHECK_DATA_CORRUPTION(!list_empty(&sb->s_inodes),
+		if (CHECK_DATA_CORRUPTION(!list_empty(&sb->s_inodes), NULL,
 				"VFS: Busy inodes after unmount of %s (%s)",
 				sb->s_id, sb->s_type->name)) {
 			/*
--- a/include/linux/bug.h~lib-list_debugc-add-object-information-in-case-of-invalid-object
+++ a/include/linux/bug.h
@@ -73,15 +73,23 @@ static inline void generic_bug_clear_onc
 
 #endif	/* CONFIG_GENERIC_BUG */
 
+#ifdef CONFIG_PRINTK
+void mem_dump_obj(void *object);
+#else
+static inline void mem_dump_obj(void *object) {}
+#endif
+
 /*
  * Since detected data corruption should stop operation on the affected
  * structures. Return value must be checked and sanely acted on by caller.
  */
 static inline __must_check bool check_data_corruption(bool v) { return v; }
-#define CHECK_DATA_CORRUPTION(condition, fmt, ...)			 \
+#define CHECK_DATA_CORRUPTION(condition, addr, fmt, ...)		 \
 	check_data_corruption(({					 \
 		bool corruption = unlikely(condition);			 \
 		if (corruption) {					 \
+			if (addr)					 \
+				mem_dump_obj(addr);			 \
 			if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION)) { \
 				pr_err(fmt, ##__VA_ARGS__);		 \
 				BUG();					 \
--- a/include/linux/mm.h~lib-list_debugc-add-object-information-in-case-of-invalid-object
+++ a/include/linux/mm.h
@@ -4170,12 +4170,6 @@ unsigned long wp_shared_mapping_range(st
 
 extern int sysctl_nr_trim_pages;
 
-#ifdef CONFIG_PRINTK
-void mem_dump_obj(void *object);
-#else
-static inline void mem_dump_obj(void *object) {}
-#endif
-
 #ifdef CONFIG_ANON_VMA_NAME
 int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
 			  unsigned long len_in,
--- a/lib/list_debug.c~lib-list_debugc-add-object-information-in-case-of-invalid-object
+++ a/lib/list_debug.c
@@ -22,17 +22,17 @@ __list_valid_slowpath
 bool __list_add_valid_or_report(struct list_head *new, struct list_head *prev,
 				struct list_head *next)
 {
-	if (CHECK_DATA_CORRUPTION(prev == NULL,
+	if (CHECK_DATA_CORRUPTION(prev == NULL, NULL,
 			"list_add corruption. prev is NULL.\n") ||
-	    CHECK_DATA_CORRUPTION(next == NULL,
+	    CHECK_DATA_CORRUPTION(next == NULL, NULL,
 			"list_add corruption. next is NULL.\n") ||
-	    CHECK_DATA_CORRUPTION(next->prev != prev,
+	    CHECK_DATA_CORRUPTION(next->prev != prev, next,
 			"list_add corruption. next->prev should be prev (%px), but was %px. (next=%px).\n",
 			prev, next->prev, next) ||
-	    CHECK_DATA_CORRUPTION(prev->next != next,
+	    CHECK_DATA_CORRUPTION(prev->next != next, prev,
 			"list_add corruption. prev->next should be next (%px), but was %px. (prev=%px).\n",
 			next, prev->next, prev) ||
-	    CHECK_DATA_CORRUPTION(new == prev || new == next,
+	    CHECK_DATA_CORRUPTION(new == prev || new == next, NULL,
 			"list_add double add: new=%px, prev=%px, next=%px.\n",
 			new, prev, next))
 		return false;
@@ -49,20 +49,20 @@ bool __list_del_entry_valid_or_report(st
 	prev = entry->prev;
 	next = entry->next;
 
-	if (CHECK_DATA_CORRUPTION(next == NULL,
+	if (CHECK_DATA_CORRUPTION(next == NULL, NULL,
 			"list_del corruption, %px->next is NULL\n", entry) ||
-	    CHECK_DATA_CORRUPTION(prev == NULL,
+	    CHECK_DATA_CORRUPTION(prev == NULL, NULL,
 			"list_del corruption, %px->prev is NULL\n", entry) ||
-	    CHECK_DATA_CORRUPTION(next == LIST_POISON1,
+	    CHECK_DATA_CORRUPTION(next == LIST_POISON1, next,
 			"list_del corruption, %px->next is LIST_POISON1 (%px)\n",
 			entry, LIST_POISON1) ||
-	    CHECK_DATA_CORRUPTION(prev == LIST_POISON2,
+	    CHECK_DATA_CORRUPTION(prev == LIST_POISON2, prev,
 			"list_del corruption, %px->prev is LIST_POISON2 (%px)\n",
 			entry, LIST_POISON2) ||
-	    CHECK_DATA_CORRUPTION(prev->next != entry,
+	    CHECK_DATA_CORRUPTION(prev->next != entry, prev,
 			"list_del corruption. prev->next should be %px, but was %px. (prev=%px)\n",
 			entry, prev->next, prev) ||
-	    CHECK_DATA_CORRUPTION(next->prev != entry,
+	    CHECK_DATA_CORRUPTION(next->prev != entry, next,
 			"list_del corruption. next->prev should be %px, but was %px. (next=%px)\n",
 			entry, next->prev, next))
 		return false;
_

Patches currently in -mm which might be from maninder1.s@samsung.com are

lib-list_debugc-add-object-information-in-case-of-invalid-object.patch

