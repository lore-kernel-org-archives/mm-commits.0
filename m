Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB892F12AE
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 00:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782347799; cv=none; b=NMDlZ7Bj/T9ykPsEDcotS4RsRQbN7Oo/BM0niFsKdK8IDgFHIxTo1x4X96dmmcuPoZa8ej4NNSF+Eawe3r0uLCjUWn+BCrz3W92bEqSwgU+5TKBMMYz8HQwI21FcytiAvmv19o0JVDVc0oLwFmptm/2jnYyx2EUPIDLWwh3symY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782347799; c=relaxed/simple;
	bh=S6IatgnjN93JzIh1bhfO7D8tR1Ty8BkSCJCQFMCy/BY=;
	h=Date:To:From:Subject:Message-Id; b=VeXB81vzPMr72qxpzODqNYdLp3VqJCJeZcS82ZuV7V7RtIFU/icdJkit3DlJ2cEup8NcSwEvtxV86YZbHFo5CS/6XAepudVx/kUcF7tOC1bSOH5GX8Ka/2l/PHs2TeO6tI4/cgQfajUM6OzoGS33x/scBAvX+0HbIf4B0Y27CxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x+7NDMmm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x+7NDMmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197C01F000E9;
	Thu, 25 Jun 2026 00:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782347789;
	bh=IYyTzBi5YfhPprFDeZZjBZ8NUQ/8tr5GM3HYRWRLrgI=;
	h=Date:To:From:Subject;
	b=x+7NDMmmE2lfzLr2sw2ideH3mXXF+YFj/6/EzgbpRm1D8Pi0u7i1wcwZ1YbVpipyj
	 iqBHALT+mJppq65G09oyMtwxYyXawDbhSkFAxc65fmCl7TVA/I1uo5K5+zbtZc1bPo
	 6Tl2SmrlAAzynORJhaUTUrKRkyE5nV8rFMzkvxls=
Date: Wed, 24 Jun 2026 17:36:28 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,skhan@linuxfoundation.org,ljs@kernel.org,gregkh@linuxfoundation.org,corbet@lwn.net,doehyunbaek@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-driver-api-uio-howto-document-mmap_prepare-callback.patch added to mm-hotfixes-unstable branch
Message-Id: <20260625003629.197C01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/driver-api/uio-howto: document mmap_prepare callback
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     docs-driver-api-uio-howto-document-mmap_prepare-callback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-driver-api-uio-howto-document-mmap_prepare-callback.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Doehyun Baek <doehyunbaek@gmail.com>
Subject: Docs/driver-api/uio-howto: document mmap_prepare callback
Date: Mon, 22 Jun 2026 18:18:21 +0000

The UIO howto still documents an mmap callback in struct uio_info.  That
field was replaced by mmap_prepare, which takes a struct vm_area_desc.

A UIO driver following the current howto no longer builds because struct
uio_info has no mmap member.  Update the documented callback signature and
matching text to match the current API.

Link: https://lore.kernel.org/20260622181821.1195257-1-doehyunbaek@gmail.com
Fixes: 933f05f58ac6 ("uio: replace deprecated mmap hook with mmap_prepare in uio_info")
Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/driver-api/uio-howto.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/driver-api/uio-howto.rst~docs-driver-api-uio-howto-document-mmap_prepare-callback
+++ a/Documentation/driver-api/uio-howto.rst
@@ -246,10 +246,10 @@ the members are required, others are opt
    hardware interrupt number. The flags given here will be used in the
    call to :c:func:`request_irq()`.
 
--  ``int (*mmap)(struct uio_info *info, struct vm_area_struct *vma)``:
+-  ``int (*mmap_prepare)(struct uio_info *info, struct vm_area_desc *desc)``:
    Optional. If you need a special :c:func:`mmap()`
    function, you can set it here. If this pointer is not NULL, your
-   :c:func:`mmap()` will be called instead of the built-in one.
+   ``mmap_prepare`` will be called instead of the built-in one.
 
 -  ``int (*open)(struct uio_info *info, struct inode *inode)``:
    Optional. You might want to have your own :c:func:`open()`,
_

Patches currently in -mm which might be from doehyunbaek@gmail.com are

docs-driver-api-uio-howto-document-mmap_prepare-callback.patch

