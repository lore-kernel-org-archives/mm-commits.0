Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F8719DFAB
	for <mm-commits@vger.kernel.org>; Sun, 21 Dec 2025 00:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766276755; cv=none; b=khivXWOP0XqTEsOSp6QY93c7ggG0qqeyMn9Y8mw85r+FWOG0NqB0z12e0F24MmCbwZUczHd7nR++htxmqf8hwB21ZMtqoDXQ/iwMT369DGvykqjAL9crnm76dG/IwL848zscPUWpBolAtEz+QALCDAyOQw1oZeQSYSUg1iBBmjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766276755; c=relaxed/simple;
	bh=FvcV4Jm9O02Bi/igLKJCt+J2uv1OlI54QOrwTnLP4o4=;
	h=Date:To:From:Subject:Message-Id; b=VHNFHc3ZU+E1g8yMZEv1L06UyhgpdzWglXpa8c3NwX7dMXIZddN+1Ggjdnyz7zJwlR6Ba+L/GyhOqIqV+Wk+PhzdfwdN6w5FSS4o9QYcA01zIk687eNAA+yF5Tfv1cefGwomCqT+fNySjLhOnykaEPzqV13NWFOpndtlqqPKQDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vBtN6kEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vBtN6kEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6190C4CEF5;
	Sun, 21 Dec 2025 00:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766276755;
	bh=FvcV4Jm9O02Bi/igLKJCt+J2uv1OlI54QOrwTnLP4o4=;
	h=Date:To:From:Subject:From;
	b=vBtN6kEqWeyKlxYLTWoOctcrX3diUnlWZHq+fXaD8QNfYvL8d0NC/oX4qYZSDQ47c
	 pCKjMMVHKCk/ZjkqBDFgPOpmot/QqPWNlulkR+aM2Nd8NbToklkwIlMiTegjvn9f3G
	 T+2Qqd/ZLL4WC6gWLZvL1ngepn9h5FsGkFr3RfxQ=
Date: Sat, 20 Dec 2025 16:25:54 -0800
To: mm-commits@vger.kernel.org,harry.yoo@oracle.com,elver@google.com,david@kernel.org,bagasdotme@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-describe-slab-parameter-in-__kfence_obj_info.patch added to mm-hotfixes-unstable branch
Message-Id: <20251221002554.E6190C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, kfence: describe @slab parameter in __kfence_obj_info()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kfence-describe-slab-parameter-in-__kfence_obj_info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-describe-slab-parameter-in-__kfence_obj_info.patch

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
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: mm, kfence: describe @slab parameter in __kfence_obj_info()
Date: Fri, 19 Dec 2025 08:40:07 +0700

Sphinx reports kernel-doc warning:

WARNING: ./include/linux/kfence.h:220 function parameter 'slab' not described in '__kfence_obj_info'

Fix it by describing @slab parameter.

Link: https://lkml.kernel.org/r/20251219014006.16328-6-bagasdotme@gmail.com
Fixes: 2dfe63e61cc31e ("mm, kfence: support kmem_dump_obj() for KFENCE objects")
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Acked-by: Marco Elver <elver@google.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfence.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/kfence.h~mm-kfence-describe-slab-parameter-in-__kfence_obj_info
+++ a/include/linux/kfence.h
@@ -211,6 +211,7 @@ struct kmem_obj_info;
  * __kfence_obj_info() - fill kmem_obj_info struct
  * @kpp: kmem_obj_info to be filled
  * @object: the object
+ * @slab: the slab
  *
  * Return:
  * * false - not a KFENCE object
_

Patches currently in -mm which might be from bagasdotme@gmail.com are

mm-describe-flags-parameter-in-memalloc_flags_save.patch
textsearch-describe-list-member-in-ts_ops-search.patch
mm-vmalloc-fix-up-vrealloc_node_align-kernel-doc-macro-name.patch
mm-kfence-describe-slab-parameter-in-__kfence_obj_info.patch

