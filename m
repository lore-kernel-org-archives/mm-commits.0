Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E5227450
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 00:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754959968; cv=none; b=MD4e+yO/EHX++SZN7jRY4pRWHkIxbaau5Rlnu9l2hJ88gnwHqMFmKnc7z1vfNj3fIdNoErMei4aVFLGhnWtBLgjniojWfKSy+1QH1hlkybUVvJpii0h4R2T4mvnPep5Ur+12TjFoNz7MYcfEXgD+kOAWLY3HNtJhfQNpuR0Dsj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754959968; c=relaxed/simple;
	bh=wcYrc/w4FRZlT9SH6W2/XNMSOtfUJLQktiC6/k+MoMY=;
	h=Date:To:From:Subject:Message-Id; b=i6MfPgH/x3jctYa236oXxAkXC1k08a0Ic8yGHh2WFiHfSJ2EIOaUVJesFZz3lfPLJKRyT3nJOvWA12+sZN4+bs8MwLUrSzDLqRSM5ETyfvnYqO5cnEAc268GBy0vH8xpL87v7oUHZH/kK9ai349iNyHbIBRAYt1xHaYQB+oiCNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y2CQAF0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y2CQAF0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F877C4CEED;
	Tue, 12 Aug 2025 00:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754959968;
	bh=wcYrc/w4FRZlT9SH6W2/XNMSOtfUJLQktiC6/k+MoMY=;
	h=Date:To:From:Subject:From;
	b=y2CQAF0fIgvNuL+KiAYlzGufkcSvRfz45tZwlwKfhfP38JEylMQ+4IFeUpJ5p/lfQ
	 od5QgE6DtA80ThyzcsrYJzL9lMOlh4profJjj4pOqQ+4uTqOBrjuR5BCwNipegFydl
	 jnfqSJiqI3y+CUuaiLuACXBHvfJhU9K4hoKXN/x0=
Date: Mon, 11 Aug 2025 17:52:47 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,linux@weissschuh.net,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_kho-fixes-for-error-handling.patch added to mm-new branch
Message-Id: <20250812005248.6F877C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_kho: fixes for error handling
has been added to the -mm mm-new branch.  Its filename is
     lib-test_kho-fixes-for-error-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_kho-fixes-for-error-handling.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: lib/test_kho: fixes for error handling
Date: Mon, 11 Aug 2025 11:25:09 +0300

* Update kho_test_save() so that folios array won't be freed when
  returning from the function and the fdt will be freed on error
* Reset state->nr_folios to 0 in  kho_test_generate_data() on error
* Simplify allocation of folios info in fdt.

Link: https://lkml.kernel.org/r/20250811082510.4154080-3-rppt@kernel.org
Fixes: b753522bed0b ("kho: add test for kexec handover")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reported-by: Pratyush Yadav <pratyush@kernel.org>
Closes: https://lore.kernel.org/all/mafs0zfcjcepf.fsf@kernel.org
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kho.c |   52 +++++++++++++++++++++++++++++------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

--- a/lib/test_kho.c~lib-test_kho-fixes-for-error-handling
+++ a/lib/test_kho.c
@@ -67,13 +67,20 @@ static struct notifier_block kho_test_nb
 
 static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 {
-	phys_addr_t *folios_info __free(kvfree) = NULL;
+	phys_addr_t *folios_info;
 	int err = 0;
 
-	folios_info = kvmalloc_array(state->nr_folios, sizeof(*folios_info),
-				     GFP_KERNEL);
-	if (!folios_info)
-		return -ENOMEM;
+	err |= fdt_begin_node(fdt, "data");
+	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
+			    sizeof(state->nr_folios));
+	err |= fdt_property_placeholder(fdt, "folios_info",
+					state->nr_folios * sizeof(*folios_info),
+					(void **)&folios_info);
+	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
+	err |= fdt_end_node(fdt);
+
+	if (err)
+		return err;
 
 	for (int i = 0; i < state->nr_folios; i++) {
 		struct folio *folio = state->folios[i];
@@ -83,17 +90,9 @@ static int kho_test_save_data(struct kho
 
 		err = kho_preserve_folio(folio);
 		if (err)
-			return err;
+			break;
 	}
 
-	err |= fdt_begin_node(fdt, "data");
-	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
-			    sizeof(state->nr_folios));
-	err |= fdt_property(fdt, "folios_info", folios_info,
-			    state->nr_folios * sizeof(*folios_info));
-	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
-	err |= fdt_end_node(fdt);
-
 	return err;
 }
 
@@ -140,7 +139,10 @@ static int kho_test_generate_data(struct
 		unsigned int size;
 		void *addr;
 
-		/* cap allocation so that we won't exceed max_mem */
+		/*
+		 * Since get_order() rounds up, make sure that actual
+		 * allocation is smaller so that we won't exceed max_mem
+		 */
 		if (alloc_size + (PAGE_SIZE << order) > max_mem) {
 			order = get_order(max_mem - alloc_size);
 			if (order)
@@ -165,13 +167,14 @@ static int kho_test_generate_data(struct
 err_free_folios:
 	for (int i = 0; i < state->nr_folios; i++)
 		folio_put(state->folios[i]);
+	state->nr_folios = 0;
 	return -ENOMEM;
 }
 
 static int kho_test_save(void)
 {
 	struct kho_test_state *state = &kho_test_state;
-	struct folio **folios __free(kvfree) = NULL;
+	struct folio **folios;
 	unsigned long max_nr;
 	int err;
 
@@ -185,13 +188,23 @@ static int kho_test_save(void)
 
 	err = kho_test_generate_data(state);
 	if (err)
-		return err;
+		goto err_free_folios;
 
 	err = kho_test_prepare_fdt(state);
 	if (err)
-		return err;
+		goto err_free_folios;
 
-	return register_kho_notifier(&kho_test_nb);
+	err = register_kho_notifier(&kho_test_nb);
+	if (err)
+		goto err_free_fdt;
+
+	return 0;
+
+err_free_fdt:
+	folio_put(state->fdt);
+err_free_folios:
+	kvfree(folios);
+	return err;
 }
 
 static int kho_test_restore_data(const void *fdt, int node)
@@ -291,6 +304,7 @@ static void kho_test_cleanup(void)
 		folio_put(kho_test_state.folios[i]);
 
 	kvfree(kho_test_state.folios);
+	folio_put(kho_test_state.fdt);
 }
 
 static void __exit kho_test_exit(void)
_

Patches currently in -mm which might be from rppt@kernel.org are

kho-allow-scratch-areas-with-zero-size.patch
lib-test_kho-fixes-for-error-handling.patch
selftest-kho-update-generation-of-initrd.patch

