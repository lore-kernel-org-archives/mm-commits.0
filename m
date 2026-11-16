Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794814041;
	b=ghEU2NW8pwD1I1kBG+W1vOnUgSOW97LnvjrmASha9UF/uAqfvO7mGJMuPMGuNJsiZj/e
	 +k0A5RNZC7jj+E1zAxnLSgNVYO1OYwq6/eoVbKHfTzsG6qAIiChEMqeLYdJXP8MRoZCiM
	 s84vGHlyGpddRZ9KVkbIHQqa7PvQp4hKVJZoKRsbc0105faF8ghih3o8mxGQxXt+Ya0Sb
	 wVmbkVq5U8TIuUXvrS3XdYWawBaoXPDlPDbyPOz3ndqEdjxvWdVo8Uj/ahaYSyCqKM2ZO
	 qTxivxvcgr8lELUsK1VyH0xFy1MTE4xe3g/XdWd3OT2fY5NkSoy28RIFxYBzUOYA7BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794814041;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=WEPNM/t0OaqQkqsknBLcwS9bm6be+LeYjLS7sBoaVzQ=;
	b=zsBsiE7c0NobcJE/0aUTx4OY9zSYrvIAk0GnizB9lO3WsvCUG+qWfp0O509PXGmtKAgx
	 d27oEP7qCS9L25UAHFGSyvmHbU1D0iQmfr0A4TXL59kJ9m5uftPaum7z4KBtPHwGHHS2U
	 ipFQqjJyA5r6zn3au4qvD1LKDxjphZqR5yO0PNP14oHjtUk83S08mT4XFoGN9wPHseQh/
	 eOC1gtjm5i4lmx+N6tHF+bgRolKAjWqWkDTWHD7y07CgUPaw5Ut/1Ra47e8f7QTn7Vczq
	 8pDOEqY5pVSPUk+64wmClB/kcUfMbE9gK2s9Qh3+HdDIHI4fTCG3OgeZaEzecNseA2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IeGnuxNi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE823606A323
	for <mm-commits@vger.kernel.org>; Mon, 16 Nov 2026 07:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IeGnuxNi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F431F000C4;
	Mon, 16 Nov 2026 07:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794814041;
	bh=WEPNM/t0OaqQkqsknBLcwS9bm6be+LeYjLS7sBoaVzQ=;
	h=Date:To:From:Subject;
	b=IeGnuxNiB2IQ62h/dgHS+5jJArHoolJhkzgTmZeoi96SwTz2VQ8a9W+Yr2tUv+3tt
	 yPbrM1jqMuiLcvzAFDNSKJToqGGadXuwQMEweo4hrb2O/gq2uJxOgscWK9DWnfqWZ4
	 AM34rxHF8yz9od1N0QNbKpgCe6JHXncL5isHShZg=
Date: Sun, 15 Nov 2026 23:27:20 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	phillip.lougher@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-sanity-check-directory-metadata-block-location-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20261116072721.22F431F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: squashfs-sanity-check-directory-metadata-block-location-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-sanity-check-directory-metadata-block-location-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-sanity-check-directory-metadata-block-location-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-sanity-check-directory-metadata-block-location-fix
Date: Sun Nov 15 11:23:18 PM PST 2026

squashfs_lookup() stores squashfs_dir_start() in a u64 then checks block <
0.  That check cannot detect its negative error returns; block needs a
signed type.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>

 fs/squashfs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/namei.c~squashfs-sanity-check-directory-metadata-block-location-fix
+++ a/fs/squashfs/namei.c
@@ -138,7 +138,7 @@ static struct dentry *squashfs_lookup(st
 
 	TRACE("Entered squashfs_lookup [%llx:%x]\n", squashfs_i(dir)->start, offset);
 
-	if (block < 0)
+	if ((s64)block < 0)
 		goto data_error;
 
 	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-list_lru-dont-use-a-new-memcgs-lists-for-an-offline-memcg-fix.patch
shmem-consume-the-reserved-xattr-space-despite-remount.patch
selftests-mm-check-madv_cold-and-madv_pageout-on-partly-advised-thps-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix-fix.patch
alloc_tag-introduce-ioctls-to-toggle-allocation-tracepoints-fix.patch
selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix.patch
selftests-mm-allocate-nr_pages-based-on-pmd-size-for-uffd-pmd_move-tests-fix.patch
selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds.patch
lib-test_xarray-check-unused-spare-node-after-range-creation.patch
profile-account-for-partial-proc-profile-reads.patch
profile-simplify-proc-profile-read-layout.patch
ipc-msg-clamp-negative-msg_info-usage-counts.patch
squashfs-fix-leaked-page-locks-when-page-actor-allocation-fails-fix.patch
squashfs-sanity-check-directory-metadata-block-location-fix.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix.patch
ocfs2-skip-network-flush-when-no-domain-handlers-are-registered.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

