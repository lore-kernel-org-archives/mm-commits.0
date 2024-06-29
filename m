Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20A0168C7
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628288; cv=none; b=gTyPBhIgeCjxNsiG5yj8apCmL3g5l5C8AL06o60WDI4Otp1zBgHvH1QUxp5lyWyPiyCaLbgsvbNyNg+gORlDLiAuug+Sa1T9fTSK4rUPUkYWS709iE8iIP6bDOOuQA/EyAeDsuKraQXH2dZLRKb6kWqNQFOWP8CTPkcIMe61hjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628288; c=relaxed/simple;
	bh=iJOHRltD9SPpvnm4GdNj2rb9kEwmB5JmzzM6wHIeYCM=;
	h=Date:To:From:Subject:Message-Id; b=M2PHBOmrVVz0PntNKnrHxL/OsHNrMRJEargaLUce+v7mD5e5Q3zaeDnK6fV1PLDfoJb/ToI26wJo8lAZcPS7aoPAaNyTk2kI4I4prSE9fmUzAH6VkUpurU7AO06td6sV8aGgGzRomiLiqXjKghr7VojaX7jxPIdwVxqBanvBaoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jcavv4bG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jcavv4bG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6B4C32781;
	Sat, 29 Jun 2024 02:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628287;
	bh=iJOHRltD9SPpvnm4GdNj2rb9kEwmB5JmzzM6wHIeYCM=;
	h=Date:To:From:Subject:From;
	b=Jcavv4bG41zzT+5yuh68XSvBTDJ1gZr8MAXpgTb91RQR0FG5m1R8iI7venu81oOx+
	 c6Dxt5cb25CRvLanrM1aVdxEGXY3PS5btAj3Uno56VqC02QMYQn2y0eUQzalsr/C4S
	 nbpTJUnRQ1Hlae322l2rxfzKAmE0TrsPEZuSwxYk=
Date: Fri, 28 Jun 2024 19:31:27 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,glider@google.com,elver@google.com,dvyukov@google.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-add-missing-__user-tags.patch removed from -mm tree
Message-Id: <20240629023127.CB6B4C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: add missing __user tags
has been removed from the -mm tree.  Its filename was
     kmsan-add-missing-__user-tags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: add missing __user tags
Date: Thu, 27 Jun 2024 16:57:46 +0200

sparse complains that __user pointers are being passed to functions that
expect non-__user ones.  In all cases, these functions are in fact working
with user pointers, only the tag is missing.  Add it.

Link: https://lkml.kernel.org/r/20240627145754.27333-2-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406272033.KejtfLkw-lkp@intel.com/
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c   |    4 ++--
 mm/kmsan/kmsan.h  |    6 +++---
 mm/kmsan/report.c |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/mm/kmsan/core.c~kmsan-add-missing-__user-tags
+++ a/mm/kmsan/core.c
@@ -249,8 +249,8 @@ struct page *kmsan_vmalloc_to_page_or_nu
 		return NULL;
 }
 
-void kmsan_internal_check_memory(void *addr, size_t size, const void *user_addr,
-				 int reason)
+void kmsan_internal_check_memory(void *addr, size_t size,
+				 const void __user *user_addr, int reason)
 {
 	depot_stack_handle_t cur_origin = 0, new_origin = 0;
 	unsigned long addr64 = (unsigned long)addr;
--- a/mm/kmsan/kmsan.h~kmsan-add-missing-__user-tags
+++ a/mm/kmsan/kmsan.h
@@ -73,7 +73,7 @@ void kmsan_print_origin(depot_stack_hand
  * @off_last corresponding to different @origin values.
  */
 void kmsan_report(depot_stack_handle_t origin, void *address, int size,
-		  int off_first, int off_last, const void *user_addr,
+		  int off_first, int off_last, const void __user *user_addr,
 		  enum kmsan_bug_reason reason);
 
 DECLARE_PER_CPU(struct kmsan_ctx, kmsan_percpu_ctx);
@@ -163,8 +163,8 @@ depot_stack_handle_t kmsan_internal_chai
 void kmsan_internal_task_create(struct task_struct *task);
 
 bool kmsan_metadata_is_contiguous(void *addr, size_t size);
-void kmsan_internal_check_memory(void *addr, size_t size, const void *user_addr,
-				 int reason);
+void kmsan_internal_check_memory(void *addr, size_t size,
+				 const void __user *user_addr, int reason);
 
 struct page *kmsan_vmalloc_to_page_or_null(void *vaddr);
 void kmsan_setup_meta(struct page *page, struct page *shadow,
--- a/mm/kmsan/report.c~kmsan-add-missing-__user-tags
+++ a/mm/kmsan/report.c
@@ -148,7 +148,7 @@ void kmsan_print_origin(depot_stack_hand
 }
 
 void kmsan_report(depot_stack_handle_t origin, void *address, int size,
-		  int off_first, int off_last, const void *user_addr,
+		  int off_first, int off_last, const void __user *user_addr,
 		  enum kmsan_bug_reason reason)
 {
 	unsigned long stack_entries[KMSAN_STACK_DEPTH];
_

Patches currently in -mm which might be from iii@linux.ibm.com are


