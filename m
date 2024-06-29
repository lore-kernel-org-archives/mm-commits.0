Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF0F18C36
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628634; cv=none; b=clQHyxk+PFJGRLIom3KBwNTulpfgVwWMXHYFzL7sGkumAmuclNM87rDTTpxX1AElVNXXK0trA50UjArIhJ52c5EzIllfMOAp1QxocfjJkP6scRD3ULRVHFXQnkuqXk2gbiEJgjrBeQefLnDcc9ckxiDgmEoAEiz8HXtDDFxGG3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628634; c=relaxed/simple;
	bh=Htle4zNfdDimGaWR0XflKdi6WpRcPLOD2znsHIn7LNo=;
	h=Date:To:From:Subject:Message-Id; b=Vxl/Ko2BkARX1S+l2cZ6Y5DPFoU1+R3ESqOw6Avv6/fs6Lj/5SaOx/J0AoVC81X/TSNqE+Ql2aGsKpnWANZsD6MuPKsZuGsjgjQ5sv77660z59AFJk+yyankiGLnietkJ4VRT1XLCp5ZvRVApc0W6Hies+xZBIWcqG5dIh5R5Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l9mReMJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l9mReMJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A626C32781;
	Sat, 29 Jun 2024 02:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628633;
	bh=Htle4zNfdDimGaWR0XflKdi6WpRcPLOD2znsHIn7LNo=;
	h=Date:To:From:Subject:From;
	b=l9mReMJrOyZ/g1XN3dBwPq96O51A9aDaHopWRVvz87liv53yLHMWDAPcHA/hQ/oRx
	 XaPaXH/uxv+gWw3WV3Peyr+/Mbd+83V5J23kpbBercOVPwvQMqLec7YgOQEq3eU76+
	 W+L6G0nqxWjELyO7zjbJibFKx2TVizrHfC9cMddI=
Date: Fri, 28 Jun 2024 19:37:12 -0700
To: mm-commits@vger.kernel.org,jolsa@kernel.org,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] build-id-require-program-headers-to-be-right-after-elf-header.patch removed from -mm tree
Message-Id: <20240629023713.5A626C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: build-id: require program headers to be right after ELF header
has been removed from the -mm tree.  Its filename was
     build-id-require-program-headers-to-be-right-after-elf-header.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: build-id: require program headers to be right after ELF header
Date: Fri, 21 Jun 2024 21:39:33 +0300

Neither ELF spec not ELF loader require program header to be placed right
after ELF header, but build-id code very much assumes such placement:

See

	find_get_page(vma->vm_file->f_mapping, 0);

line and checks against PAGE_SIZE.

Returns errors for now until someone rewrites build-id parser
to be more inline with load_elf_binary().

Link: https://lkml.kernel.org/r/d58bc281-6ca7-467a-9a64-40fa214bd63e@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/buildid.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/lib/buildid.c~build-id-require-program-headers-to-be-right-after-elf-header
+++ a/lib/buildid.c
@@ -73,6 +73,13 @@ static int get_build_id_32(const void *p
 	Elf32_Phdr *phdr;
 	int i;
 
+	/*
+	 * FIXME
+	 * Neither ELF spec nor ELF loader require that program headers
+	 * start immediately after ELF header.
+	 */
+	if (ehdr->e_phoff != sizeof(Elf32_Ehdr))
+		return -EINVAL;
 	/* only supports phdr that fits in one page */
 	if (ehdr->e_phnum >
 	    (PAGE_SIZE - sizeof(Elf32_Ehdr)) / sizeof(Elf32_Phdr))
@@ -98,6 +105,13 @@ static int get_build_id_64(const void *p
 	Elf64_Phdr *phdr;
 	int i;
 
+	/*
+	 * FIXME
+	 * Neither ELF spec nor ELF loader require that program headers
+	 * start immediately after ELF header.
+	 */
+	if (ehdr->e_phoff != sizeof(Elf64_Ehdr))
+		return -EINVAL;
 	/* only supports phdr that fits in one page */
 	if (ehdr->e_phnum >
 	    (PAGE_SIZE - sizeof(Elf64_Ehdr)) / sizeof(Elf64_Phdr))
_

Patches currently in -mm which might be from adobriyan@gmail.com are


