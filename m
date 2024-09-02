Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4F42D057
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247805; cv=none; b=RPB6p3ArcIzRt5uJzkexWeeSouASWk/lKYrikcLc+BTl2ojPTCAL6eiXzqFJfMqIwkjyKvNS0JSmuQtYIa14SBU3DOSRB5Bp5I584oFUscyOus6vLiF8suELKFztDgc+WeHrSUzJQhktYOV6Erb6TI2wEjjDbs5J6PF0CDSjqxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247805; c=relaxed/simple;
	bh=FX/ZwCuKugElIPTaVnktZ7tp5txiFMU92aPwvc4HDAQ=;
	h=Date:To:From:Subject:Message-Id; b=aOsRXvNaMQVUvWxF35DXGNvYOJdOGMn8xF8BMnLohVT9mE7vNqep+TJ0AJwRoEJDpS8jCUOzBxHasn/vaTm8t3ZWxgzTMo7F7FY3n89N7jtJQXzHDOZ+J6WWKrWJg7F5bdLHJWH8GtGvsZ9r3g6ihxGVv0emIqbH3B1gV1jTPo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nvce6EDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nvce6EDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D6CC4CEC2;
	Mon,  2 Sep 2024 03:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247805;
	bh=FX/ZwCuKugElIPTaVnktZ7tp5txiFMU92aPwvc4HDAQ=;
	h=Date:To:From:Subject:From;
	b=Nvce6EDXCrO1j9ilYXE+RYA+gcLgB1pUevkNsRPuiIZ1Sir9/VzgNFgKZao/GVzSv
	 sd25rnkBJgtY54oPHYXsy9n1AqQEwpugsExengHdvuYiwbxyE1x3NbhFSHAE3SOTSz
	 HIzHJqIE0gvxe4cRitgVW/Aw8FQd4iGPQ54M+nd4=
Date: Sun, 01 Sep 2024 20:30:04 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,yangge1116@126.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-take-folio-refcount-after-testing-the-lru-flag.patch removed from -mm tree
Message-Id: <20240902033005.62D6CC4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/swap: take folio refcount after testing the LRU flag
has been removed from the -mm tree.  Its filename was
     mm-swap-take-folio-refcount-after-testing-the-lru-flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: yangge <yangge1116@126.com>
Subject: mm/swap: take folio refcount after testing the LRU flag
Date: Tue, 13 Aug 2024 17:52:23 +0800

Whoever passes a folio to __folio_batch_add_and_move() must hold a
reference, otherwise something else would already be messed up.  If the
folio is referenced, it will not be freed elsewhere, so we can safely
clear the folio's lru flag.  As discussed with David in [1], we should
take the reference after testing the LRU flag, not before.

Link: https://lore.kernel.org/lkml/d41865b4-d6fa-49ba-890a-921eefad27dd@redhat.com/ [1]
Link: https://lkml.kernel.org/r/1723542743-32179-1-git-send-email-yangge1116@126.com
Signed-off-by: yangge <yangge1116@126.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/swap.c~mm-swap-take-folio-refcount-after-testing-the-lru-flag
+++ a/mm/swap.c
@@ -226,12 +226,10 @@ static void __folio_batch_add_and_move(s
 {
 	unsigned long flags;
 
-	folio_get(folio);
-
-	if (on_lru && !folio_test_clear_lru(folio)) {
-		folio_put(folio);
+	if (on_lru && !folio_test_clear_lru(folio))
 		return;
-	}
+
+	folio_get(folio);
 
 	if (disable_irq)
 		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
_

Patches currently in -mm which might be from yangge1116@126.com are


