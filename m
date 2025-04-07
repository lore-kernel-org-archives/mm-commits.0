Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B2717BA6
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 01:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743990493; cv=none; b=M+aqOflDuKrEWWLnZniMToJ69G+YvsLhHxzBKv/oV79zxVS1cgC77BzeJC+rQ8T4PB+/W8//s2iew7iOltUG+oc/CaHaxYNRacN8UxLJNs4t74uH7W1HRhxxd7XxcHKnyh8qdZ4EpVjH4NAfcMpsDRJ0i8v61t8QVONFJJQa3kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743990493; c=relaxed/simple;
	bh=ZmDuYrxEBbt5RaavwsNMG0kry5yXTVLdrpY8T6IeTTw=;
	h=Date:To:From:Subject:Message-Id; b=K07a+PqwfgGr7aJ7r158py0atJ2Fqz3iiHdSqJnq3Skwd+3AG600bodfWQFbe+NCI/V1YbkkfvP4Ol+sjOn0mzXiDFzc7zf2zpo/y0aMZ+Sgv/g60Rf3ckawelKKa24x6zY+PNpIGZyvnQQLudShoaPf8EUuoEELpPSP8hhhEnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZZVntvCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZZVntvCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F85C4CEE3;
	Mon,  7 Apr 2025 01:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743990493;
	bh=ZmDuYrxEBbt5RaavwsNMG0kry5yXTVLdrpY8T6IeTTw=;
	h=Date:To:From:Subject:From;
	b=ZZVntvCgDq+ZK5EZQKPJElzwKV9JEyB9/tpRwiLzzyhgTdNoK4eLlHLw4jsB3GiRI
	 PoZ2NYzt5SiaxsP+IVXevtgPn2+tBvwE6roygyoBl7FCh0lnA/Bpq51SV8d7/tjs81
	 8bGKZmYHMbRUuvJ8HLHaG54p4cN6N68sTYkGr6IE=
Date: Sun, 06 Apr 2025 18:48:12 -0700
To: mm-commits@vger.kernel.org,sstabellini@kernel.org,sfr@canb.auug.org.au,oleksandr_tyshchenko@epam.com,masahiroy@kernel.org,jgross@suse.com,jeff.johnson@oss.qualcomm.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xenbus-add-module-description.patch added to mm-nonmm-unstable branch
Message-Id: <20250407014813.37F85C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xenbus: add module description
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     xenbus-add-module-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xenbus-add-module-description.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: xenbus: add module description
Date: Mon, 24 Mar 2025 18:32:30 +0100

Modules without a description now cause a warning:

WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/xen/xenbus/xenbus_probe_frontend.o

Link: https://lkml.kernel.org/r/20250324173242.1501003-5-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Stehen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/xenbus/xenbus_probe_frontend.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/xen/xenbus/xenbus_probe_frontend.c~xenbus-add-module-description
+++ a/drivers/xen/xenbus/xenbus_probe_frontend.c
@@ -513,4 +513,5 @@ static int __init boot_wait_for_devices(
 late_initcall(boot_wait_for_devices);
 #endif
 
+MODULE_DESCRIPTION("Frontend for Xen bus probe");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from arnd@arndb.de are

exportfs-add-module-description.patch
asn1-add-module-description.patch
samples-livepatch-add-module-descriptions.patch
fpga-tests-add-module-descriptions.patch
xenbus-add-module-description.patch
zlib-add-module-description.patch
ucs2_string-add-module-description.patch
mm-kasan-add-module-decription.patch
kunit-slub-add-module-description.patch

