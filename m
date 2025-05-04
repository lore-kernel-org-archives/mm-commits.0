Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C0B2FB6
	for <mm-commits@vger.kernel.org>; Sun,  4 May 2025 02:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746326173; cv=none; b=JmA1XG2nvVxE6dLsoJgq+VWH1Wg6B8mWTWXU5v84u79VNYRj5dY8JW9it6sxmKvOqxCTjxJ8dx6Zt3tmxRfaaqu2LtCBW9IYZEp4uhlWvHfVKqkMbZiquzAy2gCCATk1+vHT16pq8umAkhzeX6SlrTHBLzS21UopdX0B+sENIm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746326173; c=relaxed/simple;
	bh=v/Mi+XytCWoqoNisvwPN3oNtgMYQs1GUwWNKDppixso=;
	h=Date:To:From:Subject:Message-Id; b=ItmRY736aIecWn03rMVnNS/CGTj18KJN9V7Vq7FAauSHW/2LTxnxWWeFj8VeByfezNRjp83v/WPkuQkHDyiTCOJtr1+l9jrVVda7eAVhKZumjMxS0r9QaxUCEdVQ5TPuiMrESkO094QSIBmfrx/PWTuGCxzk7HukrZuVfPjpZ5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BXKk7yaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BXKk7yaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62331C4CEE3;
	Sun,  4 May 2025 02:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746326172;
	bh=v/Mi+XytCWoqoNisvwPN3oNtgMYQs1GUwWNKDppixso=;
	h=Date:To:From:Subject:From;
	b=BXKk7yaMF8QAZuqcR0DYNEqwsEnTkkwbHZxxnnkdGfJTOQIKzF9uQyF6Il2WMDYW6
	 tUfHR63tysiTfzrHqHYnJsnQqpX9MmeBtk/WgjlAkNqR3E42trQ137k/9A4gXofp//
	 W5IfyEGziyMUF+GMX0Nc9ZPAuN0hSglRcnX3Lawk=
Date: Sat, 03 May 2025 19:36:11 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + list-remove-redundant-extern-for-function-prototypes.patch added to mm-nonmm-unstable branch
Message-Id: <20250504023612.62331C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: list: remove redundant 'extern' for function prototypes
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     list-remove-redundant-extern-for-function-prototypes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/list-remove-redundant-extern-for-function-prototypes.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: list: remove redundant 'extern' for function prototypes
Date: Fri, 2 May 2025 15:17:42 +0300

The 'extern' keyword is redundant for function prototypes.  list.h never
used them and new code in general is better without them.

Link: https://lkml.kernel.org/r/20250502121742.3997529-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/list.h~list-remove-redundant-extern-for-function-prototypes
+++ a/include/linux/list.h
@@ -50,9 +50,9 @@ static inline void INIT_LIST_HEAD(struct
  * Performs the full set of list corruption checks before __list_add().
  * On list corruption reports a warning, and returns false.
  */
-extern bool __list_valid_slowpath __list_add_valid_or_report(struct list_head *new,
-							     struct list_head *prev,
-							     struct list_head *next);
+bool __list_valid_slowpath __list_add_valid_or_report(struct list_head *new,
+						      struct list_head *prev,
+						      struct list_head *next);
 
 /*
  * Performs list corruption checks before __list_add(). Returns false if a
@@ -93,7 +93,7 @@ static __always_inline bool __list_add_v
  * Performs the full set of list corruption checks before __list_del_entry().
  * On list corruption reports a warning, and returns false.
  */
-extern bool __list_valid_slowpath __list_del_entry_valid_or_report(struct list_head *entry);
+bool __list_valid_slowpath __list_del_entry_valid_or_report(struct list_head *entry);
 
 /*
  * Performs list corruption checks before __list_del_entry(). Returns false if a
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

util_macrosh-make-the-header-more-resilient.patch
kernelh-move-ptr_if-and-u64_to_user_ptr-to-util_macrosh.patch
util_macrosh-fix-the-reference-in-kernel-doc.patch
list-remove-redundant-extern-for-function-prototypes.patch

