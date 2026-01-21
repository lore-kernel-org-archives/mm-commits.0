Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56643288D0
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967358; cv=none; b=QyWD+hVjr09WSR/2LOdFdDUeXk0kVgNwnTT6VkwZGC3zwJ5UB4k8Zj1rEUy09R/pxvzX929svkssn+iLmhhB0sjX410s7oZ1wXbpIE5WPziSQgSimzlnBYSAAbThLO4e2u6iAJCzwxiE/U1eVTBucBocJQOQHwLhabUlxNSeleQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967358; c=relaxed/simple;
	bh=cw0dihvEcEUEKWodyl30V3RGQKNHceOD6rgw+Az2BrM=;
	h=Date:To:From:Subject:Message-Id; b=d9s/3dR9ewoYzGrmM7xvxkLYsUxvpfALf4u2cuhaWxkD10ENWpGHQoa1s8awQYAaDtcXPoBZXyIBt9RKZ9QWV0h90fdLwU69JkX6ZIKTYG7PIBNlxeriuCUwyyxA9xRyB2RBe5PP0MSUZYhhaE4oKSpH3F4mV3c91ckxXEsfQEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AThK7tJ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AThK7tJ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE62FC16AAE;
	Wed, 21 Jan 2026 03:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967357;
	bh=cw0dihvEcEUEKWodyl30V3RGQKNHceOD6rgw+Az2BrM=;
	h=Date:To:From:Subject:From;
	b=AThK7tJ3i8b/TvxcYl8KaNa2PxQ0nufm/3Y5Z0kO/MFvdzspGhayl7RngsqZ/zof7
	 RzUb0/cTR2VMVCRBKemD1q+qpFoGukbCt7/31+xQKK8g8sAmIVA2droJmvVsVT3dtu
	 tbTGOmYO37CuekvNTA7cndzZxZEn/zyBqHc51nfo=
Date: Tue, 20 Jan 2026 19:49:17 -0800
To: mm-commits@vger.kernel.org,tamird@gmail.com,skhawaja@google.com,rppt@kernel.org,rientjes@google.com,pratyush@kernel.org,pmladek@suse.com,kees@kernel.org,graf@amazon.com,dmatlack@google.com,davidgow@google.com,corbet@lwn.net,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] liveupdate-luo_file-use-private-list.patch removed from -mm tree
Message-Id: <20260121034917.BE62FC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: luo_file: Use private list
has been removed from the -mm tree.  Its filename was
     liveupdate-luo_file-use-private-list.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: liveupdate: luo_file: Use private list
Date: Thu, 18 Dec 2025 10:57:50 -0500

Switch LUO to use the private list iterators.

Link: https://lkml.kernel.org/r/20251218155752.3045808-4-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: David Gow <davidgow@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <kees@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Tamir Duberstein <tamird@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/luo_file.c     |    7 ++++---
 kernel/liveupdate/luo_internal.h |    7 -------
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/kernel/liveupdate/luo_file.c~liveupdate-luo_file-use-private-list
+++ a/kernel/liveupdate/luo_file.c
@@ -104,6 +104,7 @@
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/luo.h>
+#include <linux/list_private.h>
 #include <linux/liveupdate.h>
 #include <linux/module.h>
 #include <linux/sizes.h>
@@ -273,7 +274,7 @@ int luo_preserve_file(struct luo_file_se
 		goto  err_fput;
 
 	err = -ENOENT;
-	luo_list_for_each_private(fh, &luo_file_handler_list, list) {
+	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 		if (fh->ops->can_preserve(fh, file)) {
 			err = 0;
 			break;
@@ -760,7 +761,7 @@ int luo_file_deserialize(struct luo_file
 		bool handler_found = false;
 		struct luo_file *luo_file;
 
-		luo_list_for_each_private(fh, &luo_file_handler_list, list) {
+		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
 			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
 				handler_found = true;
 				break;
@@ -835,7 +836,7 @@ int liveupdate_register_file_handler(str
 		return -EBUSY;
 
 	/* Check for duplicate compatible strings */
-	luo_list_for_each_private(fh_iter, &luo_file_handler_list, list) {
+	list_private_for_each_entry(fh_iter, &luo_file_handler_list, list) {
 		if (!strcmp(fh_iter->compatible, fh->compatible)) {
 			pr_err("File handler registration failed: Compatible string '%s' already registered.\n",
 			       fh->compatible);
--- a/kernel/liveupdate/luo_internal.h~liveupdate-luo_file-use-private-list
+++ a/kernel/liveupdate/luo_internal.h
@@ -40,13 +40,6 @@ static inline int luo_ucmd_respond(struc
  */
 #define luo_restore_fail(__fmt, ...) panic(__fmt, ##__VA_ARGS__)
 
-/* Mimics list_for_each_entry() but for private list head entries */
-#define luo_list_for_each_private(pos, head, member)				\
-	for (struct list_head *__iter = (head)->next;				\
-	     __iter != (head) &&						\
-	     ({ pos = container_of(__iter, typeof(*(pos)), member); 1; });	\
-	     __iter = __iter->next)
-
 /**
  * struct luo_file_set - A set of files that belong to the same sessions.
  * @files_list: An ordered list of files associated with this session, it is
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are


