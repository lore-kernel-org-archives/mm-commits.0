Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C9E1A9B40
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011389; cv=none; b=nIj8yCX1W0ypKroKgdEtti2Weyo04/wonHGeexu/+lqx/5garTQsGSjfq24LCoT5W6sDMFOeK1gnVAtCStVW4n7wiBUDYOOayR40ArUClpzmgQwmKpO0+BJ+AGIKsL4PPcvvZvX3dja49WQa5bqwiCJVEse7bLnHXUTZsSttd04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011389; c=relaxed/simple;
	bh=p9F8Yw2Ox9xgYtmLdatX9VLit6bp/07zYKnq2Gqifx4=;
	h=Date:To:From:Subject:Message-Id; b=e5fdBMEmkzyXu5q18Z3T+o0U9sfLK6Dh7yuZF9xSKZB5w7C19RAafrRCr9bpFwwC4NBlGyEDwE7c4BWAQPytyF2Ea4dqfNW2Lgq97jcMB1J8gFsroLWtmOAHk5ASx+1sQRIoXiyYVry525b1UNLRFLyQaLiT2GpeWqXZUku33OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jum3Z79g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jum3Z79g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B77C4CEED;
	Mon, 12 May 2025 00:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011389;
	bh=p9F8Yw2Ox9xgYtmLdatX9VLit6bp/07zYKnq2Gqifx4=;
	h=Date:To:From:Subject:From;
	b=Jum3Z79gfc8nnYExUG1nrHOND0DWQ7bs49TZr9wRqpo6S2Tbu9A7dW2DBP92Zgp9k
	 AwBFw7g4/QzqPBJ0TojPFkKn4AGfQbv2+XSwB8okMPLRZ2HeCgS3xWBdETTap2cty+
	 RqGIw1dhL3KFC6Zaa1TT9kvB1h3CFRQT4eYiNpgk=
Date: Sun, 11 May 2025 17:56:28 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] list-remove-redundant-extern-for-function-prototypes.patch removed from -mm tree
Message-Id: <20250512005629.69B77C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: list: remove redundant 'extern' for function prototypes
has been removed from the -mm tree.  Its filename was
     list-remove-redundant-extern-for-function-prototypes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

