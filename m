Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A017230D406;
	Wed, 29 Jul 2026 00:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785285497; cv=none; b=nvRtbsPXyXcf/n1Xl944kIFWRq+bs76mUfmOprC49b+8amh+cvVMPtQdsynY4jQQ+fPCRaLjJa/uTIB/oc82/rNSzLHnjMwQUznmHbUJlmHGgQ0SmDoQBhBWAuv1VPLFjcmt5fLUnIcQ+sJel6kWUsMgVpPeYrvAabYVLDPC53g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785285497; c=relaxed/simple;
	bh=VqKw1SHSykoyNeZrks57mqAK0ujjyNSC/vvxbV1pMC8=;
	h=Date:To:From:Subject:Message-Id; b=UkeH5l4OZr15F9f+F8Uv7tFVeB4mRq1PdwbUTH2zVnrKXjlipJryPhPud0BSEIz/QHiJQyWUAo4MuDnkChCrq2LqTTVT1kwxyRN7es8g9HpzvVGQELPcVf6wCOtxO+7SboxUlVfFXfi38TcjdcoJIkeIczRREFOmg/qXBwirRFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vm6bA3qn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vm6bA3qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7596D1F00A3A;
	Wed, 29 Jul 2026 00:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785285496;
	bh=NX2L3Vg2GcMIyjFXGV3++rdIruMugjuGF3RZaWY78Ek=;
	h=Date:To:From:Subject;
	b=vm6bA3qnbTbiNq4rK7soU0U0wQJBLztj432i+BCsHuqaPu6NbWIQ4kTHbE77vDnM+
	 MRIKsAbFWYvOBnayR6qNP2DmXoz95x8S4e+VAI/7m/hF+oiQA5NczZRMOMXgfNmHBg
	 hgXEx/7nBggcj1/sRrgED1jsJ7hETHtGg4LIVgmQ=
Date: Tue, 28 Jul 2026 17:38:16 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,brauner@kernel.org,christian.gellermann@codasip.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-potential-wild-pointer-access-of-getline-due-to-missing-init.patch removed from -mm tree
Message-Id: <20260729003816.7596D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix potential wild pointer access of getline due to missing init
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-potential-wild-pointer-access-of-getline-due-to-missing-init.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chris Gellermann <christian.gellermann@codasip.com>
Subject: selftests/mm: fix potential wild pointer access of getline due to missing init
Date: Wed, 22 Jul 2026 15:02:46 +0200

This is another occurrence of using getline where the code assumes that
getline allocates memory to store the line, but the pointer passed to it
is uninitialized and potentially a non-null pointer.  This violates the
Open Group Spec[1] and caused a segfault in a similar situation in
selftest/clone3/clone3_set_tid.  Fix it by initializing the line pointer
to NULL.

The issue has been found by simply grepping through the selftest code
after running into the issue in clone3_set_tid.  Whether it segfaults in
its current state is unknown to me.  But it's good to be addressed due to
defensive reasons.

Link: https://lore.kernel.org/20260722130246.2135563-3-christian.gellermann@codasip.com
Link: https://pubs.opengroup.org/onlinepubs/9799919799/functions/getline.html [1]
Fixes: 26b4224d9961 ("selftests: expanding more mlock selftest")
Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/mlock-random-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/mlock-random-test.c~selftests-mm-fix-potential-wild-pointer-access-of-getline-due-to-missing-init
+++ a/tools/testing/selftests/mm/mlock-random-test.c
@@ -84,7 +84,7 @@ int get_proc_locked_vm_size(void)
 int get_proc_page_size(unsigned long addr)
 {
 	FILE *smaps;
-	char *line;
+	char *line = NULL;
 	unsigned long mmupage_size = 0;
 	size_t size;
 
_

Patches currently in -mm which might be from christian.gellermann@codasip.com are


