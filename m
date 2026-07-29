Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F016F391E7C
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298454; cv=none; b=Ay+Cc0nkoiZSsmWcrbrBFecSvZoBGNVZLYG1r387FLKzrEkiRqJEtIFtpcVdpKO2mjA4YZl6a3OWJa0QYO5Lta8MZbgQowfYDhV8Y54Xy8jhVFatIUSmxpYLJlXMQoPVI1vO15rHxaMdfyCkV63cxtZcZjTQgVJlnvWp+Ukc/ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298454; c=relaxed/simple;
	bh=DxWQKR0OuNVMAic877Lq4shVZvYZSx6uJOTZPD4pDjI=;
	h=Date:To:From:Subject:Message-Id; b=WcAvlUQMRqxrPLqXSQxBUJKgW0WowHXzKE0EOTHSDWryNLK/OAkN+CAFTha+I/duqw3VA8Sn7qdTEvPeGYrIJVyH328nmedAlIi7esdkXOvWbSG9wiMy2euLYEH7ACU8j6YCteARvfwqkqKiLWBOeb3fv025m7rvlHMnE2v1bi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ihB9xgtW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ihB9xgtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795FF1F00A3A;
	Wed, 29 Jul 2026 04:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298452;
	bh=H7aQmK9XpwwKBVza9k/V5ecBbs/qAF1nZKRqAj3k3Xg=;
	h=Date:To:From:Subject;
	b=ihB9xgtW1JTssCUslvU/gVzRfbS6ez6gdT0TuHMIcw5JvC5qAgdJUbQSQP5b5n78r
	 oBZDzoL8yhDQOIndvJsCPCo4ye59hpnAYxwmeWqtYx4uL9dV2FsgvT22Is3wWvh5Qe
	 nJTMkOR/Q346Fe6cXCBD74OsEUH3xUi2z0zNfdYE=
Date: Tue, 28 Jul 2026 21:14:12 -0700
To: mm-commits@vger.kernel.org,tj@kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] percpu_ref-fix-documentation-of-maximum-value.patch removed from -mm tree
Message-Id: <20260729041412.795FF1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: percpu_ref: fix documentation of maximum value
has been removed from the -mm tree.  Its filename was
     percpu_ref-fix-documentation-of-maximum-value.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


