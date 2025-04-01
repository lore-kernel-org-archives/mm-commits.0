Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8681E51E7
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 19:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743534383; cv=none; b=kqsoZbiLvIhDldJupohf3h/RTSVfjTYN3ZWEJLT5eDGcwnW3cSQaEMRzO3QsiBFWm7Wo0YguPHdbpFB9+ZPAFgMo5sUsSSjz3+oHKSe/xb/7UVXTTqJft6R7qRwK4I4noYtU0DOExhnh1SZg1hYMk/IkUe7NCQAYLPq6A89+lmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743534383; c=relaxed/simple;
	bh=zwP272J06wP7x4AUFk3M0MwS1nVKGgkA7CJ9bSMy5pA=;
	h=Date:To:From:Subject:Message-Id; b=jbNbf/Qad2Ip0MM6WThmfCLIWJqbY4APeNN8+NsC2p8rxN2mdK2mepcf77RQLRwXo6YPukdUbYG611kS4NzioaSw/WjZ+Hw2V37h+wNyA28dqE7m4aH9WItKTs8eNbGeesxGBw1vUt4kM71lo0mGS1ZjyMCYveygBuXtpCelzFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OHRlt6Uv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OHRlt6Uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E110C4CEE4;
	Tue,  1 Apr 2025 19:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743534383;
	bh=zwP272J06wP7x4AUFk3M0MwS1nVKGgkA7CJ9bSMy5pA=;
	h=Date:To:From:Subject:From;
	b=OHRlt6Uv3x0ilWc6dTS4FWO5zjUHZYwwOkJ5wOp8Bhlfdl2Eo9FZp9PS1PUUQ1BtZ
	 sctTPHXT2aKbTL7vEIqOnyoQTds8BmjUSZnf3Ul654APYs89qJvW6Ny6jeXA/egCBM
	 CF6mnpVAhy9pEmeiW+PrL8XO2vk57PjDpVk3tCkA=
Date: Tue, 01 Apr 2025 12:06:22 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] maintainers-add-myself-as-userfaultfd-reviewer-fix.patch removed from -mm tree
Message-Id: <20250401190623.3E110C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maintainers-add-myself-as-userfaultfd-reviewer-fix
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-userfaultfd-reviewer-fix.patch

This patch was dropped because it was folded into maintainers-add-myself-as-userfaultfd-reviewer.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: maintainers-add-myself-as-userfaultfd-reviewer-fix
Date: Sat Mar 22 06:02:12 PM PDT 2025

add include/linux/userfaultfd_k.h, per Mike

Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-userfaultfd-reviewer-fix
+++ a/MAINTAINERS
@@ -15227,6 +15227,7 @@ S:	Maintained
 F:	Documentation/admin-guide/mm/userfaultfd.rst
 F:	fs/userfaultfd.c
 F:	include/asm-generic/pgtable_uffd.h
+F:	include/linux/userfaultfd_k.h
 F:	include/uapi/linux/userfaultfd.h
 F:	mm/userfaultfd.c
 F:	tools/testing/selftests/mm/uffd-*.[ch]
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-myself-as-userfaultfd-reviewer.patch
mm-pgtable-convert-some-architectures-to-use-tlb_remove_ptdesc-v2-fix.patch

