Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CFE1FAA;
	Fri,  6 Jun 2025 05:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749186171; cv=none; b=Xx5D/XuU8Ju4nylD0trWTNVqvTZD2jUWiPYZgltq8yGQz4F2nhk39ebW0/jRlajam+GnuLQwkKyAZ7VetRFFD922UcnoBHgtcx6HW5Qh7znVyGekasaOvKjqElv5719ZoTNL8P2CnMjkGEzdeLCUcUYsA0ODqAhk8obSNMbBtAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749186171; c=relaxed/simple;
	bh=qY15qQecLELacctWTFazxQK/HnHqlCgEU6ryWIb6Tsc=;
	h=Date:To:From:Subject:Message-Id; b=HWD4wYPNyg8DYC3sw6toUUfvxXH8hbgBp1W4nQLH5fSST5LWxFnh7l56WsbbA+qFrt3wikLhKTK2CH7zaataqJGXbesSZSQ9skJVMK+qA4uf9AO+rffBrUBLCx+JTHb52jelZ4B+2wOOqYa/UdtT7R4dFVs+E0ME7KlKe34ySo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=l+WtG7/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="l+WtG7/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A42C4CEEB;
	Fri,  6 Jun 2025 05:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749186170;
	bh=qY15qQecLELacctWTFazxQK/HnHqlCgEU6ryWIb6Tsc=;
	h=Date:To:From:Subject:From;
	b=l+WtG7/KI+Nq4+s6EwbYCNjJ86lza3Ygr5vaxwqAj2kNsVI9lpJBuWTGS/huH1i7S
	 6orNr0owLm76jVsHXLky8hmHDrxpn9ohJwHQxGnWwlvukNX8xrgqBEP5kKnidVb1oP
	 sLcMa2ZnaMlGJYQ1m72k79GwN1snp3ua9bwp/TxM=
Date: Thu, 05 Jun 2025 22:02:49 -0700
To: mm-commits@vger.kernel.org,yang@os.amperecomputing.com,willy@infradead.org,svens@linux.ibm.com,stable@vger.kernel.org,pbonzini@redhat.com,osalvador@suse.de,lkp@intel.com,Liam.Howlett@oracle.com,jthoughton@google.com,imbrenda@linux.ibm.com,Ignacio.MorenoGonzalez@kuka.com,hca@linux.ibm.com,gor@linux.ibm.com,frankja@linux.ibm.com,david@redhat.com,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] kvm-s390-rename-prot_none-to-prot_type_dummy.patch removed from -mm tree
Message-Id: <20250606050250.54A42C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
has been removed from the -mm tree.  Its filename was
     kvm-s390-rename-prot_none-to-prot_type_dummy.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -319,7 +319,7 @@ enum prot_type {
 	PROT_TYPE_DAT  = 3,
 	PROT_TYPE_IEP  = 4,
 	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
-	PROT_NONE,
+	PROT_TYPE_DUMMY,
 };
 
 static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
@@ -335,7 +335,7 @@ static int trans_exc_ending(struct kvm_v
 	switch (code) {
 	case PGM_PROTECTION:
 		switch (prot) {
-		case PROT_NONE:
+		case PROT_TYPE_DUMMY:
 			/* We should never get here, acts like termination */
 			WARN_ON_ONCE(1);
 			break;
@@ -805,7 +805,7 @@ static int guest_range_to_gpas(struct kv
 			gpa = kvm_s390_real_to_abs(vcpu, ga);
 			if (!kvm_is_gpa_in_memslot(vcpu->kvm, gpa)) {
 				rc = PGM_ADDRESSING;
-				prot = PROT_NONE;
+				prot = PROT_TYPE_DUMMY;
 			}
 		}
 		if (rc)
@@ -963,7 +963,7 @@ int access_guest_with_key(struct kvm_vcp
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

docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch

