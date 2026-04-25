Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F0530AD0B
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 15:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777130901; cv=none; b=q125cY6ENvct2yvG+oolgic2yWP8CHx/FwZ2eub9nkAQ98SQGPxR9bLqBe97/STqQ+UvQGN8O516THZjUqo9DVI50808K2fhky+x5XLXWcBdyUj4FAWHTKPiYFuqc7gLZaD60gbuCypzysBgN20Hf+6vOWzxjoX/d1SixrezwAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777130901; c=relaxed/simple;
	bh=aY/5OHGRcuxd81qHVmyI6hSEOlArssuPxgPbyRdymA8=;
	h=Date:To:From:Subject:Message-Id; b=UccPYdfWOR3+8IeJyk3oUa7aUcUt81ZGySRgHfRy18QE1m26YQZbXHSTDMcqB/4fC9xjxnJaF97CwvOOPubg4xajbgIrx5A3YAI6WQdb/XYrbHbCYhcBSLrypjnpqbpAtY3AaoZPhFZU17M1R5aFC7mYQuQhRVdqjmGA2rnenjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zoWmu01d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zoWmu01d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B58EC2BCB0;
	Sat, 25 Apr 2026 15:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777130901;
	bh=aY/5OHGRcuxd81qHVmyI6hSEOlArssuPxgPbyRdymA8=;
	h=Date:To:From:Subject:From;
	b=zoWmu01d/BgRAiTGHBxWaepKz988Qi0SFE+Y6NVkg0WRj0GDxDa5Y5z6Dz56Ga46T
	 lmmR1AB2aNmtrh+UtDgaQ2sEhPl9nGeM7InkM6vj+iHvWorHNhTnXyKCvKL3hVjb5H
	 XPZO603umEl3pUcGweFux+l2WUpCfT2njVsuRGXc=
Date: Sat, 25 Apr 2026 08:28:20 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,nathan@kernel.org,kent.overstreet@linux.dev,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-split-codetag_lock_module_list.patch added to mm-nonmm-unstable branch
Message-Id: <20260425152821.0B58EC2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: split codetag_lock_module_list()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-split-codetag_lock_module_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-split-codetag_lock_module_list.patch

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
From: Bart Van Assche <bvanassche@acm.org>
Subject: lib: split codetag_lock_module_list()
Date: Tue, 24 Mar 2026 14:42:25 -0700

Letting a function argument indicate whether a lock or unlock operation
should be performed is incompatible with compile-time analysis of locking
operations by sparse and Clang.  Hence, split codetag_lock_module_list()
into two functions: a function that locks cttype->mod_lock and another
function that unlocks cttype->mod_lock.  No functionality has been
changed.  See also commit 916cc5167cc6 ("lib: code tagging framework").

Link: https://lore.kernel.org/20260324214226.3684605-1-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/codetag.h |    3 ++-
 lib/alloc_tag.c         |    8 ++++----
 lib/codetag.c           |   12 +++++++-----
 3 files changed, 13 insertions(+), 10 deletions(-)

--- a/include/linux/codetag.h~lib-split-codetag_lock_module_list
+++ a/include/linux/codetag.h
@@ -74,8 +74,9 @@ struct codetag_iterator {
 	.flags		= 0,				\
 }
 
-void codetag_lock_module_list(struct codetag_type *cttype, bool lock);
+void codetag_lock_module_list(struct codetag_type *cttype);
 bool codetag_trylock_module_list(struct codetag_type *cttype);
+void codetag_unlock_module_list(struct codetag_type *cttype);
 struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype);
 struct codetag *codetag_next_ct(struct codetag_iterator *iter);
 
--- a/lib/alloc_tag.c~lib-split-codetag_lock_module_list
+++ a/lib/alloc_tag.c
@@ -54,7 +54,7 @@ static void *allocinfo_start(struct seq_
 	loff_t node = *pos;
 
 	priv = (struct allocinfo_private *)m->private;
-	codetag_lock_module_list(alloc_tag_cttype, true);
+	codetag_lock_module_list(alloc_tag_cttype);
 	if (node == 0) {
 		priv->print_header = true;
 		priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
@@ -77,7 +77,7 @@ static void *allocinfo_next(struct seq_f
 
 static void allocinfo_stop(struct seq_file *m, void *arg)
 {
-	codetag_lock_module_list(alloc_tag_cttype, false);
+	codetag_unlock_module_list(alloc_tag_cttype);
 }
 
 static void print_allocinfo_header(struct seq_buf *buf)
@@ -136,7 +136,7 @@ size_t alloc_tag_top_users(struct codeta
 		return 0;
 
 	if (can_sleep)
-		codetag_lock_module_list(alloc_tag_cttype, true);
+		codetag_lock_module_list(alloc_tag_cttype);
 	else if (!codetag_trylock_module_list(alloc_tag_cttype))
 		return 0;
 
@@ -161,7 +161,7 @@ size_t alloc_tag_top_users(struct codeta
 		}
 	}
 
-	codetag_lock_module_list(alloc_tag_cttype, false);
+	codetag_unlock_module_list(alloc_tag_cttype);
 
 	return nr;
 }
--- a/lib/codetag.c~lib-split-codetag_lock_module_list
+++ a/lib/codetag.c
@@ -35,12 +35,9 @@ struct codetag_module {
 static DEFINE_MUTEX(codetag_lock);
 static LIST_HEAD(codetag_types);
 
-void codetag_lock_module_list(struct codetag_type *cttype, bool lock)
+void codetag_lock_module_list(struct codetag_type *cttype)
 {
-	if (lock)
-		down_read(&cttype->mod_lock);
-	else
-		up_read(&cttype->mod_lock);
+	down_read(&cttype->mod_lock);
 }
 
 bool codetag_trylock_module_list(struct codetag_type *cttype)
@@ -48,6 +45,11 @@ bool codetag_trylock_module_list(struct
 	return down_read_trylock(&cttype->mod_lock) != 0;
 }
 
+void codetag_unlock_module_list(struct codetag_type *cttype)
+{
+	up_read(&cttype->mod_lock);
+}
+
 struct codetag_iterator codetag_get_ct_iter(struct codetag_type *cttype)
 {
 	struct codetag_iterator iter = {
_

Patches currently in -mm which might be from bvanassche@acm.org are

clang-format-fix-formatting-of-guard-and-scoped_guard-statements.patch
lib-split-codetag_lock_module_list.patch

