Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971183A7F70
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068032; cv=none; b=fZS61JJ/hSPQL0BtZggqPX4OC6VOoKKdbdhSqS27PL1shIzvk13dwV1r4xFKVnUsGmxHcEuWVzxEIWTf6JjCYVy3NA/JMCkX/Hp5+p0YU7iqPqKxXCfWyix+b5VY4k8DPMT/OrtVPLuCMi2U40RKluBx4xTZa7vLVOLuQ3yiamw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068032; c=relaxed/simple;
	bh=xkwpKeL+44HAIdma13NDXw79/Jzra6gtQkKbX0RZ8NA=;
	h=Date:To:From:Subject:Message-Id; b=uoE5c1WWbXAe2qHnwpXgO75P5dJgxc5MR6N429/E74GuQ4tKRIah5kcyHyZ95jsdAqFB/w88tqYsA+EeW3STYjBQQeIDE9JdVTlEz/wV8A3AAdSgI0b1B5G2wgKHU3UHF9MmZXqNtH7Me0H9l+yvt8TvZI/2Ms+CUc4JJI2OBLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z8h89IbD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z8h89IbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478601F00ACF;
	Fri,  7 Aug 2026 02:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068027;
	bh=/ml2TXLxRWY7VukEPELw4M8MIbjdQf809UFI5aVK3mo=;
	h=Date:To:From:Subject;
	b=Z8h89IbDPN9yMvCNKB4VhEffdto7nxzbsGbkicHPJHt+YTUv8ZgvDcYdSgrJZ+LcG
	 bBkbwlDe48/9RiqTUnsEHNSAYFfzHRXiMSpp+YzfVDLhSxHPqRg/8EbV2TDNVnCeWm
	 HImHsw5hgs1icnc7v10gyHwLVu1i/lrLy3G4kA0I=
Date: Thu, 06 Aug 2026 19:00:26 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-abi-damon-document-tried_regions-probe-hits.patch removed from -mm tree
Message-Id: <20260807020027.478601F00ACF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document tried_regions probe hits
has been removed from the -mm tree.  Its filename was
     docs-abi-damon-document-tried_regions-probe-hits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Song Hu <husong@kylinos.cn>
Subject: Docs/ABI/damon: document tried_regions probe hits
Date: Tue, 14 Jul 2026 07:01:16 -0700

The 'tried_regions/<R>/probes/<P>/hits' file, added in commit 5b0de1bc3325
("mm/damon/sysfs-schemes: implement probe/hits file"), is described in
usage.rst but missing from the canonical ABI document.

Document the 'probes/' directory and the 'probes/<P>/hits' file.

Link: https://lore.kernel.org/20260714140117.94147-5-sj@kernel.org
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-tried_regions-probe-hits
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -650,3 +650,15 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the size of the memory in the region
 		that passed DAMON operations layer-handled filters of the
 		scheme in bytes.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/probes/
+Date:		May 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Directory for DAMON data-attribute monitoring probes of the
+		region.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/tried_regions/<R>/probes/<P>/hits
+Date:		May 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Reading this file returns the number of data-attribute
+		monitoring probe-hit positive samples of the region.
_

Patches currently in -mm which might be from husong@kylinos.cn are


