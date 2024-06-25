Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325C713C914
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289148; cv=none; b=ePy33r9HDPAqZU5ApWIGOL6MN4wYijGAOe+7oAWsLgiSQiuY2mRjPVgucqUyxoiUD1FCmkcM8zxrOvIDIUdPkmNhwgBi/IbDJufYwUFzfC2T0fQ+F2QlYG2W47EMnzuFeQE9c+aFUEhQqhtVKBCJ3UwqGRqk2tt+DId6Sxijv0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289148; c=relaxed/simple;
	bh=2jlyFsGdNv1pnY4nSx/ZDDmts6Y0GHd3dlN3eJ9zg/U=;
	h=Date:To:From:Subject:Message-Id; b=GvgnZ1kBmk2xzFXWRkB5qcYgFv4f63y4j5rojNyrp4eLuDTSl5fDhWwNmByYmgikzVMDqsWOu38JgQZEB5LiQ9wFtJ/phfBj+o77wU6RC8hhBT2eNyeMXLkSJULfZR4h/w/rlEOkSRH7XyaOcy50F6hG98GVVZGk9RYLaenSVKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0egxmMum; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0egxmMum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A50C4AF0B;
	Tue, 25 Jun 2024 04:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289147;
	bh=2jlyFsGdNv1pnY4nSx/ZDDmts6Y0GHd3dlN3eJ9zg/U=;
	h=Date:To:From:Subject:From;
	b=0egxmMumxehT8jlipeoazeP30OpjzON4iIE4DI+NZIDfYc13CuYYo6Gty46KR69S0
	 YiinHgrNx8asNM6Ekyxx9d8M98ACULVzTDMDgYNF/2isFjlRMLHVHc+hf0hypFnViB
	 CYY/s1rATaU7aTw2iTR+0og1B82E7W1Wqh8lDRKU=
Date: Mon, 24 Jun 2024 21:19:07 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,david@redhat.com,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-rmap-abstract-updating-per-node-and-per-memcg-stats-fix.patch removed from -mm tree
Message-Id: <20240625041907.B0A50C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rmap: abstract updating per-node and per-memcg stats fix
has been removed from the -mm tree.  Its filename was
     mm-rmap-abstract-updating-per-node-and-per-memcg-stats-fix.patch

This patch was dropped because it was folded into mm-rmap-abstract-updating-per-node-and-per-memcg-stats.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: rmap: abstract updating per-node and per-memcg stats fix
Date: Tue, 11 Jun 2024 22:10:43 -0700 (PDT)

/proc/meminfo is showing ridiculously large numbers on some lines:
__folio_remove_rmap()'s __folio_mod_stat() should be subtracting!

Link: https://lkml.kernel.org/r/49914517-dfc7-e784-fde0-0e08fafbecc2@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mm-rmap-abstract-updating-per-node-and-per-memcg-stats-fix
+++ a/mm/rmap.c
@@ -1567,7 +1567,7 @@ static __always_inline void __folio_remo
 		    list_empty(&folio->_deferred_list))
 			deferred_split_folio(folio);
 	}
-	__folio_mod_stat(folio, nr, nr_pmdmapped);
+	__folio_mod_stat(folio, -nr, -nr_pmdmapped);
 
 	/*
 	 * It would be tidy to reset folio_test_anon mapping when fully
_

Patches currently in -mm which might be from hughd@google.com are

mm-rmap-abstract-updating-per-node-and-per-memcg-stats.patch

