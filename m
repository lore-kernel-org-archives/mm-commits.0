Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1741223E33A;
	Sat,  9 Aug 2025 00:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754700099; cv=none; b=GsI228OKzOWR4KAYdv3lTEuE3uBzZTJ+Cdd/WOcYtpfoS6BSWjMocqYJDX5MHk3DVO/rs6ezph0zhYxOYflWkWWy8vT9S95PYEwtzJ+CpQW4JkWr3msd1pehYTBbE+bxIf7VYXJ9Nuu6lYHxe47AXuaBETF9AHe7CXIuuD60wzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754700099; c=relaxed/simple;
	bh=Y443LAT/u6yga3inM0r7Iq2bpj4O+qXywc4v28hHExo=;
	h=Date:To:From:Subject:Message-Id; b=iaAr79TuoOarRUZlwRCQJb3kNl3eUx3HCIZnl1nRT8XhQcujFzspegVYP88TCKogV1Dz4GqTOKcoA/8fjSt3w2NewTU00/1D1WNhbRorxMnei6CiUn+P68yztyHQEryi7br+JOuEaGE6bd/QiaV8gpzIuhhhMmd58uYIXFXpz28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pTSCRZul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pTSCRZul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FE6C4CEED;
	Sat,  9 Aug 2025 00:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754700098;
	bh=Y443LAT/u6yga3inM0r7Iq2bpj4O+qXywc4v28hHExo=;
	h=Date:To:From:Subject:From;
	b=pTSCRZulALrThxLJgx8EtX6qM3KibJQd5zP3BONgOemnlA+AYBx8woWCYqDOCO5lv
	 ITmCrsZLsK7cI6MlUxbmtxPrTjcNFW8h8fLRQ84WR2V0NdYNcm52YkPJq4MHGTkUyh
	 cKhTmVhz2yXLal2pdAPnSNjv8+n6BaPL4CYZpIPU=
Date: Fri, 08 Aug 2025 17:41:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,kees@kernel.org,graf@amazon.com,ebiggers@google.com,dave@vasilevsky.ca,coxu@redhat.com,changyuanl@google.com,bhe@redhat.com,arnd@arndb.de,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-warn-if-kho-is-disabled-due-to-an-error.patch added to mm-hotfixes-unstable branch
Message-Id: <20250809004138.C7FE6C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: warn if KHO is disabled due to an error
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kho-warn-if-kho-is-disabled-due-to-an-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-warn-if-kho-is-disabled-due-to-an-error.patch

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
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: kho: warn if KHO is disabled due to an error
Date: Fri, 8 Aug 2025 20:18:04 +0000

During boot scratch area is allocated based on command line parameters or
auto calculated.  However, scratch area may fail to allocate, and in that
case KHO is disabled.  Currently, no warning is printed that KHO is
disabled, which makes it confusing for the end user to figure out why KHO
is not available.  Add the missing warning message.

Link: https://lkml.kernel.org/r/20250808201804.772010-4-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/kexec_handover.c~kho-warn-if-kho-is-disabled-due-to-an-error
+++ a/kernel/kexec_handover.c
@@ -564,6 +564,7 @@ err_free_scratch_areas:
 err_free_scratch_desc:
 	memblock_free(kho_scratch, kho_scratch_cnt * sizeof(*kho_scratch));
 err_disable_kho:
+	pr_warn("Failed to reserve scratch area, disabling kexec handover\n");
 	kho_enable = false;
 }
 
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

kho-init-new_physxa-phys_bits-to-fix-lockdep.patch
kho-mm-dont-allow-deferred-struct-page-with-kho.patch
kho-warn-if-kho-is-disabled-due-to-an-error.patch

