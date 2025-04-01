Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C6321CC58
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545885; cv=none; b=Aj/SNI9qEB6KafvVPClxxC31fBmzNwuTTdfXaQmIwkRr/KTYFBckxil5ZM55Dj0ZW8SOGy3IofM0HVZ2pTERMm6gisbJNoO8VsunPak+Zl+sghD85pTDE1oE4MbTy+DgtoE0lblw7rEXjrUb9h8gJLNJaLxyasNtCtSnk5PlMI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545885; c=relaxed/simple;
	bh=Xr1c1C0m240oQGedMkZO3JDHfIqblEerZNztrn42a6s=;
	h=Date:To:From:Subject:Message-Id; b=t7aakGj0MhlIaI2N97W+SDXLJVA2hoG8gvXIiRmHafLibbZYmwyISOHmnX9jwiMSO7gIHCPAUqYtHZV/QVTXIUVXJim5hq6ymDZdg82h+saiKb/bq4z9TiOV1Ez0t76Nfv+tG/wKcj1lugl3kTxmwRy8wV+mMdiML1IfF9zK63s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jWaKLdbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jWaKLdbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25D9C4CEE4;
	Tue,  1 Apr 2025 22:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545884;
	bh=Xr1c1C0m240oQGedMkZO3JDHfIqblEerZNztrn42a6s=;
	h=Date:To:From:Subject:From;
	b=jWaKLdbNboarxVFiF4pb7UXGsJ1HOqdGkTASgwIhIoGNLVwi5G9z7sa7tJDDiWBF2
	 BPCq9ySzHHi5vTwVZQUoTI5+s+ftJvIyfyo6sIym/eH0UZyX+Urov3vkh6WAMqt9Bh
	 LUNQnIZl7ZSQ67M+g3wnd3cJBjGUFK0ko1j7W7nw=
Date: Tue, 01 Apr 2025 15:18:04 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,osalvador@suse.de,mhocko@suse.com,dan.j.williams@intel.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maintainers-fixup-userfaultfd-entry.patch removed from -mm tree
Message-Id: <20250401221804.B25D9C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: fixup USERFAULTFD entry
has been removed from the -mm tree.  Its filename was
     maintainers-fixup-userfaultfd-entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: MAINTAINERS: fixup USERFAULTFD entry
Date: Wed, 26 Mar 2025 23:55:38 +0200

Patch series "MAINTAINERS: add my isub-entries to MM part."

Following discussion at LSF/MM/BPF I'm adding execmem, secretmem and
numa memblocks sub-entries for MEMORY MANAGEMENT in MAINTAINERS.


This patch (of 4):

Change title to "MEMORY MANAGEMENT - USERFAULTFD" and make it sub-topic in
memory management and add missing include/linux/userfaultfd_k.h and
mailing list

Link: https://lkml.kernel.org/r/20250326215541.1809379-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20250326215541.1809379-2-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Willaims <dan.j.williams@intel.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/MAINTAINERS~maintainers-fixup-userfaultfd-entry
+++ a/MAINTAINERS
@@ -15497,6 +15497,19 @@ F:	tools/mm/
 F:	tools/testing/selftests/mm/
 N:	include/linux/page[-_]*
 
+MEMORY MANAGEMENT - USERFAULTFD
+M:	Andrew Morton <akpm@linux-foundation.org>
+R:	Peter Xu <peterx@redhat.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/admin-guide/mm/userfaultfd.rst
+F:	fs/userfaultfd.c
+F:	include/asm-generic/pgtable_uffd.h
+F:	include/linux/userfaultfd_k.h
+F:	include/uapi/linux/userfaultfd.h
+F:	mm/userfaultfd.c
+F:	tools/testing/selftests/mm/uffd-*.[ch]
+
 MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
@@ -15517,18 +15530,6 @@ F:	mm/vma.h
 F:	mm/vma_internal.h
 F:	tools/testing/vma/
 
-MEMORY USERFAULTFD
-M:	Andrew Morton <akpm@linux-foundation.org>
-R:	Peter Xu <peterx@redhat.com>
-S:	Maintained
-F:	Documentation/admin-guide/mm/userfaultfd.rst
-F:	fs/userfaultfd.c
-F:	include/asm-generic/pgtable_uffd.h
-F:	include/linux/userfaultfd_k.h
-F:	include/uapi/linux/userfaultfd.h
-F:	mm/userfaultfd.c
-F:	tools/testing/selftests/mm/uffd-*.[ch]
-
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Richard Weinberger <richard@nod.at>
_

Patches currently in -mm which might be from rppt@kernel.org are


