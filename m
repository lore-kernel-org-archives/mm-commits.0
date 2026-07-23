Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828203446C7
	for <mm-commits@vger.kernel.org>; Thu, 23 Jul 2026 23:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784848696; cv=none; b=Axt+hJLQbeb3uL234WyT5+4jqiiv1c587+DhpYj5eAvvS+mJE12Esu2+BTjB1yeGNeF1ummqmGR0tmogdYkAUGQsl41cyUmFul1WzZ6zqrEKPp5BkyMqVrF43cClyhl3kI27r3DnuaxpZQd7/Lr9r9e06CG7Jcjc/9ZqyhMX5Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784848696; c=relaxed/simple;
	bh=FuGerIcfu1EKlyw8qawcRn4zrKykur3z+kbgP7azfBw=;
	h=Date:To:From:Subject:Message-Id; b=fuOaWSuwiseytrSqF0bjCUOSUl66rWI39XJr6cWpLGvufDRgWVb9JZOcnGcpyfGJh3vf7DTVhWXZFGDi+9KWHXmjbk9llfNlOcW87HB5dErGRF5WVuC73RaMJf5zE9lXoe9POXyBkAB6G0Z4QNO0XQHqNQUI2xNC1b5AqpOxmN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=f8NkaovJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="f8NkaovJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210BB1F000E9;
	Thu, 23 Jul 2026 23:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784848695;
	bh=AG7KI5e/OXyA6gxp5ZAY03Csnq6D6/+E3TAGb0jXlXM=;
	h=Date:To:From:Subject;
	b=f8NkaovJS/xU6tEXEMV65+1fZRW3MOCb/U926xUT4c8yTt8DsbdHj/n9nxq3vIlxO
	 IjAqN7x0YkF+ysS2YOiGhwjKG1RZVTD6G33yOevADssQQaPB+Y13HakmVMmWlsAGrD
	 5obBV4KKDURqy1mSDOusBnN/BiW6vFhRjiDVAofY=
Date: Thu, 23 Jul 2026 16:18:14 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + llist-use-correct-function-parameter-name.patch added to mm-nonmm-unstable branch
Message-Id: <20260723231815.210BB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: llist: use correct function parameter name
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     llist-use-correct-function-parameter-name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/llist-use-correct-function-parameter-name.patch

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

mm-migrate-use-migrate_info-field-instead-of-private-fix.patch
mm-page_owner-document-page_owner-filter-fix.patch
radix-tree-add-correct-some-kernel-doc.patch
delaytop-sort-by-max-delay-to-highlight-top-latency-processes-fix.patch
rbtree-fixup-kernel-doc-names.patch
llist-use-correct-function-parameter-name.patch

