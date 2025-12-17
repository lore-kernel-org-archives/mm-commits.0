Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D5752F88
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 21:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006271; cv=none; b=nzNKsNbOJT7aLZ/Y3iQNl93ANuAN4rRAInfszIn4PattCiYbDVTLO47/Gxl8nXS9r3vRQ93/EHF4ZHmco8T2AGlR3kMLVcdNAjLsKxStezWLZUARzPYFWBlJRnx/JouqtX6UEDyEgusoqiuxWVA4mc3QKO/QdpZfv3ub0L/Hrnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006271; c=relaxed/simple;
	bh=cPB+sT7MDyeprG4NSAhf7SzpWBfIDWRI4s3J3TTbsPs=;
	h=Date:To:From:Subject:Message-Id; b=hVh1EaC8N3G3D+NNRAwnqpS0eSY1EdBPO52oLMSk2fu4ZbDtAxn2gEGlkYb4Ztci6VUHKrW0RGDkeB6oFUPW53P+q1b4Q6U5exSP4pV1ki/9K/6b+lLT19BdyldEBUEMPO9Kk2FOzaN1LBST1OmyDrMyR7vgTj5gHBuJzZ3USVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L7L7siGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L7L7siGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C370C4CEF5;
	Wed, 17 Dec 2025 21:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766006271;
	bh=cPB+sT7MDyeprG4NSAhf7SzpWBfIDWRI4s3J3TTbsPs=;
	h=Date:To:From:Subject:From;
	b=L7L7siGQf8gTs0RzxMYSR6XIvwwlf4PhpNjjy+TNSlul8gkqeUaVYHwrD9mcTmyvP
	 p9Yp+MW/9Lk9eh6lYw3Hf5RhppqVxs7Jld3ZZ9aD6aawsWJE0KZMVf6JoePDROEB7j
	 4VlaUq6g+08eibQ2/zaSTyO+v9NZLMenx5yPFAiA=
Date: Wed, 17 Dec 2025 13:17:50 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,yosry.ahmed@linux.dev,willy@infradead.org,weixugc@google.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,nphamcs@gmail.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,david.laight.linux@gmail.com,david@kernel.org,chengming.zhou@linux.dev,axelrasmussen@google.com,chandna.sahil@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-use-%pe-to-print-error-pointers.patch added to mm-new branch
Message-Id: <20251217211751.0C370C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vmscan: use %pe to print error pointers
has been added to the -mm mm-new branch.  Its filename is
     mm-vmscan-use-%pe-to-print-error-pointers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-use-%pe-to-print-error-pointers.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sahil Chandna <chandna.sahil@gmail.com>
Subject: mm/vmscan: use %pe to print error pointers
Date: Fri, 28 Nov 2025 12:31:43 +0530

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value.  This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended

Link: https://lkml.kernel.org/r/2c842a64fddeb0fe0cac087783aaedd97edc3191.1764312627.git.chandna.sahil@gmail.com
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/vmscan.c~mm-vmscan-use-%pe-to-print-error-pointers
+++ a/mm/vmscan.c
@@ -7869,3 +7869,4 @@ void reclaim_unregister_node(struct node
 	return device_remove_file(&node->dev, &dev_attr_reclaim);
 }
 #endif
+Wed Dec 17 01:15:15 PM PST 2025
_

Patches currently in -mm which might be from chandna.sahil@gmail.com are

mm-pagewalk-simplify-hugepage-boundary-calculation.patch
mm-vmscan-use-%pe-to-print-error-pointers.patch
mm-zswap-use-%pe-to-print-error-pointers.patch

