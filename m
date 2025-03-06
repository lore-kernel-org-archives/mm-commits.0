Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EB119E98D;
	Thu,  6 Mar 2025 05:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239444; cv=none; b=GLS4HzoOoXhw5aKkKC7UXaob05wclvhw1CxNPVNJ12dSVQ+ZrQ+Re8v7Gxm16WUc0qXBndNZ/DyhxLnxfgzDMUoTGgj6TLsYRPbjEL+bUaPqVA+syPs3bwzPsnOmupQoSImM7qBxAcT40ep+ztAJQU8vjqsz4M57kk7Emvk21S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239444; c=relaxed/simple;
	bh=GVoozyq8zQWA6QVWFYEOZoQybJWiZvbMgeRuWSt00+E=;
	h=Date:To:From:Subject:Message-Id; b=a0qWjd32y9rREGh4uPL1BlhSS1xFwQd2Q4UwUj23SZ8RVXaqYED9lxMTPI72X8UzXzIb7AyDQkEzaIdB5VWBIJfYmFKbDjnSb4hKyXxZEkZAoSYy8aeUA7+grZiO/CBjzmraaOsUTeOj7BH+iwByR/E9AeSuEq2/VRVzIKVcPAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iyPkH+wb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iyPkH+wb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF85C4CEE4;
	Thu,  6 Mar 2025 05:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239444;
	bh=GVoozyq8zQWA6QVWFYEOZoQybJWiZvbMgeRuWSt00+E=;
	h=Date:To:From:Subject:From;
	b=iyPkH+wbf3V2B/Ekimc4d8U+Rfs6SRLCllT8/yiNG73ghEbavdMXQgB2/i3u28XM9
	 InVDqFx71l93hzJuQ5gy2fnzKXpD0FJHuhIyWA3V5xLAVjKw7CQBPkouU723qk/JLM
	 80lUs3R9XmboO/x31rlWu8lxYSsarOHmkMV98jC4=
Date: Wed, 05 Mar 2025 21:37:24 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,stable@vger.kernel.org,peterz@infradead.org,lkp@intel.com,glider@google.com,elver@google.com,dvyukov@google.com,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] dma-kmsan-export-kmsan_handle_dma-for-modules.patch removed from -mm tree
Message-Id: <20250306053724.9DF85C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dma: kmsan: export kmsan_handle_dma() for modules
has been removed from the -mm tree.  Its filename was
     dma-kmsan-export-kmsan_handle_dma-for-modules.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 7ade4f10779c ("dma: kmsan: unpoison DMA mappings")
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

rcu-provide-a-static-initializer-for-hlist_nulls_head.patch
ucount-replace-get_ucounts_or_wrap-with-atomic_inc_not_zero.patch
ucount-use-rcu-for-ucounts-lookups.patch
ucount-use-rcuref_t-for-reference-counting.patch

