Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E195F313283
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282377; cv=none; b=qFszQz3GxYJa5SbNClczQScypxTO8RP99mk/moj7O9/F2VB9jv+KXVJWmU/52QaXM5UhxEWsTVo4FmlJSVDXLtyraalV54VkObjTi1FAAWqZo40HYx+dA++d/oJsTqfpdV4odfAUYHHR106xHCiRwfdSuzTXdFBFUqjOp8ZLiuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282377; c=relaxed/simple;
	bh=ozkVneUcvL2yF2PSFuRfq/zUimTEisz0tJbaXSOAIHM=;
	h=Date:To:From:Subject:Message-Id; b=htb6mGrcqMjE8y2JDtpuFBb6pKQxY4mThed3cRGogQw/1nflgfBI8g1xq0xyCPcATrpV6oPb3JQUWdNcos6wRW+SwML0KYUamCy+Qj71mYafZFwzGTZjzzVjen5LZNJoA9ipez0qCrJa2/FdGRcmgGQtXwFLEQZJKdLkF/kimCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VcEhq8i0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VcEhq8i0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62718C4CEF8;
	Thu, 27 Nov 2025 22:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282376;
	bh=ozkVneUcvL2yF2PSFuRfq/zUimTEisz0tJbaXSOAIHM=;
	h=Date:To:From:Subject:From;
	b=VcEhq8i0e6sHPFQvX8v5BHv2UgJEeUsMVsxSxXpNvp5qStlKpCyiSOprErOu18QOu
	 P0B+en/aCVqWv7qoe3dwQGXFomndbRjx+/1nJuJvpE2cRalE4ebQjvOMHzGs2eoeSm
	 rgy/dc4m6ID/lgQlTXbZ4ZYQUxWsbiURGjk74b2M=
Date: Thu, 27 Nov 2025 14:26:15 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-preserve-fdt-folio-only-once-during-initialization.patch removed from -mm tree
Message-Id: <20251127222616.62718C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: preserve FDT folio only once during initialization
has been removed from the -mm tree.  Its filename was
     kho-preserve-fdt-folio-only-once-during-initialization.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: preserve FDT folio only once during initialization
Date: Fri, 14 Nov 2025 13:59:53 -0500

Currently, the FDT folio is preserved inside __kho_finalize().  If the
user performs multiple finalize/abort cycles, kho_preserve_folio() is
called repeatedly for the same FDT folio.

Since the FDT folio is allocated once during kho_init(), it should be
marked for preservation at the same time.  Move the preservation call to
kho_init() to align the preservation state with the object's lifecycle and
simplify the finalize path.

Also, pre-zero the FDT tree so we do not expose random bits to the user
and to the next kernel by using the new kho_alloc_preserve() api.

Link: https://lkml.kernel.org/r/20251114190002.3311679-5-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-preserve-fdt-folio-only-once-during-initialization
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1251,10 +1251,6 @@ static int __kho_finalize(void)
 	if (err)
 		goto abort;
 
-	err = kho_preserve_folio(virt_to_folio(kho_out.fdt));
-	if (err)
-		goto abort;
-
 	err = kho_mem_serialize(&kho_out);
 	if (err)
 		goto abort;
@@ -1384,19 +1380,17 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
 static __init int kho_init(void)
 {
-	int err = 0;
 	const void *fdt = kho_get_fdt();
-	struct page *fdt_page;
+	int err = 0;
 
 	if (!kho_enable)
 		return 0;
 
-	fdt_page = alloc_page(GFP_KERNEL);
-	if (!fdt_page) {
-		err = -ENOMEM;
+	kho_out.fdt = kho_alloc_preserve(PAGE_SIZE);
+	if (IS_ERR(kho_out.fdt)) {
+		err = PTR_ERR(kho_out.fdt);
 		goto err_free_scratch;
 	}
-	kho_out.fdt = page_to_virt(fdt_page);
 
 	err = kho_debugfs_init();
 	if (err)
@@ -1424,9 +1418,9 @@ static __init int kho_init(void)
 	return 0;
 
 err_free_fdt:
-	put_page(fdt_page);
-	kho_out.fdt = NULL;
+	kho_unpreserve_free(kho_out.fdt);
 err_free_scratch:
+	kho_out.fdt = NULL;
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		void *start = __va(kho_scratch[i].addr);
 		void *end = start + kho_scratch[i].size;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

