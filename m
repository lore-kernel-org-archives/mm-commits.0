Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179ED2367D1
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 20:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773087819; cv=none; b=QJdfb2jWpkF7wQDZaMhro2lOngLQf400ozzeEeT+6eJhNp8iQZ+oo+nZdOlexAcYq9WwEIF1njEN50u3JEWu20FH21esdA+CizxMqTgxSNFFtgjWp9Rz3SAsHtUfhBdnUpGn4r+UzpMszUs5xPGtQZjWmrjPPInGFdFYkY4OH58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773087819; c=relaxed/simple;
	bh=i43hYYJihv2DFf9coLyvin0ugVfJWmIkXf9chZCCsY0=;
	h=Date:To:From:Subject:Message-Id; b=Uvgck9WQbzZWNzH/e6XLCjviatywDL64d5eFXyfLgqRwTBowbm0pB76R0lJM8EX52GfVCO+ObHl1jrDnCO5eQfqYA5A1VQVJGs2LGhwOVJXb9HLEAUM/yvpiNlpxgpK74/TEjcwRQTxgbGLRRp2rQDPC7FqM7YsFeug+LnlD+sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uneyw4sE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uneyw4sE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99223C4CEF7;
	Mon,  9 Mar 2026 20:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773087818;
	bh=i43hYYJihv2DFf9coLyvin0ugVfJWmIkXf9chZCCsY0=;
	h=Date:To:From:Subject:From;
	b=Uneyw4sEPqzWAZnhO9FO1j29YXU5ZSIFnQsxktgRYmT1/1YKbOU3JLVsdyBaqdtBO
	 zdB65l/EjeVQfFdHw6Idd8FuCry/w7ujQt8eeWxfxrgzVuPbGcDU3whr1aPEqgmgZK
	 SaPudVPBsvNFxyEpljfjtfXW44wpsUMsBrrtwDYs=
Date: Mon, 09 Mar 2026 13:23:37 -0700
To: mm-commits@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,joseph.qi@linux.alibaba.com,jlbec@evilplan.org,heming.zhao@suse.com,gechangwei@live.cn,a.velichayshiy@ispras.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ocfs2-remove-redundant-error-code-assignment.patch added to mm-nonmm-unstable branch
Message-Id: <20260309202338.99223C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ocfs2: remove redundant error code assignment
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ocfs2-remove-redundant-error-code-assignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ocfs2-remove-redundant-error-code-assignment.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Subject: ocfs2: remove redundant error code assignment
Date: Sun, 8 Mar 2026 02:47:53 +0300

Remove the error assignment for variable 'ret' during correct code
execution.  In subsequent execution, variable 'ret' is overwritten.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Link: https://lkml.kernel.org/r/20260307234809.88421-1-a.velichayshiy@ispras.ru
Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmmaster.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmmaster.c~ocfs2-remove-redundant-error-code-assignment
+++ a/fs/ocfs2/dlm/dlmmaster.c
@@ -930,7 +930,6 @@ redo_request:
 	if (blocked)
 		goto wait;
 
-	ret = -EINVAL;
 	dlm_node_iter_init(mle->vote_map, &iter);
 	while ((nodenum = dlm_node_iter_next(&iter)) >= 0) {
 		ret = dlm_do_master_request(res, mle, nodenum);
_

Patches currently in -mm which might be from a.velichayshiy@ispras.ru are

ocfs2-remove-redundant-error-code-assignment.patch

