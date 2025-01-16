Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9D613B58C
	for <mm-commits@vger.kernel.org>; Thu, 16 Jan 2025 22:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737065804; cv=none; b=jR66q/jV6kycNoGMO48Tg+dIXy8W9IF9++95Gd+MN+Y/lEwmqaK7CIbOZnBf+MoE4SO90w5p2TPTSxk/D87BjaJKvv9bo7pszD1L9rmzhFGEELv7xzprL6YkK9Dxu8pFWkifq/03ZyBl7yKe5j/pQcBuc4L60ITCIgJdBu4RwKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737065804; c=relaxed/simple;
	bh=uRZ9LxBd+agXlp0x5mqDAQLX0bscgxCcyRWr6ys2MXU=;
	h=Date:To:From:Subject:Message-Id; b=bD1mVEgBJoRhhJcRW6AmzK3o+VmkU0h0CS4wPsQf34YKUcZxh+lBAk/TCGUX7mNw1fpOhqoBvtShR3VH05Z8Ucp8oI5fT2kVF+fREgYLbPq2R0ITP3ApKGnngY/SIEDft7PaPYmiRuyneRA37EzBLitRd2U6JkJHcyF9dbRtCpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i9W3fQQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i9W3fQQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F753C4CED6;
	Thu, 16 Jan 2025 22:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737065804;
	bh=uRZ9LxBd+agXlp0x5mqDAQLX0bscgxCcyRWr6ys2MXU=;
	h=Date:To:From:Subject:From;
	b=i9W3fQQxWs3ecIt0h1oGpNk6o6XB+LkuxkAlr8lfBkLVns4lBcVyz3O4dmJ2mPfbi
	 APUIpyxxraY90xC5PllfMBgEt7iY0OscigVKSRLiTlCBSmD0xBgqNHd9CGEay6ryLU
	 c7DiD/KK+cdAuAW6tGzbcGp2VGWnjV6YGI2Zr28A=
Date: Thu, 16 Jan 2025 14:16:43 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-add-vm_warn_on_vmg-definition.patch added to mm-unstable branch
Message-Id: <20250116221644.4F753C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: add VM_WARN_ON_VMG definition
has been added to the -mm mm-unstable branch.  Its filename is
     tools-add-vm_warn_on_vmg-definition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-add-vm_warn_on_vmg-definition.patch

This patch will later appear in the mm-unstable branch at
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
From: Suren Baghdasaryan <surenb@google.com>
Subject: tools: add VM_WARN_ON_VMG definition
Date: Thu, 16 Jan 2025 10:15:38 -0800

vma tests compilation yields the following error:

vma.c:732:9: error: implicit declaration of function ‘VM_WARN_ON_VMG’

Fix it by adding missing VM_WARN_ON_VMG() definition.

Link: https://lkml.kernel.org/r/20250116181538.759469-1-surenb@google.com
Fixes: e3a7ae85f87c ("mm/debug: prefer VM_WARN_ON_VMG() to report VMG debug warnings")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/vma_internal.h |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/vma/vma_internal.h~tools-add-vm_warn_on_vmg-definition
+++ a/tools/testing/vma/vma_internal.h
@@ -38,6 +38,7 @@ extern unsigned long dac_mmap_min_addr;
 
 #define VM_WARN_ON(_expr) (WARN_ON(_expr))
 #define VM_WARN_ON_ONCE(_expr) (WARN_ON_ONCE(_expr))
+#define VM_WARN_ON_VMG(_expr, _vmg) (WARN_ON(_expr))
 #define VM_BUG_ON(_expr) (BUG_ON(_expr))
 #define VM_BUG_ON_VMA(_expr, _vma) (BUG_ON(_expr))
 
_

Patches currently in -mm which might be from surenb@google.com are

seqlock-add-missing-parameter-documentation-for-raw_seqcount_try_begin.patch
tools-add-vm_warn_on_vmg-definition.patch

