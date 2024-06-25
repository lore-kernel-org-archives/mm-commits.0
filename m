Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA35613D251
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291565; cv=none; b=JPY/EfvBIf7Auox2c5uyC0Iz0cGhT6jVUp4LN9iwOeceNREobqrRJNCTOOAxpNgwzuJHDiaPcAurNPANQr2PfHEx0Xilu9QfTis1c4gzdBcq4SnWHJMwSORAQFjsDX/AZGDX/TH1iarRphfR7FvyXxg8Mjw+22wwL7wLuuqiAjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291565; c=relaxed/simple;
	bh=CjfbKGlmxuXpBrnsSKE/5p1KSE3ofw8ZG/mnerqbOP4=;
	h=Date:To:From:Subject:Message-Id; b=dMXXy11ReSM8HxnxZaol6Utk543BBeW9q9bWF31SoxRkzB8P9O/QnSTGObkNFeP51Zk5gnxjafcgr29gicEEyrFG/vvaoSEaNSj2vyoWZfZlVY39dPoNLScI5vwp+fVTRV58LYiMn5NG5TbwcCrsEDFyMK670w6mVozcjtIhx/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GtAe8aML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GtAe8aML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75338C32782;
	Tue, 25 Jun 2024 04:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291565;
	bh=CjfbKGlmxuXpBrnsSKE/5p1KSE3ofw8ZG/mnerqbOP4=;
	h=Date:To:From:Subject:From;
	b=GtAe8aMLXWYViu8x5GeJuM0S4r+6HsfHwQv99CFkal4gViD/q+F6MaXmEVk6yVZMz
	 KJpDpASbjyuwa4qovyWoZfILKClQ+6J3CDdkdH2GQdsp+wY32o+J9qNoR4TQwkWPiX
	 isvIljw6c4nqVVbgfQ8rB4TVsMHyjF/CygW/7Dfs=
Date: Mon, 24 Jun 2024 21:59:24 -0700
To: mm-commits@vger.kernel.org,vdonnefort@google.com,dan.j.williams@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-move-page_count-check-into-validate_page_before_insert.patch removed from -mm tree
Message-Id: <20240625045925.75338C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: move page_count() check into validate_page_before_insert()
has been removed from the -mm tree.  Its filename was
     mm-memory-move-page_count-check-into-validate_page_before_insert.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: move page_count() check into validate_page_before_insert()
Date: Wed, 22 May 2024 14:57:11 +0200

Patch series "mm/memory: cleanly support zeropage in vm_insert_page*(),
vm_map_pages*() and vmf_insert_mixed()", v2.

There is interest in mapping zeropages via vm_insert_pages() [1] into
MAP_SHARED mappings.

For now, we only get zeropages in MAP_SHARED mappings via
vmf_insert_mixed() from FSDAX code, and I think it's a bit shaky in some
cases because we refcount the zeropage when mapping it but not necessarily
always when unmapping it ...  and we should actually never refcount it.

It's all a bit tricky, especially how zeropages in MAP_SHARED mappings
interact with GUP (FOLL_LONGTERM), mprotect(), write-faults and s390x
forbidding the shared zeropage (rewrite [2] s now upstream).

This series tries to take the careful approach of only allowing the
zeropage where it is likely safe to use (which should cover the existing
FSDAX use case and [1]), preventing that it could accidentally get mapped
writable during a write fault, mprotect() etc, and preventing issues with
FOLL_LONGTERM in the future with other users.

Tested with a patch from Vincent that uses the zeropage in context of
[1].

[1] https://lkml.kernel.org/r/20240430111354.637356-1-vdonnefort@google.com
[2] https://lkml.kernel.org/r/20240411161441.910170-1-david@redhat.com


This patch (of 3):

We'll now also cover the case where insert_page() is called from
__vm_insert_mixed(), which sounds like the right thing to do.

Link: https://lkml.kernel.org/r/20240522125713.775114-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-move-page_count-check-into-validate_page_before_insert
+++ a/mm/memory.c
@@ -1981,6 +1981,8 @@ static int validate_page_before_insert(s
 {
 	struct folio *folio = page_folio(page);
 
+	if (!folio_ref_count(folio))
+		return -EINVAL;
 	if (folio_test_anon(folio) || folio_test_slab(folio) ||
 	    page_has_type(page))
 		return -EINVAL;
@@ -2035,8 +2037,6 @@ static int insert_page_in_batch_locked(s
 {
 	int err;
 
-	if (!page_count(page))
-		return -EINVAL;
 	err = validate_page_before_insert(page);
 	if (err)
 		return err;
@@ -2170,8 +2170,6 @@ int vm_insert_page(struct vm_area_struct
 {
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
-	if (!page_count(page))
-		return -EINVAL;
 	if (!(vma->vm_flags & VM_MIXEDMAP)) {
 		BUG_ON(mmap_read_trylock(vma->vm_mm));
 		BUG_ON(vma->vm_flags & VM_PFNMAP);
_

Patches currently in -mm which might be from david@redhat.com are

mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-pass-meminit_context-to-__free_pages_core-fix-2.patch
mm-pass-meminit_context-to-__free_pages_core-fix-3.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch
mm-read-page_type-using-read_once.patch
mm-migrate-make-migrate_misplaced_folio-return-0-on-success.patch
mm-migrate-move-numa-hinting-fault-folio-isolation-checks-under-ptl.patch

