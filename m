Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ECA3DA7CC
	for <mm-commits@vger.kernel.org>; Fri,  4 Sep 2026 17:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788544138; cv=none; b=HrQw3KEmfHMghzfHrZ1xdWVV9xYP9UoTwTKKzoEl3GKMmgGgfEj7AyCKZka4KlbEmErTqMN9nsg9qpjs3Y+jNQeApEiMdbXyF5hLTYhj069Ht8P5DKvfOoS8Dvriq63NAoLkf8KW+9aBzAPrdO78yVN1j89Pm/Iq58B0TzYzh3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788544138; c=relaxed/simple;
	bh=D0TDeUzPzKHmqhKMbKoCKVqBgYMzWt40IW9MV3q1I4A=;
	h=Date:To:From:Subject:Message-Id; b=mnVbP1R3AAKEX94RAkVbuYFG8Rbfu/FhFPBdITxMIdP8UjcRY+zr9Po3Moh0yVipe9uvQKJM7945czWc7083MNIDw228pDbvkDiV6v9whjP15aR0ImVFR5IKgEHO2ThtHI8TjY+QZXoelzj06t16bMP+pP737S0uzVst7DZZMVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CFyUsoFU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CFyUsoFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10501F00A3D;
	Fri,  4 Sep 2026 17:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788544137;
	bh=grCHhCPxkAG6zeYcLRtqASMESxAawb6xDPRKm1ggEwo=;
	h=Date:To:From:Subject;
	b=CFyUsoFUIE8JlbPuszuIGCeWVlAdYFcOtHJmnm1kdPJZF5c2jOMDb+XD5y6MiEhkT
	 t/wE9DJaAoGAVP/xQhVI4j1SGotcZm/T7WpEi21ebER5odIMxthjXfo1rpvrUd5lnK
	 9CpwXiRIcUyKgsQw6yetnocm1Mh+Yv5+ST+kWn3U=
Date: Fri, 04 Sep 2026 10:48:56 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,almasrymina@google.com,akpm@linux-foundation.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-restore-hidden-hugetlb-reservation-scenarios.patch removed from -mm tree
Message-Id: <20260904174856.E10501F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: restore hidden hugetlb reservation scenarios
has been removed from the -mm tree.  Its filename was
     selftests-mm-restore-hidden-hugetlb-reservation-scenarios.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Song Hu <husong@kylinos.cn>
Subject: selftests/mm: restore hidden hugetlb reservation scenarios
Date: Tue, 14 Jul 2026 10:16:30 +0800

A stray 'continue' in the main loop of charge_reserved_hugetlb.sh made the
"more than reservation", "more than cgroup limit", and "multiple cgroups"
scenarios unreachable, so they never ran.

Remove it so the first two run again.  The third,
run_multiple_cgroup_test(), is separately broken -- a backslash
line-continuation breaks its local declarations and its hugetlb
reservation accounting does not charge as expected -- and has never run in
CI; skip it explicitly with a comment until fixed.  Also correct two `[[
"$method" == 2"" ]]` typos (harmless empty-string concatenation) to plain
`2`.

Link: https://lore.kernel.org/20260714021630.1063823-1-husong@kylinos.cn
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |   14 +++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-restore-hidden-hugetlb-reservation-scenarios
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -439,11 +439,11 @@ for populate in "" "-o"; do
         fi
 
         # Skip populated shmem tests. Doesn't seem to be supported.
-        if [[ "$method" == 2"" ]] && [[ "$populate" == "-o" ]]; then
+        if [[ "$method" == 2 ]] && [[ "$populate" == "-o" ]]; then
           continue
         fi
 
-        if [[ "$method" == 2"" ]] && [[ "$reserve" == "-n" ]]; then
+        if [[ "$method" == 2 ]] && [[ "$reserve" == "-n" ]]; then
           continue
         fi
 
@@ -496,7 +496,6 @@ for populate in "" "-o"; do
         echo 'PASS'
 
         cleanup
-        continue
         echo
         echo
         echo
@@ -530,6 +529,15 @@ for populate in "" "-o"; do
 
         cleanup
 
+        # The "multiple cgroups" scenario (run_multiple_cgroup_test) is
+        # multiply broken and has never run in CI: a backslash
+        # line-continuation breaks its local declarations, it passes
+        # reservation sizes in bytes rather than pages (unlike
+        # run_test), and its assertions compare page counts to byte
+        # values. Skip it until properly rewritten; the two scenarios
+        # above are restored by this change.
+        continue
+
         echo
         echo
         echo
_

Patches currently in -mm which might be from husong@kylinos.cn are

selftests-mm-emit-tap-header-in-uffd-wp-mremap.patch
selftests-mm-emit-tap-header-and-use-tap-skip-in-mremap_test.patch
selftests-mm-restore-enable_soft_offline-in-hugetlb-soft-offline.patch

