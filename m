Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD9B320CAB
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282384; cv=none; b=RZWQcGRzUXe3DmLAqPqHs5BbqpWTy1x3OOl1J8lpOE4QJFbqhWhs0F4WYKb5CVWLopoN77FeRAgFrSQG4E+WRQ5crkxAk5z/C0NDggF5AXgmYJn5SRFGK4EPgaOp8iIN02dQTLfyTyrZueocsgTgdOEDoomBTzIA2Z6ZeKgOLUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282384; c=relaxed/simple;
	bh=HCmcrkotLsQi38Hz14L9B6qu2YYWQ2mW9SYN79q96O8=;
	h=Date:To:From:Subject:Message-Id; b=WOno9PYehNekHO2Vm4EXamis0NPYc3QmxkqPewZEPme3jjW0sCsT4EGhCKDhmawJbAKFDvmL20qCQwJbxJ1Ozewiq144nUkgMxbjHk5ittL0kLyEHun7pgfCdc4aGs8rOXhCaKtx12NwDXdgTnm/0t8DkhZHGt9t9hfVEHWV3Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ExgT+9Mm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ExgT+9Mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4ADDC4CEF8;
	Thu, 27 Nov 2025 22:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282383;
	bh=HCmcrkotLsQi38Hz14L9B6qu2YYWQ2mW9SYN79q96O8=;
	h=Date:To:From:Subject:From;
	b=ExgT+9Mmr/OQHXWTmUR/v22zsXY55iYAxQSItAP0jPt8ak8kXtjJM4RS66sZmoikq
	 8oYXNRDvnUE+jVsuOKxLbOEfBVFM7K29tXER+N7/EMdlqEwgzIYldCVj4bfYndlMnK
	 snIwJ8dLbiobyQDRUuRltdC20uBY9ePWAUGNCSlk=
Date: Thu, 27 Nov 2025 14:26:23 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-update-fdt-dynamically-for-subtree-addition-removal.patch removed from -mm tree
Message-Id: <20251127222623.C4ADDC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: update FDT dynamically for subtree addition/removal
has been removed from the -mm tree.  Its filename was
     kho-update-fdt-dynamically-for-subtree-addition-removal.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: update FDT dynamically for subtree addition/removal
Date: Fri, 14 Nov 2025 13:59:59 -0500

Currently, sub-FDTs were tracked in a list (kho_out.sub_fdts) and the
final FDT is constructed entirely from scratch during kho_finalize().

We can maintain the FDT dynamically:
1. Initialize a valid, empty FDT in kho_init().
2. Use fdt_add_subnode and fdt_setprop in kho_add_subtree to
   update the FDT immediately when a subsystem registers.
3. Use fdt_del_node in kho_remove_subtree to remove entries.

This removes the need for the intermediate sub_fdts list and the
reconstruction logic in kho_finalize().  kho_finalize() now only needs to
trigger memory map serialization.

Link: https://lkml.kernel.org/r/20251114190002.3311679-11-pasha.tatashin@soleen.com
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

 kernel/liveupdate/kexec_handover.c |  144 ++++++++++++---------------
 1 file changed, 69 insertions(+), 75 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-update-fdt-dynamically-for-subtree-addition-removal
+++ a/kernel/liveupdate/kexec_handover.c
@@ -104,20 +104,11 @@ struct kho_mem_track {
 
 struct khoser_mem_chunk;
 
-struct kho_sub_fdt {
-	struct list_head l;
-	const char *name;
-	void *fdt;
-};
-
 struct kho_out {
 	void *fdt;
 	bool finalized;
 	struct mutex lock; /* protects KHO FDT finalization */
 
-	struct list_head sub_fdts;
-	struct mutex fdts_lock;
-
 	struct kho_mem_track track;
 	struct kho_debugfs dbg;
 };
@@ -127,8 +118,6 @@ static struct kho_out kho_out = {
 	.track = {
 		.orders = XARRAY_INIT(kho_out.track.orders, 0),
 	},
-	.sub_fdts = LIST_HEAD_INIT(kho_out.sub_fdts),
-	.fdts_lock = __MUTEX_INITIALIZER(kho_out.fdts_lock),
 	.finalized = false,
 };
 
@@ -725,37 +714,67 @@ err_disable_kho:
  */
 int kho_add_subtree(const char *name, void *fdt)
 {
-	struct kho_sub_fdt *sub_fdt;
+	phys_addr_t phys = virt_to_phys(fdt);
+	void *root_fdt = kho_out.fdt;
+	int err = -ENOMEM;
+	int off, fdt_err;
 
-	sub_fdt = kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
-	if (!sub_fdt)
-		return -ENOMEM;
+	guard(mutex)(&kho_out.lock);
+
+	fdt_err = fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
+	if (fdt_err < 0)
+		return err;
+
+	off = fdt_add_subnode(root_fdt, 0, name);
+	if (off < 0) {
+		if (off == -FDT_ERR_EXISTS)
+			err = -EEXIST;
+		goto out_pack;
+	}
 
-	INIT_LIST_HEAD(&sub_fdt->l);
-	sub_fdt->name = name;
-	sub_fdt->fdt = fdt;
+	err = fdt_setprop(root_fdt, off, PROP_SUB_FDT, &phys, sizeof(phys));
+	if (err < 0)
+		goto out_pack;
 
-	guard(mutex)(&kho_out.fdts_lock);
-	list_add_tail(&sub_fdt->l, &kho_out.sub_fdts);
 	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false));
 
-	return 0;
+out_pack:
+	fdt_pack(root_fdt);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
 void kho_remove_subtree(void *fdt)
 {
-	struct kho_sub_fdt *sub_fdt;
+	phys_addr_t target_phys = virt_to_phys(fdt);
+	void *root_fdt = kho_out.fdt;
+	int off;
+	int err;
+
+	guard(mutex)(&kho_out.lock);
+
+	err = fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
+	if (err < 0)
+		return;
 
-	guard(mutex)(&kho_out.fdts_lock);
-	list_for_each_entry(sub_fdt, &kho_out.sub_fdts, l) {
-		if (sub_fdt->fdt == fdt) {
-			list_del(&sub_fdt->l);
-			kfree(sub_fdt);
+	for (off = fdt_first_subnode(root_fdt, 0); off >= 0;
+	     off = fdt_next_subnode(root_fdt, off)) {
+		const u64 *val;
+		int len;
+
+		val = fdt_getprop(root_fdt, off, PROP_SUB_FDT, &len);
+		if (!val || len != sizeof(phys_addr_t))
+			continue;
+
+		if ((phys_addr_t)*val == target_phys) {
+			fdt_del_node(root_fdt, off);
 			kho_debugfs_fdt_remove(&kho_out.dbg, fdt);
 			break;
 		}
 	}
+
+	fdt_pack(root_fdt);
 }
 EXPORT_SYMBOL_GPL(kho_remove_subtree);
 
@@ -1232,48 +1251,6 @@ void kho_restore_free(void *mem)
 }
 EXPORT_SYMBOL_GPL(kho_restore_free);
 
-static int __kho_finalize(void)
-{
-	void *root = kho_out.fdt;
-	struct kho_sub_fdt *fdt;
-	u64 empty_mem_map = 0;
-	int err;
-
-	err = fdt_create(root, PAGE_SIZE);
-	err |= fdt_finish_reservemap(root);
-	err |= fdt_begin_node(root, "");
-	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
-	err |= fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem_map,
-			    sizeof(empty_mem_map));
-	if (err)
-		goto err_exit;
-
-	mutex_lock(&kho_out.fdts_lock);
-	list_for_each_entry(fdt, &kho_out.sub_fdts, l) {
-		phys_addr_t phys = virt_to_phys(fdt->fdt);
-
-		err |= fdt_begin_node(root, fdt->name);
-		err |= fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys));
-		err |= fdt_end_node(root);
-	}
-	mutex_unlock(&kho_out.fdts_lock);
-
-	err |= fdt_end_node(root);
-	err |= fdt_finish(root);
-	if (err)
-		goto err_exit;
-
-	err = kho_mem_serialize(&kho_out);
-	if (err)
-		goto err_exit;
-
-	return 0;
-
-err_exit:
-	pr_err("Failed to convert KHO state tree: %d\n", err);
-	return err;
-}
-
 int kho_finalize(void)
 {
 	int ret;
@@ -1282,12 +1259,7 @@ int kho_finalize(void)
 		return -EOPNOTSUPP;
 
 	guard(mutex)(&kho_out.lock);
-	if (kho_out.finalized) {
-		kho_update_memory_map(NULL);
-		kho_out.finalized = false;
-	}
-
-	ret = __kho_finalize();
+	ret = kho_mem_serialize(&kho_out);
 	if (ret)
 		return ret;
 
@@ -1372,6 +1344,24 @@ int kho_retrieve_subtree(const char *nam
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
+static __init int kho_out_fdt_setup(void)
+{
+	void *root = kho_out.fdt;
+	u64 empty_mem_map = 0;
+	int err;
+
+	err = fdt_create(root, PAGE_SIZE);
+	err |= fdt_finish_reservemap(root);
+	err |= fdt_begin_node(root, "");
+	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
+	err |= fdt_property(root, PROP_PRESERVED_MEMORY_MAP, &empty_mem_map,
+			    sizeof(empty_mem_map));
+	err |= fdt_end_node(root);
+	err |= fdt_finish(root);
+
+	return err;
+}
+
 static __init int kho_init(void)
 {
 	const void *fdt = kho_get_fdt();
@@ -1394,6 +1384,10 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
+	err = kho_out_fdt_setup();
+	if (err)
+		goto err_free_fdt;
+
 	if (fdt) {
 		kho_in_debugfs_init(&kho_in.dbg, fdt);
 		return 0;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-luo_flb-introduce-file-lifecycle-bound-global-state.patch
tests-liveupdate-add-in-kernel-liveupdate-test.patch

