Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6153A11CA1
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628254; cv=none; b=fKbYO+ke0RMwaSfYKzriBUnKu5uGgbaq722bHS/D5RaHudV7Inx6/+TtG3eeSHtb2GS18KVY90NlX88ZQuUSWatu0dvaDauEXC4TIbKLL7iR3ywP9CB2wyZig3fwfCQeKCj43mJsUhQ22jsQTJpdYu5DzSjt+OmzfmMpphsr7+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628254; c=relaxed/simple;
	bh=55mGYNRIh3a96BxFdITQLRxvXXGrCAAzbf6/OdZSEhg=;
	h=Date:To:From:Subject:Message-Id; b=lM4BS0fJCr+rqT0QyTiyef5PLQT2+YlGoqb7VfKn8OmUXqjqtcAn4ESh5PxnVJBR+PZMYrxj3Q4QLYn/d0sQWqKsgGvPXpmCZdZwG7/llnowHJSh4VWtPnDGc7frk/+FoMxmdcIvL5NzxV4Z6SfkA2K1Bv9+lZzOI///JjUMXOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nxg7+8kX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nxg7+8kX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CE9C116B1;
	Sat, 29 Jun 2024 02:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628254;
	bh=55mGYNRIh3a96BxFdITQLRxvXXGrCAAzbf6/OdZSEhg=;
	h=Date:To:From:Subject:From;
	b=Nxg7+8kXQGrnN5Z94OKO0YeqlVIyX8RwXFeJH/N8apSwj1+/GgbFBIwrFrVmznHvF
	 5rvWo1fTHwbc+j7kYK+lS4L/qoRzEA+jcVlYv8LRcWswXHPoKO6q1WuRtCPEZJ7CMO
	 gmnFZTA4cFPmYPa7t6B9+5bMfWPdTIe8BVlx6LSk=
Date: Fri, 28 Jun 2024 19:30:53 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-do-not-round-up-pg_data_t-size.patch removed from -mm tree
Message-Id: <20240629023054.37CE9C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: do not round up pg_data_t size
has been removed from the -mm tree.  Its filename was
     kmsan-do-not-round-up-pg_data_t-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: do not round up pg_data_t size
Date: Fri, 21 Jun 2024 13:34:59 +0200

x86's alloc_node_data() rounds up node data size to PAGE_SIZE.  It's not
explained why it's needed, but it's most likely for performance reasons,
since the padding bytes are not used anywhere.  Some other architectures
do it as well, e.g., mips rounds it up to the cache line size.

kmsan_init_shadow() initializes metadata for each node data and assumes
the x86 rounding, which does not match other architectures.  This may
cause the range end to overshoot the end of available memory, in turn
causing virt_to_page_or_null() in kmsan_init_alloc_meta_for_range() to
return NULL, which leads to kernel panic shortly after.

Since the padding bytes are not used, drop the rounding.

Link: https://lkml.kernel.org/r/20240621113706.315500-16-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
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

 mm/kmsan/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmsan/init.c~kmsan-do-not-round-up-pg_data_t-size
+++ a/mm/kmsan/init.c
@@ -72,7 +72,7 @@ static void __init kmsan_record_future_s
  */
 void __init kmsan_init_shadow(void)
 {
-	const size_t nd_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
+	const size_t nd_size = sizeof(pg_data_t);
 	phys_addr_t p_start, p_end;
 	u64 loop;
 	int nid;
_

Patches currently in -mm which might be from iii@linux.ibm.com are


