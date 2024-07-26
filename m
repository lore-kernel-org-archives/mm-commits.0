Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817AA148FFA;
	Fri, 26 Jul 2024 20:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722026290; cv=none; b=QpxL6WwWp1LKrOPHzvH5ESvqLGvmpzzCrrhLP4FObnzXovtkcctO1nQw95CcB0T2mnfWciAK/GOTO2iPOxwhvaTIN1nq1B4Kzf0HF/FxlTNlTv1CyYnoCw4evd0GDZ9oCXA9TGv+DGN52H/pHmLxzTQIUWk15GluHEZ3Z/0Uwpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722026290; c=relaxed/simple;
	bh=pz6ECY4fRJSzNN1ne+YT6pjjXxUDj7gSVW6Rz5Cs6bw=;
	h=Date:To:From:Subject:Message-Id; b=u9eVUqtGotzwKhpPeEieXvwDW5WD4ubOE5WNvRFRB3sFqfwd+7eaLU+s4R/SDCbmmlsriYp23MkKZlcN3yXrU/rTY3dvJVkRFL9DopFn80+0smscPfZY/h2KSbfP4CCmcKbJdC1QM6wA8s3BEjrzDaGyxhftQdRn2AXYacbAn/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JrtZ2uRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JrtZ2uRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12EA8C32782;
	Fri, 26 Jul 2024 20:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722026290;
	bh=pz6ECY4fRJSzNN1ne+YT6pjjXxUDj7gSVW6Rz5Cs6bw=;
	h=Date:To:From:Subject:From;
	b=JrtZ2uRrGkERvNza8aSh1UnjxDPYAD8/gqPDhG/TUlMC0IZMkbE9/jXFdoLFMOvcP
	 +tCNrc2DexUWPDt3sez5JXRAysQzMoWeQ6KYCq8ldgu1qTwmu61wTA69UgUYXdBXOg
	 7ASIDZ3So6gqq+NJFvaDLoMtav1PmTFWGvmdc15w=
Date: Fri, 26 Jul 2024 13:38:09 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,stable@vger.kernel.org,riel@surriel.com,jirislaby@kernel.org,david@redhat.com,corsac@debian.org,cl@linux.com,carnil@debian.org,ben@decadent.org.uk,yang@os.amperecomputing.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-use-config_64bit-to-relax-huge-page-alignment-on-32-bit-machines.patch removed from -mm tree
Message-Id: <20240726203810.12EA8C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: use !CONFIG_64BIT to relax huge page alignment on 32 bit machines
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-config_64bit-to-relax-huge-page-alignment-on-32-bit-machines.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yang Shi <yang@os.amperecomputing.com>
Subject: mm: huge_memory: use !CONFIG_64BIT to relax huge page alignment on 32 bit machines
Date: Fri, 12 Jul 2024 08:58:55 -0700

Yves-Alexis Perez reported commit 4ef9ad19e176 ("mm: huge_memory: don't
force huge page alignment on 32 bit") didn't work for x86_32 [1].  It is
because x86_32 uses CONFIG_X86_32 instead of CONFIG_32BIT.

!CONFIG_64BIT should cover all 32 bit machines.

[1] https://lore.kernel.org/linux-mm/CAHbLzkr1LwH3pcTgM+aGQ31ip2bKqiqEQ8=FQB+t2c3dhNKNHA@mail.gmail.com/

Link: https://lkml.kernel.org/r/20240712155855.1130330-1-yang@os.amperecomputing.com
Fixes: 4ef9ad19e176 ("mm: huge_memory: don't force huge page alignment on 32 bit")
Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
Reported-by: Yves-Alexis Perez <corsac@debian.org>
Tested-by: Yves-Alexis Perez <corsac@debian.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Christoph Lameter <cl@linux.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>	[6.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-config_64bit-to-relax-huge-page-alignment-on-32-bit-machines
+++ a/mm/huge_memory.c
@@ -877,7 +877,7 @@ static unsigned long __thp_get_unmapped_
 	loff_t off_align = round_up(off, size);
 	unsigned long len_pad, ret, off_sub;
 
-	if (IS_ENABLED(CONFIG_32BIT) || in_compat_syscall())
+	if (!IS_ENABLED(CONFIG_64BIT) || in_compat_syscall())
 		return 0;
 
 	if (off_end <= off_align || (off_end - off_align) < size)
_

Patches currently in -mm which might be from yang@os.amperecomputing.com are


