Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC9C161
	for <mm-commits@vger.kernel.org>; Sat, 22 Jun 2024 00:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719017397; cv=none; b=FMp1qS4V20Oq5yvnwiUItz3JFggoDj99spMdcHqVUOPCBBA7NML+Ha7D6l/959cE0t9ElDqdLcZtyBEsw3dGDKXj1/6YRAQkiRaoMrj610DOsNt1DS1h9JjtIhh+vrlx22zbVhnMrVBc9OB8ktEYj7gmljQMBkvvXU5ecX8BY48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719017397; c=relaxed/simple;
	bh=O/cvstQK5dSHm+uEStZxI7n8C+l44C6cDLDhHK3jkDo=;
	h=Date:To:From:Subject:Message-Id; b=EpmXMkZpGZEw42KmyugsL5FrPQK3qEve6nt6zrdIR/3SH87SX1BHibl1gbCuhKcbX4ewhYh0pS52lgpKVgnm6BDxN9KbQ1KKCVmlNKJnkYFE7bkUg8DI+SNRwI9txiMqYrN9kIknNixhEvc5Cc+75CNaaZvIlo5XM1Bw2yIexV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LZSWD6RW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LZSWD6RW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82CAC3277B;
	Sat, 22 Jun 2024 00:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719017396;
	bh=O/cvstQK5dSHm+uEStZxI7n8C+l44C6cDLDhHK3jkDo=;
	h=Date:To:From:Subject:From;
	b=LZSWD6RW0UQQT7ONCo54OzVlNcWM9c5Rt3IpwWIlR/HHG6lFsB74c6zGBYmEPz0gr
	 rqauq5ziX+BwAz1KpD7DwDuPDqOkGj6pJkiG2fet9/mFOl3jrg17IQrvLNBvBX6III
	 cWwnruFiOVsl4llgDwUzN8Re+wIKNtBy8XL9+fA8=
Date: Fri, 21 Jun 2024 17:49:55 -0700
To: mm-commits@vger.kernel.org,jolsa@kernel.org,adobriyan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + build-id-require-program-headers-to-be-right-after-elf-header.patch added to mm-nonmm-unstable branch
Message-Id: <20240622004956.A82CAC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: build-id: require program headers to be right after ELF header
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     build-id-require-program-headers-to-be-right-after-elf-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/build-id-require-program-headers-to-be-right-after-elf-header.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Jiri Olsa <jolsa@kernel.org>
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

proc-test-kthread-field.patch
build-id-require-program-headers-to-be-right-after-elf-header.patch

