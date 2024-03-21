Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D01136984
	for <mm-commits@vger.kernel.org>; Thu, 21 Mar 2024 22:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711060181; cv=none; b=TOMvriiAlBhR3DYRIF5fuV9mEkgsra41GE4rPXMIY0KldU3z7WRYUCyJ9ItU/dSvtO5fBqoVaVYX7S+FXaK2EKZcmtPb9FRjDMB/QoSRlll26XE+EbwBb0GwwFZ/1aSrxhl1czeicfBFBBoCigiB0XnyVuu90jb9Zdrp3aBawso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711060181; c=relaxed/simple;
	bh=6tv9idRDm8Y9fpw0A+RRWp6lKrSDNWx7mYdn3YHFBEk=;
	h=Date:To:From:Subject:Message-Id; b=l68HspgQcnpzGFsOrc3e2/DzQU4hmLQt3xuDnSvFdxYqW1xFVqhw/tzYyD4kD0zk0iSkknsWsSHyjnX6duo/gcLKoZG2GQvvoD/G5DGLmTRM2zrwjiZUwKIpdn7IQ/vuZQGYRyK6y+lBkuu1HD9nVPv4y/TEJ0BiSO0+v8lBCx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uDuREgPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uDuREgPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9701EC433F1;
	Thu, 21 Mar 2024 22:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711060180;
	bh=6tv9idRDm8Y9fpw0A+RRWp6lKrSDNWx7mYdn3YHFBEk=;
	h=Date:To:From:Subject:From;
	b=uDuREgPAsRZhg3v6zTRilrrqk82jF4JDF7L4/iOrpzhAVyCcXKDkSzf8M2DQBezsH
	 75EmE6ta7Fl9fclLMb0pzmiTLB5CdISBVKpq0hGZXI3Ob2l7Pf/QCz77pB8eisc2U8
	 0T5T20FzD8EEdkxL9QWH1ijZaeG0LNK9fJMWF3eA=
Date: Thu, 21 Mar 2024 15:29:40 -0700
To: mm-commits@vger.kernel.org,jiat0218@gmail.com,lasse.collin@tukaani.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xz-cleanup-crc32-edits-from-2018.patch added to mm-nonmm-unstable branch
Message-Id: <20240321222940.9701EC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xz: cleanup CRC32 edits from 2018
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xz-cleanup-crc32-edits-from-2018.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xz-cleanup-crc32-edits-from-2018.patch

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
From: Lasse Collin <lasse.collin@tukaani.org>
Subject: xz: cleanup CRC32 edits from 2018
Date: Wed, 20 Mar 2024 20:38:39 +0200

The commit faa16bc404d72a5a ("lib: Use existing define with polynomial")
in 2018 added a dependency on <linux/crc32poly.h> to avoid duplicating the
same constant in multiple files.  Two months later it was found to be a
bad idea and the commit 242cdad873a75652 ("lib/xz: Put CRC32_POLY_LE in
xz_private.h") added the definition of CRC32_POLY_LE macro into
xz_private.h to avoid including <linux/crc32poly.h>.

xz_private.h is a wrong place for it too.  Revert back to the upstream
version which has the poly in xz_crc32_init() in xz_crc32.c.

Link: https://lkml.kernel.org/r/20240320183846.19475-7-lasse.collin@tukaani.org
Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Reviewed-by: Jia Tan <jiat0218@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/xz/xz_crc32.c   |    2 +-
 lib/xz/xz_private.h |    4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

--- a/lib/xz/xz_crc32.c~xz-cleanup-crc32-edits-from-2018
+++ a/lib/xz/xz_crc32.c
@@ -28,7 +28,7 @@ STATIC_RW_DATA uint32_t xz_crc32_table[2
 
 XZ_EXTERN void xz_crc32_init(void)
 {
-	const uint32_t poly = CRC32_POLY_LE;
+	const uint32_t poly = 0xEDB88320;
 
 	uint32_t i;
 	uint32_t j;
--- a/lib/xz/xz_private.h~xz-cleanup-crc32-edits-from-2018
+++ a/lib/xz/xz_private.h
@@ -104,10 +104,6 @@
 #	endif
 #endif
 
-#ifndef CRC32_POLY_LE
-#define CRC32_POLY_LE 0xedb88320
-#endif
-
 /*
  * Allocate memory for LZMA2 decoder. xz_dec_lzma2_reset() must be used
  * before calling xz_dec_lzma2_run().
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

maintainers-add-xz-embedded-maintainers.patch
licenses-add-0bsd-license-text.patch
xz-switch-from-public-domain-to-bsd-zero-clause-license-0bsd.patch
xz-documentation-staging-xzrst-revise-thoroughly.patch
xz-fix-comments-and-coding-style.patch
xz-cleanup-crc32-edits-from-2018.patch
xz-optimize-for-loop-conditions-in-the-bcj-decoders.patch
xz-add-arm64-bcj-filter.patch
xz-add-risc-v-bcj-filter.patch
xz-use-128-mib-dictionary-and-force-single-threaded-mode.patch
xz-adjust-arch-specific-options-for-better-kernel-compression.patch

