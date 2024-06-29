Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC27B658
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628218; cv=none; b=HrN0oaJJ1EN3iM38SUKwiqKqlE69GyjHlt42SVlQaNxBngJcbReIbpLf9szXEoJ/sLFAGX87XO4u9CU/F46x7cXsaRbwj1idnOu3dx3RS+SCzckAldG82lGRJVLWWbZ35l0k6+A7iP7ZFjE+r0ETnZQAjp42Z7BKEpODBLb4/Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628218; c=relaxed/simple;
	bh=sGRwEupkizsjZdNqjRSdaSjzqdjPT+Os/srOEMoI1Es=;
	h=Date:To:From:Subject:Message-Id; b=DniT4r0w76NwIibJdlDjlcgEQIKwLv3J4VAvui0CtXkLffM8peIgMNrdsU7irnLy3Sm1vR4fNglX3U0h0xd0L/JMjOktbPbNCK7VUSONu9Tx/ZWc/2TPH3nkjaw59QvuyVoAG00nrv6YI1QvVTKHObmnSzATZ816O5G4x/5FcjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KYRgVR2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KYRgVR2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3108C116B1;
	Sat, 29 Jun 2024 02:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628218;
	bh=sGRwEupkizsjZdNqjRSdaSjzqdjPT+Os/srOEMoI1Es=;
	h=Date:To:From:Subject:From;
	b=KYRgVR2ksFRP5QfJHPPOj9+UG+Y7zWk8akmMhDq0FATIRP3A+B8U7+o3iXbat50Qs
	 sGZo8OB3B/GMVOPVC5iI2dx1H625pfkfDOoPDRLvQkEr++qWSbfERDj67pr7QOxfGV
	 RhOux2j/RlNtQAhjFW24e6tKPGtZc9oZrXerLhnk=
Date: Fri, 28 Jun 2024 19:30:18 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,Liam.Howlett@oracle.com,rgbi3307@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-modified-return-type-of-mas_wr_store_entry.patch removed from -mm tree
Message-Id: <20240629023018.B3108C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: modified return type of mas_wr_store_entry()
has been removed from the -mm tree.  Its filename was
     maple_tree-modified-return-type-of-mas_wr_store_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: JaeJoon Jung <rgbi3307@gmail.com>
Subject: maple_tree: modified return type of mas_wr_store_entry()
Date: Fri, 14 Jun 2024 18:24:28 +0900

Since the return value of mas_wr_store_entry() is not used,
the return type can be changed to void.

Link: https://lkml.kernel.org/r/20240614092428.29491-1-rgbi3307@gmail.com
Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/lib/maple_tree.c~maple_tree-modified-return-type-of-mas_wr_store_entry
+++ a/lib/maple_tree.c
@@ -4203,31 +4203,28 @@ slow_path:
  *
  * Return: The contents that was stored at the index.
  */
-static inline void *mas_wr_store_entry(struct ma_wr_state *wr_mas)
+static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
 
 	wr_mas->content = mas_start(mas);
 	if (mas_is_none(mas) || mas_is_ptr(mas)) {
 		mas_store_root(mas, wr_mas->entry);
-		return wr_mas->content;
+		return;
 	}
 
 	if (unlikely(!mas_wr_walk(wr_mas))) {
 		mas_wr_spanning_store(wr_mas);
-		return wr_mas->content;
+		return;
 	}
 
 	/* At this point, we are at the leaf node that needs to be altered. */
 	mas_wr_end_piv(wr_mas);
 	/* New root for a single pointer */
-	if (unlikely(!mas->index && mas->last == ULONG_MAX)) {
+	if (unlikely(!mas->index && mas->last == ULONG_MAX))
 		mas_new_root(mas, wr_mas->entry);
-		return wr_mas->content;
-	}
-
-	mas_wr_modify(wr_mas);
-	return wr_mas->content;
+	else
+		mas_wr_modify(wr_mas);
 }
 
 /**
_

Patches currently in -mm which might be from rgbi3307@gmail.com are


