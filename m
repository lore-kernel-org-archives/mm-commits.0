Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933323064A4
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308388; cv=none; b=Yu97MeL3jIynT0xsSmUdijWIk4ltoxVMJAK2o9hAPz1Nwg+FCSNimAtjxLcMDLoHyRQXRFFEYbcT/Yxm7TMuoEXsRQ2Phu2ln/NZWLxLM4X3aCmPCKXqiaSt4gYEsjjFo169F1dOZ0fGiF4fPZSMAB0DG6DkvzI5J33g9K+QuUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308388; c=relaxed/simple;
	bh=mV0zYKhCgovoTDX8ce0e8AmkVXNFBVYB9JyS4BLuHhk=;
	h=Date:To:From:Subject:Message-Id; b=uKC3waW/3aTkcBxnZ6wda1DL3Wgy+TtPEVj96TI5SDdq9mynQeFVSDKsFKuPcTHjEYrXBvswOPfh5EQHSrbYyryfQ/dY3LP50PMl148rVg9+lC+Zqbqvp3YfrShghjncFR0XJh5IsHF7ntrJjzXqcCdSgK0A6L+OYjfGl8kgw+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b1HoPkcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b1HoPkcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040F7C4CEF5;
	Tue,  9 Dec 2025 19:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308388;
	bh=mV0zYKhCgovoTDX8ce0e8AmkVXNFBVYB9JyS4BLuHhk=;
	h=Date:To:From:Subject:From;
	b=b1HoPkcwpukV1NORIldUexlnZ0JL2AZKOJKl8P3ESJ2RRl4/IDDhQ58bC1rjRWusp
	 1IvvqVNFD+9M+MJu46NeUIlErVP/V2nppABm1lFpVQmw2YCCIsuL2EKu7vNShK/8rN
	 /ACC0A9V1YjKzLxjqmLUk3d/K4IlsVuLOKqAsSIw=
Date: Tue, 09 Dec 2025 11:26:27 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,aliceryhl@google.com,lukas.bulwahn@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-config-option-typo-in-header-file.patch removed from -mm tree
Message-Id: <20251209192628.040F7C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix CONFIG_STACK_GROWSUP typo in mm.h
has been removed from the -mm tree.  Its filename was
     mm-fix-config-option-typo-in-header-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: mm: fix CONFIG_STACK_GROWSUP typo in mm.h
Date: Mon, 1 Dec 2025 13:29:22 +0100

Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly
refactors the header file include/linux/mm.h.  In that step, it introduces
a typo in an ifdef, referring to a non-existing config option
STACK_GROWS_UP, whereas the actual config option is called STACK_GROWSUP.

Fix this typo in the mm header file.

Link: https://lkml.kernel.org/r/20251201122922.352480-1-lukas.bulwahn@redhat.com
Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-fix-config-option-typo-in-header-file
+++ a/include/linux/mm.h
@@ -438,7 +438,7 @@ enum {
 #define VM_NOHUGEPAGE	INIT_VM_FLAG(NOHUGEPAGE)
 #define VM_MERGEABLE	INIT_VM_FLAG(MERGEABLE)
 #define VM_STACK	INIT_VM_FLAG(STACK)
-#ifdef CONFIG_STACK_GROWS_UP
+#ifdef CONFIG_STACK_GROWSUP
 #define VM_STACK_EARLY	INIT_VM_FLAG(STACK_EARLY)
 #else
 #define VM_STACK_EARLY	VM_NONE
_

Patches currently in -mm which might be from lukas.bulwahn@redhat.com are


