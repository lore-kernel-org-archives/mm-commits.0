Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492544F8A8
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 23:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yWEESRZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09123C433C7;
	Wed, 20 Dec 2023 23:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703113425;
	bh=3ZdCJ3BukKHtEcWMxkkRcaM76jt+QE/x9sAyDtqtibg=;
	h=Date:To:From:Subject:From;
	b=yWEESRZXNWy7HxbIA+kjHXwXMFy0nHFDafr5gItVJCt2vK5ktSGav8Ghc4acFiGEY
	 MwY/1uZ+58STBA/SNZilae0cvv2BSC9rEvMSXjCe/vT1PED4HARCu95i0WMuEj5xzO
	 PTGK6Juhs7AfavDXIInHOky5xsbj4C0mG43vL6ns=
Date: Wed, 20 Dec 2023 15:03:44 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,mingo@redhat.com,hpa@zytor.com,horms@kernel.org,dave.hansen@linux.intel.com,bp@alien8.de,bhe@redhat.com,bhelgaas@google.com,ytcoode@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] x86-kexec-simplify-the-logic-of-mem_region_callback.patch removed from -mm tree
Message-Id: <20231220230345.09123C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/kexec: simplify the logic of mem_region_callback()
has been removed from the -mm tree.  Its filename was
     x86-kexec-simplify-the-logic-of-mem_region_callback.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuntao Wang <ytcoode@gmail.com>
Subject: x86/kexec: simplify the logic of mem_region_callback()
Date: Tue, 12 Dec 2023 23:05:06 +0800

The expression `mstart + resource_size(res) - 1` is actually equivalent to
`res->end`, simplify the logic of this function to improve readability.

Link: https://lkml.kernel.org/r/20231212150506.31711-1-ytcoode@gmail.com
Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/machine_kexec_64.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/machine_kexec_64.c~x86-kexec-simplify-the-logic-of-mem_region_callback
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -42,12 +42,9 @@ struct init_pgtable_data {
 static int mem_region_callback(struct resource *res, void *arg)
 {
 	struct init_pgtable_data *data = arg;
-	unsigned long mstart, mend;
 
-	mstart = res->start;
-	mend = mstart + resource_size(res) - 1;
-
-	return kernel_ident_mapping_init(data->info, data->level4p, mstart, mend);
+	return kernel_ident_mapping_init(data->info, data->level4p,
+					 res->start, res->end);
 }
 
 static int
_

Patches currently in -mm which might be from ytcoode@gmail.com are

x86-crash-remove-the-unused-image-parameter-from-prepare_elf_headers.patch
x86-crash-use-sz_1m-macro-instead-of-hardcoded-value.patch
crash_core-fix-and-simplify-the-logic-of-crash_exclude_mem_range.patch
x86-crash-fix-potential-cmem-ranges-array-overflow.patch
crash_core-optimize-crash_exclude_mem_range.patch
kexec-modify-the-meaning-of-the-end-parameter-in-kimage_is_destination_range.patch
kexec_file-fix-incorrect-temp_start-value-in-locate_mem_hole_top_down.patch
x86-kexec-use-pr_err-instead-of-kexec_dprintk-when-an-error-occurs.patch
x86-kexec-fix-incorrect-argument-passed-to-kexec_dprintk.patch

