Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485D92576
	for <mm-commits@vger.kernel.org>; Sun, 29 Jun 2025 21:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751232690; cv=none; b=CUFxRSCASnmTr1jeTWC7GEXMew/QyGXn0+Jpkwvbc8vt8sw/BwFi96XQqXZPFRer0G2Y0w9YDCqlSkT2JfJcJaMo6ZXUWmbXpzAKpiHScJG0A/UesiQ3uRG4dN6ZDwfzacQsu5csPGrKRC2xNE1V4i5BG5xj4SoAvvQ18T/mJ1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751232690; c=relaxed/simple;
	bh=uWxJ496WC7hiRRFUJkwvJxd74Kz1AiljiowLH6KDmDk=;
	h=Date:To:From:Subject:Message-Id; b=PS1G78XMtcaB21v0d9BxRWvAeywKC7NkTFV46dXplPD3SF27d+Gg1vWiPaV1wUXkDubIQA+RH1iWioiKC/vsdPL2mLXH4+sDrrC3tyBf1nx7jglpOU5/zod+vtow+Er36fueSE1A0JYBGSpnarZUzHroOx/krNQBwGCSvizvB2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0CcDTsix; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0CcDTsix"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC34C4CEEB;
	Sun, 29 Jun 2025 21:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751232689;
	bh=uWxJ496WC7hiRRFUJkwvJxd74Kz1AiljiowLH6KDmDk=;
	h=Date:To:From:Subject:From;
	b=0CcDTsixHPsweVxLthkuVXv0IwAN9UIsejiSBlxKuwcaKxyPxeC3Xp+BRG7/uKR9J
	 mW23+OkPsQVbbaJrjd67WjMR+OvczD+gGjNPGXo4J85p2smusTR4MZTEUTC3vzxFzJ
	 R+NJ6uuGYrr0tRIOF+VCUUbshIVXKAAcrl28a6zs=
Date: Sun, 29 Jun 2025 14:31:29 -0700
To: mm-commits@vger.kernel.org,ojeda@kernel.org,nicolas@fjasle.eu,masahiroy@kernel.org,wen.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-headers_install-fix-a-false-positive.patch added to mm-nonmm-unstable branch
Message-Id: <20250629213129.BAC34C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts: headers_install: fix a false positive
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     scripts-headers_install-fix-a-false-positive.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-headers_install-fix-a-false-positive.patch

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
From: Wen Yang <wen.yang@linux.dev>
Subject: scripts: headers_install: fix a false positive
Date: Sun, 29 Jun 2025 23:52:07 +0800

The current implementation only handles C89 style comments (/*... */) in
the code, and there are false positives for C99 style comments (//...).

This patch fixes this issue.

Link: https://lkml.kernel.org/r/20250629155208.16174-1-wen.yang@linux.dev
Signed-off-by: Wen Yang <wen.yang@linux.dev>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/headers_install.sh |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/headers_install.sh~scripts-headers_install-fix-a-false-positive
+++ a/scripts/headers_install.sh
@@ -44,6 +44,7 @@ scripts/unifdef -U__KERNEL__ -D__EXPORTE
 # Remove /* ... */ style comments, and find CONFIG_ references in code
 configs=$(sed -e '
 :comment
+	s://.*::
 	s:/\*[^*][^*]*:/*:
 	s:/\*\*\**\([^/]\):/*\1:
 	t comment
_

Patches currently in -mm which might be from wen.yang@linux.dev are

scripts-headers_install-fix-a-false-positive.patch

