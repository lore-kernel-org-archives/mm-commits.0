Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2074BE47
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628257; cv=none; b=cJmJISSCX3AudRvF8DngsmFq8imF+pKJ6p+PzjZojjmQ0ru8pRol421bDXQ4YvdQ3JQ4YA7rKycVI7/7dS5bV6X/puLsaMNDQjdOzBaXj/nt5eOkTXYn5GyNQrjNZcbskViqCXk39CuXy+Xb+gMSYg7BGqqoVyqEooOPZw9JkeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628257; c=relaxed/simple;
	bh=v3I18+0UuDx2XOrDLOn6bq9NFMpyLg4OFfmS8dXpC6g=;
	h=Date:To:From:Subject:Message-Id; b=kgolvab6+RQmx9vP3vv6iz8c74JvFkDxfKrxkxw6Z5BXkM7/61T+Nrs5G6fiGbEhahgirmlEx/99WnaX/vLqnrBdYj1TSJHpsG64lXEJ7YKDKmXU6j+kSxVsu3U7HCLxxZX04oc5O2d+8dfAxhyZRy+E7EXCpUZgtNbUdeoeA10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vWL1GSuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vWL1GSuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FB3C116B1;
	Sat, 29 Jun 2024 02:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628256;
	bh=v3I18+0UuDx2XOrDLOn6bq9NFMpyLg4OFfmS8dXpC6g=;
	h=Date:To:From:Subject:From;
	b=vWL1GSuJwA+2NiYYQ3F8xQdnvMGV8+F0rrI1va/eiyy1dpivjb+ipl0+eVHt+StBm
	 XIN/cxWXAsSW8hmHQ9ItqZ8bwVPaZchtWxWS8pmXwUrfgUMG9hzMrXsd8SZvxcb8JK
	 QhxL6rZYhl4zK5PR81F6CKcAumfEgtE2eWZOXMEs=
Date: Fri, 28 Jun 2024 19:30:56 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-slub-let-kmsan-access-metadata.patch removed from -mm tree
Message-Id: <20240629023056.C7FB3C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: slub: let KMSAN access metadata
has been removed from the -mm tree.  Its filename was
     mm-slub-let-kmsan-access-metadata.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: mm: slub: let KMSAN access metadata
Date: Fri, 21 Jun 2024 13:35:01 +0200

Building the kernel with CONFIG_SLUB_DEBUG and CONFIG_KMSAN causes KMSAN
to complain about touching redzones in kfree().

Fix by extending the existing KASAN-related metadata_access_enable() and
metadata_access_disable() functions to KMSAN.

Link: https://lkml.kernel.org/r/20240621113706.315500-18-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/slub.c~mm-slub-let-kmsan-access-metadata
+++ a/mm/slub.c
@@ -829,10 +829,12 @@ static int disable_higher_order_debug;
 static inline void metadata_access_enable(void)
 {
 	kasan_disable_current();
+	kmsan_disable_current();
 }
 
 static inline void metadata_access_disable(void)
 {
+	kmsan_enable_current();
 	kasan_enable_current();
 }
 
_

Patches currently in -mm which might be from iii@linux.ibm.com are


