Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B00F7FBD2
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104084; cv=none; b=HUALdiuKMPFF3GKfI3puR+EqmwCQPo0PQYpozP5nzOPRJwVZ+F1pIGTCAkQbfQvXo9LF6YNmKkBQczFr/w2B9WmGId/Asy9Ig+fvdWM0vNo13qui4NH8zK0YK3BTDqvSpOOTnWZVOdkVtRwHLcfa0dXLkQWL0Oj1uOhBpYY7kpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104084; c=relaxed/simple;
	bh=845gYLXf8spqiqXO1EZijlKhdcYbbtpjhEg4Hk0Bqs0=;
	h=Date:To:From:Subject:Message-Id; b=oJh7/uFyht94lEK1zCXnEF7+Lvxt21Yao5JkR6vfhqU4t7UtK4yhPf4jVlel9B1qqV7bCK7OWVGMXx6Ma6gDTKZYg9I56JqrZTNcwBAS2y6lAaI6Q771l8xCCfrqkKgFJkLvWaxiKWZavNbT4otNPSh7uy+JOw6nQN1WNx0VjiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J6WySmuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J6WySmuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FACEC113CD;
	Fri, 26 Apr 2024 04:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104084;
	bh=845gYLXf8spqiqXO1EZijlKhdcYbbtpjhEg4Hk0Bqs0=;
	h=Date:To:From:Subject:From;
	b=J6WySmuBczFRFPXf+UHxlguJnmJo85l7XDVUjqqCCrMArcpt2RAYk5M8PGpPz6agj
	 2utprrFTdP76vCJhfR4b0DdEggQDCHHTXn/tDuN3q7Fk0cc0VhsbXpgmk065NKNrzj
	 0cn5l5oiVShit1/b5wQe9Yb/oPsFN84DLR/oU+Ow=
Date: Thu, 25 Apr 2024 21:01:23 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-export-for-get_unmapped_area.patch removed from -mm tree
Message-Id: <20240426040124.0FACEC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove export for get_unmapped_area()
has been removed from the -mm tree.  Its filename was
     mm-remove-export-for-get_unmapped_area.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: mm: remove export for get_unmapped_area()
Date: Mon, 25 Mar 2024 19:16:46 -0700

The mm/mmap.c function get_unmapped_area() is not used from any modules,
so it doesn't need to be exported.  Remove the export.

Link: https://lkml.kernel.org/r/20240326021656.202649-5-rick.p.edgecombe@intel.com
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: H. Peter Anvin (Intel) <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Naveen N. Rao <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/mmap.c~mm-remove-export-for-get_unmapped_area
+++ a/mm/mmap.c
@@ -1886,8 +1886,6 @@ get_unmapped_area(struct file *file, uns
 	return error ? error : addr;
 }
 
-EXPORT_SYMBOL(get_unmapped_area);
-
 unsigned long
 mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
 		     unsigned long addr, unsigned long len,
_

Patches currently in -mm which might be from rick.p.edgecombe@intel.com are


