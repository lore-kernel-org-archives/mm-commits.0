Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5985E34A79B
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 19:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517834; cv=none; b=FPFDIEPNnePm9M6+N/Ss9ejmE3O5HyCCh6k1DxugBCrO+CHpiMWmYb8Ei/C3Bnj9h4+SuGsGTSg5xcvBJ1ENRXue9p285Qa9Jxka/m3V7ZvQcg4ZiuLESsshPK8aCxxpbOakfXaltjdsOGjXITTUEZCa7LTusb826SimPkosPzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517834; c=relaxed/simple;
	bh=HnuoWHCrTh6Ruy8OhqXdb7Ht9d9imzX+/wve+qO71ns=;
	h=Date:To:From:Subject:Message-Id; b=GRc2Z4rthPyUdMU317HquViVGJQZzWgiJ/BYwQIJzHjwoxnBv6sl5uly7RB1Z53Ye2PRkNcLp0k1LKY51MHJhxDxoIV/sGpk97gGf8+m/kqYdut39/4q5dmEw/q2rsbd+pKEx7HZK3r+vC+EA55u0qOR6PzS6BKMf5/epu0WDNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z5qAdmvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z5qAdmvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE543C116D0;
	Tue, 23 Dec 2025 19:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517834;
	bh=HnuoWHCrTh6Ruy8OhqXdb7Ht9d9imzX+/wve+qO71ns=;
	h=Date:To:From:Subject:From;
	b=Z5qAdmvrdqFj5H/LvgKL+6rrde4/7ClBke5BWnRXc1M81E7sbZZDMcfnbVnm3WDd+
	 tmMq2cG7wL+JYoUBTdhP8++ODTQ/PaJpnlSr8LM4FxX8omGjo3SNYRwQdXzGhCwpgU
	 JpmgulYKAJNp6JSY0HwO51IFmrkSZaTr6Yr05CCs=
Date: Tue, 23 Dec 2025 11:23:53 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-mike-rapoport-as-maintainer-for-userfaultfd.patch removed from -mm tree
Message-Id: <20251223192353.DE543C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Mike Rapoport as maintainer for userfaultfd
has been removed from the -mm tree.  Its filename was
     maintainers-add-mike-rapoport-as-maintainer-for-userfaultfd.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: add Mike Rapoport as maintainer for userfaultfd
Date: Tue, 25 Nov 2025 15:29:08 +0200

Link: https://lkml.kernel.org/r/20251125132908.847055-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-mike-rapoport-as-maintainer-for-userfaultfd
+++ a/MAINTAINERS
@@ -16751,6 +16751,7 @@ F:	tools/testing/selftests/mm/transhuge-
 
 MEMORY MANAGEMENT - USERFAULTFD
 M:	Andrew Morton <akpm@linux-foundation.org>
+M:	Mike Rapoport <rppt@kernel.org>
 R:	Peter Xu <peterx@redhat.com>
 L:	linux-mm@kvack.org
 S:	Maintained
_

Patches currently in -mm which might be from rppt@kernel.org are


