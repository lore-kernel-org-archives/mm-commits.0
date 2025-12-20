Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136BC63CB
	for <mm-commits@vger.kernel.org>; Sat, 20 Dec 2025 22:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766269106; cv=none; b=VY3OSkbkid5XiYBapivOYFAsukLY0gDmzEmtMd72+xFry5XHcG0DGGW9MoKvwji71XGneV/ih2hEBuiQ/bqEkLTfFPuxoUMxf9ZblM5RaWekeQFi2kOAc2PZ7rST2IOCtMUbcHlIY9yY54exeNEwjr9g889rQ4KISxuoNVg+w+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766269106; c=relaxed/simple;
	bh=Zr8A99/OtOmZ6nF2tVmW+vTf8IUw4hiX93XjyOoxqFg=;
	h=Date:To:From:Subject:Message-Id; b=lpQCO/81AuCCev5L+o0595PMZQbymAubUHdGTqTN62o0zRxpcz7BTWZEAGWhp/Mr1r+WroLbaCGeP/RRIADu1+CElKKXsnXgBWw0YhmiD90rODNwWu0VcuREH2W/gRH4R5QKuEci4xeC7UTqqEpI1PsmYICG6TqLZdpBsQDdtUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EaGsmfbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EaGsmfbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF24C4CEF5;
	Sat, 20 Dec 2025 22:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766269105;
	bh=Zr8A99/OtOmZ6nF2tVmW+vTf8IUw4hiX93XjyOoxqFg=;
	h=Date:To:From:Subject:From;
	b=EaGsmfbDWgoPEv88iWuM7zI4rPV9arpZCNVogfOYBADnfXXuoXDQRhyl8Z0XDdd+S
	 d3QUJI8ahpXzCvM9k8RFMFpan+Sa1tXIp/2ZEfps81zOBKhgK51QCfc0FBM5xRg/DO
	 UGAKVIxz2ecvHb8eWYfcFJWzbjges/Yl2b81sNYI=
Date: Sat, 20 Dec 2025 14:18:25 -0800
To: mm-commits@vger.kernel.org,mic@digikod.net,masahiroy@kernel.org,ihuguet@redhat.com,danny@kdrag0n.dev,corbet@lwn.net,kari.argillander@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + editorconfig-add-rst-extension.patch added to mm-nonmm-unstable branch
Message-Id: <20251220221825.BDF24C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: editorconfig: add rst extension
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     editorconfig-add-rst-extension.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/editorconfig-add-rst-extension.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Kari Argillander <kari.argillander@gmail.com>
Subject: editorconfig: add rst extension
Date: Fri, 19 Dec 2025 18:25:11 +0200

We have a lot of .rst documentation; use editorconfig rules for those. 
This sets the default tab width to 8, which makes indentation consistent
and avoids requiring developers to adjust editor settings manually.

Link: https://lkml.kernel.org/r/20251219-editorconfig-rst-v1-1-58d4fa397664@gmail.com
Signed-off-by: Kari Argillander <kari.argillander@gmail.com>
Cc: Danny Lin <danny@kdrag0n.dev>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mickael Salaun <mic@digikod.net>
Cc: Íñigo Huguet <ihuguet@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .editorconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/.editorconfig~editorconfig-add-rst-extension
+++ a/.editorconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-[{*.{awk,c,dts,dtsi,dtso,h,mk,s,S},Kconfig,Makefile,Makefile.*}]
+[{*.{awk,c,dts,dtsi,dtso,h,mk,rst,s,S},Kconfig,Makefile,Makefile.*}]
 charset = utf-8
 end_of_line = lf
 insert_final_newline = true
_

Patches currently in -mm which might be from kari.argillander@gmail.com are

editorconfig-add-rst-extension.patch

