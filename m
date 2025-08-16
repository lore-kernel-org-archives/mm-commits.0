Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C8A27453;
	Sat, 16 Aug 2025 07:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755328144; cv=none; b=JAQGUKN7n3+ESQVh6EzwSo31xa3jlRpfR5UjrVa7U37LSBpq0z8MzNn+S6vMdsyl95S6LVfdt1a+IEuIAUh7UEuHK1Vy9mHyz5wzkephL19UnUAwZAOxOKoq6RZaOWr4e/s2t9t9/TnJdWytnohS9MGRAdzzMopE5ZogoFhQ4SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755328144; c=relaxed/simple;
	bh=iRuPTC1YssnFLbqRfcCHtnM/cA3wMwXxlvcFHcUW2vE=;
	h=Date:To:From:Subject:Message-Id; b=VXHAk7GhGIjAAvP7SAGLCiTj2Eij2jQCfhZY5Dyuqq/Ma6w555o2iblezuFM/UN8sXGH/1Sn0SzcO/xsdQEom6Ro6YFYM5KKYN/9RN33De8bZ/m7mrKoJ4XVSFcpHQbqPTa14+vtpZ4qawv8wTpZT/7mXoBCiwbjEy6ebNFYkYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IsxbjMzG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IsxbjMzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74715C4CEEF;
	Sat, 16 Aug 2025 07:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755328143;
	bh=iRuPTC1YssnFLbqRfcCHtnM/cA3wMwXxlvcFHcUW2vE=;
	h=Date:To:From:Subject:From;
	b=IsxbjMzG+ZFsoj6J6gMnYkR2Ct62+vI+BOn4kgj5NtabeKqZARxhkt1UvKekgi2t4
	 s52DD+FmB30FxH+rJKeBqGg0eeWjWhMVW+jEnRIzlSZDJe0kZs3gnFfxJBCnEjl/AW
	 cJ9WCjkKGWWttG++EL39HGpn5nb5ZMCR7FUrt6ks=
Date: Sat, 16 Aug 2025 00:09:02 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,stable@vger.kernel.org,jack@suse.cz,brauner@kernel.org,chenhuacai@loongson.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-handle-bootloader-identifier-in-kernel-parameters-v4.patch added to mm-nonmm-unstable branch
Message-Id: <20250816070903.74715C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init-handle-bootloader-identifier-in-kernel-parameters-v4
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-handle-bootloader-identifier-in-kernel-parameters-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-handle-bootloader-identifier-in-kernel-parameters-v4.patch

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
From: Huacai Chen <chenhuacai@loongson.cn>
Subject: init-handle-bootloader-identifier-in-kernel-parameters-v4
Date: Fri, 15 Aug 2025 17:01:20 +0800

use strstarts()

Link: https://lkml.kernel.org/r/20250815090120.1569947-1-chenhuacai@loongson.cn
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-handle-bootloader-identifier-in-kernel-parameters-v4
+++ a/init/main.c
@@ -559,7 +559,7 @@ static int __init unknown_bootoption(cha
 
 	/* Handle bootloader identifier */
 	for (int i = 0; bootloader[i]; i++) {
-		if (!strncmp(param, bootloader[i], strlen(bootloader[i])))
+		if (strstarts(param, bootloader[i]))
 			return 0;
 	}
 
_

Patches currently in -mm which might be from chenhuacai@loongson.cn are

init-handle-bootloader-identifier-in-kernel-parameters.patch
init-handle-bootloader-identifier-in-kernel-parameters-v4.patch

