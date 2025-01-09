Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FB41AAC9
	for <mm-commits@vger.kernel.org>; Thu,  9 Jan 2025 04:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736398402; cv=none; b=UrLtjJ0k1VkNnlsBNmIr961BpAvuUS6GfcZGPkSRaswcXrqKTd04MMrjUG1p+HpGOkUc/pdLyOrbT7viAMF1a7lBv6FedTbUcqGMo7DB/Ldq3yjtrt3aZEt3gNQWBck6uOVp6j13ZhKj/jXOVB/B+kVxfmmPaPPF252gwYtvDp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736398402; c=relaxed/simple;
	bh=UwALEo+DXUapA3xGyPhR92cYUNVj8WnfIGj6KVzKzUw=;
	h=Date:To:From:Subject:Message-Id; b=TDSdfKg8Mg8S7COJQiWRLlpXpIRvTWMznvHUF6qrLW4AGTtwEYRAW/tJ+BzNETCyI3pq/h7thCK/Xbw/ruCYE4wNCmPlAB08M1ffAYV/77xQ7xeY/phBHqjKy01izbeajp+R8sRQNVt6G3HH2Hoqjb6PnU8B9o7jxS6wY9x+jGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2KmQ/7Vn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2KmQ/7Vn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFF6C4CED2;
	Thu,  9 Jan 2025 04:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736398401;
	bh=UwALEo+DXUapA3xGyPhR92cYUNVj8WnfIGj6KVzKzUw=;
	h=Date:To:From:Subject:From;
	b=2KmQ/7Vnajqu0Ft1SvnM8aGvN2LWIubHdWv7ed//EfpbSEAzAYsr6g/S4aw0mDwMi
	 WVYO9LsFEHPjaWKfXFmW02JAIPrK7PsAFEpitaEboTAup6rlZIuIZUoivT/FsLZcpy
	 98ZhlvfWesNDrL91IGIW8jX9ZNrOGHQPW6npaiPo=
Date: Wed, 08 Jan 2025 20:53:20 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,david@redhat.com,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless.patch removed from -mm tree
Message-Id: <20250109045321.5CFF6C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove an avoidable load of page refcount in page_ref_add_unless
has been removed from the -mm tree.  Its filename was
     mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: mm: remove an avoidable load of page refcount in page_ref_add_unless
Date: Sat, 7 Dec 2024 09:29:31 +0100

Explicitly pre-checking the count adds nothing as atomic_add_unless starts
with doing the same thing.  iow no functional changes.

disasm of stock filemap_get_read_batch from perf top while running
readseek2_processes -t 24:

  0.04 │ cb:   mov    0x34(%rbx),%eax           # first load
 73.11 │       test   %eax,%eax
       │     ↓ je     1bd
  0.09 │       mov    0x34(%rbx),%eax           # second load
  1.01 │ d9:   test   %eax,%eax
       │     ↓ je     1bd
  0.06 │       lea    0x1(%rax),%edx
  0.00 │       lea    0x34(%rbx),%r14
  0.00 │       lock   cmpxchg %edx,0x34(%rbx)
 14.06 │     ↑ jne    d9

Link: https://lkml.kernel.org/r/20241207082931.1707465-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ref.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/page_ref.h~mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless
+++ a/include/linux/page_ref.h
@@ -234,7 +234,7 @@ static inline bool page_ref_add_unless(s
 
 	rcu_read_lock();
 	/* avoid writing to the vmemmap area being remapped */
-	if (!page_is_fake_head(page) && page_ref_count(page) != u)
+	if (!page_is_fake_head(page))
 		ret = atomic_add_unless(&page->_refcount, nr, u);
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from mjguzik@gmail.com are

get_task_exe_file-check-pf_kthread-locklessly.patch

