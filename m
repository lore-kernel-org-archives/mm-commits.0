Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BDD31ED64
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282380; cv=none; b=H9VdFGrALqnaoPp7LPdji/8AntyCqUHDsP/hRawXCkJFFByLQ9g8EWR4z4jbUGLBN22jzpmgwYVtPh4s9HKn0a7FyF6GuJWRwKOioo6MFPEkXmhWD0yTUR7njIlK/pNI/hT+Li2J2vNrdiIM46C2JkynFuWVQfN6tUYAdUx6dhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282380; c=relaxed/simple;
	bh=vWYQSQ2rrzunYJQCFMZHsrAUpKO7uwkLdgNf6FSKy/U=;
	h=Date:To:From:Subject:Message-Id; b=a3N7sFhjRolBLwPZ6r5VDTJqXB1oYNy8l5QVVUViaClDULcOvhhnTVEm6dpvHNtF5/ShjfYbIu//1iDeecEuzu3dR02TlJ/ednpUoa+Vpie3SGGrYP5Fj3HciH4QsRHncDlrH3MIrP997d63YGvrOeRR8m8YGoZQ+dzv4P/I118=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=m4KIhyPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="m4KIhyPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130AEC4CEF8;
	Thu, 27 Nov 2025 22:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282380;
	bh=vWYQSQ2rrzunYJQCFMZHsrAUpKO7uwkLdgNf6FSKy/U=;
	h=Date:To:From:Subject:From;
	b=m4KIhyPccgiRIt4wAJPYtkJW1w78KIKiR8fap0W2XkY8SaQ6wUQBzwRBvs0Z7ZmH+
	 4DZgv4vydTAQ4Uj8kFe87kJarqWwNW5YQVbg2ZKuJgi4tStXqVRvBkBhv7yjL59etc
	 GpRrmh0MY+PYHaTgOnDGqo3/JV9PnKwE9olC6nTs=
Date: Thu, 27 Nov 2025 14:26:19 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-simplify-serialization-and-remove-__kho_abort.patch removed from -mm tree
Message-Id: <20251127222620.130AEC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: simplify serialization and remove __kho_abort
has been removed from the -mm tree.  Its filename was
     kho-simplify-serialization-and-remove-__kho_abort.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: simplify serialization and remove __kho_abort
Date: Fri, 14 Nov 2025 13:59:56 -0500

Currently, __kho_finalize() performs memory serialization in the middle of
FDT construction.  If FDT construction fails later, the function must
manually clean up the serialized memory via __kho_abort().

Refactor __kho_finalize() to perform kho_mem_serialize() only after the
FDT has been successfully constructed and finished.  This reordering has
two benefits:
1. It avoids expensive serialization work if FDT generation fails.
2. It removes the need for cleanup in the FDT error path.

As a result, the internal helper __kho_abort() is no longer needed for
internal error handling.  Inline its remaining logic (cleanup of the
preserved memory map) directly into kho_abort() and remove the helper.

Link: https://lkml.kernel.org/r/20251114190002.3311679-8-pasha.tatashin@soleen.com
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

 kernel/liveupdate/kexec_handover.c |   41 +++++++++++----------------
 1 file changed, 17 insertions(+), 24 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-simplify-serialization-and-remove-__kho_abort
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1214,14 +1214,6 @@ void kho_restore_free(void *mem)
 }
 EXPORT_SYMBOL_GPL(kho_restore_free);
 
-static void __kho_abort(void)
-{
-	if (kho_out.preserved_mem_map) {
-		kho_mem_ser_free(kho_out.preserved_mem_map);
-		kho_out.preserved_mem_map = NULL;
-	}
-}
-
 int kho_abort(void)
 {
 	if (!kho_enable)
@@ -1231,7 +1223,8 @@ int kho_abort(void)
 	if (!kho_out.finalized)
 		return -ENOENT;
 
-	__kho_abort();
+	kho_mem_ser_free(kho_out.preserved_mem_map);
+	kho_out.preserved_mem_map = NULL;
 	kho_out.finalized = false;
 
 	return 0;
@@ -1239,12 +1232,12 @@ int kho_abort(void)
 
 static int __kho_finalize(void)
 {
-	int err = 0;
-	u64 *preserved_mem_map;
 	void *root = kho_out.fdt;
 	struct kho_sub_fdt *fdt;
+	u64 *preserved_mem_map;
+	int err;
 
-	err |= fdt_create(root, PAGE_SIZE);
+	err = fdt_create(root, PAGE_SIZE);
 	err |= fdt_finish_reservemap(root);
 	err |= fdt_begin_node(root, "");
 	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
@@ -1257,13 +1250,7 @@ static int __kho_finalize(void)
 					sizeof(*preserved_mem_map),
 					(void **)&preserved_mem_map);
 	if (err)
-		goto abort;
-
-	err = kho_mem_serialize(&kho_out);
-	if (err)
-		goto abort;
-
-	*preserved_mem_map = (u64)virt_to_phys(kho_out.preserved_mem_map);
+		goto err_exit;
 
 	mutex_lock(&kho_out.fdts_lock);
 	list_for_each_entry(fdt, &kho_out.sub_fdts, l) {
@@ -1277,13 +1264,19 @@ static int __kho_finalize(void)
 
 	err |= fdt_end_node(root);
 	err |= fdt_finish(root);
+	if (err)
+		goto err_exit;
 
-abort:
-	if (err) {
-		pr_err("Failed to convert KHO state tree: %d\n", err);
-		__kho_abort();
-	}
+	err = kho_mem_serialize(&kho_out);
+	if (err)
+		goto err_exit;
+
+	*preserved_mem_map = (u64)virt_to_phys(kho_out.preserved_mem_map);
+
+	return 0;
 
+err_exit:
+	pr_err("Failed to convert KHO state tree: %d\n", err);
 	return err;
 }
 
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

