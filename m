Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4F8284690
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782066742; cv=none; b=Q8Ts9y6ASROR0XVzTJmWr+1lUYmt2MDD4Vx1+JlFxxMLRHz2nJRGpEvPAy+kNpcEb6kTIVysCJuaAMEDJ+mHkubPpwUiNfjQU4o4BXbmKGmPURSlyW2oOK2rM1D1WGznFyvFYgKxlC1vi8YxFWjaJHb/I/tcEnPEfeGrVihjdm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782066742; c=relaxed/simple;
	bh=iwxakDt8ctphpyQ1x+b5DrDl0fnWjUzXuFHQpYmZD0w=;
	h=Date:To:From:Subject:Message-Id; b=HGJIyUorgU2gGW9yJz5FrnIqTaNWus9vGAm+Jzl+S/NCeMbvuHIRjWyh/m4apt/YCyTMtRerxNQQsqYuvK2vC/5pSCZe50cwNIdqi2v4/UTyFHCM5Be244vFK4R4wff6kBrXFR/ejsCDJE6KUkbG0H1hN8mp/HJ4ikAm/dxnDIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ixqCAvih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ixqCAvih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9C81F000E9;
	Sun, 21 Jun 2026 18:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782066740;
	bh=M7OzwftoLfCucMDa1qRg4m07labV7372RU5HJrDWF4c=;
	h=Date:To:From:Subject;
	b=ixqCAvih/jU9ZPiCothplsQhQfgEgmhE6Q13mrNvLQ7aFKllf5LQ8opCDC5tmRKOr
	 DXnsnRQFF4J1mTby2t3hBEMo+chGtZtgJDHE0TXOf5IgoxDZhBAR8fL/6BPfhT5Bp4
	 /d9q6poD0caL+boTDkqCakbM708EBzJzRm7b6WsE=
Date: Sun, 21 Jun 2026 11:32:20 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,nathan@kernel.org,kent.overstreet@linux.dev,bvanassche@acm.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-split-codetag_lock_module_list.patch removed from -mm tree
Message-Id: <20260621183220.AF9C81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib: split codetag_lock_module_list()
has been removed from the -mm tree.  Its filename was
     lib-split-codetag_lock_module_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -55,7 +55,7 @@ static void *allocinfo_start(struct seq_
 	loff_t node = *pos;
 
 	priv = (struct allocinfo_private *)m->private;
-	codetag_lock_module_list(alloc_tag_cttype, true);
+	codetag_lock_module_list(alloc_tag_cttype);
 	if (node == 0) {
 		priv->print_header = true;
 		priv->iter = codetag_get_ct_iter(alloc_tag_cttype);
@@ -82,7 +82,7 @@ static void *allocinfo_next(struct seq_f
 
 static void allocinfo_stop(struct seq_file *m, void *arg)
 {
-	codetag_lock_module_list(alloc_tag_cttype, false);
+	codetag_unlock_module_list(alloc_tag_cttype);
 }
 
 static void print_allocinfo_header(struct seq_buf *buf)
@@ -141,7 +141,7 @@ size_t alloc_tag_top_users(struct codeta
 		return 0;
 
 	if (can_sleep)
-		codetag_lock_module_list(alloc_tag_cttype, true);
+		codetag_lock_module_list(alloc_tag_cttype);
 	else if (!codetag_trylock_module_list(alloc_tag_cttype))
 		return 0;
 
@@ -166,7 +166,7 @@ size_t alloc_tag_top_users(struct codeta
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


