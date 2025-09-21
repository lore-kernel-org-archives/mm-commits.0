Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D57E28DB3
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489812; cv=none; b=awP+mDQmKWbgNinfpPySdwx+GpniWDKJLf8HB23WwwB9uxiNrQjdev/NKWhyBwn2iuSoZDAAtx967zR+Jm7B1FSRVD+OYC5oL/WcUNB1GqljygILx6i4ng9VLn0WfkGWH3jYh+TdlBGsYwTfKNE3DpCPOD/QqPEKcp9WJeWaOsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489812; c=relaxed/simple;
	bh=iRaMLfI60VjsCRcGdaB3h8V2i1SwBXDSgjgIsIsRJkk=;
	h=Date:To:From:Subject:Message-Id; b=fpM65WA8CNOmyeYuRXdT/xpYdMtyc20tWV3pIPL5/pO3dfr2LchisXCQj/urUjvB/tu2I3hFD/6hB6N/9bO137cenxOqRjIwiYWFTTuES412Mjn6VVpHnFYydJDyGS+3iyVtYd7cXw1LvYTDazp1u7fUSGmoOqyWqWFoEhHkPCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hozoWk2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hozoWk2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5375C4CEE7;
	Sun, 21 Sep 2025 21:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489811;
	bh=iRaMLfI60VjsCRcGdaB3h8V2i1SwBXDSgjgIsIsRJkk=;
	h=Date:To:From:Subject:From;
	b=hozoWk2REBNKm6oNRwbmdZX0OZilU0ob/Q2BQlFLlXPX0h3b+yg8SZ/zaQeIGv3nZ
	 Y7DMieOGPbDzcw6J8Rob2ebaODNIRAQIcZ5XdfI8HP7974B8PV1i7c9+9p/M6CaO4q
	 0qxaT85GoqwJa0jTGYpwBvUwKSzcLtHk/lt6/c2o=
Date: Sun, 21 Sep 2025 14:23:31 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,rppt@kernel.org,mingo@redhat.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,dave.hansen@linux.intel.com,bp@alien8.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] x86-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch removed from -mm tree
Message-Id: <20250921212331.A5375C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: x86/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
has been removed from the -mm tree.  Its filename was
     x86-kconfig-drop-superfluous-select-sparsemem_vmemmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: x86/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Mon, 1 Sep 2025 17:03:25 +0200

Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE is
selected.

Link: https://lkml.kernel.org/r/20250901150359.867252-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/x86/Kconfig~x86-kconfig-drop-superfluous-select-sparsemem_vmemmap
+++ a/arch/x86/Kconfig
@@ -1552,7 +1552,6 @@ config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
-	select SPARSEMEM_VMEMMAP if X86_64
 
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool X86_64 || (NUMA && X86_32)
_

Patches currently in -mm which might be from david@redhat.com are


