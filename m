Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A67B12EBC5
	for <mm-commits@vger.kernel.org>; Thu,  4 Apr 2024 17:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712252242; cv=none; b=d1kYbGMdWkEOzmX9rFjlfkcQYBHsjbAGoQSkvUrqT09fxLt5m76LNLFqbE6y/70RhTlHjQ0TAZZHP7zThIU+bThcyFrKt/PB8zlu3xSSlKDqK+x0GF7CdwCEmtRgf9i/fV5xFr8e7gyrujcWMHUtwrjD+Bdz03pbOtSSH2czISY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712252242; c=relaxed/simple;
	bh=fSsKfisgMjJn4QQ0K+xHxvgOScMdtl0srU1OgFeNEEk=;
	h=Date:To:From:Subject:Message-Id; b=GIZ1Y1DApTlHTCrnIUXvOq4oGamsQcPHJijCPEIQu3eTV+e5KOR8XUd4uKPiVsl/T71gyVnQ9A5RZWWKBRuGsZxjOhU3wuprH7GvRdrDXd/PbUXU/+nu58Opeiq4xTJKSKfcok7HXxCWOrxotsD6YPABlunmlkXEEg1F9PmDul4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zFPBk3vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zFPBk3vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A39FC433F1;
	Thu,  4 Apr 2024 17:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712252241;
	bh=fSsKfisgMjJn4QQ0K+xHxvgOScMdtl0srU1OgFeNEEk=;
	h=Date:To:From:Subject:From;
	b=zFPBk3vlwsVvnduX3WY8bbn52BrqcxDsdu5vFeHumAbVOEkf4jXw6pwKhIuaEHqkT
	 5KnaUwTNY7v2nfx/Q55yA8kRz07crVDz1yUT/BkNY0cjmAq++73NPiGZtiIihoQ+S9
	 CZISIE7IpN6GcV8Q1ts85euaMxNiUM/itpFjfdYQ=
Date: Thu, 04 Apr 2024 10:37:21 -0700
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,dyoung@redhat.com,bhe@redhat.com,justinstitt@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmcore-replace-strncpy-with-strscpy_pad.patch added to mm-nonmm-unstable branch
Message-Id: <20240404173721.8A39FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmcore: replace strncpy with strscpy_pad
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     vmcore-replace-strncpy-with-strscpy_pad.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmcore-replace-strncpy-with-strscpy_pad.patch

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

vmcore-replace-strncpy-with-strscpy_pad.patch

