Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB37120B20
	for <mm-commits@vger.kernel.org>; Tue, 16 Jan 2024 20:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705435758; cv=none; b=BywkJXs3LsNnWXuXdscg8WK4fBWPtILDl9pkia28oaPxTkpAda3315xW0Gv3cocHmLIFI9yCgzmFKfjJtkiIe+7aql3vA7V8Q11vI4m6HFpkAcK6tUXhuWaXS64hz6FLOhK2EiBmtN/HJfzm2tav9oEbbm6KcHEKPfZGDZh6Ad4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705435758; c=relaxed/simple;
	bh=UU050LF/Nm3r8tQfPAaSAGmUIjneFflFKqRvai4p25Q=;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id; b=pryYl35uizFuUsxcYxf0Od9hUCM0HByD/WPvf1dTI5AVEWXLiaOJWPw/ozchPzfZHOnJx03vTDsBEVprp2K4nsq9eqchzo8zPMyQ1i6RQVVy5Y5tX2LjhrFPcdQ3WduU5DaBY9D8W7Ql30hABC4zcvl1k10vi9WBbVUDNQzCsaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O0mfCtTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O0mfCtTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9D5C433F1;
	Tue, 16 Jan 2024 20:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705435758;
	bh=UU050LF/Nm3r8tQfPAaSAGmUIjneFflFKqRvai4p25Q=;
	h=Date:To:From:Subject:From;
	b=O0mfCtTxzwF5PbsfCQoFN2CmNsqkqpejVb8XyX861KLK66qydBfgacL7k1HvA5j74
	 6W3xSnHZXPg8NPF+8g1ZwVXlWPjuObPehmprwNrABf/An3JuJM5jMF2591HLI1663v
	 zuu2RhyWnD9/C64+/4awywPM5ovUEyHHCvx8YFdw=
Date: Tue, 16 Jan 2024 12:09:16 -0800
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,zeming@nfschina.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + user_namespace-remove-unnecessary-null-values-from-kbuf.patch added to mm-nonmm-unstable branch
Message-Id: <20240116200918.3D9D5C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: user_namespace: Remove unnecessary NULL values from kbuf
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     user_namespace-remove-unnecessary-null-values-from-kbuf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/user_namespace-remove-unnecessary-null-values-from-kbuf.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Li zeming <zeming@nfschina.com>
Subject: user_namespace: Remove unnecessary NULL values from kbuf
Date: Mon, 15 Jan 2024 14:25:19 +0800

kbuf is assigned first, so it does not need to initialize the assignment.

Link: https://lkml.kernel.org/r/20240115062519.31298-1-zeming@nfschina.com
Signed-off-by: Li zeming <zeming@nfschina.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/user_namespace.c~user_namespace-remove-unnecessary-null-values-from-kbuf
+++ a/kernel/user_namespace.c
@@ -931,7 +931,7 @@ static ssize_t map_write(struct file *fi
 	struct uid_gid_map new_map;
 	unsigned idx;
 	struct uid_gid_extent extent;
-	char *kbuf = NULL, *pos, *next_line;
+	char *kbuf, *pos, *next_line;
 	ssize_t ret;
 
 	/* Only allow < page size writes at the beginning of the file */
_

Patches currently in -mm which might be from zeming@nfschina.com are

user_namespace-remove-unnecessary-null-values-from-kbuf.patch

