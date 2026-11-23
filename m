Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415087;
	b=K/NxM/j2x0JvNVCdY3aIeSa3pcihO81Iz+DN4hzmVeADyQV9el6F+WHyvumS83oWT9rE
	 qU4DcMoVw84wzUwZG6fjwW2HB8V/gfmotFxy+L126gvHESE7bJyuVMlYh+apaEs/n8JAU
	 /u5TuiPROH/6Drplu7vEiIaj5RaLKz6tfrqGjjNRrHhCtFrSVrLSHKJwDTLN+wOnLi/yi
	 /ZaQD85iJv7XHRr4/A4Hh/ie4GBO28utGjXlTAqiNNxIhW5bUr9teGoHSperhis1gzq3p
	 AuhWLGgHAwNC+dkqv+AFOlbrEkrgaBUCWdW92NzPBrk1JNZnMcKVmofRkKjPqUkX27Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415087;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=v2CappKqoYhJFHQ/D3OMVQHBKbFlGrWQrj/zg4N/UPE=;
	b=LUlhUiVp/+CwCXJCnVriKuXgtpaDjQHmDPpec/01e0FNXI9DwTWWVHvDf3wxQHsSRYCK
	 BzDOrlrcR9SZL3SKYi+NDqCUCTati+CIOB5rr0YJO4auAVLiHsyjmazGG0Pom6YI64UmY
	 8oS1l4gqUVslnZtso69W3NyksUiyXNCjvuK8kcMO1Qv6jkTYiViCz5AECi4bP4KTnq19W
	 AQiZ/UsbgcN23aEFwep9Tbl7k+eE31mGMKePBNSOBa6Hx0QTXIZEaf6yXWMRqacuE64GM
	 reQf1yoTAwq0igX20r7PAspdauvNQbMyqHvxLMtx5o8WBMXrGRqfTc5C+LpZ3vam7Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=A96R67ZI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308B4606A31E;
	Mon, 23 Nov 2026 06:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=A96R67ZI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310EB1F000C0;
	Mon, 23 Nov 2026 06:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795415086;
	bh=v2CappKqoYhJFHQ/D3OMVQHBKbFlGrWQrj/zg4N/UPE=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=A96R67ZIjp7nXkoqgbpXNtw5X+atz2Am2gu0T6BOSvwK8pHt8WWtfWhKtxP1JDban
	 h7ostRg2nh8EIGUJaXYnWFf5xDg+nRUrnuwVFtw44TQfEPMaHsB2yVr3TWckxHbqmU
	 wSTeTLjnQSDg+IIRpWAgxcH6oMXdm0pTLArdBJ6Y=
Date: Sun, 22 Nov 2026 22:24:45 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,
	pfalcato@suse.de,kas@kernel.org,jack@suse.cz,dave.hansen@linux.intel.com,
	dennylin0707@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261104071002.49693-1-dennylin0707@gmail.com>
References: <20261104071002.49693-1-dennylin0707@gmail.com>
Subject: [merged mm-hotfixes-stable] filemap-prefault-writes-starting-beyond-eof.patch removed from -mm tree
Message-Id: <20261123062446.310EB1F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: filemap: prefault writes starting beyond EOF
has been removed from the -mm tree.  Its filename was
     filemap-prefault-writes-starting-beyond-eof.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hungyu Lin <dennylin0707@gmail.com>
Subject: filemap: prefault writes starting beyond EOF
Date: Wed, 04 Nov 2026 07:10:02 +0000

Since prefaulting moved to the slow write path, a buffered write can reach
->write_begin() and ->write_end() before discovering that its source
buffer is unreadable.  Several filesystems can extend i_size in these
callbacks even when no data was copied.  For example, a one-byte pwrite()
at offset 4096 into an empty file can fail with EFAULT but leave a
4096-byte file.

Prefault the source before ->write_begin() when the write position is
beyond EOF, and return EFAULT if no source bytes can be made readable. 
Overwrites and appends continue to skip this prefault.  Keep the existing
slow-path faulting for forward progress after a failed atomic copy.

This also leaves intentional zero-length ->write_end() calls used by
generic_cont_expand_simple() unchanged.  As with the previous prefaulting
behavior, a concurrent userspace unmap can still race with the later copy.

Link: https://patch.msgid.link/20261104071002.49693-1-dennylin0707@gmail.com
Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Link: https://lore.kernel.org/all/at-XtWBQg3jv3H8Z@thinkstation/
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>

 mm/filemap.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/filemap.c~filemap-prefault-writes-starting-beyond-eof
+++ a/mm/filemap.c
@@ -4404,6 +4404,16 @@ retry:
 			break;
 		}
 
+		/*
+		 * Some filesystems can extend i_size even when nothing was copied.
+		 * Prefault writes beyond EOF to catch unreadable source buffers.
+		 */
+		if (unlikely(pos > i_size_read(mapping->host)) &&
+		    fault_in_iov_iter_readable(i, bytes) == bytes) {
+			status = -EFAULT;
+			break;
+		}
+
 		status = a_ops->write_begin(iocb, mapping, pos, bytes,
 						&folio, &fsdata);
 		if (unlikely(status < 0))
_

Patches currently in -mm which might be from dennylin0707@gmail.com are

mm-page-writeback-avoid-overflow-when-reporting-bdi-byte-limits.patch
mm-skip-empty-finite-ranges-in-truncate_pagecache_range.patch
hugetlbfs-report-inode-limits-without-a-memory-subpool.patch
delayacct-preserve-delay-extrema-when-aggregating-taskstats.patch
shmem-clamp-negative-used-block-samples-in-statfs.patch

