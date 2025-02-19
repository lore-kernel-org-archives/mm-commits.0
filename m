Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8B98F49;
	Wed, 19 Feb 2025 00:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739923914; cv=none; b=LEsBJXbiKSKXOGIRZyPK4v5nUUFYKyEELtAm8t0rEtKL33DtP9mDHSI0Neoar+yreKBP2OROkfaCka+UKcaX80iLnQVaJ2P4EcmbZvFVyltWNDXA0AOzGUWVFhUBjVxpQMb2RmZd5S7GldYvzKCzvsASsIe6HBX+PH946e3JDKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739923914; c=relaxed/simple;
	bh=WVslqES/TqFXcAX7ersOvpgacBNnnBom0m6DlA6rQrM=;
	h=Date:To:From:Subject:Message-Id; b=sexAH/swngyYJbwY3z8b/X3RsncxPRfzq8CHn32Xq20BRXiIwRoLevi5gtKe7hC0skkyS9HVRmIRbwEIYn0UWvAEtwMn4497bjwY6sRcFTQ/p+bx/iMj+NKP7ffZlRmwLi/0ZU7OyGCVjPkVH2+B813Njm7XC8jcsEAfOOmh9gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GheniZeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GheniZeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9E0C4CEE2;
	Wed, 19 Feb 2025 00:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739923913;
	bh=WVslqES/TqFXcAX7ersOvpgacBNnnBom0m6DlA6rQrM=;
	h=Date:To:From:Subject:From;
	b=GheniZeHvAhu5aaGdvBZ6rWCr6JuNjbjPK2qdifMWvq6oOke3k44acaF60ns9VzL3
	 fVTe3XSXUkQBAQB45qf7sA3KI9Ry5PCkGJoGOAmxh/TgcwmO77H/PvGki2z8UHioRe
	 PH0DUV4dtN/Cnj0m1OiHPigKnnGMkqiHHt32oNPE=
Date: Tue, 18 Feb 2025 16:11:52 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,peterz@infradead.org,lkp@intel.com,glider@google.com,elver@google.com,dvyukov@google.com,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dma-kmsan-export-kmsan_handle_dma-for-modules.patch added to mm-hotfixes-unstable branch
Message-Id: <20250219001153.4C9E0C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dma: kmsan: export kmsan_handle_dma() for modules
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     dma-kmsan-export-kmsan_handle_dma-for-modules.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dma-kmsan-export-kmsan_handle_dma-for-modules.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: dma: kmsan: export kmsan_handle_dma() for modules
Date: Tue, 18 Feb 2025 10:14:11 +0100

kmsan_handle_dma() is used by virtio_ring() which can be built as a
module.  kmsan_handle_dma() needs to be exported otherwise building the
virtio_ring fails.

Export kmsan_handle_dma for modules.

Link: https://lkml.kernel.org/r/20250218091411.MMS3wBN9@linutronix.de
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502150634.qjxwSeJR-lkp@intel.com/
Fixes: 7ade4f10779cb ("dma: kmsan: unpoison DMA mappings")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Macro Elver <elver@google.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/hooks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/kmsan/hooks.c~dma-kmsan-export-kmsan_handle_dma-for-modules
+++ a/mm/kmsan/hooks.c
@@ -357,6 +357,7 @@ void kmsan_handle_dma(struct page *page,
 		size -= to_go;
 	}
 }
+EXPORT_SYMBOL_GPL(kmsan_handle_dma);
 
 void kmsan_handle_dma_sg(struct scatterlist *sg, int nents,
 			 enum dma_data_direction dir)
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

dma-kmsan-export-kmsan_handle_dma-for-modules.patch
rcu-provide-a-static-initializer-for-hlist_nulls_head.patch
ucount-replace-get_ucounts_or_wrap-with-atomic_inc_not_zero.patch
ucount-use-rcu-for-ucounts-lookups.patch
ucount-use-rcuref_t-for-reference-counting.patch

