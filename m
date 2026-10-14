Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE38499F12
	for <mm-commits@vger.kernel.org>; Wed, 14 Oct 2026 09:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791969417; cv=none; b=BltZpdefaAbxMDcYHLXWIJs1IgarK3GSRZABLF5EQatEVWXCvjY1KQX36RY51rmCNeGrrb2MYK18Z1SqjOoQv2Dj6jDBzqDjEQ5wiqynk+4mGRoHCYtXq8wS6RxQja7o6O+aVj6ueK+7RaH/cpRJ38fWAIQauDfaeZxSBr7BZ4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791969417; c=relaxed/simple;
	bh=fiUFSXtN6wKNgTaVikvqdSNODLiMB/CPRSiY3EpWmLE=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:Subject:Content-Type; b=Ba5QNYpLvCeCy0JPgMcBuXw8DF29n3DjGjwTUs8a3kqjOt3I7Z0WhTzEJC23qOrPGedasMtuD/NwuiPIoEG8VoQw5W5VSXilfLg1OhFvxZCXKQ1fy5InzVL9uLCQ5FOIZ5gCiDRsEyMEhsBjYaXqfgvy0NZOi0rmoQtUfNudx1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IMbmw2Xe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IMbmw2Xe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE0F1F000FF;
	Wed, 14 Oct 2026 09:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791969416;
	bh=H7azOrJvtgsnLjhsEK19ZwdOTcpOdjmLI5lVmJm9JAo=;
	h=Date:From:To:Cc:Subject;
	b=IMbmw2XeI9mutMSuY/vB2Kp4NaU2YSJysw8DCTzQrFvvfEn1XT5jhZMGL2nEynVgM
	 P52SXsMKfpS9DBFBhoN01r3SfWg+pyE37fXJMxQzI/wYS7uDY6U+8rPvd1whOMHSRU
	 Tzsyxj/iWDhu8050p4DuJ5/WoSeC1+2F8RHo1Ns/LWq2qx3/PaOqfAwmDnulfj7tp1
	 uJDowlUflqtzbMvnrVFBEmWBZjMtXvRt9aFB8DKcew+8sD8DMfyOQslGsOCsubcPAt
	 W/YSFG4IE+7nKzEchI3jv2N6APgf9idjlQR8imZy3uv7FvIrAfiPuYJZ5CuYZbQFee
	 mFLteK7zALlsw==
Message-ID: <836fd90a-4417-4457-97bd-e540f41de597@kernel.org>
Date: Wed, 14 Oct 2026 11:16:52 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: mm-commits@vger.kernel.org, Muchun Song <muchun.song@linux.dev>,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm-next: manual merge of the akpm/mm-unstable branch
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

today's mm-next merge of the akpm/mm-unstable branch tree got a conflict in:

  mm/sparse-vmemmap.c

between the commit:

  063b5e8bbd21 mm: Remove unused exact_nid parameter from memmap_alloc()

from the memblock/for-next branch:

  59cbd435300c mm/sparse-vmemmap: factor out shared vmemmap tail page allocation

from the akpm/mm-unstable branch.

I resolved the conflict manually and will carry the conflict resolution going
forward. "git show --remerge-diff" output for brevity; if people prefer a
different (longer?) output please shout.


diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
remerge CONFLICT (content): Merge conflict in mm/sparse-vmemmap.c
index a43f1256bf5e..5d7e982f94d0 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -36,11 +36,7 @@
 #include "mm_init.h"
 #include "sparse.h"

-<<<<<<< 46c6d937b2c5 (Merge https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git for-next into for-next)
-void * __meminit vmemmap_alloc_block(unsigned long size, int node)
-=======
 void __ref *vmemmap_alloc_block(unsigned long size, int node)
->>>>>>> 1d0b04a60516 (mm: page_alloc: make defrag_mode retries follow the promoted order)
 {
        /* If the main allocator is up use that, fallback to bootmem. */
        if (slab_is_available()) {
@@ -60,11 +56,7 @@ void __ref *vmemmap_alloc_block(unsigned long size, int node)
                }
                return NULL;
        } else
-<<<<<<< 46c6d937b2c5 (Merge https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock.git for-next into for-next)
                return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), node);
-=======
-               return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), node, false);
->>>>>>> 1d0b04a60516 (mm: page_alloc: make defrag_mode retries follow the promoted order)
 }

 static void * __meminit altmap_alloc_block_buf(unsigned long size,
