Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759BA358396
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388522; cv=none; b=tOi4r9JRIZ7+Ggij+rro2qlsyNShMoNfwFo2B2mOTeeKYRa93/85bciMbnMhMUd3X3oYMib/UAiu/DtSD8ptHfnDSTgHcQCNaahn2Xvvl/jz+1JdOtr+7EO7qJoLjSHyWFxicrTU4DbWCWBa/51jvaZav9OCeZ8i+vFhZyScSmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388522; c=relaxed/simple;
	bh=SoWW4ocd9O0ekjkCxZnbJ+P0OsteIFpuwd64ctx5blA=;
	h=Date:To:From:Subject:Message-Id; b=AsG+klWaRC0q755R8XWprfuwsaWIUo17aIHncByP8Udv/ec+Zh3ipGqLvS+s+haaosKEZ6I2d1+CjFGQ2LqAgNW8eZjrclqhb/lXNXmu0YmpQIAIvLUUtjH0tXSkvk7MRW1ObwwR4gukuYifUKhPvuDRMHz37Ia6FPlg2mrAn04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ow+EBSSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ow+EBSSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D152C19424;
	Tue, 24 Mar 2026 21:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388522;
	bh=SoWW4ocd9O0ekjkCxZnbJ+P0OsteIFpuwd64ctx5blA=;
	h=Date:To:From:Subject:From;
	b=ow+EBSSMtUuRS1GfThBn8fscCJ5z2OberHU/75BoAgxsN4URkjm/UOXCBLsrjBJuW
	 dyrIV8LDYk26C4FKROF1GeYA9lc3MvGUQXVB5Z6p2zFKJkgEJLbgZZIZCwZOaeSvwa
	 HHNq8zIzbnUFkUlegbrSTi+O4hFU0cSYc/9OKQ1Q=
Date: Tue, 24 Mar 2026 14:42:01 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,sj@kernel.org,sidhartha.kumar@oracle.com,lists@nerdbynature.de,kuninori.morimoto.gx@renesas.com,geert@linux-m68k.org,arnd@arndb.de,andrewjballance@gmail.com,aliceryhl@google.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-add-copy_tree_location-helper.patch removed from -mm tree
Message-Id: <20260324214202.4D152C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: add copy_tree_location() helper
has been removed from the -mm tree.  Its filename was
     maple_tree-add-copy_tree_location-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: maple_tree: add copy_tree_location() helper
Date: Fri, 30 Jan 2026 15:59:29 -0500

Extract the copying of the tree location from one maple state to another
into its own function.  This is used more later.

Link: https://lkml.kernel.org/r/20260130205935.2559335-25-Liam.Howlett@oracle.com
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

 lib/maple_tree.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/lib/maple_tree.c~maple_tree-add-copy_tree_location-helper
+++ a/lib/maple_tree.c
@@ -3531,6 +3531,17 @@ static bool spanning_ascend(struct maple
 	return true;
 }
 
+static inline
+void copy_tree_location(const struct ma_state *src, struct ma_state *dst)
+{
+	dst->node = src->node;
+	dst->offset = src->offset;
+	dst->min = src->min;
+	dst->max = src->max;
+	dst->end = src->end;
+	dst->depth = src->depth;
+}
+
 /*
  * rebalance_ascend() - Ascend the tree and set up for the next loop - if
  * necessary
@@ -3570,12 +3581,7 @@ static inline bool rebalance_ascend(stru
 	}
 
 	cp->height++;
-	mas->node = parent->node;
-	mas->offset = parent->offset;
-	mas->min = parent->min;
-	mas->max = parent->max;
-	mas->end = parent->end;
-	mas->depth = parent->depth;
+	copy_tree_location(parent, mas);
 	wr_mas_setup(wr_mas, mas);
 	return true;
 }
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


