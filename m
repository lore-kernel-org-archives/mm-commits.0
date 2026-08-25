Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ED73839A9
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622997; cv=none; b=AF+a7EIXzcdKcATJk3i2pDEqdgFMEF8xxC8x6LtTlhTqUg/zhh0lVsjNP8+Dr6PyiM1fBzlj/NHwpJ9cAhVZHgTbS/YaUBoGMIu5hZaElWdmW7VKS7dQVZ+mRvzpdGLu2YIFfvrtE75iCJYJiCCW+nkBG60MUMBgkwv5Rv3QbMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622997; c=relaxed/simple;
	bh=ZLkj2VoJfirEks2W5joXA+gyda+aaZZ4JbiD4/y9fPA=;
	h=Date:To:From:Subject:Message-Id; b=JhGWdgbzcxtDq+uRJfSB3AVRARZ9NsGMd2keTtEBh3WRFRWF5ot5PGxPcD+zAsAb0ODQ8JusjmAcPTxUl8ka0NrOeGObzL1Fp1qPOXULptQcLpTKCT/gsDC1ZthBtbyMGR+nMjdKqSnPv2hPhqw3GnK54T85WYGIcGNAtsnKfJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c/YydO4h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c/YydO4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD1C1F00A3E;
	Tue, 25 Aug 2026 01:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622995;
	bh=KylLRPIKZZNn2F+6YJvR5EiYC7DuQBgYxEa0+a/HrCk=;
	h=Date:To:From:Subject;
	b=c/YydO4h3x4oPSiIcU48dtypCRTWLOPnujqReTHTeqTc6+Dx10yDLlOJXjDt1s+Kq
	 7HhgmE6VbVzPi3Cnqw2SPSyn3XhSfTHUVlPECSCvOOE7Sdao9PAH7HGW1PQ0dg3Gjr
	 pWBC2eAqn2MnrLlDW8Ijh7rhN4T+awLY6G+9bkQY=
Date: Mon, 24 Aug 2026 18:56:34 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,liam@infradead.org,jannh@google.com,adobriyan@gmail.com,kmehltretter@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-proc-make-proc-maps-race-work-with-read_implies_exec.patch removed from -mm tree
Message-Id: <20260825015635.5FD1C1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/proc: make proc-maps-race work with READ_IMPLIES_EXEC
has been removed from the -mm tree.  Its filename was
     selftests-proc-make-proc-maps-race-work-with-read_implies_exec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Karl Mehltretter <kmehltretter@gmail.com>
Subject: selftests/proc: make proc-maps-race work with READ_IMPLIES_EXEC
Date: Sat, 8 Aug 2026 22:03:12 +0200

test_maps_tearing_from_split times out when READ_IMPLIES_EXEC is set. 
This happens by default on pre-ARMv6 CPUs, which lack no-execute support.

split_vma() re-maps the first page with mod_info->prot | PROT_EXEC to make
it differ from its neighbours.  With READ_IMPLIES_EXEC the original
mapping is already executable, so no split occurs and the test hangs
waiting for the modifier child.

Use PROT_NONE for the split mapping, which always differs from its
readable neighbours.

Link: https://lore.kernel.org/20260808200312.6326-1-kmehltretter@gmail.com
Fixes: beb69e817246 ("selftests/proc: add /proc/pid/maps tearing from vma split test")
Assisted-by: Codex:gpt-5.6-terra
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-maps-race.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/proc/proc-maps-race.c~selftests-proc-make-proc-maps-race-work-with-read_implies_exec
+++ a/tools/testing/selftests/proc/proc-maps-race.c
@@ -490,7 +490,8 @@ static bool query_addr_at(int maps_fd, v
 
 static inline bool split_vma(FIXTURE_DATA(proc_maps_race) *self)
 {
-	return mmap(self->mod_info->addr, self->page_size, self->mod_info->prot | PROT_EXEC,
+	/* PROT_NONE differs from both readable neighbors. */
+	return mmap(self->mod_info->addr, self->page_size, PROT_NONE,
 		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0) != MAP_FAILED;
 }
 
_

Patches currently in -mm which might be from kmehltretter@gmail.com are


