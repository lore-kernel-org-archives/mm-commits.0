Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D063254868
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 19:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744055250; cv=none; b=g2KMaVtAidNlRhUwvjH2EZFzkQ8nfRpF7wKuVNm67/Ysyp3LWYKAR+WBNtf9C35O7VPbMO2f7GY5Xf6TjL+pmvQgxQZf0gFa0Mn2TpjuEm7gjn55Yw+LZFkr86D8QFTnttZW9aXBMoe0LfmKrWAU7pXIMd6m3NYroUSVl5GBn2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744055250; c=relaxed/simple;
	bh=zG91Fo92PL2lXuWapmPBbFoP9C9VK2BQmEEayq5N6o0=;
	h=Date:To:From:Subject:Message-Id; b=sGtfgYHK82eZozzDqGGL4disJg+l4xcA9BIThnueWci6hYk9PlR9anGMPtNVwH8DfxojSxnaeR+Qr4kUeG0wvjqWNljaE44NNQUqJPclacdW6hycD4bheaFYFoxlEpG4IHPyhmh8DkebZGJEBlUUE2tHfl3+k3zI0vo0FkL6oX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tthIghUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tthIghUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C345C4CEF1;
	Mon,  7 Apr 2025 19:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744055249;
	bh=zG91Fo92PL2lXuWapmPBbFoP9C9VK2BQmEEayq5N6o0=;
	h=Date:To:From:Subject:From;
	b=tthIghUpWyWDxg7vOz/tYHJ3A6/nUeAEs7sZ4jaCXHHy5qPwYCdmBaqiMwf0P97ek
	 4EMxV+q/D6JKirS1SfxWyF0crvMel1mLc3VhwaJEBeFhkDZiSuTacqPupEmfD25HPV
	 lIjc4SaJFi/DKJnTXO5sz31mrIhQk+Jxn7PcXFxw=
Date: Mon, 07 Apr 2025 12:47:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,michal.swiatkowski@linux.intel.com,dave.hansen@intel.com,andriy.shevchenko@intel.com,przemyslaw.kitszel@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xarray-make-xa_alloc_cyclic-return-0-on-all-success-cases.patch added to mm-new branch
Message-Id: <20250407194729.5C345C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xarray: make xa_alloc_cyclic() return 0 on all success cases
has been added to the -mm mm-new branch.  Its filename is
     xarray-make-xa_alloc_cyclic-return-0-on-all-success-cases.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xarray-make-xa_alloc_cyclic-return-0-on-all-success-cases.patch

This patch will later appear in the mm-new branch at
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
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Subject: xarray: make xa_alloc_cyclic() return 0 on all success cases
Date: Thu, 20 Mar 2025 11:22:19 +0100

Change xa_alloc_cyclic() to return 0 even on wrap-around.  Do the same for
xa_alloc_cyclic_irq() and xa_alloc_cyclic_bh().

This will prevent any future bug of treating return of 1 as an error:
	int ret = xa_alloc_cyclic(...)
	if (ret) // currently mishandles ret==1
		goto failure;

If there will be someone interested in when wrap-around occurs, there is
still __xa_alloc_cyclic() that behaves as before.  For now there is no
such user.

Link: https://lkml.kernel.org/r/20250320102219.8101-1-przemyslaw.kitszel@intel.com
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Link: https://lore.kernel.org/netdev/Z9gUd-5t8b5NX2wE@casper.infradead.org
Cc: Andriy Shevchenko <andriy.shevchenko@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/xarray.h |   24 +++++++++++++++---------
 lib/test_xarray.c      |   17 +++++++++++++++--
 2 files changed, 30 insertions(+), 11 deletions(-)

--- a/include/linux/xarray.h~xarray-make-xa_alloc_cyclic-return-0-on-all-success-cases
+++ a/include/linux/xarray.h
@@ -965,10 +965,12 @@ static inline int __must_check xa_alloc_
  * Must only be operated on an xarray initialized with flag XA_FLAGS_ALLOC set
  * in xa_init_flags().
  *
+ * Note that callers interested in whether wrapping has occurred should
+ * use __xa_alloc_cyclic() instead.
+ *
  * Context: Any context.  Takes and releases the xa_lock.  May sleep if
  * the @gfp flags permit.
- * Return: 0 if the allocation succeeded without wrapping.  1 if the
- * allocation succeeded after wrapping, -ENOMEM if memory could not be
+ * Return: 0 if the allocation succeeded, -ENOMEM if memory could not be
  * allocated or -EBUSY if there are no free entries in @limit.
  */
 static inline int xa_alloc_cyclic(struct xarray *xa, u32 *id, void *entry,
@@ -981,7 +983,7 @@ static inline int xa_alloc_cyclic(struct
 	err = __xa_alloc_cyclic(xa, id, entry, limit, next, gfp);
 	xa_unlock(xa);
 
-	return err;
+	return err < 0 ? err : 0;
 }
 
 /**
@@ -1002,10 +1004,12 @@ static inline int xa_alloc_cyclic(struct
  * Must only be operated on an xarray initialized with flag XA_FLAGS_ALLOC set
  * in xa_init_flags().
  *
+ * Note that callers interested in whether wrapping has occurred should
+ * use __xa_alloc_cyclic() instead.
+ *
  * Context: Any context.  Takes and releases the xa_lock while
  * disabling softirqs.  May sleep if the @gfp flags permit.
- * Return: 0 if the allocation succeeded without wrapping.  1 if the
- * allocation succeeded after wrapping, -ENOMEM if memory could not be
+ * Return: 0 if the allocation succeeded, -ENOMEM if memory could not be
  * allocated or -EBUSY if there are no free entries in @limit.
  */
 static inline int xa_alloc_cyclic_bh(struct xarray *xa, u32 *id, void *entry,
@@ -1018,7 +1022,7 @@ static inline int xa_alloc_cyclic_bh(str
 	err = __xa_alloc_cyclic(xa, id, entry, limit, next, gfp);
 	xa_unlock_bh(xa);
 
-	return err;
+	return err < 0 ? err : 0;
 }
 
 /**
@@ -1039,10 +1043,12 @@ static inline int xa_alloc_cyclic_bh(str
  * Must only be operated on an xarray initialized with flag XA_FLAGS_ALLOC set
  * in xa_init_flags().
  *
+ * Note that callers interested in whether wrapping has occurred should
+ * use __xa_alloc_cyclic() instead.
+ *
  * Context: Process context.  Takes and releases the xa_lock while
  * disabling interrupts.  May sleep if the @gfp flags permit.
- * Return: 0 if the allocation succeeded without wrapping.  1 if the
- * allocation succeeded after wrapping, -ENOMEM if memory could not be
+ * Return: 0 if the allocation succeeded, -ENOMEM if memory could not be
  * allocated or -EBUSY if there are no free entries in @limit.
  */
 static inline int xa_alloc_cyclic_irq(struct xarray *xa, u32 *id, void *entry,
@@ -1055,7 +1061,7 @@ static inline int xa_alloc_cyclic_irq(st
 	err = __xa_alloc_cyclic(xa, id, entry, limit, next, gfp);
 	xa_unlock_irq(xa);
 
-	return err;
+	return err < 0 ? err : 0;
 }
 
 /**
--- a/lib/test_xarray.c~xarray-make-xa_alloc_cyclic-return-0-on-all-success-cases
+++ a/lib/test_xarray.c
@@ -1040,6 +1040,7 @@ static noinline void check_xa_alloc_3(st
 	unsigned int i, id;
 	unsigned long index;
 	void *entry;
+	int ret;
 
 	XA_BUG_ON(xa, xa_alloc_cyclic(xa, &id, xa_mk_index(1), limit,
 				&next, GFP_KERNEL) != 0);
@@ -1059,7 +1060,7 @@ static noinline void check_xa_alloc_3(st
 		else
 			entry = xa_mk_index(i - 0x3fff);
 		XA_BUG_ON(xa, xa_alloc_cyclic(xa, &id, entry, limit,
-					&next, GFP_KERNEL) != (id == 1));
+					&next, GFP_KERNEL) != 0);
 		XA_BUG_ON(xa, xa_mk_index(id) != entry);
 	}
 
@@ -1072,7 +1073,7 @@ static noinline void check_xa_alloc_3(st
 				xa_limit_32b, &next, GFP_KERNEL) != 0);
 	XA_BUG_ON(xa, id != UINT_MAX);
 	XA_BUG_ON(xa, xa_alloc_cyclic(xa, &id, xa_mk_index(base),
-				xa_limit_32b, &next, GFP_KERNEL) != 1);
+				xa_limit_32b, &next, GFP_KERNEL) != 0);
 	XA_BUG_ON(xa, id != base);
 	XA_BUG_ON(xa, xa_alloc_cyclic(xa, &id, xa_mk_index(base + 1),
 				xa_limit_32b, &next, GFP_KERNEL) != 0);
@@ -1080,7 +1081,19 @@ static noinline void check_xa_alloc_3(st
 
 	xa_for_each(xa, index, entry)
 		xa_erase_index(xa, index);
+	XA_BUG_ON(xa, !xa_empty(xa));
 
+	/* check wrap-around return of __xa_alloc_cyclic() */
+	next = UINT_MAX;
+	XA_BUG_ON(xa, xa_alloc_cyclic(xa, &id, xa_mk_index(UINT_MAX),
+				      xa_limit_32b, &next, GFP_KERNEL) != 0);
+	xa_lock(xa);
+	ret = __xa_alloc_cyclic(xa, &id, xa_mk_index(base), xa_limit_32b,
+				&next, GFP_KERNEL);
+	xa_unlock(xa);
+	XA_BUG_ON(xa, ret != 1);
+	xa_for_each(xa, index, entry)
+		xa_erase_index(xa, index);
 	XA_BUG_ON(xa, !xa_empty(xa));
 }
 
_

Patches currently in -mm which might be from przemyslaw.kitszel@intel.com are

xarray-make-xa_alloc_cyclic-return-0-on-all-success-cases.patch

