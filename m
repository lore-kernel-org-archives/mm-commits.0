Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA4A315D55
	for <mm-commits@vger.kernel.org>; Mon,  1 Dec 2025 17:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764609664; cv=none; b=tw4jKdI727LDT7RUR9UZ/zRCTM2XT8S7EbGtpY85Qwdel53aNEUgIItW+dnluyCRWVQtmBTGfDyY5IkCl+PUGZMQ88lYb/BKzO49gsvXswmmF4I132qP5Ae8I0EHcoOpsX/TdsBtbYjLDFNoSyW6lbrbwwu0FN7zGAk7LsUJlYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764609664; c=relaxed/simple;
	bh=LSHfEBKPFwjmLWOjvvjpOzQhK+1tQ//JjEDQNzObAHw=;
	h=Date:To:From:Subject:Message-Id; b=XAOAlwLx/9h+TqU0fsFTd7+8V8O9a2F3flOhWQYq2PzbQ+nOZsk4IDq+CR5+QyES4YT5b88i3H4WpJ0RHF1IDjprZdVHuKD8JpGlKXrF0ClJD1t0UCn8rj6ozX/+Jl0FC5wcuc1FJTwICaA01yOHLhl62dTFGAn4vOy4GxlEDmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aNwOiRgG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aNwOiRgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECDFC4CEF1;
	Mon,  1 Dec 2025 17:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764609663;
	bh=LSHfEBKPFwjmLWOjvvjpOzQhK+1tQ//JjEDQNzObAHw=;
	h=Date:To:From:Subject:From;
	b=aNwOiRgGL7Lnecq9KVmIKL3Tu+i8xLDEv11OF9AIMAVgHFcHyeTzk5sTOx58YKlcH
	 rQGG0A+JSbu/FmI/9cuPVghALJpY5uMT33Wo8v/vV7MM7jXxR6sxmOmQL78eoUWZu0
	 C5kAHIq6i136/bbXwGw9bRyZKAnzGCOyweMiOL9M=
Date: Mon, 01 Dec 2025 09:21:02 -0800
To: mm-commits@vger.kernel.org,zohar@linux.ibm.com,yifei.l.liu@oracle.com,tglx@linutronix.de,sourabhjain@linux.ibm.com,sohil.mehta@intel.com,rppt@kernel.org,paul.x.webb@oracle.com,noodles@meta.com,mingo@redhat.com,joel.granados@kernel.org,jbohac@suse.cz,hpa@zytor.com,henry.willard@oracle.com,harshit.m.mogalapalli@oracle.com,guoweikang.kernel@gmail.com,graf@amazon.com,bp@alien8.de,ardb@kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20251201172103.2ECDFC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix
Date: Mon Dec  1 09:20:28 AM PST 2025

fix comment typo

Cc: Alexander Graf <graf@amazon.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: guoweikang <guoweikang.kernel@gmail.com>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Henry Willard <henry.willard@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Joel Granados <joel.granados@kernel.org>
Cc: Jonathan McDowell <noodles@meta.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Paul Webb <paul.x.webb@oracle.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Yifei Liu <yifei.l.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/setup.c~x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix
+++ a/arch/x86/kernel/setup.c
@@ -446,7 +446,7 @@ int __init ima_get_kexec_buffer(void **a
 
 	/*
 	 * Calculate the PFNs for the buffer and ensure
-	 * they are with in addressable memory.
+	 * they are within addressable memory.
 	 */
 	start_pfn = PFN_DOWN(ima_kexec_buffer_phys);
 	end_pfn = PFN_DOWN(ima_kexec_buffer_phys + ima_kexec_buffer_size - 1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

genalloch-fix-htmldocs-warning.patch
x86-kexec-add-a-sanity-check-on-previous-kernels-ima-kexec-buffer-fix.patch

