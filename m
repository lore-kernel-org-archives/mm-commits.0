Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB81B3B2FDF
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068106; cv=none; b=bEm3i2Tk5QUD/KlnNe/koJ8inqDcEKg4mW1D9gVwV0FAZvuglbCrbwd657/BWt6opfGWU6mSf3GTHBBk5h0oMKCqKFHWlLRQoFrEupon/sN3HdkEWlNGvVNq2VuxZqTkKldttoo19ajjoLY8td2Z7+Nboo+m+HDBBPsbU47ByoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068106; c=relaxed/simple;
	bh=7IFA68fzgPftEZbOK+BTcvHeWg7BfsFsZHnDsLp9QvA=;
	h=Date:To:From:Subject:Message-Id; b=SnBCf2tJve40PqfwExNRXTVzKw0rTGI2j2RtTFVGLyHYL9WrJInheOntiu3EZt8kvItKSM8B50pvx5gr+B4nKEMrLvZMNt3MLjdL4geJwKN12/Wqr1FIwRVVNG3G2NDc7jbuHPZFZx6B+JKh1oAeHgjWNDdqJg+rh7E82BYOtaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aAyB8EZ8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aAyB8EZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749CE1F00A3A;
	Fri,  7 Aug 2026 02:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068105;
	bh=pGXXpn6uN8/mBiVuterKA6nKQ4o1GZr5JZCQV6rFZ3o=;
	h=Date:To:From:Subject;
	b=aAyB8EZ8Rp/V8cfbn6YUS5vMwKcou6QNXfcXbRWA747Q3KZZHbJXDoVU4jqq8EXgM
	 tAkUtAxfSsnn2GMKqbcdfLUHS2WprX8m/jx9oub7Rv2ODm2UpF5ycMQuFW/AHXCpdn
	 YYd36odLC7RcAT6URWLwV8PP42k1MHxZsUF/xIzE=
Date: Thu, 06 Aug 2026 19:01:45 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,lihongfu@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch removed from -mm tree
Message-Id: <20260807020145.749CE1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix BUG_ON checking wrong variable in mremap_dontunmap
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: fix BUG_ON checking wrong variable in mremap_dontunmap
Date: Fri, 17 Jul 2026 15:02:51 +0800

In mremap_dontunmap_partial_mapping_overwrite(), mremap() stores its
returned remapped address into remapped_mapping, while the BUG_ON
incorrectly checks dest_mapping instead.

If mremap() fails, dest_mapping still holds a valid pointer obtained from
the prior mmap() call, making this BUG_ON never trigger at all.  Correct
the check to validate the actual mremap() return value stored in
remapped_mapping.

Link: https://lore.kernel.org/20260717070251.73212-1-hongfu.li@linux.dev
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mremap_dontunmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mremap_dontunmap.c~selftests-mm-fix-bug_on-checking-wrong-variable-in-mremap_dontunmap
+++ a/tools/testing/selftests/mm/mremap_dontunmap.c
@@ -313,7 +313,7 @@ static void mremap_dontunmap_partial_map
 	    mremap(source_mapping, 5 * page_size,
 		   5 * page_size,
 		   MREMAP_DONTUNMAP | MREMAP_MAYMOVE | MREMAP_FIXED, dest_mapping);
-	BUG_ON(dest_mapping == MAP_FAILED, "mremap");
+	BUG_ON(remapped_mapping == MAP_FAILED, "mremap");
 	BUG_ON(dest_mapping != remapped_mapping, "expected to remap to dest_mapping");
 
 	BUG_ON(check_region_contains_byte(source_mapping, 5 * page_size, 0) !=
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-swap-fix-swap_cluster_lock-config_swap-stub-signature-mismatch.patch
ksm-update-comments-and-docs-to-reference-folio-mapping.patch
mm-use-a-folio-in-the-softleaf_is_device_private-path.patch
selftests-mm-drop-duplicate-test_seal_mprotect_two_vma_with_gap-call.patch
selftests-prctl-fix-non-anonymous-vma-mapping-in-set-anon-vma-name-test.patch

