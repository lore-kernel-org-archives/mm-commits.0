Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1042C6BB
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957106; cv=none; b=TI7F3pikZv2AoTmLCS6T4Af8KdqKVwMBp0+i3SxHnd4lZ6XlK+WQgXQyaaCscfnF9vh5c/TtPJrVuq55Oo6oIHvT+OPMmPKbCMuSMbjThDBEZ0exXczCKVOvwGEuhpskea9NIQBdie/4oVqne7icsApp+35ImT4n3UF+rPTMyyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957106; c=relaxed/simple;
	bh=DnJR65NBj4Nrud89b+6Nu6HT0p3Hg92hEDgtzmMg8vs=;
	h=Date:To:From:Subject:Message-Id; b=aKMxCOAI5p7TH6lu2N58TJ8WFH3DMvoJZ6GGyDBdOQ50ZjbsDZn8cu3XMIk92JQN+Q7o2iKKSHibtB5XxXLsu/Vvc09bsFi0ALdggCDA6rqR/3wbOlo6Eudg2y0p3KywafwO2FppRtPIN6Px//1kJHj/zdmpZlzstVIKjac80BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RnKen+WO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RnKen+WO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69202C113CC;
	Mon,  6 May 2024 00:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957106;
	bh=DnJR65NBj4Nrud89b+6Nu6HT0p3Hg92hEDgtzmMg8vs=;
	h=Date:To:From:Subject:From;
	b=RnKen+WOH4y3f200UQSXOTawFj2oqapakBUUUt9Kn9fivSZxmLkRYBSIQw7sIXuVV
	 SAbQz6pNsPYl2+D8U6xcwHeTfX3qa/CAer1ltO+4rYEDTPxachafSvqRXgp+F83ES1
	 EGeiJMSAdsdH6y614WdjQjFTdq336+MXKyDXsB7Y=
Date: Sun, 05 May 2024 17:58:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-pagereferenced.patch removed from -mm tree
Message-Id: <20240506005826.69202C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove PageReferenced
has been removed from the -mm tree.  Its filename was
     mm-remove-pagereferenced.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove PageReferenced
Date: Wed, 24 Apr 2024 20:19:12 +0100

All callers now use folio_*_referenced() so we can remove the
PageReferenced family of functions.

Link: https://lkml.kernel.org/r/20240424191914.361554-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/page-flags.h~mm-remove-pagereferenced
+++ a/include/linux/page-flags.h
@@ -512,9 +512,9 @@ static inline int TestClearPage##uname(s
 __PAGEFLAG(Locked, locked, PF_NO_TAIL)
 FOLIO_FLAG(waiters, FOLIO_HEAD_PAGE)
 PAGEFLAG(Error, error, PF_NO_TAIL) TESTCLEARFLAG(Error, error, PF_NO_TAIL)
-PAGEFLAG(Referenced, referenced, PF_HEAD)
-	TESTCLEARFLAG(Referenced, referenced, PF_HEAD)
-	__SETPAGEFLAG(Referenced, referenced, PF_HEAD)
+FOLIO_FLAG(referenced, FOLIO_HEAD_PAGE)
+	FOLIO_TEST_CLEAR_FLAG(referenced, FOLIO_HEAD_PAGE)
+	__FOLIO_SET_FLAG(referenced, FOLIO_HEAD_PAGE)
 PAGEFLAG(Dirty, dirty, PF_HEAD) TESTSCFLAG(Dirty, dirty, PF_HEAD)
 	__CLEARPAGEFLAG(Dirty, dirty, PF_HEAD)
 PAGEFLAG(LRU, lru, PF_HEAD) __CLEARPAGEFLAG(LRU, lru, PF_HEAD)
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

