Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56C68175E
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104477; cv=none; b=MKJ9/YLletIwlPYVTJBMDMKNsgI0Osq2G+INTGtIfn+2I33n5MunDXeaAL6XzP1+nUwBqxcXhNhy1FH8h2H9nEkRL0MUqv0arn4Lvh+FWFzrsjWhTUiBFOb2q3tZBdBXcwGoglDlS0n2yvqxMeWheBdRdmdPvc5AyE4ohe2Tmag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104477; c=relaxed/simple;
	bh=TOE+REyJAGtUcMEfj+xRpCFGBxcf0LnKHUi/Z7AE5yI=;
	h=Date:To:From:Subject:Message-Id; b=FfczTcKu25iXtIkbZMoOAGuxI/6OYROLw8G4ZUsexc0sQII6s+O4oSaiJWyJP6Z2fwTPplRXpABXHixwDQrcRkMgEn47ysPd4frPh4WFQ4AKdrgWm0BbrtdpR7wk1gZOBhVFEaccPKUpXpNp1lKuJqWX+bvYhDPaHXq/Us+DAic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fSa3tnym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fSa3tnym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C67C113CD;
	Fri, 26 Apr 2024 04:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104477;
	bh=TOE+REyJAGtUcMEfj+xRpCFGBxcf0LnKHUi/Z7AE5yI=;
	h=Date:To:From:Subject:From;
	b=fSa3tnym+51b+cqTDxT/c3weumkYTRfuCahYjh+sax3HaZL5A8lueMEDB8ueGkRNp
	 fqgykZbopADTKKT/v+qY0FsehYBiL4d7j8uXvn79HZIBCDPZlX9UXBA0bv1RpI4EVt
	 4Zsnv7kkyyoYAg+YkJmmTKEva89VdlVtPG1JxOEk=
Date: Thu, 25 Apr 2024 21:07:56 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,justinstitt@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] vmcore-replace-strncpy-with-strscpy_pad.patch removed from -mm tree
Message-Id: <20240426040757.10C67C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmcore: replace strncpy with strscpy_pad
has been removed from the -mm tree.  Its filename was
     vmcore-replace-strncpy-with-strscpy_pad.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Justin Stitt <justinstitt@google.com>
Subject: vmcore: replace strncpy with strscpy_pad
Date: Mon, 01 Apr 2024 18:39:55 +0000

strncpy() is in the process of being replaced as it is deprecated [1].
We should move towards safer and less ambiguous string interfaces.

Looking at vmcoredd_header's definition:
|	struct vmcoredd_header {
|		__u32 n_namesz; /* Name size */
|		__u32 n_descsz; /* Content size */
|		__u32 n_type;   /* NT_VMCOREDD */
|		__u8 name[8];   /* LINUX\0\0\0 */
|		__u8 dump_name[VMCOREDD_MAX_NAME_BYTES]; /* Device dump's name */
|	};
.. we see that @name wants to be NUL-padded.

We're copying data->dump_name which is defined as:
|	char dump_name[VMCOREDD_MAX_NAME_BYTES]; /* Unique name of the dump */
.. which shares the same size as vdd_hdr->dump_name. Let's make sure we
NUL-pad this as well.

Use strscpy_pad() which NUL-terminates and NUL-pads its destination
buffers. Specifically, use the new 2-argument version of strscpy_pad
introduced in Commit e6584c3964f2f ("string: Allow 2-argument
strscpy()").

Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
Link: https://github.com/KSPP/linux/issues/90
Link: https://lkml.kernel.org/r/20240401-strncpy-fs-proc-vmcore-c-v2-1-dd0a73f42635@google.com
Signed-off-by: Justin Stitt <justinstitt@google.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/proc/vmcore.c~vmcore-replace-strncpy-with-strscpy_pad
+++ a/fs/proc/vmcore.c
@@ -1370,9 +1370,8 @@ static void vmcoredd_write_header(void *
 	vdd_hdr->n_descsz = size + sizeof(vdd_hdr->dump_name);
 	vdd_hdr->n_type = NT_VMCOREDD;
 
-	strncpy((char *)vdd_hdr->name, VMCOREDD_NOTE_NAME,
-		sizeof(vdd_hdr->name));
-	memcpy(vdd_hdr->dump_name, data->dump_name, sizeof(vdd_hdr->dump_name));
+	strscpy_pad(vdd_hdr->name, VMCOREDD_NOTE_NAME);
+	strscpy_pad(vdd_hdr->dump_name, data->dump_name);
 }
 
 /**
_

Patches currently in -mm which might be from justinstitt@google.com are


