Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D919B1CEEB2
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846609; cv=none; b=nC3NcdZGQP/dJ/iTaG5WynE7fVMvGpR8/k594Zvw5bbDvsQC99HKvNeBSgQUiDuS/9T3ybBcHMHK+6wc33b7elmxn0bN6kIpm501FSK/39tqXqIVvl8iUZid4+8aJIj4AzTIMN58zQM5U9ldhYRhYqXdnpNQvVkX6iWS3AE9OIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846609; c=relaxed/simple;
	bh=qeaXHPhSB4PdICxn35iaa5egxGd57zmkIQBi7O2OVwo=;
	h=Date:To:From:Subject:Message-Id; b=bj92s8qKI3hixHukCmuZxQb6qbuFMyGDvC3sPcNmJviYBv7XbM1OANDEIXi0PvixrOfxMXTkMi9iAapNFa8fgibs+OB9Y74Wi3REpzH5nn6P1GwgXVBvnqnSgwk9DgM4DOdj00sgMckQvEWlRvtxsl87vvdfMoYG2cgnmNcQ4io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ncFlo0J+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ncFlo0J+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D653C4CEE4;
	Wed, 21 May 2025 16:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846609;
	bh=qeaXHPhSB4PdICxn35iaa5egxGd57zmkIQBi7O2OVwo=;
	h=Date:To:From:Subject:From;
	b=ncFlo0J+34G48Q38rplYRfRcu6aOvMDUbkCsWROqI8D/xyNGhCbXBDW3qrYeQ2KHO
	 f2uPYccg4iCQbltHSKGCTuCXAbz07SRjk8zN2Cj0+5eIK2xCldEw/ns/Sss4w+nChn
	 KODAaeR55cz+5PZ/ceTmyHOYmvSJJZe4D8EuiUr0=
Date: Wed, 21 May 2025 09:56:48 -0700
To: mm-commits@vger.kernel.org,kent.overstreet@linux.dev,iii@linux.ibm.com,elver@google.com,dvyukov@google.com,bvanassche@acm.org,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-drop-the-declaration-of-kmsan_save_stack.patch removed from -mm tree
Message-Id: <20250521165649.3D653C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kmsan: drop the declaration of kmsan_save_stack()
has been removed from the -mm tree.  Its filename was
     kmsan-drop-the-declaration-of-kmsan_save_stack.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kmsan: drop the declaration of kmsan_save_stack()
Date: Wed, 7 May 2025 18:00:10 +0200

This function is not defined anywhere.

Link: https://lkml.kernel.org/r/20250507160012.3311104-3-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Bart van Assche <bvanassche@acm.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan.h |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/kmsan/kmsan.h~kmsan-drop-the-declaration-of-kmsan_save_stack
+++ a/mm/kmsan/kmsan.h
@@ -121,7 +121,6 @@ static __always_inline void kmsan_leave_
 	KMSAN_WARN_ON(--ctx->kmsan_in_runtime);
 }
 
-depot_stack_handle_t kmsan_save_stack(void);
 depot_stack_handle_t kmsan_save_stack_with_flags(gfp_t flags,
 						 unsigned int extra_bits);
 
_

Patches currently in -mm which might be from glider@google.com are


