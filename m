Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28793D8122
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 16:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791907707; cv=none; b=GwlzVE31/8OE29QP3qETs0fVN/wL+BcPRw/Y6en8xGQNBJpmFeFgMV4CF5neig3zOmtzB7GHmoFPN9i07OpX+hz74urWX43IttvES/8bTU59T6doNw8FoQgB9AoGKBqrmSVRn7EZcNzvZn7ylTuEvsiQrOEKqRIPpdJf0N/PgNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791907707; c=relaxed/simple;
	bh=PwJii4JIVRzJZJNtX4i2cLPOSEq8tHaohHiq65AWe98=;
	h=Date:To:From:Subject:Message-Id; b=iWolaTxBkTnvsxxyS1KRQ5Ah0eHCCRABzEi8TuFk/C2vROu+Zap2Ycdte7zGwbUmtZ+6uxl4WmTe2bPBmmaFiNUkhYcFyPkJBax8o2F/M3IGp/cEFOtQe234Sof9CRmscqUdrTNFKtHSIbPk2KlSYSW3464gXNorVKy9+PeK5Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bfhaeDQ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bfhaeDQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BC81F000FF;
	Tue, 13 Oct 2026 16:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791907706;
	bh=wfzCMaRYcN1+l5IIS9H81IL8UF52MFNioH6W2qaGEX8=;
	h=Date:To:From:Subject;
	b=bfhaeDQ665MyUvV0B5trFsLqZaK5EQ5vpEau9iejux+sc1bo+34FJzyLYbK4+jD/P
	 oKYN6nJNZYr0lkJzAG+BefYM8+OAO+qi2HOK07BpESXjGhBMdM5VxxYm84vyi3adwN
	 9ZXR/vaohrFat5HvBxCqytlZeA+ZnSlHx1NXECMM=
Date: Tue, 13 Oct 2026 09:08:25 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,blum@kernel.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kstrtox-use-isdigit-in-_parse_integer_limit.patch added to mm-nonmm-unstable branch
Message-Id: <20261013160826.40BC81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: kstrtox: use isdigit() in _parse_integer_limit()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-kstrtox-use-isdigit-in-_parse_integer_limit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kstrtox-use-isdigit-in-_parse_integer_limit.patch

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
From: Thorsten Blum <blum@kernel.org>
Subject: lib: kstrtox: use isdigit() in _parse_integer_limit()
Date: Tue, 13 Oct 2026 09:21:10 +0200

Use isdigit() to replace the open-coded implementation.

Link: https://lore.kernel.org/20261013072108.4407-3-blum@kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kstrtox.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/kstrtox.c~lib-kstrtox-use-isdigit-in-_parse_integer_limit
+++ a/lib/kstrtox.c
@@ -69,7 +69,7 @@ unsigned int _parse_integer_limit(const
 		unsigned int lc = _tolower(c);
 		unsigned int val;
 
-		if ('0' <= c && c <= '9')
+		if (isdigit(c))
 			val = c - '0';
 		else if ('a' <= lc && lc <= 'f')
 			val = lc - 'a' + 10;
_

Patches currently in -mm which might be from blum@kernel.org are

lib-kstrtox-use-isdigit-in-_parse_integer_limit.patch

