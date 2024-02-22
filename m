Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DAC79D9
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560183; cv=none; b=a4Q4AeAZRZycxzn7YoR5x29vhM9E7Z7lMzoPNTspVYMVK39rmdC+fwbf7G7jAI3G52/rDUlvtwuvy+fyqsQkGZa/DXmkd8JfxMTzRSDecw4LyRBcPRnz5JqzdOyVAsimzqVa5dAaPVa1LWV1iHY1+kz44vqn/KWhxkWvU7t44q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560183; c=relaxed/simple;
	bh=6VH6GSiJF1Z7UNSgtjowucBPONesyvytmczqyPDaJFc=;
	h=Date:To:From:Subject:Message-Id; b=VxxCZz+vEWhnCvEv+zVAx89gDbNxi49923fM70hZ2y1LL6E5Xs3V9ZHc/z6zzEg8eBJ+4x0IsccKKaLV3qJ7873CqTS7qZeHuZ6TC5xx+fc/hGI+TcNqZygQFGFAP0scOoB4NHOny4TUOzSTmghCAasWQWIxxHrWwkYK91EGcWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qj+C44IQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qj+C44IQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A42C43390;
	Thu, 22 Feb 2024 00:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560183;
	bh=6VH6GSiJF1Z7UNSgtjowucBPONesyvytmczqyPDaJFc=;
	h=Date:To:From:Subject:From;
	b=Qj+C44IQt39wkZOX4VRF/fnznZd0d5vFxYTKD9f+h2xnJJ3MbUKb6Vh7DVRF5ckM1
	 1y+5DOa79vV/gifNpERoLlETIQ/evUs+7LHmaKcmqg4ZWWZb5YZbtzF9YBd4rrqrwv
	 dHzyOI4mhC3N2gsKGiDQ1aeKdAhyjwon/jv5tjkM=
Date: Wed, 21 Feb 2024 16:03:03 -0800
To: mm-commits@vger.kernel.org,christophe.jaillet@wanadoo.fr,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-reduce-dependencies-on-linux-kernelh.patch removed from -mm tree
Message-Id: <20240222000303.A8A42C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: reduce dependencies on <linux/kernel.h>
has been removed from the -mm tree.  Its filename was
     mm-reduce-dependencies-on-linux-kernelh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: mm: reduce dependencies on <linux/kernel.h>
Date: Fri, 2 Feb 2024 22:23:18 +0100

"page_counter.h" does not need <linux/kernel.h>. <linux/limits.h> is enough
to get LONG_MAX.

Files that include page_counter.h are limited. They have been compile
tested or checked.

$ git grep page_counter\.h
include/linux/hugetlb_cgroup.h: struct page_counter hugepage[HUGE_MAX_HSTATE];
	--> all files that include it have been compile tested

include/linux/memcontrol.h:#include <linux/page_counter.h>
	--> <linux/kernel.h> has been added, to be safe

include/net/sock.h:#include <linux/page_counter.h>
	--> already include <linux/kernel.h>

mm/hugetlb_cgroup.c:#include <linux/page_counter.h>
mm/memcontrol.c:#include <linux/page_counter.h>
mm/page_counter.c:#include <linux/page_counter.h>
	--> compile tested

Link: https://lkml.kernel.org/r/adfdbe21c4d06400d7bd802868762deb85cae8b6.1706908921.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h   |    1 +
 include/linux/page_counter.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-reduce-dependencies-on-linux-kernelh
+++ a/include/linux/memcontrol.h
@@ -14,6 +14,7 @@
 #include <linux/vm_event_item.h>
 #include <linux/hardirq.h>
 #include <linux/jump_label.h>
+#include <linux/kernel.h>
 #include <linux/page_counter.h>
 #include <linux/vmpressure.h>
 #include <linux/eventfd.h>
--- a/include/linux/page_counter.h~mm-reduce-dependencies-on-linux-kernelh
+++ a/include/linux/page_counter.h
@@ -4,7 +4,7 @@
 
 #include <linux/atomic.h>
 #include <linux/cache.h>
-#include <linux/kernel.h>
+#include <linux/limits.h>
 #include <asm/page.h>
 
 struct page_counter {
_

Patches currently in -mm which might be from christophe.jaillet@wanadoo.fr are


