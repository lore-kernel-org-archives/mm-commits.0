Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F8D171D2
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628282; cv=none; b=s3TYEUbpaM2DK6Kh+XvXu1XWA14y5eSiy+k6bWipzN/K6pBAHv+junRx+kNEERWFCmKgqarqwWZxX4Hxm8ZnzeG8yqwzp2o/RqYzS+/cpvtSayy/aJPJQiPm9orNm4+YITJLWaupwEnfHnwWRlcVn681BMvBGtYyPikgvHfHSPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628282; c=relaxed/simple;
	bh=ZiFTZdxsHZKZ/0sGoR/Vmpj5f5qPA86Z19GFRfU5+kE=;
	h=Date:To:From:Subject:Message-Id; b=Vvb2T2lZBpPTnJAzqjNSUSSPLR5ahPqSDciFhtUqks6E9gHjDU+85qsYAh0kOH8whon6uNCGUY+GnSfz3EzZ5dNvo5IBjCLAQ6zOOLrRLDRKfXqTIqs0h01DsahQ/wleuXXJpkz50SsTDZR129KHinRSaM6x5GV8wBoI1r5r5wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hC/D1x1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hC/D1x1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C392C116B1;
	Sat, 29 Jun 2024 02:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628282;
	bh=ZiFTZdxsHZKZ/0sGoR/Vmpj5f5qPA86Z19GFRfU5+kE=;
	h=Date:To:From:Subject:From;
	b=hC/D1x1XBUMfMkYdYG4CjBEpvzJRhm9SCvlAbe1AvePhPRsh3BIS0CBg6oSENRHfy
	 q8TD2O2eSf3Jh98fKr0YnELzx/QdZWbObHnqIJHKj1PQF3ZtK7kfZOoACGiSOkTNHn
	 zVnAXvhwMRWvpn9q1hdTfS5xMddX3uwRNL9bHRHY=
Date: Fri, 28 Jun 2024 19:31:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,svens@linux.ibm.com,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,mhiramat@kernel.org,mark.rutland@arm.com,kasan-dev@googlegroups.com,iamjoonsoo.kim@lge.com,hca@linux.ibm.com,gor@linux.ibm.com,glider@google.com,elver@google.com,dvyukov@google.com,cl@linux.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,42.hyeyoo@gmail.com,iii@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-uaccess-add-the-missing-linux-instrumentedh-include.patch removed from -mm tree
Message-Id: <20240629023122.6C392C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/uaccess: add the missing linux/instrumented.h #include
has been removed from the -mm tree.  Its filename was
     s390-uaccess-add-the-missing-linux-instrumentedh-include.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ilya Leoshkevich <iii@linux.ibm.com>
Subject: s390/uaccess: add the missing linux/instrumented.h #include
Date: Fri, 21 Jun 2024 13:35:19 +0200

uaccess.h uses instrument_get_user() and instrument_put_user(), which are
defined in linux/instrumented.h.  Currently we get this header from
somewhere else by accident; prefer to be explicit about it and include it
directly.

Link: https://lkml.kernel.org/r/20240621113706.315500-36-iii@linux.ibm.com
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Suggested-by: Alexander Potapenko <glider@google.com>
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

 arch/s390/include/asm/uaccess.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/include/asm/uaccess.h~s390-uaccess-add-the-missing-linux-instrumentedh-include
+++ a/arch/s390/include/asm/uaccess.h
@@ -18,6 +18,7 @@
 #include <asm/extable.h>
 #include <asm/facility.h>
 #include <asm-generic/access_ok.h>
+#include <linux/instrumented.h>
 
 void debug_user_asce(int exit);
 
_

Patches currently in -mm which might be from iii@linux.ibm.com are


