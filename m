Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794262668;
	b=08+WeC0G/lOYw8YkIKi3bYQsbhO+P5hMEgSzxcV27eVLmNGTB5bpEv4WicxDuWaEJazp
	 Fct6N5VkKotXtQTi0D9B8yQHHOrVWSgRdbTr30O9eyysS+yq5iBffAKoT2PpcjVcArKMx
	 FwZVcozAgA/DikWyFuxTLTAxCZTRDUKf3bewnfBI/S3oSfQj0/Ns7K5iI40mTyFqt1CsU
	 bIlUqKrAh7yts/XzG/bql6hFi8o067gLd0cs5ONfNvwGgOHzK4wiubogAlIpmjI2kgP/g
	 ugycdmOjjrrpTIMHVfE1HEMtiiWpqSytopWn9R/LG1UVOqryvBI5vQ3y1OyPdb6FKNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794262668;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=7e8QoEp4/GYJQs8vWI8rkLnzzIcnq/HTu+WfPbWgp6s=;
	b=CayOT+U/j38j/ZN5eXe18dAYtZ3X80ubFEAPyxqZQKm97fowV4Er/x1UKhibDwtJEgkw
	 nWc0hQDE/wRTABQTJoqak6FmMuTzX8p4PbZb08+0JmpzhhBSX4ni0fgF2xX/vGW6aU3/D
	 A1uNt7lL+IQnsmXRu8YbwbeLeIiKjqbhElQUhAZLSe+B9zcdPA0u4nxO9NJnApp4AUE3k
	 t7I5C/atDO0/zPop1T/wicNdP+s6LFJ7UZc9Zh51HRvz6zmuYgnkVOHC87izFrlNcwD2l
	 p4EyCg128AqX+3wvRjsHiLNEYxIbewO+7Eb9er7OY1Ecop1L1HYffChIoX8zVivusjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="pg1d/EkD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F045606A31C;
	Mon,  9 Nov 2026 22:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pg1d/EkD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1295F1F0089F;
	Mon,  9 Nov 2026 22:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794262667;
	bh=7e8QoEp4/GYJQs8vWI8rkLnzzIcnq/HTu+WfPbWgp6s=;
	h=Date:To:From:Subject;
	b=pg1d/EkDwO1u3BFW2l9dy7hqOgEWOlN6oa348DqHrwQQFz5by3UoaverDFgwpXy4P
	 P7nj6x69HNExOGkoKLAyhwRF3ZqXK0uWtR+tjf7tm6+51pzs5sBVRqpEpkP69nDygg
	 q4zKuAB0vQW/xrzeSj4KmQcegswivDnv2wLI64T4=
Date: Mon, 09 Nov 2026 14:17:46 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,stable@vger.kernel.org,
	pfalcato@suse.de,kas@kernel.org,jack@suse.cz,dave.hansen@linux.intel.com,
	dennylin0707@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-prefault-writes-starting-beyond-eof.patch added to mm-hotfixes-unstable branch
Message-Id: <20261109221747.1295F1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: filemap: prefault writes starting beyond EOF
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     filemap-prefault-writes-starting-beyond-eof.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-prefault-writes-starting-beyond-eof.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

Link: https://lore.kernel.org/20261104071002.49693-1-dennylin0707@gmail.com
Fixes: 665575cff098 ("filemap: move prefaulting out of hot write path")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Link: https://lore.kernel.org/all/at-XtWBQg3jv3H8Z@thinkstation/
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>.
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: <stable@vger.kernel.org>
---

 mm/filemap.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/filemap.c~filemap-prefault-writes-starting-beyond-eof
+++ a/mm/filemap.c
@@ -4396,6 +4396,16 @@ retry:
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

filemap-prefault-writes-starting-beyond-eof.patch
mm-page-writeback-avoid-overflow-when-reporting-bdi-byte-limits.patch
mm-skip-empty-finite-ranges-in-truncate_pagecache_range.patch
delayacct-preserve-delay-extrema-when-aggregating-taskstats.patch
shmem-clamp-negative-used-block-samples-in-statfs.patch

