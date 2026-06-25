Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0B030276A
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 22:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428015; cv=none; b=Rf60gzXUGgZiSflvCwvakVwg46b0sXFpVq2d/GI222H62YUEBiFC3npU29QyGAoo+gCKuUTYn8LaShzzpZgFh+v0FTNsQRRW24NUEK1lAKeC/kGp/2D7nZPqPuBHgVJ1VG5KrVpFIYkHMnWeprQr/xex05M/MJ7qzyI1YzjKMVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428015; c=relaxed/simple;
	bh=XhxWcojWE1beeOR9iWVjEGvQjkt/Ma1ND5QUdDVY8Ds=;
	h=Date:To:From:Subject:Message-Id; b=aFqFXFYIO/OLlLRLEL3NYnR3MC/WirCq3APGaN+QDX7UNuNZBWv4xMk+VcGTB6kUVFfImzRWNIck93HVGjqeadRyEsY7Vadwdcet45PZSB9BoOuNR1XnXSeXYEQ74PROGTDALZ5P//MGbuKrE3a4YY8jQt/I1/GNguivljoCPfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C3nneeR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C3nneeR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F186A1F000E9;
	Thu, 25 Jun 2026 22:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782428014;
	bh=GFCiiCDuvWKXt0eP4HEt/tA7s/NPJx3xaJGk66dLVZ0=;
	h=Date:To:From:Subject;
	b=C3nneeR7TdCe6+UTslQ6dE3I2s9NdQKK/yDJFKDbm64ohc/aj2CKARHQ+SqhLHm43
	 s/HAp6A19vsn6ebk4Qw1pvMXyvFz65ANQfHOqz5Qk3wK0zt7U8hyMhXAdfexUStqPS
	 +6dVBvJjUvtYpAjGfK9Hw84rJbrZlGaaLW3fpibw=
Date: Thu, 25 Jun 2026 15:53:33 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu_ref-fix-documentation-of-maximum-value.patch added to mm-new branch
Message-Id: <20260625225333.F186A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: percpu_ref: fix documentation of maximum value
has been added to the -mm mm-new branch.  Its filename is
     percpu_ref-fix-documentation-of-maximum-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/percpu_ref-fix-documentation-of-maximum-value.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: percpu_ref: fix documentation of maximum value
Date: Wed, 11 Dec 2024 20:40:14 +0000

Tejun changd percpu_ref to use long instead of int back in 2014 but missed
updating this bit of the documentation.  Also add the documentation to the
htmldocs.

Link: https://lore.kernel.org/20241211204017.184512-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/driver-api/basics.rst |    3 +++
 include/linux/percpu-refcount.h     |    5 +++--
 lib/percpu-refcount.c               |    2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

--- a/Documentation/driver-api/basics.rst~percpu_ref-fix-documentation-of-maximum-value
+++ a/Documentation/driver-api/basics.rst
@@ -90,6 +90,9 @@ Reference counting
 .. kernel-doc:: lib/refcount.c
    :export:
 
+.. kernel-doc:: include/linux/percpu-refcount.h
+.. kernel-doc:: lib/percpu-refcount.c
+
 Atomics
 -------
 
--- a/include/linux/percpu-refcount.h~percpu_ref-fix-documentation-of-maximum-value
+++ a/include/linux/percpu-refcount.h
@@ -12,8 +12,8 @@
  * start shutting down you call percpu_ref_kill() _before_ dropping the initial
  * refcount.
  *
- * The refcount will have a range of 0 to ((1U << 31) - 1), i.e. one bit less
- * than an atomic_t - this is because of the way shutdown works, see
+ * The refcount will have a range of 0 to LONG_MAX, i.e. one bit less
+ * than an atomic_long_t - this is because of the way shutdown works, see
  * percpu_ref_kill()/PERCPU_COUNT_BIAS.
  *
  * Before you call percpu_ref_kill(), percpu_ref_put() does not check for the
@@ -269,6 +269,7 @@ static inline bool percpu_ref_tryget(str
 /**
  * percpu_ref_tryget_live_rcu - same as percpu_ref_tryget_live() but the
  * caller is responsible for taking RCU.
+ * @ref: percpu_ref to try-get
  *
  * This function is safe to call as long as @ref is between init and exit.
  */
--- a/lib/percpu-refcount.c~percpu_ref-fix-documentation-of-maximum-value
+++ a/lib/percpu-refcount.c
@@ -289,7 +289,7 @@ static void __percpu_ref_switch_mode(str
  * @confirm_switch: optional confirmation callback
  *
  * There's no reason to use this function for the usual reference counting.
- * Use percpu_ref_kill[_and_confirm]().
+ * Use percpu_ref_kill() or percpu_ref_kill_and_confirm().
  *
  * Schedule switching of @ref to atomic mode.  All its percpu counts will
  * be collected to the main atomic counter.  On completion, when all CPUs
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-writebackh-to-docs-build.patch
percpu_ref-fix-documentation-of-maximum-value.patch

