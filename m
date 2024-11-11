Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F6213E02E
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313728; cv=none; b=JSIOBzlGeOS14kmwpM66+l1mMglMwf1h9cpoyTaWvKC5emAcUp0g6G1bbAQkZeSxMZnwPibChh7/I4Y1haUSKX5KZyI/NLSMa5i8FIJrmz1YYHqGDlvOcWSXJ+AqO4g+68A/oiz97sYyQZJRqWgPh/8I8SO1cXAuRj1ZikrMWYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313728; c=relaxed/simple;
	bh=rNT7kud1xP3si0VMHvx5ObaB1pXqK6iqtLx0Hi9Mow0=;
	h=Date:To:From:Subject:Message-Id; b=GqMN1lL3G5zAZPYfvuExiyfxJcjL+W4h/2mlmJwA45Zyt4C4cDZLAvgvc8CGCUKkamCM13GXQEwtG3gEYuSlGIH/Gmecs9fsRQeYsCEAJS9g4Xm3GWY5rHm6MaD9Gv6FoGiQF8Zf8jyHakHjCwKuu4A8hyj8vqopljcbEQ3TDFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=af859dy1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="af859dy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9707CC4CED0;
	Mon, 11 Nov 2024 08:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313728;
	bh=rNT7kud1xP3si0VMHvx5ObaB1pXqK6iqtLx0Hi9Mow0=;
	h=Date:To:From:Subject:From;
	b=af859dy1WGCri+TZnhx7h8/N621aMiIgMJkymQ+IVyih0j1cwFVAlnx9m5Co1QXIZ
	 pkQqvLktpZtr7We5cSHL2lG9lY9uXpNDFajTSWozz7negV0N65zvTw+vNHlOB3cn/4
	 ZwDgNvWiizLBOHElLsEp0vkCzTYHd6ts44aYK/Vc=
Date: Mon, 11 Nov 2024 00:28:48 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,mcanal@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-move-get_order_from_str-to-internalh.patch removed from -mm tree
Message-Id: <20241111082848.9707CC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: move ``get_order_from_str()`` to internal.h
has been removed from the -mm tree.  Its filename was
     mm-move-get_order_from_str-to-internalh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Maíra Canal <mcanal@igalia.com>
Subject: mm: move ``get_order_from_str()`` to internal.h
Date: Fri, 1 Nov 2024 13:54:07 -0300

In order to implement a kernel parameter similar to ``thp_anon=`` for
shmem, we'll need the function ``get_order_from_str()``.

Instead of duplicating the function, move the function to a shared
header, in which both mm/shmem.c and mm/huge_memory.c will be able to
use it.

Link: https://lkml.kernel.org/r/20241101165719.1074234-5-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   38 +++++++++++++++-----------------------
 mm/internal.h    |   22 ++++++++++++++++++++++
 2 files changed, 37 insertions(+), 23 deletions(-)

--- a/mm/huge_memory.c~mm-move-get_order_from_str-to-internalh
+++ a/mm/huge_memory.c
@@ -958,26 +958,6 @@ out:
 }
 __setup("transparent_hugepage=", setup_transparent_hugepage);
 
-static inline int get_order_from_str(const char *size_str)
-{
-	unsigned long size;
-	char *endptr;
-	int order;
-
-	size = memparse(size_str, &endptr);
-
-	if (!is_power_of_2(size))
-		goto err;
-	order = get_order(size);
-	if (BIT(order) & ~THP_ORDERS_ALL_ANON)
-		goto err;
-
-	return order;
-err:
-	pr_err("invalid size %s in thp_anon boot parameter\n", size_str);
-	return -EINVAL;
-}
-
 static char str_dup[PAGE_SIZE] __initdata;
 static int __init setup_thp_anon(char *str)
 {
@@ -1007,10 +987,22 @@ static int __init setup_thp_anon(char *s
 				start_size = strsep(&subtoken, "-");
 				end_size = subtoken;
 
-				start = get_order_from_str(start_size);
-				end = get_order_from_str(end_size);
+				start = get_order_from_str(start_size, THP_ORDERS_ALL_ANON);
+				end = get_order_from_str(end_size, THP_ORDERS_ALL_ANON);
 			} else {
-				start = end = get_order_from_str(subtoken);
+				start_size = end_size = subtoken;
+				start = end = get_order_from_str(subtoken,
+								 THP_ORDERS_ALL_ANON);
+			}
+
+			if (start == -EINVAL) {
+				pr_err("invalid size %s in thp_anon boot parameter\n", start_size);
+				goto err;
+			}
+
+			if (end == -EINVAL) {
+				pr_err("invalid size %s in thp_anon boot parameter\n", end_size);
+				goto err;
 			}
 
 			if (start < 0 || end < 0 || start > end)
--- a/mm/internal.h~mm-move-get_order_from_str-to-internalh
+++ a/mm/internal.h
@@ -1291,6 +1291,28 @@ static inline bool alloc_zeroed(void)
 			&init_on_alloc);
 }
 
+/*
+ * Parses a string with mem suffixes into its order. Useful to parse kernel
+ * parameters.
+ */
+static inline int get_order_from_str(const char *size_str,
+				     unsigned long valid_orders)
+{
+	unsigned long size;
+	char *endptr;
+	int order;
+
+	size = memparse(size_str, &endptr);
+
+	if (!is_power_of_2(size))
+		return -EINVAL;
+	order = get_order(size);
+	if (BIT(order) & ~valid_orders)
+		return -EINVAL;
+
+	return order;
+}
+
 enum {
 	/* mark page accessed */
 	FOLL_TOUCH = 1 << 16,
_

Patches currently in -mm which might be from mcanal@igalia.com are


