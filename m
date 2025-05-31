Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C23190664;
	Sat, 31 May 2025 21:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748727280; cv=none; b=qcpQnA70mlgj5Ch30I/6j08vX2aKFOpuXumLynbS9F2HEaxrCF0y75aLNYnmfCE24ClBPanSu3044VUTQcXneykzz6K1RWHcdI9ZwBN5AW3zKsziUB7g6IAA8lDntMm9i92GK53Na26Hx4u+UX4pt3bw+WNQxzNCMN01Lyx+FT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748727280; c=relaxed/simple;
	bh=FX6BuvzMZaRCRM9Z3Qx4oYX+1JZOgVKu0hU9xpEORek=;
	h=Date:To:From:Subject:Message-Id; b=OG+i+GrpNjufR+ab4mYwYUiEeok9qmF80rqlp711XAv2HUx3SbfBQiEjn75B0l1HiYb3I25tHhxWSP7rHA5kfe4jyo7MhdrOmcQKdRHfAlAWaC0hTHu0HpOLxCxafSs839XhUBJ5aEWtn6Ju6TYRCjuynYTOlqGvhnCvhSG7gTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J5YS2DTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J5YS2DTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70171C4CEE3;
	Sat, 31 May 2025 21:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1748727279;
	bh=FX6BuvzMZaRCRM9Z3Qx4oYX+1JZOgVKu0hU9xpEORek=;
	h=Date:To:From:Subject:From;
	b=J5YS2DTGtykds3oHzEvIdGIWR8X/W/lDsxLjqLXD6D4/IffInikuYWszXFIPEPqSt
	 GVpMohbYp/YvKQeVbEHkdf/CDlBvx01oK7uRaom3ZhD66ICzbMBAW/kGokowwwK8kD
	 /pVLzn4PkLOzDo6Epu95UC0mSZ/3Vr57IVbpCE7A=
Date: Sat, 31 May 2025 14:34:38 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,willy@infradead.org,svens@linux.ibm.com,stable@vger.kernel.org,pbonzini@redhat.com,osalvador@suse.de,lkp@intel.com,Liam.Howlett@oracle.com,jthoughton@google.com,imbrenda@linux.ibm.com,Ignacio.MorenoGonzalez@kuka.com,hca@linux.ibm.com,gor@linux.ibm.com,frankja@linux.ibm.com,david@redhat.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kvm-s390-rename-prot_none-to-prot_type_dummy.patch added to mm-hotfixes-unstable branch
Message-Id: <20250531213439.70171C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kvm-s390-rename-prot_none-to-prot_type_dummy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kvm-s390-rename-prot_none-to-prot_type_dummy.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
Date: Mon, 19 May 2025 15:56:57 +0100

The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
unfortunate identifier within it - PROT_NONE.

This clashes with the protection bit define from the uapi for mmap()
declared in include/uapi/asm-generic/mman-common.h, which is indeed what
those casually reading this code would assume this to refer to.

This means that any changes which subsequently alter headers in any way
which results in the uapi header being imported here will cause build
errors.

Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.

Link: https://lkml.kernel.org/r/20250519145657.178365-1-lorenzo.stoakes@oracle.com
Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Acked-by: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kvm/gaccess.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/s390/kvm/gaccess.c~kvm-s390-rename-prot_none-to-prot_type_dummy
+++ a/arch/s390/kvm/gaccess.c
@@ -318,7 +318,7 @@ enum prot_type {
 	PROT_TYPE_DAT  = 3,
 	PROT_TYPE_IEP  = 4,
 	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
-	PROT_NONE,
+	PROT_TYPE_DUMMY,
 };
 
 static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
@@ -334,7 +334,7 @@ static int trans_exc_ending(struct kvm_v
 	switch (code) {
 	case PGM_PROTECTION:
 		switch (prot) {
-		case PROT_NONE:
+		case PROT_TYPE_DUMMY:
 			/* We should never get here, acts like termination */
 			WARN_ON_ONCE(1);
 			break;
@@ -804,7 +804,7 @@ static int guest_range_to_gpas(struct kv
 			gpa = kvm_s390_real_to_abs(vcpu, ga);
 			if (!kvm_is_gpa_in_memslot(vcpu->kvm, gpa)) {
 				rc = PGM_ADDRESSING;
-				prot = PROT_NONE;
+				prot = PROT_TYPE_DUMMY;
 			}
 		}
 		if (rc)
@@ -962,7 +962,7 @@ int access_guest_with_key(struct kvm_vcp
 		if (rc == PGM_PROTECTION)
 			prot = PROT_TYPE_KEYC;
 		else
-			prot = PROT_NONE;
+			prot = PROT_TYPE_DUMMY;
 		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
 	}
 out_unlock:
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

kvm-s390-rename-prot_none-to-prot_type_dummy.patch
tools-testing-vma-add-missing-function-stub.patch

