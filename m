Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0FB41F376
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 20:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786133458; cv=none; b=TLIJgx17a0N5gyoTBuCzDioB38OWNLrSpm9/B+gcJr9bUxXbtbOus1lZg3zlxqHpkm1p6a29MdWymVevh9UEi8APJRrUZU2LRJaKRstiMOZRSZaPbF1kuLV8kM0/bvCfEWEyYSGr5pVwrgosGbNOwLAeu+aaT+mB5oMCmkSso7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786133458; c=relaxed/simple;
	bh=Pxn1EVho/xS1UjTmz4QOj/sSuKi0ztiU/7GPBfWIQcY=;
	h=Date:To:From:Subject:Message-Id; b=Xu2f33aMKOGaAR1iVj1prc9D0VXg/p1jKsmrtxuSIO7EA44k/18l4zrP/0wLkyw3Kg+kwZKUCdjTMlXP4t+1bagsqKKSD83FORycyXeNReGe0hNg3D4vswW7l2x0MWEH/qzJkOete/1qVUoCWFp87UJAl4cxIWmBA080gYFKcK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rsaiG1DM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rsaiG1DM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2363C1F000E9;
	Fri,  7 Aug 2026 20:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786133457;
	bh=DbvnML+BXX6aR+GezAsDmqWxah8u7vvze7ijx7xuaxU=;
	h=Date:To:From:Subject;
	b=rsaiG1DMVL8BxRwMCJ3sbJYNX9ptx29psL33lSgjl1DXF4y3zqHHniRRhbu+aDPxz
	 3te++36Rz3OXdCuxIAygPAzQc6uIA8x/pIdXIvnRouKGOf9KS9mJxryRRTcWT3D+i3
	 9kybC7ztVwTd8py/Xo5EAmaqRvlIfcahGfGACvkU=
Date: Fri, 07 Aug 2026 13:10:56 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,henry.elderman.edu+linux@gmail.com,henry.elderman.edu@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-execmem-fix-fallback_end-description-in-kernel-doc.patch added to mm-unstable branch
Message-Id: <20260807201057.2363C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/execmem: fix fallback_end description in kernel-doc
has been added to the -mm mm-unstable branch.  Its filename is
     mm-execmem-fix-fallback_end-description-in-kernel-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-execmem-fix-fallback_end-description-in-kernel-doc.patch

This patch will later appear in the mm-unstable branch at
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
From: Henry Elderman <henry.elderman.edu@gmail.com>
Subject: mm/execmem: fix fallback_end description in kernel-doc
Date: Fri, 7 Aug 2026 11:19:58 +0200

The kernel-doc for struct execmem_range incorrectly describes @fallback_end
as "start". Correct it to "end".

Link: https://lore.kernel.org/20260807091958.4735-1-henry.elderman.edu+linux@gmail.com
Signed-off-by: Henry Elderman <henry.elderman.edu+linux@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/execmem.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/execmem.h~mm-execmem-fix-fallback_end-description-in-kernel-doc
+++ a/include/linux/execmem.h
@@ -89,7 +89,7 @@ static inline int execmem_restore_rox(vo
  * @end:	address space end (inclusive)
  * @fallback_start: start of the secondary address space range for fallback
  *                  allocations on architectures that require it
- * @fallback_end:   start of the secondary address space (inclusive)
+ * @fallback_end:   end of the secondary address space (inclusive)
  * @pgprot:	permissions for memory in this address space
  * @alignment:	alignment required for text allocations
  * @flags:	options for memory allocations for this range
_

Patches currently in -mm which might be from henry.elderman.edu@gmail.com are

mm-execmem-fix-fallback_end-description-in-kernel-doc.patch

