Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9CA125A9
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628268; cv=none; b=ORKnVd/10Lm9fX+8vyo/dWoXZsInqDDnwX7BwCibVMWfdfIGJKzML1HjEpGmXALBXgoMlxGwjlkbZpJwfS9IzfsXozFDifOSgX4y6KXE/slk4H0DITgT+IbYmY3zsSN/CiIMJdZytXhBZvkMqqUaMl1jAiXZSU7Ftj3xOven3do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628268; c=relaxed/simple;
	bh=QnjoeuUOU2pye8RhocLm9/8ujT92KEcziKIlxUMWDHo=;
	h=Date:To:From:Subject:Message-Id; b=O/BbxNpohLwWNv01PNL8gJKkg+Ie2ad5YzxkGUNOUWmKTfQ+j5KV9z+NpW1AoCtBNtItyj2GXNwCSTOvtyE8qAiRJB87n4vAbsQ9CzXn9sidgGggP9QZm5g3wEZ5OpRGHtxBBl6KZh4SvkuUemzWJKT4F1403Pwt1A2j2gP6UzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gb1UylUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gb1UylUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BEAC116B1;
	Sat, 29 Jun 2024 02:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628268;
	bh=QnjoeuUOU2pye8RhocLm9/8ujT92KEcziKIlxUMWDHo=;
	h=Date:To:From:Subject:From;
	b=Gb1UylUv4OWihsexgrysZRole0Uu+VicdwWI6vZEyB1akS+s1GljUmPcUBBm7PA9D
	 B/EbUS7fs0Zs16tMBeIM5gLX82pe0l5mlgPoVLnrSx9hVTUdbagEjmPlK63VTXBMuw
	 Uoa+mj5pZID/u0ZxC3/0wyhsd5ab/65MKI11uMlM=
Date: Fri, 28 Jun 2024 19:31:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-checksum-add-a-kmsan-check.patch removed from -mm tree
Message-Id: <20240629023108.30BEAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/checksum: add a KMSAN check
has been removed from the -mm tree.  Its filename was
     s390-checksum-add-a-kmsan-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: s390/checksum: add a KMSAN check
Date: Fri, 21 Jun 2024 13:35:09 +0200

Add a KMSAN check to the CKSM inline assembly, similar to how it was done
for ASAN in commit e42ac7789df6 ("s390/checksum: always use cksm
instruction").

Link: https://lkml.kernel.org/r/20240621113706.315500-26-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
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

 arch/s390/include/asm/checksum.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/include/asm/checksum.h~s390-checksum-add-a-kmsan-check
+++ a/arch/s390/include/asm/checksum.h
@@ -13,6 +13,7 @@
 #define _S390_CHECKSUM_H
 
 #include <linux/instrumented.h>
+#include <linux/kmsan-checks.h>
 #include <linux/in6.h>
 
 static inline __wsum cksm(const void *buff, int len, __wsum sum)
@@ -23,6 +24,7 @@ static inline __wsum cksm(const void *bu
 	};
 
 	instrument_read(buff, len);
+	kmsan_check_memory(buff, len);
 	asm volatile("\n"
 		"0:	cksm	%[sum],%[rp]\n"
 		"	jo	0b\n"
_

Patches currently in -mm which might be from iii@linux.ibm.com are


