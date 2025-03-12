Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAE21F03F1
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 22:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741818413; cv=none; b=eGeIGo/omOqHQgiG2RwgBy8C2Re51kGjG0+6rPBVjvLeL/R5plo7mZ541P7KP6j2yP6wotJK4q1YEEY2lBeBKrmKxTLRF4F7SnieTRkR/sFugGBvrzFxYTNw7fyG7zQ+miApiow7TzFwoKifGrxqufb1j4s+Ej7FNFAupbCkM6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741818413; c=relaxed/simple;
	bh=ky1awXJMLrrV2OEuojOq+IYeRx/0B39t/xihg51SctA=;
	h=Date:To:From:Subject:Message-Id; b=BJyyNw4SOHIE2BVzz8fKV965nCv7b6hsUY2QmAHWbrn4tfgLt5hrOJZbpMn6BFxJ6LX8DYfkkHxrG7plDcKxeFlhbWBP+JZW78U2DkYQryJUKqHbDNN4b5oppJ0gOZSEGE8WXvh4ko2eegNczom2IonRgjzXbGoLjUXX/6NB2h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X0MIObOD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X0MIObOD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3555AC4CEEB;
	Wed, 12 Mar 2025 22:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741818413;
	bh=ky1awXJMLrrV2OEuojOq+IYeRx/0B39t/xihg51SctA=;
	h=Date:To:From:Subject:From;
	b=X0MIObODc4It+N/+L9aIv4TQ5AVO66Zbe3AXygUJse6AiNiJK9+zP3lGLi4eASnM6
	 3vrEFM9Ku/kSeaeVTFozISkLQcsvzdFAbIGZVJies/Sl5HixN0SBqnJV2mOSqE3O7E
	 P0JFsP1j+qL7uxhSOdmtqpSvNo6TgCx3RZo8DBFg=
Date: Wed, 12 Mar 2025 15:26:52 -0700
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,Liam.Howlett@Oracle.com,lukas.bulwahn@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-adjust-file-entry-in-maple-tree.patch added to mm-unstable branch
Message-Id: <20250312222653.3555AC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: adjust file entry in MAPLE TREE
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-adjust-file-entry-in-maple-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-adjust-file-entry-in-maple-tree.patch

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
From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: MAINTAINERS: adjust file entry in MAPLE TREE
Date: Wed, 12 Mar 2025 11:52:45 +0100

Commit 0f3b602e1bad ("tools: separate out shared radix-tree components")
moves files from radix-tree/linux to shared/linux in the ./tools/testing/
directory, but misses to adjust a file entry in MAPLE TREE.  Hence,
./scripts/get_maintainer.pl --self-test=patterns complains about a broken
reference.

Adjust the file entry in MAPLE TREE.

Link: https://lkml.kernel.org/r/20250312105245.216302-1-lukas.bulwahn@redhat.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-adjust-file-entry-in-maple-tree
+++ a/MAINTAINERS
@@ -13922,8 +13922,8 @@ F:	include/linux/maple_tree.h
 F:	include/trace/events/maple_tree.h
 F:	lib/maple_tree.c
 F:	lib/test_maple_tree.c
-F:	tools/testing/radix-tree/linux/maple_tree.h
 F:	tools/testing/radix-tree/maple.c
+F:	tools/testing/shared/linux/maple_tree.h
 
 MARDUK (CREATOR CI40) DEVICE TREE SUPPORT
 M:	Rahul Bedarkar <rahulbedarkar89@gmail.com>
_

Patches currently in -mm which might be from lukas.bulwahn@redhat.com are

maintainers-adjust-file-entry-in-maple-tree.patch

