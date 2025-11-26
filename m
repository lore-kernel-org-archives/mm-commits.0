Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3773223E25B
	for <mm-commits@vger.kernel.org>; Wed, 26 Nov 2025 17:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764179686; cv=none; b=iTZY2NszRLX1v8gz/Vs9bqjg+cJdEBudH/5yiaiyRlzS8kgUfdqYhkWycP6B+X8ZP7nUe1Tl0rkkmYqztEW+HJsAJNZ8fN2uItw/lWQ68fDGJzwP9jrNkFiOI23Fkkcy62oslkA3PirsvVx/dQe9cG0GAEUF/L/86ZWfqTg7teQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764179686; c=relaxed/simple;
	bh=z35V8epzw0nKXCJ3VCVn2F/qt5wCy/UgUt26XCUOPPU=;
	h=Date:To:From:Subject:Message-Id; b=nCdZDhXnknsMbbIn0mPT1pF+Vb3IY6er8QI4kjnp232PMldCBcexZGv5baejEPkDJqR6tvLdkKLUzCItfia0po0ErJvAiYegNL5vs2hCOLF6ymoEgRcJ2QDhQMXjn+hns5rglMKu5iarZokzR78he8NDIMEHQ24LGUS6mDM5wrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kierkpsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kierkpsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6932C4CEF7;
	Wed, 26 Nov 2025 17:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764179685;
	bh=z35V8epzw0nKXCJ3VCVn2F/qt5wCy/UgUt26XCUOPPU=;
	h=Date:To:From:Subject:From;
	b=kierkpsdLp23k2jFzembKOk3oRaXleQwJY8Xf/un5C1ENfsz1PsuCbfjpIQ69ERV0
	 baFLcnaEaF7faFESKg4lmekccIazuyEjMLPgBvGRkxlE4S6n3n8yg6cr0LR2njcIv4
	 Gw4WsP/GBrIF7bzEGTRjvePL6uYphl71hTcsFZ1g=
Date: Wed, 26 Nov 2025 09:54:45 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,bhe@redhat.com,maqianga@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-print-out-debugging-message-if-required-for-kexec_load.patch added to mm-nonmm-unstable branch
Message-Id: <20251126175445.A6932C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec: print out debugging message if required for kexec_load
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-print-out-debugging-message-if-required-for-kexec_load.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-print-out-debugging-message-if-required-for-kexec_load.patch

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
From: Qiang Ma <maqianga@uniontech.com>
Subject: kexec: print out debugging message if required for kexec_load
Date: Wed, 26 Nov 2025 16:44:27 +0800

commit a85ee18c7900 ("kexec_file: print out debugging message if
required") has added general code printing in kexec_file_load(), but not
in kexec_load().

As a result, when using '-d' for the kexec_load interface, print nothing
in the kernel space.

And print out type/start/head of kimage and flags to help debug.

Link: https://lkml.kernel.org/r/20251126084427.3222212-4-maqianga@uniontech.com
Signed-off-by: Qiang Ma <maqianga@uniontech.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510310332.6XrLe70K-lkp@intel.com/
Cc: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/kexec.c~kexec-print-out-debugging-message-if-required-for-kexec_load
+++ a/kernel/kexec.c
@@ -166,6 +166,9 @@ static int do_kexec_load(unsigned long e
 	if (ret)
 		goto out;
 
+	kexec_dprintk("kexec_load: type:%u, start:0x%lx head:0x%lx flags:0x%lx\n",
+		      image->type, image->start, image->head, flags);
+
 	/* Install the new kernel and uninstall the old */
 	image = xchg(dest_image, image);
 
_

Patches currently in -mm which might be from maqianga@uniontech.com are

kexec-fix-uninitialized-struct-kimage-image-pointer.patch
kexec-add-kexec-flag-to-control-debug-printing.patch
kexec-print-out-debugging-message-if-required-for-kexec_load.patch

