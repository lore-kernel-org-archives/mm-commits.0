Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4D7217659;
	Fri, 22 May 2026 02:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779415618; cv=none; b=LqaUQoij3uvOR6CuC19e856/jj/vuykNZc3RBeYgqZKi+CHBwSGfJfRfE6ElWCsbnwj1kmRK6fYoCPaoUdeENgL2pUpUYDfVuVss3MW2OBcIf2Ny2IGoR4oYwPV1if8c5/XlTdaXNd4a//48kHfmlj8pcajl2q4WIJLVuJHQgfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779415618; c=relaxed/simple;
	bh=/i68O9iN0bRyS37xEpRzvGaPIrsHliRpAZJVTb3Mwds=;
	h=Date:To:From:Subject:Message-Id; b=Cdkzrm5jzvr2JL+JZvY9jbC1pQOLrSqHF5Dt3BdQJGVccMS7RzNbOSCdY/LhEAc4DkQmpdGowMEZV/OnfOczTEnxOTKaIwE+5BeMZFdAX4/EJPWD0cn2J4B+W5TnztNiczDhvohSKigQAf9bpJbZ+WOdNgTPRehGcdtfR6Sk0Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zdk479+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zdk479+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EBB1F00A3D;
	Fri, 22 May 2026 02:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779415617;
	bh=HAKo/KixOABDrhIFPzRZu2WFXRxDOrrKVRcI7m0a3Wc=;
	h=Date:To:From:Subject;
	b=Zdk479+KRO1gRAEFAS5ed7FS+H9kTOb74xCF8ay2uvaQ6JnrDuEAGqRXRpxlWGJfF
	 Gp+ukXotiG00Gp7uMSDtIFmS+WqAeohR7JuSY6RqzZddQLYB6rRST+N2hpyHOVGvNo
	 2wfDazjOkHM4ZT2emJD0qlliBW1+CuL2ljqvhcSI=
Date: Thu, 21 May 2026 19:06:56 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,pasha.tatashin@soleen.com,kees@kernel.org,jeffxu@google.com,jackmanb@google.com,hughd@google.com,gthelen@google.com,david@kernel.org,baolin.wang@linux.alibaba.com,pratyush@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] memfd-deny-writeable-mappings-when-implying-seal_write.patch removed from -mm tree
Message-Id: <20260522020656.E3EBB1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memfd: deny writeable mappings when implying SEAL_WRITE
has been removed from the -mm tree.  Its filename was
     memfd-deny-writeable-mappings-when-implying-seal_write.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Subject: memfd: deny writeable mappings when implying SEAL_WRITE
Date: Tue, 5 May 2026 15:39:20 +0200

When SEAL_EXEC is added, SEAL_WRITE is implied to make W^X.  But the
implied seal is set after the check that makes sure the memfd can not have
any writable mappings.  This means one can use SEAL_EXEC to apply
SEAL_WRITE while having writeable mappings.

This breaks the contract that SEAL_WRITE provides and can be used by an
attacker to pass a memfd that appears to be write sealed but can still be
modified arbitrarily.

Fix this by adding the implied seals before the call for
mapping_deny_writable() is done.

Link: https://lore.kernel.org/20260505133922.797635-1-pratyush@kernel.org
Fixes: c4f75bc8bd6b ("mm/memfd: add write seals when apply SEAL_EXEC to executable memfd")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 
Acked-by: Jeff Xu <jeffxu@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memfd.c~memfd-deny-writeable-mappings-when-implying-seal_write
+++ a/mm/memfd.c
@@ -283,6 +283,12 @@ int memfd_add_seals(struct file *file, u
 		goto unlock;
 	}
 
+	/*
+	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
+	 */
+	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
+		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
+
 	if ((seals & F_SEAL_WRITE) && !(*file_seals & F_SEAL_WRITE)) {
 		error = mapping_deny_writable(file->f_mapping);
 		if (error)
@@ -295,12 +301,6 @@ int memfd_add_seals(struct file *file, u
 		}
 	}
 
-	/*
-	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
-	 */
-	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
-		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
-
 	*file_seals |= seals;
 	error = 0;
 
_

Patches currently in -mm which might be from pratyush@kernel.org are


