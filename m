Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9901388
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 01:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725238976; cv=none; b=gF3AG2MDZjK1zKXT5Xbhxm9dNK/SEMQRwqFwZhwvmpJDGMo32TMXfR3Mjam3PiMhQNprOrwLAusOCKUSD1xjHDKYMuzOidpFvp0tGqf9l91f4D1BV3KH4/36NowEQX6hQpqDFq5bxbDA1XPGkKWmZ5A+16YsvkuWv7OHdRFGVm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725238976; c=relaxed/simple;
	bh=vmU6NaVpZQpARv3RB9udMlumtolsecS0F1rLNMYg35k=;
	h=Date:To:From:Subject:Message-Id; b=hhwYTS+C1B5bm+23I7QEskzijVDWI8nLEDWMK4nwX1JB8+LdgAMBfGsW9Y8DHHF2qX8sjjDs5J10ybIBEjvkxyyPgb/4eZu7Cacm008GJ3qymyJlnfejk3YKM0o2eR/7juHFCOj0ZugCfhyAHZyFxGGm9n9QoYpsUx89m6esizk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zsV6YMSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zsV6YMSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39288C4CEC3;
	Mon,  2 Sep 2024 01:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725238976;
	bh=vmU6NaVpZQpARv3RB9udMlumtolsecS0F1rLNMYg35k=;
	h=Date:To:From:Subject:From;
	b=zsV6YMSSTq8xSE7vC04wY+9fmUXLoXgkjnCD0a7a1GiRjnlI0BOjaLGrMNSb+3/Ux
	 xMHmuaKaLawQb0lRaf/hCyDcc6c+tkgsHSefDedrwm/qkPOhfZc9Z2E5CJ+F6MspDa
	 dKE9EA3JiO71eAMWJfrpKiY2ZE+fUI8ARRhhUm5o=
Date: Sun, 01 Sep 2024 18:02:55 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,hch@infradead.org,dakr@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-kvmalloc-align-kvrealloc-with-krealloc-fix.patch removed from -mm tree
Message-Id: <20240902010256.39288C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: (k)vrealloc: document concurrency restrictions
has been removed from the -mm tree.  Its filename was
     mm-kvmalloc-align-kvrealloc-with-krealloc-fix.patch

This patch was dropped because it was folded into mm-kvmalloc-align-kvrealloc-with-krealloc.patch

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
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/util.c~mm-kvmalloc-align-kvrealloc-with-krealloc-fix
+++ a/mm/util.c
@@ -732,6 +732,9 @@ EXPORT_SYMBOL(kvfree_sensitive);
  * If @p is %NULL, kvrealloc() behaves exactly like kvmalloc(). If @size is 0
  * and @p is not a %NULL pointer, the object pointed to is freed.
  *
+ * This function must not be called concurrently with itself or kvfree() for the
+ * same memory allocation.
+ *
  * Return: pointer to the allocated memory or %NULL in case of error
  */
 void *kvrealloc_noprof(const void *p, size_t size, gfp_t flags)
_

Patches currently in -mm which might be from dakr@kernel.org are

mm-vmalloc-implement-vrealloc.patch
mm-kvmalloc-align-kvrealloc-with-krealloc.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-2.patch
mm-kvmalloc-align-kvrealloc-with-krealloc-fix-3.patch
mm-krealloc-consider-spare-memory-for-__gfp_zero.patch
mm-krealloc-clarify-valid-usage-of-__gfp_zero.patch

