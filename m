Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21F31CEAC9
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 18:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730485752; cv=none; b=A0N4IoSVWCgwCtSK3+2AOVAaiO3yVV8RlEVt0xnw9vM9+XwSt4zwgXCLf50fLINgwOpNRoiOYnwP9A7Yyi86iXdBFFQ19HtL1Zkxtq3ZXQgxxbcexa78DP3ydPLNehT/8Ulcf29JHahpwY8lJRubhWaV0w1O6rDgLNuTJnIzbOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730485752; c=relaxed/simple;
	bh=loersE5vUaaXT1aw+WMWsF877qiX3//X/cDKlpqw/vw=;
	h=Date:To:From:Subject:Message-Id; b=Uy4OX1qX6MS1wGo7f5NEsd+JwMkfhORZkQN2IkhJ9Gi5FZFlKkdr3TP3JCukoGTAlzs0Wu+B3N1v3D5hvPA2KVjJ+IbDs6vLi6JbC0ggwDhq+VsZss/5q0PtX1lRNgCtLnvPn5xR52fTCIVCjp06G3cgYs+gU6RHYNbrrBYzLf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NB2nOV4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NB2nOV4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EA8C4CECD;
	Fri,  1 Nov 2024 18:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730485752;
	bh=loersE5vUaaXT1aw+WMWsF877qiX3//X/cDKlpqw/vw=;
	h=Date:To:From:Subject:From;
	b=NB2nOV4P7G8j2I8zYNvv/xzs/ssvsENwNXkqWv5Mg0PsFbywl2j/a32rIVLmEh9Wu
	 f68xFa/9KIp2K/2t61G/pJzDn+q0SDKHVW+eIvmcwrQttHJR1YYRKocNqq2fMwfi09
	 kT6RCcjwOtInmvSp846H0GzhdZyr2csdE1PFxJew=
Date: Fri, 01 Nov 2024 11:29:12 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,mcanal@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-get_order_from_str-to-internalh.patch added to mm-unstable branch
Message-Id: <20241101182912.A2EA8C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: move ``get_order_from_str()`` to internal.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-get_order_from_str-to-internalh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-get_order_from_str-to-internalh.patch

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
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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

mm-fix-docs-for-the-kernel-parameter-thp_anon=.patch
mm-shmem-control-thp-support-through-the-kernel-command-line.patch
mm-move-get_order_from_str-to-internalh.patch
mm-shmem-override-mthp-shmem-default-with-a-kernel-parameter.patch
mm-huge_memory-use-strscpy-instead-of-strcpy.patch

