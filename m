Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A6914A62A
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 05:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737006492; cv=none; b=sp2tToUD+UxNNEhx+sDmF3Nhelc7iFWNrG1ufJNJHUcmQW8U3xGb9HyW2NZRbkZXoFyEknQYphbqaol7VJSnRDcxbMdevSOavC4pi2VfcG0h8fWXj7HDYD/7s+t3DBZaRF8jWx8Ke9m5GoA1tE7fcYlixJDOYh1GCs0gwevDuBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737006492; c=relaxed/simple;
	bh=kh4W6w5AR+LL7uw/QyV6fOBeJUve7MBjCh4es+WHq+U=;
	h=Date:To:From:Subject:Message-Id; b=LwG/5Fea7a7XC5GOjkaHadXnarwA0uFkodk2Ki1J1XYph+jxpm023ftKLKNtP7gepMwMeq3mkiV8bL9E7ffZyGfLlcDMs7XThgntD8ZY0tyMaHfkUi9w8c/wtjvQTn5kW8cfEuk2V7PIVFqDdcqEth6muwkuO8MB2ozF/y0f9Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EuZMzSgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EuZMzSgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59ECC4CED6;
	Thu, 16 Jan 2025 05:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737006491;
	bh=kh4W6w5AR+LL7uw/QyV6fOBeJUve7MBjCh4es+WHq+U=;
	h=Date:To:From:Subject:From;
	b=EuZMzSgZRjhWFn1h0J2uPXVvXP70jcwHV/j8SwnWFsFo04S5rAh1c0gbU3GWbaflS
	 q/DQvxscbAnlirHxCG+hbz5/g23MZ+bBY8sR5CmbUrKxbM9lgTqhn4qRUG556+CfZL
	 0Si1Hzck9ZcJ+OX6+N1q7AeSR3pI47ouKO/JKTqI=
Date: Wed, 15 Jan 2025 21:48:11 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-utilc-complete-the-kernel-doc-function-descriptions.patch removed from -mm tree
Message-Id: <20250116054811.B59ECC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ipc/util.c: complete the kernel-doc function descriptions
has been removed from the -mm tree.  Its filename was
     ipc-utilc-complete-the-kernel-doc-function-descriptions.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: ipc/util.c: complete the kernel-doc function descriptions
Date: Fri, 10 Jan 2025 22:29:05 -0800

Move the function descriptive comments so that they conform to
kernel-doc format, eliminating the kernel-doc warnings.

util.c:618: warning: missing initial short description on line:
 * ipc_obtain_object_idr
util.c:640: warning: missing initial short description on line:
 * ipc_obtain_object_check

Link: https://lkml.kernel.org/r/20250111062905.910576-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/ipc/util.c~ipc-utilc-complete-the-kernel-doc-function-descriptions
+++ a/ipc/util.c
@@ -615,12 +615,11 @@ void ipc64_perm_to_ipc_perm(struct ipc64
 }
 
 /**
- * ipc_obtain_object_idr
+ * ipc_obtain_object_idr - Look for an id in the ipc ids idr and
+ *   return associated ipc object.
  * @ids: ipc identifier set
  * @id: ipc id to look for
  *
- * Look for an id in the ipc ids idr and return associated ipc object.
- *
  * Call inside the RCU critical section.
  * The ipc object is *not* locked on exit.
  */
@@ -637,13 +636,11 @@ struct kern_ipc_perm *ipc_obtain_object_
 }
 
 /**
- * ipc_obtain_object_check
+ * ipc_obtain_object_check - Similar to ipc_obtain_object_idr() but
+ *   also checks the ipc object sequence number.
  * @ids: ipc identifier set
  * @id: ipc id to look for
  *
- * Similar to ipc_obtain_object_idr() but also checks the ipc object
- * sequence number.
- *
  * Call inside the RCU critical section.
  * The ipc object is *not* locked on exit.
  */
_

Patches currently in -mm which might be from rdunlap@infradead.org are


