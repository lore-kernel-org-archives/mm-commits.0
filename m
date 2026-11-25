Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795586074;
	b=gn0XD5AFOyE2feRFD2b412ooE3MEx4ZySLrKOVRPdtRDm6w1VNnu6zvWOOq65WRhMPiR
	 f0zgpEyit+vAOGHRLiTfg+1soNoRkdSXQTuDIodfr0k9vssgH0Oy+ONBOoBDusdSzn1Hm
	 GtO/JD8iqZnQ95jDnteX3ah0/CO0rl1iOym38/T3htkw0DDOD9BH06DsxWalffMkfO7GW
	 qDzuY0VKwZylGNTcgyiI/x8eEZpjcTRDC9nGqdjaVz04ZOTzCU/nueLWucH5RD1OAUrRz
	 YuNmM2v2u89GJuwo+ALAVhz2u59Bo8wV107w6CpzLMcfVkXUsbQsOeygOSaMrHSTfQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795586074;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=8uUH/IcAJItOE2bjBRRwr465x1O4fBWdjJfQl0DUOkw=;
	b=FFwoyglJz5BQDUJVg9nVLUKlZSMXygL0FHbQ6Xk3fSu/MpmJhoBHymhl9jPv+PquCKOF
	 pOlMJOhLNyHCLi9BCrjj99Awv6d0XbKE5IhByIsEhUrz58qi5Ee5kASeowa6FuJm6bNIl
	 aSXEUJ9UlxOKMP5bV1h/WXPFX/yacPp1wKfqvLmOQD27f1t2XZtWqiLNu7tvqwQM1sV02
	 jm00t2Z+pvU/yY4CGgAlMtBnDIsPiOLCVojLSToXjiTdgxmL6M/aWvwWyG0F1oA/d09BH
	 PgT49U4+VZT9nBNp8wMmkKqVKeFK9G6nrzft6yKerqYnNAq0pItj90rbRuy1tkruC+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=u6eygU+e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AC7606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=u6eygU+e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CAE1F000D8;
	Wed, 25 Nov 2026 05:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795586073;
	bh=8uUH/IcAJItOE2bjBRRwr465x1O4fBWdjJfQl0DUOkw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=u6eygU+e4HCXswJj5cuj9OukmbfDe7QyQRYO0gsGG2bjeCkct+tXDpOENMcJCh0QH
	 aNoL49p9/xlf1mhv8WSZlHJkll/qRJZYSFV6PsEdKe6+K0YjxnrGDU60Jf3dL3r2Vk
	 Z0+0P0Enr7nPZG0oFfmMC0SArTI/1l9orw49hBTk=
Date: Tue, 24 Nov 2026 21:54:33 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125014737.347231-24-phillip@squashfs.org.uk>
References: <20261125014737.347231-24-phillip@squashfs.org.uk>
Subject: + squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch added to mm-nonmm-unstable branch
Message-Id: <20261125055433.A0CAE1F000D8@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: check index isn't greater than S64_MAX in squashfs_read_data()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch

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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: check index isn't greater than S64_MAX in squashfs_read_data()
Date: Wed, 25 Nov 2026 01:47:37 +0000

The previous commits in this patch-set now sanity check index before
squashfs_read_data() is called.  However, it is always wise to take
a belts and braces approach and sanity check at the lowest level to
trap any values that could slip through.

Link: https://patch.msgid.link/20261125014737.347231-24-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 fs/squashfs/block.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/squashfs/block.c~squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data
+++ a/fs/squashfs/block.c
@@ -297,6 +297,15 @@ int squashfs_read_data(struct super_bloc
 	int res;
 	int offset;
 
+	/*
+	 * Reject index values greater than possible filesystem size (S64_MAX).
+	 * This also ensures the index variable doesn't overflow in the function.
+	 */
+	if (index > S64_MAX) {
+		res = -EIO;
+		goto out;
+	}
+
 	if (length) {
 		/*
 		 * Datablock.
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-convert-squashfs_compressed_-to-inline-functions.patch
squashfs-convert-squashfs_inode_-and-squashfs_mkinode-to-inline-functions.patch
squashfs-convert-squashfs_fragment_-to-inline-functions.patch
squashfs-convert-squashfs_lookup_-to-inline-functions.patch
squashfs-convert-squashfs_id_-to-inline-functions.patch
squashfs-convert-squashfs_xattr_-to-inline-functions.patch
squashfs-fix-offset-in-squashfs_read_inode-trace-statements.patch
squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index.patch
squashfs-fix-fragment-bytes-overflow-on-32-bit-architectures.patch
squashfs-fix-fragment-index-table-length-too-large-exploit.patch
squashfs-sanity-check-inode-metadata-block-location.patch
squashfs-sanity-check-directory-metadata-block-location.patch
squashfs-widen-xattr-count-variables-and-add-sanity-check.patch
squashfs-very-large-files-can-exceed-an-int-or-size_t.patch
squashfs-add-more-sanity-checking-to-squashfs_block_size.patch
squashfs-sanity-check-fragment-block-location-and-range.patch
squashfs-sanity-check-block-list-sizes-and-range.patch
squashfs-dont-store-large-export-table-indexes-in-memory.patch
squashfs-dont-store-large-fragment-table-indexes-in-memory.patch
squashfs-dont-store-large-xattr-id-table-indexes-in-memory.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks.patch
squashfs-fix-regression-in-squashfs_copy_cache.patch
squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch

