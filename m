Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7B9423E9F
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816359; cv=none; b=pqrHl/hKS0NZ5utdruS97tj3dSKPtmvWcG4KWDVf8o2jFNDZeoUlZYiWL50rIiaOAa87Zx+4flQ/EBeq6pZTLfeGAC9++8G4v1QEZNWxvQkMU4ZP95qNlx874uT3CAlxhflv4mkdGfnkd/O8IghB+OBX2NAbHQaYT9m3i9IopPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816359; c=relaxed/simple;
	bh=JXM5mIVSy3m9qx/nCXDprnDkhXyK7pPpj8Tx/sqoo0c=;
	h=Date:To:From:Subject:Message-Id; b=OAp+XBQNwNcVMDSMDRBsXGX+VCPoKvpUn+o+LQ7cUV8YEPJHnOKz4ausu1PO2GXP8D37+aRq5tx298xM7Kdltz7uuvE+IDGHx31UA3Knrk+EBXrlnoctT1OUodoPoimg6P/URWcQPx8iI3BujLi1Qu6vP8wRZHXMoHfyPYdP7zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d05DKHh5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d05DKHh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215BB1F000E9;
	Tue,  4 Aug 2026 04:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816358;
	bh=WOAphybPpvAcYMf8P/p5G4wvNHNu0AoWMY9Oy6Al93Y=;
	h=Date:To:From:Subject;
	b=d05DKHh5rGs4t4wZXfvd3hIF0rMLiJ6ZxpFjoROb8NUOgxaYx7NMlE3ZKQQx8nE6X
	 XrOO7g8FWZmGItnBeXdt4qVpMoF557Swpx0pzXms2CoBI7s0x8VIuQugMr2jLsMlEz
	 vbJvES6+IztABsdNIbLsjyXDIl+Dvvdo/MtzsmOU=
Date: Mon, 03 Aug 2026 21:05:57 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] llist-use-correct-function-parameter-name.patch removed from -mm tree
Message-Id: <20260804040558.215BB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: llist: use correct function parameter name
has been removed from the -mm tree.  Its filename was
     llist-use-correct-function-parameter-name.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: llist: use correct function parameter name
Date: Thu, 23 Jul 2026 09:51:13 -0700

Correct the function parameter name to avoid kernel-doc warnings:

Warning: ./include/linux/llist.h:71 function parameter 'list' not described in 'init_llist_head'
Warning: ./include/linux/llist.h:71 Excess function parameter 'head' description in 'init_llist_head'

Link: https://lore.kernel.org/20260723165113.225098-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/llist.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/llist.h~llist-use-correct-function-parameter-name
+++ a/include/linux/llist.h
@@ -66,7 +66,7 @@ struct llist_node {
 
 /**
  * init_llist_head - initialize lock-less list head
- * @head:	the head for your lock-less list
+ * @list:	the head for your lock-less list
  */
 static inline void init_llist_head(struct llist_head *list)
 {
_

Patches currently in -mm which might be from rdunlap@infradead.org are


