Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE541791EB
	for <mm-commits@vger.kernel.org>; Tue, 28 May 2024 20:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716928920; cv=none; b=Eyit70Tp1mrjQLvitjMZccg2GF26zzx3+FUfOn3EeZJeYN406iQskso6P4abURPhZjoQG5ksD/qWF8EH49972IFoWeKtk44eE+QPNn0I6eZufm1aBW7W4u/27XkFlAV8ACjQn6TsGJ22X/dGNNq/oHoSy/G9STbNcDiGpiXWeB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716928920; c=relaxed/simple;
	bh=v4YtCYvvE+f8UmD0UAGv7K95kEzARToCJ7Rm7p9ky3s=;
	h=Date:To:From:Subject:Message-Id; b=I7Qzugw51cnxrNSqVUkChR2IazaGvWyBnyre5Jfd4cRgraKRZ6a2TyyBnUyazzTbTFnBy+HbwCYmXwudpwlnTqB+QYwM6JfJMr3xBMtWEIKx++P9fohAFfYHZWq/yFMWbYO3weqVi044PH0dT6DbE8UY4lgKbPnHhyYVgjvCqOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I9ItiNWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I9ItiNWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB15FC3277B;
	Tue, 28 May 2024 20:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716928920;
	bh=v4YtCYvvE+f8UmD0UAGv7K95kEzARToCJ7Rm7p9ky3s=;
	h=Date:To:From:Subject:From;
	b=I9ItiNWlbfHSZHuPabVFmH6lUglWvukYFYl5PerTldfnwI4GfQrXa7UZ+ueB5NKFP
	 L71gTFrq/n/ICeJI1AxBNbA/bPt+vsbKbC9sDG+Qj5Ox8OaUFVZgnwofdGevieNyvJ
	 nhTeCadczPw2cz9me0D2c8Cp7YiLhEnKUJ4MF4P8=
Date: Tue, 28 May 2024 13:41:59 -0700
To: mm-commits@vger.kernel.org,jserv@ccns.ncku.edu.tw,visitorckw@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-sort-remove-unused-pr_fmt-macro.patch added to mm-nonmm-unstable branch
Message-Id: <20240528204159.EB15FC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/sort: remove unused pr_fmt macro
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-sort-remove-unused-pr_fmt-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-sort-remove-unused-pr_fmt-macro.patch

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
From: Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: lib/sort: remove unused pr_fmt macro
Date: Tue, 28 May 2024 04:30:08 +0800

Patch series "lib/sort: Optimizations and cleanups".

This patch series optimizes the handling of the last 2 or 3 elements in
lib/sort and adds a testcase in lib/test_sort to maintain 100% code
coverage reflecting this change.  Additionally, it corrects outdated
descriptions regarding glibc qsort() and removes the unused pr_fmt macro.


This patch (of 4):

The pr_fmt macro is defined but not used in lib/sort.c.  Since there are
no pr_* functions printing any messages, the pr_fmt macro is redundant and
can be safely removed.

Link: https://lkml.kernel.org/r/20240527203011.1644280-1-visitorckw@gmail.com
Link: https://lkml.kernel.org/r/20240527203011.1644280-2-visitorckw@gmail.com
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/sort.c |    2 --
 1 file changed, 2 deletions(-)

--- a/lib/sort.c~lib-sort-remove-unused-pr_fmt-macro
+++ a/lib/sort.c
@@ -10,8 +10,6 @@
  * quicksort's O(n^2) worst case.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/types.h>
 #include <linux/export.h>
 #include <linux/sort.h>
_

Patches currently in -mm which might be from visitorckw@gmail.com are

perf-core-fix-several-typos.patch
bcache-fix-typo.patch
bcachefs-fix-typo.patch
lib-min_heap-add-type-safe-interface.patch
lib-min_heap-add-min_heap_init.patch
lib-min_heap-add-min_heap_peek.patch
lib-min_heap-add-min_heap_full.patch
lib-min_heap-add-args-for-min_heap_callbacks.patch
lib-min_heap-add-min_heap_sift_up.patch
lib-min_heap-add-min_heap_del.patch
lib-min_heap-update-min_heap_push-and-min_heap_pop-to-return-bool-values.patch
lib-min_heap-rename-min_heapify-to-min_heap_sift_down.patch
lib-min_heap-update-min_heap_push-to-use-min_heap_sift_up.patch
lib-test_min_heap-add-test-for-heap_del.patch
bcache-remove-heap-related-macros-and-switch-to-generic-min_heap.patch
bcachefs-remove-heap-related-macros-and-switch-to-generic-min_heap.patch
lib-sort-remove-unused-pr_fmt-macro.patch
lib-sort-fix-outdated-comment-regarding-glibc-qsort.patch
lib-sort-optimize-heapsort-for-handling-final-2-or-3-elements.patch
lib-test_sort-add-a-testcase-to-ensure-code-coverage.patch

