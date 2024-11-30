Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523EA1C6A3
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 02:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732935594; cv=none; b=S5PwgJdsCVQDiqSVxYgaWywojbzkUwtuXtoUCF2FKs+DIFdJ57RF3vXhqD3Xd3CY/2i7VTg7r65EtC89amHpnkTd2qK42KyUyUGTFmYyRY0Woi8Zsf7b8yrUCDt++vfrcQGmI9kkUaV+YC1tZiY1OIz4iJPr9MhakFG9ai2MTyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732935594; c=relaxed/simple;
	bh=2SeHI13PUmsc0ch3gdSasMQcSf9S8QRIHTdhWbFcvR4=;
	h=Date:To:From:Subject:Message-Id; b=RWvwcOw464eieAQGhfo/nf1P+gncIBVy6WpzC0WZHb2zP1Syja1bdv7mSQBv/Tiw8u7log1rFTElgPK5Oa+u/u2HqrXzzMB3kLkM7Z9VylxCUBVM+LASXlwfo+n3O4aXI/K1hTcq0Lm0RsJG8irQtEdAvfO/hEDqf4vjgbxV440=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XNP1Ml4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XNP1Ml4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BC1C4CECF;
	Sat, 30 Nov 2024 02:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732935594;
	bh=2SeHI13PUmsc0ch3gdSasMQcSf9S8QRIHTdhWbFcvR4=;
	h=Date:To:From:Subject:From;
	b=XNP1Ml4a9Ea1XvKxy2pvtNGXqf/1Ly+lpX+7v9YzQso3x2CTvG57uybZxqSbf8bXE
	 Ylui5ll/FNyH1S9YsE8+RQatiWFCr+Qjz/uJ69py15tvDGviAxzqChLTP2bT/fuBOt
	 mswGoI81UkJxGsHqlO/lNfn5YxDCcXISJ3OMb6GU=
Date: Fri, 29 Nov 2024 18:59:53 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,dchinner@redhat.com,aliceryhl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + list_lru-expand-list_lru_add-docs-with-info-about-sublists.patch added to mm-unstable branch
Message-Id: <20241130025954.15BC1C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: list_lru: expand list_lru_add() docs with info about sublists
has been added to the -mm mm-unstable branch.  Its filename is
     list_lru-expand-list_lru_add-docs-with-info-about-sublists.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/list_lru-expand-list_lru_add-docs-with-info-about-sublists.patch

This patch will later appear in the mm-unstable branch at
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
From: Alice Ryhl <aliceryhl@google.com>
Subject: list_lru: expand list_lru_add() docs with info about sublists
Date: Fri, 29 Nov 2024 14:58:25 +0000

The documentation for list_lru_add() and list_lru_del() has not been
updated since lru lists were originally introduced by commit a38e40824844
("list: add a new LRU list type").  Back then, list_lru stored all of the
items in a single list, but the implementation has since been expanded to
use many sublists internally.

Thus, update the docs to mention that the requirements about not using the
item with several lists at the same time also applies not using different
sublists.  Also mention that list_lru items are reparented when the memcg
is deleted as discussed on the LKML [1].

Also fix incorrect use of 'Return value:' which should be 'Return:'.

Link: https://lore.kernel.org/all/Z0eXrllVhRI9Ag5b@dread.disaster.area/ [1]
Link: https://lkml.kernel.org/r/20241129-list_lru_memcg_docs-v2-1-e285ff1c481b@google.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |   44 +++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 11 deletions(-)

--- a/include/linux/list_lru.h~list_lru-expand-list_lru_add-docs-with-info-about-sublists
+++ a/include/linux/list_lru.h
@@ -91,13 +91,24 @@ void memcg_reparent_list_lrus(struct mem
  * @memcg: the cgroup of the sublist to add the item to.
  *
  * If the element is already part of a list, this function returns doing
- * nothing. Therefore the caller does not need to keep state about whether or
- * not the element already belongs in the list and is allowed to lazy update
- * it. Note however that this is valid for *a* list, not *this* list. If
- * the caller organize itself in a way that elements can be in more than
- * one type of list, it is up to the caller to fully remove the item from
- * the previous list (with list_lru_del() for instance) before moving it
- * to @lru.
+ * nothing. This means that it is not necessary to keep state about whether or
+ * not the element already belongs in the list. That said, this logic only
+ * works if the item is in *this* list. If the item might be in some other
+ * list, then you cannot rely on this check and you must remove it from the
+ * other list before trying to insert it.
+ *
+ * The lru list consists of many sublists internally; the @nid and @memcg
+ * parameters are used to determine which sublist to insert the item into.
+ * It's important to use the right value of @nid and @memcg when deleting the
+ * item, since it might otherwise get deleted from the wrong sublist.
+ *
+ * This also applies when attempting to insert the item multiple times - if
+ * the item is currently in one sublist and you call list_lru_add() again, you
+ * must pass the right @nid and @memcg parameters so that the same sublist is
+ * used.
+ *
+ * You must ensure that the memcg is not freed during this call (e.g., with
+ * rcu or by taking a css refcnt).
  *
  * Return: true if the list was updated, false otherwise
  */
@@ -113,7 +124,7 @@ bool list_lru_add(struct list_lru *lru,
  * memcg of the sublist is determined by @item list_head. This assumption is
  * valid for slab objects LRU such as dentries, inodes, etc.
  *
- * Return value: true if the list was updated, false otherwise
+ * Return: true if the list was updated, false otherwise
  */
 bool list_lru_add_obj(struct list_lru *lru, struct list_head *item);
 
@@ -125,8 +136,19 @@ bool list_lru_add_obj(struct list_lru *l
  * @memcg: the cgroup of the sublist to delete the item from.
  *
  * This function works analogously as list_lru_add() in terms of list
- * manipulation. The comments about an element already pertaining to
- * a list are also valid for list_lru_del().
+ * manipulation.
+ *
+ * The comments in list_lru_add() about an element already being in a list are
+ * also valid for list_lru_del(), that is, you can delete an item that has
+ * already been removed or never been added. However, if the item is in a
+ * list, it must be in *this* list, and you must pass the right value of @nid
+ * and @memcg so that the right sublist is used.
+ *
+ * You must ensure that the memcg is not freed during this call (e.g., with
+ * rcu or by taking a css refcnt). When a memcg is deleted, list_lru entries
+ * are automatically moved to the parent memcg. This is done in a race-free
+ * way, so during deletion of an memcg both the old and new memcg will resolve
+ * to the same sublist internally.
  *
  * Return: true if the list was updated, false otherwise
  */
@@ -142,7 +164,7 @@ bool list_lru_del(struct list_lru *lru,
  * memcg of the sublist is determined by @item list_head. This assumption is
  * valid for slab objects LRU such as dentries, inodes, etc.
  *
- * Return value: true if the list was updated, false otherwise.
+ * Return: true if the list was updated, false otherwise.
  */
 bool list_lru_del_obj(struct list_lru *lru, struct list_head *item);
 
_

Patches currently in -mm which might be from aliceryhl@google.com are

mm-zswap-add-lru_stop-to-comment-about-dropping-the-lru-lock.patch
list_lru-expand-list_lru_add-docs-with-info-about-sublists.patch

