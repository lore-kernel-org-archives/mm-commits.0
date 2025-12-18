Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4732D9796
	for <mm-commits@vger.kernel.org>; Thu, 18 Dec 2025 21:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766092103; cv=none; b=TNJlfoz1J1dbww6+ZYXdoZJzQF8GObcaX12vNNPG1eOjg1O++gBZ7oKYJmZxfyYe/5f6H/hiU8ZrTxrO5rvbOR9Eb8V8HXgkswl/EfyYP+oRNuwItUwa9hkBhLwYUdokOdFr2x9e5iEYXWUit2hZRzQgJLngeWGvc86M6VMQvC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766092103; c=relaxed/simple;
	bh=lFnLgqvqBVAm820gDOZlDD6oA4+HyQgVgy+sielwLZc=;
	h=Date:To:From:Subject:Message-Id; b=cJ4GOkkZkklZeRCiVg9TKi2sLkbN/xne4wH6FqyQAbipRLGUm8ZKzPZfTEDG9gStTp3Hmg++VF+CC4ZJ2f4If39S2yPA8hNQFlCDV0bn6jcULOuJCxr8Xpq/Q/T/pbNVy6AUHZuWKF7+RphAZCat+O7ft4eWkfDcxtL5Kz1dJZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m9lqoneM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m9lqoneM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1F7C4CEFB;
	Thu, 18 Dec 2025 21:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766092102;
	bh=lFnLgqvqBVAm820gDOZlDD6oA4+HyQgVgy+sielwLZc=;
	h=Date:To:From:Subject:From;
	b=m9lqoneM55Uu2WTLTvKNS1zrDUt6afInWozBImsgYKJgON+QH1+FEKo6Q7EFoCZ2k
	 xF7f50ZDXGH4tPlpRijt76bVRFq/jQy3T+QZlgt5SF++ri/FHhhm/8ZIZtsnu/osdv
	 i6v14ziw3zRhXvDgMS5Wl8IYSwzpAHolGDI+KrDg=
Date: Thu, 18 Dec 2025 13:08:21 -0800
To: mm-commits@vger.kernel.org,tamird@gmail.com,skhawaja@google.com,rppt@kernel.org,rientjes@google.com,pratyush@kernel.org,pmladek@suse.com,kees@kernel.org,graf@amazon.com,dmatlack@google.com,davidgow@google.com,corbet@lwn.net,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-luo_file-use-private-list.patch added to mm-nonmm-unstable branch
Message-Id: <20251218210822.5F1F7C4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: luo_file: Use private list
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     liveupdate-luo_file-use-private-list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-luo_file-use-private-list.patch

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

list-add-primitives-for-private-list-manipulations.patch
list-add-kunit-test-for-private-list-primitives.patch
liveupdate-luo_file-use-private-list.patch
liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

