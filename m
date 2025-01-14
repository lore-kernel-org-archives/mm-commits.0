Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C704C23D3CA
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837069; cv=none; b=muQC3SwfrhsFI/BeEmtX8wHmxPTUWxjGBwSsL9Flmw7FrIzS3erD9hSjF1iElmUdXpzgmzv90oi3u9opey/Az+vkhvU7/y2phpAFT6RfraNAiRlIwZdCaUMorKCKZRYzaNzsrdpDt5QriZJGC7FuUSZpa3KfTsiGOgeHp2JG0Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837069; c=relaxed/simple;
	bh=qp4+0JRmluboI8VoJ8dPZ5yOBYRZSOmNEz82825IuOA=;
	h=Date:To:From:Subject:Message-Id; b=LNVQV8Z1gXl2b/oLgpytuslHRFm3cxJ5/rVlNMPl03QiBsI6MwYz2lodI+2GefHLAQXTJdJd/81SrQ2j8iFdRCCAfnqbbSjbELuiZ0bojWvxHLjI2UT4g0ETZNfh3j4C4Oj9JPu3d1tP9ObDrMAEgZeCUAkEweINjQCOTtmvtOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=waM7dug9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="waM7dug9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BE1C4CEDF;
	Tue, 14 Jan 2025 06:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837069;
	bh=qp4+0JRmluboI8VoJ8dPZ5yOBYRZSOmNEz82825IuOA=;
	h=Date:To:From:Subject:From;
	b=waM7dug9r99bsy5r32q0uxqzNaD5VMJIzrT7oASPSjpNuATz6apCSHf6wYgO1uvX6
	 XMc0E0pmUhPNdcerpUnzKGWyEE3TAxNZiDpjXR/RYdSaCCO+gIHFAiehgJ3+jASKfN
	 w2lXbM2G9QJo2NGY46wKDF7VBjfhZ5xdNs0TSaQQ=
Date: Mon, 13 Jan 2025 22:44:29 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@Oracle.com,jannh@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch removed from -mm tree
Message-Id: <20250114064429.92BE1C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: assert mmap write lock held on do_mmap(), mmap_region()
has been removed from the -mm tree.  Its filename was
     mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: assert mmap write lock held on do_mmap(), mmap_region()
Date: Thu, 12 Dec 2024 11:48:41 +0000

Both of these functions can be invoked outside of mm, so it is probably a
good idea to assert that the required lock is held.

Will only have an impact if CONFIG_DEBUG_VM is set, otherwise this amounts
to no change at all.

Link: https://lkml.kernel.org/r/20241212114841.55185-1-lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/mmap.c~mm-assert-mmap-write-lock-held-on-do_mmap-mmap_region
+++ a/mm/mmap.c
@@ -291,6 +291,8 @@ unsigned long do_mmap(struct file *file,
 
 	*populate = 0;
 
+	mmap_assert_write_locked(mm);
+
 	if (!len)
 		return -EINVAL;
 
@@ -1023,6 +1025,8 @@ unsigned long mmap_region(struct file *f
 	unsigned long ret;
 	bool writable_file_mapping = false;
 
+	mmap_assert_write_locked(current->mm);
+
 	/* Check to see if MDWE is applicable. */
 	if (map_deny_write_exec(vm_flags, vm_flags))
 		return -EACCES;
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mips-vdso-prefer-do_mmap-to-mmap_region.patch
mm-make-mmap_region-internal.patch

