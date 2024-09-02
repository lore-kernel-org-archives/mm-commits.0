Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844ACB663
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 01:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238887; cv=none; b=ttdz22pyY48xswRVqFmMkCb0rL3QgKz2so1NVuR1VlVVJLJb1K92HyeWVFo+7toGWbJGWcd73KfZNXWgbnDnQUtDi4KFWayxlvc/t3zmHo1ZC9CO0EZXw+HkCXyS14/JMgkW/zacGed4CdEv1PiyJDIGbeAYQoP8t1aDykEGWGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238887; c=relaxed/simple;
	bh=XoXr60mrv+MfMr0MWxX2WLrqnEPYBhC56QQok/UGh5M=;
	h=Date:To:From:Subject:Message-Id; b=VXhL0wCK1HPEpzPYfnMDTZyMccGLX68j9VsJsJ/V9tWApbPmM7FBdje0XlwktNG6tJTL7qNratbZguRL/353ApenhOnhVcQW32eohitz/WEZiuxLiydj85dxEeQi332w2bmnazMHHcQQ0WPIFOuVYGePsBGYHATE3Bh7p1O+2lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XdfoW8A3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XdfoW8A3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1C7C4CEC3;
	Mon,  2 Sep 2024 01:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238887;
	bh=XoXr60mrv+MfMr0MWxX2WLrqnEPYBhC56QQok/UGh5M=;
	h=Date:To:From:Subject:From;
	b=XdfoW8A3r5CCdmmY56wJmZr3rQgfu4ktAZKvGCGhq2SAo6HszeCaDRuYHWWL7H2re
	 AYvSiVQPIfow4K4XySJuaYfsC4SRgSB+fc3+wXYTxT87WRAsREuqZ6amXaCNr4MEfR
	 MEcF2GgaF4O438b2DNOamhOMUWl0bzAQMVzZ3rBg=
Date: Sun, 01 Sep 2024 18:01:26 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vmalloc-implement-vrealloc-fix-2.patch removed from -mm tree
Message-Id: <20240902010127.0E1C7C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: (k)vrealloc: document concurrency restrictions
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-implement-vrealloc-fix-2.patch

This patch was dropped because it was folded into mm-vmalloc-implement-vrealloc.patch

------------------------------------------------------
From: Danilo Krummrich <dakr@kernel.org>
Subject: mm: (k)vrealloc: document concurrency restrictions
Date: Thu, 25 Jul 2024 14:54:37 +0200

Document that concurrent calls to vrealloc() with itself or vfree() for
the same memory allocation are not permitted, since it leads to undefined
behavior.

Consequently, the same applies for kvrealloc(), hence also document it
for kvrealloc().

Link: https://lkml.kernel.org/r/20240725125442.4957-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-implement-vrealloc-fix-2
+++ a/mm/vmalloc.c
@@ -4045,6 +4045,9 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
  * If @p is %NULL, vrealloc() behaves exactly like vmalloc(). If @size is 0 and
  * @p is not a %NULL pointer, the object pointed to is freed.
  *
+ * This function must not be called concurrently with itself or vfree() for the
+ * same memory allocation.
+ *
  * Return: pointer to the allocated memory; %NULL if @size is zero or in case of
  *         failure
  */
_

Patches currently in -mm which might be from dakr@kernel.org are

mm-vmalloc-implement-vrealloc.patch
mm-vmalloc-implement-vrealloc-fix-3.patch
mm-vmalloc-implement-vrealloc-fix-4.patch
mm-kvmalloc-align-kvrealloc-with-krealloc.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-3.patch
mm-krealloc-consider-spare-memory-for-__gfp_zero.patch
mm-krealloc-clarify-valid-usage-of-__gfp_zero.patch

