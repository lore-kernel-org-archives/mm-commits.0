Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3CC35F5FB
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388492; cv=none; b=UYuaN6LWkma3D0l7RNxUU2TYJ8mHxDHj7yiiqIyHoQTco3WS8dc1jrnk+mIGlY3FCRfFbuncFgqrT6ZpHX6c5httJ3Rq+pQzxIZrfzEETdSfr6Oo919YI/DMqwPWEGJTpGLwttqbZVFntZ8XaPS3VZ5P11VehBAacUQKEsIbCT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388492; c=relaxed/simple;
	bh=SHfvHLjegUXzC05vNeerP+kR4Hn8k7PpfGNcBkz/dyA=;
	h=Date:To:From:Subject:Message-Id; b=qTxK2jHjygc3JnxgvaoDaqEN/ye23Xhgo+HaHPIn7nYIqBoWpmglDL88kM8BwJ5U6N9DpLGUAIVVucu2GEU+xc/iNBN9eGlh/s5e3CiVyJ/nAPmUkXs545fGID0PyiecAuf7VzmLn++SzfXfMUK/jDVSpyAcps9jTNgam7fWbSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vHgXqJqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vHgXqJqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62017C19424;
	Tue, 24 Mar 2026 21:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388492;
	bh=SHfvHLjegUXzC05vNeerP+kR4Hn8k7PpfGNcBkz/dyA=;
	h=Date:To:From:Subject:From;
	b=vHgXqJqoNkuCndf707L1pLKPY0EyPzKaeJ0mdpOCRBAy6xGBwJDSEtmZc9geFttoa
	 1C69OJvoE1gkocB2XtJd5+5hLDH8Lys8w72m78rYikQFmNSyps4QxNMv2UbaaPnmX5
	 6A8iouDJrbIBjbFLo4sPNY9titLfkThFfRVPIk7g=
Date: Tue, 24 Mar 2026 14:41:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-make-ma_wr_states-reliable-for-reuse-in-spanning-store.patch removed from -mm tree
Message-Id: <20260324214132.62017C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: make ma_wr_states reliable for reuse in spanning store
has been removed from the -mm tree.  Its filename was
     maple_tree-make-ma_wr_states-reliable-for-reuse-in-spanning-store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: make ma_wr_states reliable for reuse in spanning store
Date: Fri, 30 Jan 2026 15:59:11 -0500

mas_extend_spanning_null() was not modifying the range min and range max
of the resulting store operation.  The result was that the maple write
state no longer matched what the write was doing.  This was not an issue
as the values were previously not used, but to make the ma_wr_state usable
in future changes, the range min/max stored in the ma_wr_state for left
and right need to be consistent with the operation.

Link: https://lkml.kernel.org/r/20260130205935.2559335-7-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Ballance <andrewjballance@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/maple_tree.c~maple_tree-make-ma_wr_states-reliable-for-reuse-in-spanning-store
+++ a/lib/maple_tree.c
@@ -3319,6 +3319,7 @@ static inline void mas_extend_spanning_n
 			l_mas->index = l_mas->min;
 
 		l_mas->offset = l_slot - 1;
+		l_wr_mas->r_min = l_mas->index;
 	}
 
 	if (!r_wr_mas->content) {
@@ -3331,6 +3332,7 @@ static inline void mas_extend_spanning_n
 		r_mas->last = mas_safe_pivot(r_mas, r_wr_mas->pivots,
 					     r_wr_mas->type, r_mas->offset + 1);
 		r_mas->offset++;
+		r_wr_mas->r_max = r_mas->last;
 	}
 }
 
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


