Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341AB33BBCD
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388489; cv=none; b=YQVaCLiupZc2vmlFTeDa2kG3Z4pUkjg+BOOCb4X5QOZ5/O8DSnTNGADKaXMMc9IgpExt6h7J2hfYy/5wi8Pq0R/nRsUpw5CqsewtVu03CqaM4vlLOc8sVEPRMvcmgPgLUqqV/Lt4RJQrNRzbMPCUEe0TXnI1ujtZyq+SYb9Lb9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388489; c=relaxed/simple;
	bh=PTF+W3YLngF0xgz0XpoeuvJA0kVnz696eZG2jCvB6QU=;
	h=Date:To:From:Subject:Message-Id; b=MJBJe5M+UQFHvRdiYCLUUWWOQSDhdOlVemyJcS02YB4G2LdgWiusRoffDn6Y8mF2BUXC+/f0YcqGrElYcKwNm/7YhgwC6nD0vPtt4T+S+x5+QYP5GMr42U/yHZP5u5V+2z3ro7KYk+zNqfjvNpFz555glYes7dsPJkxvZKSmzJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nKNi9uh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nKNi9uh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF6BC19424;
	Tue, 24 Mar 2026 21:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388489;
	bh=PTF+W3YLngF0xgz0XpoeuvJA0kVnz696eZG2jCvB6QU=;
	h=Date:To:From:Subject:From;
	b=nKNi9uh315l0SDuRr/6ocVYJmGeoO6SEeDybHHNajthMy9T7BkUU7HG1tSMxT84A7
	 O2v4nt6mv0RE0lyHHsjqxAR3WJcvgbsOj/3IBe9Wr1zcpYYWeCVq9G6FkeAje7LiRT
	 Aj1tsZWnWkMJFtEYYkKZB3mX1UplF4v0YH6sHmCM=
Date: Tue, 24 Mar 2026 14:41:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-remove-unnecessary-assignment-of-orig_l-index.patch removed from -mm tree
Message-Id: <20260324214129.0BF6BC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: remove unnecessary assignment of orig_l index
has been removed from the -mm tree.  Its filename was
     maple_tree-remove-unnecessary-assignment-of-orig_l-index.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: remove unnecessary assignment of orig_l index
Date: Fri, 30 Jan 2026 15:59:09 -0500

The index value is already a copy of the maple state so there is no need
to set it again.

Link: https://lkml.kernel.org/r/20260130205935.2559335-5-Liam.Howlett@oracle.com
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

 lib/maple_tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/maple_tree.c~maple_tree-remove-unnecessary-assignment-of-orig_l-index
+++ a/lib/maple_tree.c
@@ -2766,7 +2766,7 @@ static noinline void mas_wr_spanning_reb
 		b_node.b_end++;
 
 	/* Stop spanning searches by searching for just index. */
-	mast->orig_l->index = mast->orig_l->last = mas->index;
+	mast->orig_l->last = mas->index;
 
 	mast->bn = &b_node;
 	/* Combine l_mas and r_mas and split them up evenly again. */
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


