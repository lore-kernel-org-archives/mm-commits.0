Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B262EB10
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011361; cv=none; b=qxoMWE1q7ea0pAB0sWx0sz2ZI8dSbVdq9+lMbP2hxSpLhl7cZshp7TiBs46+PcDLfcNSOJilsRzrQH8ks3ouJ0jnACmkHHrjFAI0FVVkARn68EtJUG8U2+YhF6LLR5ymY6XGqq7A9eRBrF7fitLWb5W8Zlj3yKbmMTzjBLlitQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011361; c=relaxed/simple;
	bh=6jUD9X3TeKxJ8hghHeia1FRY3KLTy5fCXZc+023TCj4=;
	h=Date:To:From:Subject:Message-Id; b=uyu/3IlZLLSIA67951Pbv5Oew/Ow9eDX3LqrzB21835SP9aegELlbLy/crLfhRY4t/HkyW3ZxyGAln9LOwCyJwU/vR7bLSj+FChm69tmThZH++WOsGUQvxbheSPospHsaDTUJ6EtuW0bv/CWa55OdXqhLtO3WFnd7lpkNCYacHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cF3B19zz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cF3B19zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7F7C4CEE4;
	Mon, 12 May 2025 00:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011361;
	bh=6jUD9X3TeKxJ8hghHeia1FRY3KLTy5fCXZc+023TCj4=;
	h=Date:To:From:Subject:From;
	b=cF3B19zzyPhPReBRYfODHd2o4f9VSQnzE7yYxNujeQHYrqPcIRh+IMqWw3ngfOjG5
	 XGofkj57DD4TXS9ttGjuwlHqJBghowTY33WsCy8YmKzLNWpfBxNou1mDqd7quiMZ9S
	 su2V1jCkIyU8St997kKKBj3Tw0mYwDYkSLtpzT8I=
Date: Sun, 11 May 2025 17:56:01 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,gechangwei@live.cn,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ocfs2-simplify-return-statement-in-ocfs2_filecheck_attr_store.patch removed from -mm tree
Message-Id: <20250512005601.AB7F7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: simplify return statement in ocfs2_filecheck_attr_store()
has been removed from the -mm tree.  Its filename was
     ocfs2-simplify-return-statement-in-ocfs2_filecheck_attr_store.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: ocfs2: simplify return statement in ocfs2_filecheck_attr_store()
Date: Tue,  8 Apr 2025 12:34:07 +0200

Don't negate 'ret' and simplify the return statement.

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/filecheck.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/filecheck.c~ocfs2-simplify-return-statement-in-ocfs2_filecheck_attr_store
+++ a/fs/ocfs2/filecheck.c
@@ -505,5 +505,5 @@ static ssize_t ocfs2_filecheck_attr_stor
 		ocfs2_filecheck_handle_entry(ent, entry);
 
 exit:
-	return (!ret ? count : ret);
+	return ret ?: count;
 }
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are


