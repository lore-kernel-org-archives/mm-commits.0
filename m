Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7330F4C6E
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 22:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719355651; cv=none; b=QjwwGgKhwo8acFUSIwmICvXIHx6cVipygf4N0HH8Q945r6rFF4DFoxWm7kfw6TiejprM2E4d1iNMPVq3IkR+KbdD0qhCz12hcFGtzdTVYBa08ZMH8PC6xsgOTbYvFyJ5hsktR5IPSY6QxYN/BjgpSFtv6N1766Y47wl7biKjW4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719355651; c=relaxed/simple;
	bh=tmfRB/nf+Jgmsp/KSenJDBrk5g1er2Xdl9L5N20JpFE=;
	h=Date:To:From:Subject:Message-Id; b=VmOA4Pf6nr2ZlNTJuorFtLRuZeejInjQ31FwR0u8rDRvEVFnd7ICIFKuEJFKJrwrd2hb85DXsieSCcEEAutE6bAw2sCJeNnnyQeMhBPoeAkAbTCK5N2oVxt7DDrUW//kwt0k9HfoIovUuoGCUx+i2FwJI5sKg/xoIqrNc8aE5zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SKp+Axxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SKp+Axxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9935C32781;
	Tue, 25 Jun 2024 22:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719355651;
	bh=tmfRB/nf+Jgmsp/KSenJDBrk5g1er2Xdl9L5N20JpFE=;
	h=Date:To:From:Subject:From;
	b=SKp+AxxeZkgdrjU7ZD32fOeY61wDN49RrNmZzG4SL9356Dnsbr67MRsch4M565rEA
	 Ejmzg33/wDmOwxUQbtc++KdbRSg8O9rB3ekvS6jx4AmLA06ioZ5/bN2iI9cB+iyg4L
	 dju9kc/PKxEBGWgvDhkzPzT20y3sLQRwcA93ZJPo=
Date: Tue, 25 Jun 2024 15:47:30 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rientjes@google.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,linmiaohe@huawei.com,jiaqiyan@google.com,jane.chu@oracle.com,fvdl@google.com,corbet@lwn.net,ak@linux.intel.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-refactor-log-format-in-soft-offline-code-fix.patch added to mm-unstable branch
Message-Id: <20240625224730.D9935C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-failure-refactor-log-format-in-soft-offline-code-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-refactor-log-format-in-soft-offline-code-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-refactor-log-format-in-soft-offline-code-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memory-failure-refactor-log-format-in-soft-offline-code-fix
Date: Tue Jun 25 03:46:01 PM PDT 2024

add `:' to message, per Miaohe

Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-refactor-log-format-in-soft-offline-code-fix
+++ a/mm/memory-failure.c
@@ -2710,7 +2710,7 @@ static int soft_offline_in_use_page(stru
 	if (PageHWPoison(page)) {
 		folio_unlock(folio);
 		folio_put(folio);
-		pr_info("%#lx page already poisoned\n", pfn);
+		pr_info("%#lx: page already poisoned\n", pfn);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

hack.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type-fix.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch
tools-mm-introduce-a-tool-to-assess-swap-entry-allocation-for-thp_swapout-fix.patch
mm-memory-failure-refactor-log-format-in-soft-offline-code-fix.patch

