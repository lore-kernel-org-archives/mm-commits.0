Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90D71C6F66
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 07:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150142; cv=none; b=u/lVrIuX+OjYFc079CfjAwSwwuA9L7ujSX2SRZ16prlLBqdvuSsVyLxrPvmjCmtlbgqGIiCeoV8WiE+E1W1w7AO/0XkAnxB87ms8KM+Prblw434LC7HblbaAyw2RSZYhm9Q4w7UxFoC60xY5MraJvyJex1MdAV620v3m/TWTz6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150142; c=relaxed/simple;
	bh=hkZIWf1gFvdVhkykDj5QpA2LuuZ1G8qCYCZJVzeSMEU=;
	h=Date:To:From:Subject:Message-Id; b=SPppH/YwVwF8gftY4yaud1YWPGs1qNjeiko/CgJrba6keen8M/XmEA5yOJjnu1C+OJZz4+5LnC8bahhbpyDkyR2U42FUiR3UQMCpZPdqktM5H5u/R7vlNOBKIKK5d9liLvndhh+9ZUrfYySa8HvrJbNE3BRKD87QC0XA74d168o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qghlz+xH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qghlz+xH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2F4C4CEC3;
	Thu, 17 Oct 2024 07:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150141;
	bh=hkZIWf1gFvdVhkykDj5QpA2LuuZ1G8qCYCZJVzeSMEU=;
	h=Date:To:From:Subject:From;
	b=qghlz+xHPTGdr9VK2zF4EbdUqhtizFgxzIP6Rb7EUotDN5l990zyNvGu/iEE9EJPQ
	 K1TD1JWC2QvS8m2LjRBAijclNKO/OOGSUfR3pru6w1uf+ZNyhjjRmyZ4WFID3u56tH
	 WTcOrFAqjOvtFat+31Ab6ssOzu50wM+IZypsK0jI=
Date: Thu, 17 Oct 2024 00:29:01 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-myself-as-memory-mapping-vma-reviewer.patch removed from -mm tree
Message-Id: <20241017072901.BF2F4C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Jann as memory mapping/VMA reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-memory-mapping-vma-reviewer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: MAINTAINERS: add Jann as memory mapping/VMA reviewer
Date: Mon, 14 Oct 2024 22:50:57 +0200

Add myself as a reviewer for memory mapping / VMA code.  I will probably
only reply to patches sporadically, but hopefully this will help me keep
up with changes that look interesting security-wise.

Link: https://lkml.kernel.org/r/20241014-maintainers-mmap-reviewer-v1-1-50dce0514752@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-myself-as-memory-mapping-vma-reviewer
+++ a/MAINTAINERS
@@ -14912,6 +14912,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
@@ -24742,6 +24743,7 @@ M:	Andrew Morton <akpm@linux-foundation.
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
 M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
 R:	Vlastimil Babka <vbabka@suse.cz>
+R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	https://www.linux-mm.org
_

Patches currently in -mm which might be from jannh@google.com are

mm-mark-mas-allocation-in-vms_abort_munmap_vmas-as-__gfp_nofail.patch

