Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC73F12E78
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628262; cv=none; b=CksUY6GlF28Oe4XWQ1jtnPaqN3QE4H9RSaFLQZPU/TuZHLZJ3ei46g0DFHSSFKtHNVhyRHpb+ls4u2G2HqbfPz9cIp0SVInHAkE3vmX35m0dvtJdHbdostCa9+6rLCI7vqgc+r+9PM9xPEEI+nb5ffbhBkUFhjmxAmx+s5fXCQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628262; c=relaxed/simple;
	bh=x2E5I0J1WnRg3vPl3vK2TikJ1vv3/rtSyrcHpJYBzQo=;
	h=Date:To:From:Subject:Message-Id; b=Fk0JC9AUi5B45REHtNv25M2mqQOJptyA7gkUYRvmswmGZYG/bdghclxhhMw8sQcl2EKtXjO/fY0qaqig8z07m9wQOSFNw1bRZ0KyV1/mxKkLrLN9ppFBjbTz++SA6H4L5jGNyWGPk8GgO+687cnNDJrwAQtXNgIyLOA9qqo78S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TGdyhHgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TGdyhHgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833E6C116B1;
	Sat, 29 Jun 2024 02:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628262;
	bh=x2E5I0J1WnRg3vPl3vK2TikJ1vv3/rtSyrcHpJYBzQo=;
	h=Date:To:From:Subject:From;
	b=TGdyhHgUJdvBYipDvxy4ku2oS/hUnMZfR1rEbQ93VOkWjRzsA3AvG2agLAjDVJTbC
	 zKcr9/4k18FEOrOeCRODgcQM0cHLs9q2FLsPjf9ilUmpyavrqUGaHAWRw+PsK8tgo6
	 fJe1jL9KSz7ex5N/NM8Wm2lbHEcxvnE2VwjN8HTI=
Date: Fri, 28 Jun 2024 19:31:02 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-accept-ranges-starting-with-0-on-s390.patch removed from -mm tree
Message-Id: <20240629023102.833E6C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: accept ranges starting with 0 on s390
has been removed from the -mm tree.  Its filename was
     kmsan-accept-ranges-starting-with-0-on-s390.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: accept ranges starting with 0 on s390
Date: Fri, 21 Jun 2024 13:35:05 +0200

On s390 the virtual address 0 is valid (current CPU's lowcore is mapped
there), therefore KMSAN should not complain about it.

Disable the respective check on s390.  There doesn't seem to be a Kconfig
option to describe this situation, so explicitly check for s390.

Link: https://lkml.kernel.org/r/20240621113706.315500-22-iii@linux.ibm.com
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

 mm/kmsan/init.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/kmsan/init.c~kmsan-accept-ranges-starting-with-0-on-s390
+++ a/mm/kmsan/init.c
@@ -33,7 +33,10 @@ static void __init kmsan_record_future_s
 	bool merged = false;
 
 	KMSAN_WARN_ON(future_index == NUM_FUTURE_RANGES);
-	KMSAN_WARN_ON((nstart >= nend) || !nstart || !nend);
+	KMSAN_WARN_ON((nstart >= nend) ||
+		      /* Virtual address 0 is valid on s390. */
+		      (!IS_ENABLED(CONFIG_S390) && !nstart) ||
+		      !nend);
 	nstart = ALIGN_DOWN(nstart, PAGE_SIZE);
 	nend = ALIGN(nend, PAGE_SIZE);
 
_

Patches currently in -mm which might be from iii@linux.ibm.com are


