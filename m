Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CD91DF25A
	for <mm-commits@vger.kernel.org>; Mon,  9 Jun 2025 23:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749513288; cv=none; b=KxOBm4n6JyiUCcaXmBLXKT6zfDH7qvH7Ei9O+eRInjyjTmM7EdQHIqSBvvT6QeVM+nBjHr7JkeYpS0HWkKs4le2Z/xfXw0Nh6k4BiG4zxMkIfEf4yLA5rlRNi0KUD7M8MuJkDP2befv4OGDNG0XWftUSEFizA1CTDxDxVGnL5xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749513288; c=relaxed/simple;
	bh=qKU0Kbdctd41mkExmpA+gufaCX+/EI8dv3zniy+q/7M=;
	h=Date:To:From:Subject:Message-Id; b=F2ovmx4QlHg08bC/gTzq6NNMEDDU9GN3HwUN7Rn7eRkKmWCBRMO7N6Xq3KRsCTeIh1kJcK6z7H2BOpQPiBh6ypFQLSgZwjN/ak79nm0xcRPBKvLdQ/Ch3tMHS6sYOaEphSTZYLzs8tbs4V4EoF9VVIk86ZLdSppcJ/VrO5RyteA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qJ8ipEjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qJ8ipEjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FA3C4CEEB;
	Mon,  9 Jun 2025 23:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749513287;
	bh=qKU0Kbdctd41mkExmpA+gufaCX+/EI8dv3zniy+q/7M=;
	h=Date:To:From:Subject:From;
	b=qJ8ipEjIEUyJ0qSGznqGGCte4SUTDiIe6vxtQKFanVuJ2waGS2/D4Xnl06mZHAY41
	 J/2EQ/s81hRv2XwRgoezQq2i1Sp9H7zFbON/HhEujsl/euhZpCPsa+VUwzXxPi6NWT
	 LCiVFm/riijWBl8Qdr5e3IsPF50p3twlJDU2gW4U=
Date: Mon, 09 Jun 2025 16:54:47 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,surenb@google.com,kent.overstreet@linux.dev,00107082@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-add-sequence-number-for-module-and-iterator.patch added to mm-new branch
Message-Id: <20250609235447.95FA3C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: add sequence number for module and iterator
has been added to the -mm mm-new branch.  Its filename is
     alloc_tag-add-sequence-number-for-module-and-iterator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-add-sequence-number-for-module-and-iterator.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: David Wang <00107082@163.com>
Subject: alloc_tag: add sequence number for module and iterator
Date: Mon, 9 Jun 2025 14:42:00 +0800

Codetag iterator use <id,address> pair to guarantee the validness.  But
both id and address can be reused, there is theoretical possibility when
module inserted right after another module removed, kmalloc returns an
address same as the address kfree by previous module and IDR key reuses
the key recently removed.

Add a sequence number to codetag_module and code_iterator, the sequence
number is strickly incremented whenever a module is loaded.  An iterator
is valid if and only if its sequence number match codetag_module's.

Link: https://lkml.kernel.org/r/20250609064200.112639-1-00107082@163.com
Signed-off-by: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/codetag.h |    1 +
 lib/codetag.c           |   17 ++++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

--- a/include/linux/codetag.h~alloc_tag-add-sequence-number-for-module-and-iterator
+++ a/include/linux/codetag.h
@@ -54,6 +54,7 @@ struct codetag_iterator {
 	struct codetag_module *cmod;
 	unsigned long mod_id;
 	struct codetag *ct;
+	unsigned long mod_seq;
 };
 
 #ifdef MODULE
--- a/lib/codetag.c~alloc_tag-add-sequence-number-for-module-and-iterator
+++ a/lib/codetag.c
@@ -11,8 +11,14 @@ struct codetag_type {
 	struct list_head link;
 	unsigned int count;
 	struct idr mod_idr;
-	struct rw_semaphore mod_lock; /* protects mod_idr */
+	/*
+	 * protects mod_idr, next_mod_seq,
+	 * iter->mod_seq and cmod->mod_seq
+	 */
+	struct rw_semaphore mod_lock;
 	struct codetag_type_desc desc;
+	/* generates unique sequence number for module load */
+	unsigned long next_mod_seq;
 };
 
 struct codetag_range {
@@ -23,6 +29,7 @@ struct codetag_range {
 struct codetag_module {
 	struct module *mod;
 	struct codetag_range range;
+	unsigned long mod_seq;
 };
 
 static DEFINE_MUTEX(codetag_lock);
@@ -48,6 +55,7 @@ struct codetag_iterator codetag_get_ct_i
 		.cmod = NULL,
 		.mod_id = 0,
 		.ct = NULL,
+		.mod_seq = 0,
 	};
 
 	return iter;
@@ -91,11 +99,13 @@ struct codetag *codetag_next_ct(struct c
 		if (!cmod)
 			break;
 
-		if (cmod != iter->cmod) {
+		if (!iter->cmod || iter->mod_seq != cmod->mod_seq) {
 			iter->cmod = cmod;
+			iter->mod_seq = cmod->mod_seq;
 			ct = get_first_module_ct(cmod);
-		} else
+		} else {
 			ct = get_next_module_ct(iter);
+		}
 
 		if (ct)
 			break;
@@ -191,6 +201,7 @@ static int codetag_module_init(struct co
 	cmod->range = range;
 
 	down_write(&cttype->mod_lock);
+	cmod->mod_seq = ++cttype->next_mod_seq;
 	mod_id = idr_alloc(&cttype->mod_idr, cmod, 0, 0, GFP_KERNEL);
 	if (mod_id >= 0) {
 		if (cttype->desc.module_load) {
_

Patches currently in -mm which might be from 00107082@163.com are

alloc_tag-add-sequence-number-for-module-and-iterator.patch
alloc_tag-keep-codetag-iterator-active-between-read.patch

