Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140D5284B2E
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 05:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752126274; cv=none; b=VKxAtBiBvRJGO84qTv3OfghQIEgy+8vFOyGWiMOZB0m96lI/715dx15bFDG6XXqVmarCJU20OC/2c6Ep4RejZcdoB/DxgRkN95eqUhUDNmA/+saaagmPLWbxdwStB34PUOrKi2N8V9sVPViBtsynYZX0cdF2RSwE0k/ZwMuw3CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752126274; c=relaxed/simple;
	bh=YFMpc7q5M3JJh4bg5R9DD9yBfm+971hDyVb5wFnkzdY=;
	h=Date:To:From:Subject:Message-Id; b=Wtynx713fT4NfcpP9H6bqvlQiuiL6td2FsSQd+kJeVhsbz6F5AVgOf+lXWsIaGlVS5XONAMDhpQPkVGPpsLCJQrpO676+BpoQQfpIRJl0aQ3qz1b89H4KWZCzN2PtgaJfufsPo4DDTi1Es5VmrC6vmEjlC5XHO7CWta60eY/lUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YLsin1RG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YLsin1RG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD22C4CEE3;
	Thu, 10 Jul 2025 05:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752126274;
	bh=YFMpc7q5M3JJh4bg5R9DD9yBfm+971hDyVb5wFnkzdY=;
	h=Date:To:From:Subject:From;
	b=YLsin1RGjjonNvIEaZUQBbW1UtnA2F0W9cPY/ilr67daQSPKl+Qctvbweqx7WZhVi
	 hGfMl1hdwJgEEsevafCpbrxyHi5pCf9WzL5vyDfPJngeNrQTHksj4pAN4B+nLwilNk
	 KprVZpDVoyXeYE4JsAq0DuNNO1Z5+uRbpeEvcE3U=
Date: Wed, 09 Jul 2025 22:44:33 -0700
To: mm-commits@vger.kernel.org,tim.c.chen@linux.intel.com,surenb@google.com,kent.overstreet@linux.dev,00107082@163.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alloc_tag-add-sequence-number-for-module-and-iterator.patch removed from -mm tree
Message-Id: <20250710054433.DDD22C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: add sequence number for module and iterator
has been removed from the -mm tree.  Its filename was
     alloc_tag-add-sequence-number-for-module-and-iterator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
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


