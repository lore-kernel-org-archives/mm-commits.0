Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C473813E02E
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313717; cv=none; b=Es5LaPfqF9ROQKGOjCW7mQ9MovIRq18TmaBdvow1HK5WJpC5GDsDW51FXfuGI61xtE3CmXhCaaXrK1YaAb1B/wu7qXpliJWqgpMyR91wspdyfUgJY4qqWhhxOgDczpgc//0Pc/EhnTT5Dy8lQ6tXd11K9IiTxaBXHFTTIDhM9ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313717; c=relaxed/simple;
	bh=TfBaOKfXMjXzQcZHq7/phlHBfVkgOWoUSdbPVglqVU0=;
	h=Date:To:From:Subject:Message-Id; b=arbLt3OJA4YSqaTGdc9eFXzhioiD3M5o9SQM5xheHrHibA6cIhM01AL773abbt2o+Fj2QOBZw8ybOCZCv8GOTJdmkw5WfG5eKbcjzFTTjwsKXPLOqDEyr30IeQONAAc5Xi3/2YErEaY0ROQ0t2CIgG9LPauYS34xY1gs9oEdb7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vMcVePXE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vMcVePXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D8EC4CED0;
	Mon, 11 Nov 2024 08:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313717;
	bh=TfBaOKfXMjXzQcZHq7/phlHBfVkgOWoUSdbPVglqVU0=;
	h=Date:To:From:Subject:From;
	b=vMcVePXEPhh8UaInj+s45fRsIzwHrev3jORh93q337AfOYXhBEsZrZeDa4zEU3dua
	 hPYsDtz+1K5iTckO18bv+U9nJGp12ezleRv0eo8eF828xW7hC0TUcBHb5dgRsrlbxW
	 9QIi4pvLpwKeqrCFnaL5dpw2YeMAmN7JN0hiJF+M=
Date: Mon, 11 Nov 2024 00:28:37 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,jannh@google.com,david@redhat.com,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vma-detect-infinite-loop-in-vma-tree.patch removed from -mm tree
Message-Id: <20241111082837.99D8EC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vma: detect infinite loop in vma tree
has been removed from the -mm tree.  Its filename was
     vma-detect-infinite-loop-in-vma-tree.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: vma: detect infinite loop in vma tree
Date: Thu, 31 Oct 2024 15:36:08 -0400

There have been no reported infinite loops in the tree, but checking the
detection of an infinite loop during validation is simple enough.  Add the
detection to the validate_mm() function so that error reports are clear
and don't just report stalls.

This does not protect against internal maple tree issues, but it does
detect too many vmas being returned from the tree.

The variance of +10 is to allow for the debugging output to be more useful
for nearly correct counts.  In the event of more than 10 over the
map_count, the count will be set to -1 for easier identification of a
potential infinite loop.

Note that the mmap lock is held to ensure a consistent tree state during
the validation process.

[akpm@linux-foundation.org: add comment]
Link: https://lkml.kernel.org/r/20241031193608.1965366-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/vma.c~vma-detect-infinite-loop-in-vma-tree
+++ a/mm/vma.c
@@ -615,7 +615,11 @@ void validate_mm(struct mm_struct *mm)
 			anon_vma_unlock_read(anon_vma);
 		}
 #endif
-		i++;
+		/* Check for a infinite loop */
+		if (++i > mm->map_count + 10) {
+			i = -1;
+			break;
+		}
 	}
 	if (i != mm->map_count) {
 		pr_emerg("map_count %d vma iterator %d\n", mm->map_count, i);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


