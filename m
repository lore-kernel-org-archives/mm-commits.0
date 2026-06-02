Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76C33C871D
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439223; cv=none; b=TWimxijCg8LkYNm20xrgaaIB37+wXvu7/QQBaxId9usTSRHQvQAnLTIZZX8Si8ZETXKDttdqaG9E/GO0vTRd+IiRX24qAlKZ7yT0eI/nh1P1DZvYk+enlu6ywJ0uTWvT5I/JjOFLIO5AOgVhiSIR19mF+aLiHu4zPaPetzrkMWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439223; c=relaxed/simple;
	bh=5fciW2rCe+d6Ss1xUklcmk65Mv9zc2BQs/Bbi31eU0o=;
	h=Date:To:From:Subject:Message-Id; b=H1qVmb4frWtgu/j2ZjMxYKlzwU3L+ksG3q7PTqGV72wwlgkK0HXGQur7sPnn6wYbnghbdBeHnho+vIPQpcekydEDkuN/z6xoeCYgHORJEVMFAegxD7sRpHJCU6XMARKrizDvnmOw246tLYlVcdXKiKb1BknzLukCj/abFm+WLPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t8/bKKoH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t8/bKKoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9191F00893;
	Tue,  2 Jun 2026 22:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439222;
	bh=/XBF1TmNVtEvpt/nviT9LZGZGVkUZj/F20VcPnOYS2E=;
	h=Date:To:From:Subject;
	b=t8/bKKoHDrXyd3+XvrCzz85xFgqRyTpT5g0vU7o+eNqHpfFgF5UHdVwxIN3/zn2eB
	 uo6ktryxw0ziJB8ovXrYrtxN0Bg9RJ64dF1QikKLKiJPpdn0ogwpugWT8UzbsmQ2yE
	 2f91MpOe6I3n9qLEg4UB8NAUzrda0TdwHDH8cyzw=
Date: Tue, 02 Jun 2026 15:27:02 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,osalvador@kernel.org,ljs@kernel.org,liam@infradead.org,david@kernel.org,bmasney@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-add-vmrst-to-memory-management-core.patch removed from -mm tree
Message-Id: <20260602222702.BC9191F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add vm.rst to memory management core
has been removed from the -mm tree.  Its filename was
     maintainers-add-vmrst-to-memory-management-core.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brian Masney <bmasney@redhat.com>
Subject: MAINTAINERS: add vm.rst to memory management core
Date: Thu, 28 May 2026 09:56:14 -0400

The vm.rst file is currently not listed in the MAINTAINERS file, so let's
go ahead and add to the MM core subsystem so that the maintainers are CCed
when changes to the documentation are proposed.

Link: https://lore.kernel.org/20260528-mm-vm-rst-maintainers-file-v1-1-306631c0a610@redhat.com
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-vmrst-to-memory-management-core
+++ a/MAINTAINERS
@@ -16781,6 +16781,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/admin-guide/sysctl/vm.rst
 F:	include/linux/folio_batch.h
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
_

Patches currently in -mm which might be from bmasney@redhat.com are


