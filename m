Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634707EF06
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104097; cv=none; b=I7pNqAWh4m9kUSIxMhE4LLqJlFF4wsc4zxRu7yaP1iwbaQkxVMF4Y7MT47YJ7j8ioEln/qS9G4sq0CQrS9m34lDbIiMJhXdSYLZcFC3c5EYZMQRomUMI3HUVQHq/3u73HGQlJdVFdWFzD6ib3DQURHY+chyYCNqxdwCadDE5sJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104097; c=relaxed/simple;
	bh=RXxNWmYP+bsTXesmx2GSMNk+Jbbh6leP3RMO7ckjUQI=;
	h=Date:To:From:Subject:Message-Id; b=oupGDY+DZV9tRPhInKwhiv6Yz4eDJIF7kM4mAk4uhv0+Tg/PO1AVriWU2lnp+wTbIZNCaHXHFAzLzxuuDwiRmYiu+Cnu7ZIh92XAq/fv5s8suXhSjb1UkX0BMWmektPNv21A694/wwa1TT1zzrkGc5qbdyJMPnQurvK6clsJXvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oh7YmDIa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oh7YmDIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C5BC113CD;
	Fri, 26 Apr 2024 04:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104097;
	bh=RXxNWmYP+bsTXesmx2GSMNk+Jbbh6leP3RMO7ckjUQI=;
	h=Date:To:From:Subject:From;
	b=Oh7YmDIaHcPxzNurBa7ZZlucWquBLKFTaKSZrkZe3mJySGCmnhbdM1JpbC8QEJKIk
	 d8AagnheUlVSOoAlJh7I2rOXcEiMkHcAbbr7+eiDhIbpFNQOLy2Of0fjW4g/y/wAZW
	 IOD2T6sFrhHFs1AM6Z1RcNzriy8NZj9lD61VTyeY=
Date: Thu, 25 Apr 2024 21:01:36 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,peterz@infradead.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,mpe@ellerman.id.au,mingo@redhat.com,luto@kernel.org,Liam.Howlett@oracle.com,kirill.shutemov@linux.intel.com,keescook@chromium.org,James.Bottomley@HansenPartnership.com,hpa@zytor.com,guoren@kernel.org,deller@gmx.de,debug@rivosinc.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,christophe.leroy@csgroup.eu,broonie@kernel.org,bp@alien8.de,ast@kernel.org,aneesh.kumar@kernel.org,rick.p.edgecombe@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-x86-add-placement-guard-gap-test-for-shstk.patch removed from -mm tree
Message-Id: <20240426040137.38C5BC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/x86: add placement guard gap test for shstk
has been removed from the -mm tree.  Its filename was
     selftests-x86-add-placement-guard-gap-test-for-shstk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: selftests/x86: add placement guard gap test for shstk
Date: Mon, 25 Mar 2024 19:16:56 -0700

The existing shadow stack test for guard gaps just checks that new
mappings are not placed in an existing mapping's guard gap.  Add one that
checks that new mappings are not placed such that preexisting mappings are
in the new mappings guard gap.

Link: https://lkml.kernel.org/r/20240326021656.202649-15-rick.p.edgecombe@intel.com
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

 tools/testing/selftests/x86/test_shadow_stack.c |   67 +++++++++++++-
 1 file changed, 63 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/x86/test_shadow_stack.c~selftests-x86-add-placement-guard-gap-test-for-shstk
+++ a/tools/testing/selftests/x86/test_shadow_stack.c
@@ -556,7 +556,7 @@ struct node {
  *      looked at the shadow stack gaps.
  *   5. See if it landed in the gap.
  */
-int test_guard_gap(void)
+int test_guard_gap_other_gaps(void)
 {
 	void *free_area, *shstk, *test_map = (void *)0xFFFFFFFFFFFFFFFF;
 	struct node *head = NULL, *cur;
@@ -593,11 +593,64 @@ int test_guard_gap(void)
 	if (shstk - test_map - PAGE_SIZE != PAGE_SIZE)
 		return 1;
 
-	printf("[OK]\tGuard gap test\n");
+	printf("[OK]\tGuard gap test, other mapping's gaps\n");
 
 	return 0;
 }
 
+/* Tests respecting the guard gap of the mapping getting placed */
+int test_guard_gap_new_mappings_gaps(void)
+{
+	void *free_area, *shstk_start, *test_map = (void *)0xFFFFFFFFFFFFFFFF;
+	struct node *head = NULL, *cur;
+	int ret = 0;
+
+	free_area = mmap(0, PAGE_SIZE * 4, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	munmap(free_area, PAGE_SIZE * 4);
+
+	/* Test letting map_shadow_stack find a free space */
+	shstk_start = mmap(free_area, PAGE_SIZE, PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (shstk_start == MAP_FAILED || shstk_start != free_area)
+		return 1;
+
+	while (test_map > shstk_start) {
+		test_map = (void *)syscall(__NR_map_shadow_stack, 0, PAGE_SIZE, 0);
+		if (test_map == MAP_FAILED) {
+			printf("[INFO]\tmap_shadow_stack MAP_FAILED\n");
+			ret = 1;
+			break;
+		}
+
+		cur = malloc(sizeof(*cur));
+		cur->mapping = test_map;
+
+		cur->next = head;
+		head = cur;
+
+		if (test_map == free_area + PAGE_SIZE) {
+			printf("[INFO]\tNew mapping has other mapping in guard gap!\n");
+			ret = 1;
+			break;
+		}
+	}
+
+	while (head) {
+		cur = head;
+		head = cur->next;
+		munmap(cur->mapping, PAGE_SIZE);
+		free(cur);
+	}
+
+	munmap(shstk_start, PAGE_SIZE);
+
+	if (!ret)
+		printf("[OK]\tGuard gap test, placement mapping's gaps\n");
+
+	return ret;
+}
+
 /*
  * Too complicated to pull it out of the 32 bit header, but also get the
  * 64 bit one needed above. Just define a copy here.
@@ -850,9 +903,15 @@ int main(int argc, char *argv[])
 		goto out;
 	}
 
-	if (test_guard_gap()) {
+	if (test_guard_gap_other_gaps()) {
+		ret = 1;
+		printf("[FAIL]\tGuard gap test, other mappings' gaps\n");
+		goto out;
+	}
+
+	if (test_guard_gap_new_mappings_gaps()) {
 		ret = 1;
-		printf("[FAIL]\tGuard gap test\n");
+		printf("[FAIL]\tGuard gap test, placement mapping's gaps\n");
 		goto out;
 	}
 
_

Patches currently in -mm which might be from rick.p.edgecombe@intel.com are


