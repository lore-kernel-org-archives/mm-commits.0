Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E3177A01
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 17:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708451687; cv=none; b=ij49pttBxm3+H64O2A0lh31m1kJ15mL7yWK/09ByJVKRhMVbuns877O1vXfKaMb7+BD9iVVgg1b5bG4UWakk643T/zeyptltAVhyugTQqR1QNeFYzakwa8HqQmtcPMHjbrqNcW1T1kDOK0o2TJUXObgJvkcbW6JRE/aqzrDEMLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708451687; c=relaxed/simple;
	bh=K/S7vhXON189UDW8TIAIIKhCHBiDoA9Yk3t0rXIEdDI=;
	h=Date:To:From:Subject:Message-Id; b=LetMc8XfWiynfPyuq/O0rVR7mMq3ZLrXpEwT4T/hpbnkGX5ABUceAauHlsBNXq9DLHhd90+fxBgwgg+ChmUQwAhOe7G4oivGwpD0ELR0xkUBlLB0A9buo9t0hqPtWXsPKi9JC25QHAQlnUcHIacwXu1kIKJ7HlgcojoAmtDuvk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QOGni6Hj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QOGni6Hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9783CC433C7;
	Tue, 20 Feb 2024 17:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708451686;
	bh=K/S7vhXON189UDW8TIAIIKhCHBiDoA9Yk3t0rXIEdDI=;
	h=Date:To:From:Subject:From;
	b=QOGni6HjjDlOhUYyFKs11pEnM3VuboQGoMtO3SXEPumcL+HlBSeucKkfYOhioI6dD
	 l2XEXPfPbU5sYBmcm500uWp9rWsg09a8LfeckahLAk1CJN31xfj/RKuVWlP6HBsHis
	 TFHAsMYX9soTGH1xEkYd/PJl4sYAGKSzv+Nz6RKA=
Date: Tue, 20 Feb 2024 09:54:46 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,Liam.Howlett@oracle.com,lstoakes@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-memory-mapping-entry-with-reviewers.patch added to mm-hotfixes-unstable branch
Message-Id: <20240220175446.9783CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add memory mapping entry with reviewers
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-add-memory-mapping-entry-with-reviewers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-memory-mapping-entry-with-reviewers.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: MAINTAINERS: add memory mapping entry with reviewers
Date: Tue, 20 Feb 2024 06:44:10 +0000

Recently there have been a number of patches which have affected various
aspects of the memory mapping logic as implemented in mm/mmap.c where it
would have been useful for regular contributors to have been notified.

Add an entry for this part of mm in particular with regular contributors
tagged as reviewers.

Link: https://lkml.kernel.org/r/20240220064410.4639-1-lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/MAINTAINERS~maintainers-add-memory-mapping-entry-with-reviewers
+++ a/MAINTAINERS
@@ -14111,6 +14111,17 @@ F:	mm/
 F:	tools/mm/
 F:	tools/testing/selftests/mm/
 
+MEMORY MAPPING
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Lorenzo Stoakes <lstoakes@gmail.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	mm/mmap.c
+
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Richard Weinberger <richard@nod.at>
_

Patches currently in -mm which might be from lstoakes@gmail.com are

maintainers-add-memory-mapping-entry-with-reviewers.patch

