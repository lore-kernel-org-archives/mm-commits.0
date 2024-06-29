Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C397BE47
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628247; cv=none; b=bi5C63rrB4AHKABPbA6rQ6QILeQ6fKkkJUBWz9W/tYrgazf0RkqJ31GMx4pY2ZJHSkWj0gPmu8cx4NXHWznhj3Yj8K1spXf6RgZ80uhvguti3Q2QUV+RzaEm5gfDa6BK2ld2VGP6u8WIWUHHe1kqvluk9muUBsgX5LZMOUy3ODE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628247; c=relaxed/simple;
	bh=IYPw6AZhLbva+i16a/rZRBn8uZ6i+lIbuQCC5LXdipQ=;
	h=Date:To:From:Subject:Message-Id; b=W87S8/CBPlabvLJ+26US7Q4UsEdbt3l0LGFVXeBTDTW7z4COnh7Yk5BPBmo/HCLvLZmJN4sJxxl2GlvfKn9xQzGIudiTQHm9MZ1xvMXTTx5wNXgePONcaCPReK5rqDDMpLdsyFIidBXkJ3MpJPBoJPfyVV655q6AM/iFwgbbPqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g+gF+byy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g+gF+byy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BF1C116B1;
	Sat, 29 Jun 2024 02:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628247;
	bh=IYPw6AZhLbva+i16a/rZRBn8uZ6i+lIbuQCC5LXdipQ=;
	h=Date:To:From:Subject:From;
	b=g+gF+byyKHKuJnMIjs6+Y50Xlg/n1wzzN3AVrBEsdkH4Pw3rM7YGgsvKf53zCAUcu
	 beDk6LPT4gZObNT+COhnMiGEGwxydlcLT3mmxRJFGsJgSHz/at8Mw65NZiSeqiBy9I
	 pepzKRXRtiyyUVXNsi4ZpMEEeNtQc6Yj/UkRA1VQ=
Date: Fri, 28 Jun 2024 19:30:46 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-export-panic_on_kmsan.patch removed from -mm tree
Message-Id: <20240629023047.32BF1C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: export panic_on_kmsan
has been removed from the -mm tree.  Its filename was
     kmsan-export-panic_on_kmsan.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: kmsan: export panic_on_kmsan
Date: Fri, 21 Jun 2024 13:34:54 +0200

When building the kmsan test as a module, modpost fails with the following
error message:

    ERROR: modpost: "panic_on_kmsan" [mm/kmsan/kmsan_test.ko] undefined!

Export panic_on_kmsan in order to improve the KMSAN usability for
modules.

Link: https://lkml.kernel.org/r/20240621113706.315500-11-iii@linux.ibm.com
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

 mm/kmsan/report.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kmsan/report.c~kmsan-export-panic_on_kmsan
+++ a/mm/kmsan/report.c
@@ -20,6 +20,7 @@ static DEFINE_RAW_SPINLOCK(kmsan_report_
 /* Protected by kmsan_report_lock */
 static char report_local_descr[DESCR_SIZE];
 int panic_on_kmsan __read_mostly;
+EXPORT_SYMBOL_GPL(panic_on_kmsan);
 
 #ifdef MODULE_PARAM_PREFIX
 #undef MODULE_PARAM_PREFIX
_

Patches currently in -mm which might be from iii@linux.ibm.com are


