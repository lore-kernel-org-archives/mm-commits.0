Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6777B111A1
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628243; cv=none; b=S+BpgUxjg8lgdtBnxoEUyYY/dASEIe60v5l18Oh6/C2PqVlmzw12/N55Ydx4HMNHg934nCs621MZnv4iHcyfVYVqrHsXorEfB1WMklJlbC1LUjhGcfv3CDgy3IdQI9rU15b02rJqQw5IyuSZ9jg6mNmRI4LjiFS854YXrD9JNGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628243; c=relaxed/simple;
	bh=X5DvUUYTGoKke6bek/DSUkHEhYV/y5pOW1uixPvvB3c=;
	h=Date:To:From:Subject:Message-Id; b=NFpE7sZYJSKDfE5VRJrqS8Kb0DGL+7mo9mTn6Cj/YhIqdMeiTfjETp2i99TmIMAs6xO8cZg0/E40QmUm59xF8W3QnTJL4XI8PTKc4e/Y3jARa29CLmc7TFBcgWIrSGKCZkbcHmCM/+W7hnqF6rsN1UrsT1lgocQptb8sBWEyT1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UyTPuz1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UyTPuz1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75AAC116B1;
	Sat, 29 Jun 2024 02:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628243;
	bh=X5DvUUYTGoKke6bek/DSUkHEhYV/y5pOW1uixPvvB3c=;
	h=Date:To:From:Subject:From;
	b=UyTPuz1i9mpYPYXOvwHRYu5v2xvCMZZXiyINi9X75Is6u/WuVl1cO6tndonE6NwHe
	 jiuwcDDw71C4qP57CHM94OIQYmF/ASZroZNidyc9BIcACi5zgi6QjKNhmzFSoN+we2
	 JQHj5WQUVA8Oo3Eg8Dn/obtIXhcstDUg+ZeMgIZY=
Date: Fri, 28 Jun 2024 19:30:42 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-remove-a-useless-assignment-from-kmsan_vmap_pages_range_noflush.patch removed from -mm tree
Message-Id: <20240629023042.E75AAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: remove a useless assignment from kmsan_vmap_pages_range_noflush()
has been removed from the -mm tree.  Its filename was
     kmsan-remove-a-useless-assignment-from-kmsan_vmap_pages_range_noflush.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: remove a useless assignment from kmsan_vmap_pages_range_noflush()
Date: Fri, 21 Jun 2024 13:34:51 +0200

The value assigned to prot is immediately overwritten on the next line
with PAGE_KERNEL.  The right hand side of the assignment has no
side-effects.

Link: https://lkml.kernel.org/r/20240621113706.315500-8-iii@linux.ibm.com
Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page operations")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Suggested-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <kasan-dev@googlegroups.com>
Cc: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/shadow.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/kmsan/shadow.c~kmsan-remove-a-useless-assignment-from-kmsan_vmap_pages_range_noflush
+++ a/mm/kmsan/shadow.c
@@ -243,7 +243,6 @@ int kmsan_vmap_pages_range_noflush(unsig
 		s_pages[i] = shadow_page_for(pages[i]);
 		o_pages[i] = origin_page_for(pages[i]);
 	}
-	prot = __pgprot(pgprot_val(prot) | _PAGE_NX);
 	prot = PAGE_KERNEL;
 
 	origin_start = vmalloc_meta((void *)start, KMSAN_META_ORIGIN);
_

Patches currently in -mm which might be from iii@linux.ibm.com are


