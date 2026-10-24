Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832280;
	b=tu5D6h82RGF7kj1M9xy2VWpYiRKKp2kn7wDVd/GdwYsVQfPjt/akBI1E+BbfZhvgXouw
	 S8Gw0qVK+ptnmrUdQTBan1fBcWwQyb7kV42+npk0K2MQuv2DrRI0Rya/nXiruz24uBaJG
	 7M9jaFqctZ3krwU50GDCtfZpmP7yQezYvsgiXLZzyPuzxnqPUvUIE3H2S/B+yfwzVNFDe
	 AUQs0GR7sWeEYvF+Lfq4HG9NvLWs+teUZhi8SWgVF4OafydL7hr8fD54jvzTcg2DlxLoc
	 GaTBX84D+7hITYdhuaTILQM8/7RYHGQv6ImPrcT3rcNRTi7dMVWpUdc7TKopchuysHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832280;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=WIImytbUFnvrrnO9j4WruzYEgG6tOngp//qNGAG/JfE=;
	b=p280y6PcUtVHDDh//s/r9ALUhoVNynu9lTSoOfD298oZkOs+9TSHQ8L3SsqE/Da4AW4/
	 TYKBoG47akBXmNbZe8lv7o2oDUi3X6faMG1VfKzzHCi67LdphY5i+fXcGNffMqAW29K4j
	 FCnlsbSkTbmKCfMg9RDcEf46VbawUIMQEvoE8Cih2XkVMXtGBe2lTkiTyfP/eZxRl7dJ1
	 pZGnaCCGQXIj6qS3TWDo4PaYJsqbbRqv4Ld7GvHFf4Ns/3Or3rMqfa4UJ8awPfjJ+bXLS
	 do/RUvURosu21T6YRG9dlRGXhWd5bS5cNV9wekh977QFQEdMS4K+O9d9DPJcPWnKS0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=a2PdjxZL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670B5606A31B
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=a2PdjxZL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D8A1F01828;
	Sat, 24 Oct 2026 08:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832280;
	bh=WIImytbUFnvrrnO9j4WruzYEgG6tOngp//qNGAG/JfE=;
	h=Date:To:From:Subject;
	b=a2PdjxZLqdAW2/ARX7tBPhDuMC7asPG6fgNdwkl4MzSqbWdVqMxYjomQAY81FJ/jj
	 YdeFBJJtZrTafZHVPMU6wd5wOb+09L6O3qID0Na9h47YorTZ4xuFZTtdB7ThfuGEta
	 ubodVHkB8qZleXaGDzs6eS6xOLfmtEsJX+qMRcL8=
Date: Sat, 24 Oct 2026 01:57:59 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,rppt@kernel.org,ljs@kernel.org,david@kernel.org,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-standardize-printing-for-pgtable-entries.patch removed from -mm tree
Message-Id: <20261024085800.04D8A1F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: arm64/mm: standardize printing for pgtable entries
has been removed from the -mm tree.  Its filename was
     arm64-mm-standardize-printing-for-pgtable-entries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: arm64/mm: standardize printing for pgtable entries
Date: Wed, 16 Sep 2026 10:19:33 +0530

Standardize printing for pgtable entries using recently introduced generic
helper ptval_bytes_to_hex_str() in core MM which automatically enables 128
bits entries when added later.

Link: https://lore.kernel.org/20260916044933.2689426-3-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
---

 arch/arm64/mm/fault.c |   16 +++++++++++-----
 arch/arm64/mm/mmu.c   |   16 ++++++++++------
 2 files changed, 21 insertions(+), 11 deletions(-)

--- a/arch/arm64/mm/fault.c~arm64-mm-standardize-printing-for-pgtable-entries
+++ a/arch/arm64/mm/fault.c
@@ -131,6 +131,7 @@ static inline unsigned long mm_to_pgd_ph
  */
 static void show_pte(unsigned long addr)
 {
+	char pxd_str[PTVAL_STR_MAX];
 	struct mm_struct *mm;
 	pgd_t *pgdp;
 	pgd_t pgd;
@@ -160,7 +161,8 @@ static void show_pte(unsigned long addr)
 
 	pgdp = pgd_offset(mm, addr);
 	pgd = READ_ONCE(*pgdp);
-	pr_alert("[%016lx] pgd=%016llx", addr, pgd_val(pgd));
+	ptval_to_str(pxd_str, pgd_val(pgd));
+	pr_alert("[%016lx] pgd=%s", addr, pxd_str);
 
 	do {
 		p4d_t *p4dp, p4d;
@@ -173,19 +175,22 @@ static void show_pte(unsigned long addr)
 
 		p4dp = p4d_offset_lockless(pgdp, pgd, addr);
 		p4d = READ_ONCE(*p4dp);
-		pr_cont(", p4d=%016llx", p4d_val(p4d));
+		ptval_to_str(pxd_str, p4d_val(p4d));
+		pr_cont(", p4d=%s", pxd_str);
 		if (p4d_none(p4d) || p4d_bad(p4d))
 			break;
 
 		pudp = pud_offset_lockless(p4dp, p4d, addr);
 		pud = READ_ONCE(*pudp);
-		pr_cont(", pud=%016llx", pud_val(pud));
+		ptval_to_str(pxd_str, pud_val(pud));
+		pr_cont(", pud=%s", pxd_str);
 		if (pud_none(pud) || pud_bad(pud))
 			break;
 
 		pmdp = pmd_offset_lockless(pudp, pud, addr);
 		pmd = READ_ONCE(*pmdp);
-		pr_cont(", pmd=%016llx", pmd_val(pmd));
+		ptval_to_str(pxd_str, pmd_val(pmd));
+		pr_cont(", pmd=%s", pxd_str);
 		if (pmd_none(pmd) || pmd_bad(pmd))
 			break;
 
@@ -194,7 +199,8 @@ static void show_pte(unsigned long addr)
 			break;
 
 		pte = __ptep_get(ptep);
-		pr_cont(", pte=%016llx", pte_val(pte));
+		ptval_to_str(pxd_str, pte_val(pte));
+		pr_cont(", pte=%s", pxd_str);
 		pte_unmap(ptep);
 	} while(0);
 
--- a/arch/arm64/mm/mmu.c~arm64-mm-standardize-printing-for-pgtable-entries
+++ a/arch/arm64/mm/mmu.c
@@ -2412,6 +2412,8 @@ int arch_set_user_pkey_access(int pkey,
 #ifdef CONFIG_DEBUG_VM
 void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
 {
+	char pte_str_old[PTVAL_STR_MAX];
+	char pte_str[PTVAL_STR_MAX];
 	pte_t old_pte;
 
 	old_pte = __ptep_get(ptep);
@@ -2426,14 +2428,16 @@ void __check_safe_pte_update(struct mm_s
 	 * (__ptep_set_access_flags safely changes valid ptes without going
 	 * through an invalid entry).
 	 */
+	ptval_to_str(pte_str, pte_val(pte));
+	ptval_to_str(pte_str_old, pte_val(old_pte));
 	VM_WARN_ONCE(!pte_young(pte),
-		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: racy access flag clearing: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
-		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: racy dirty state clearing: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
-		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: unsafe attribute change: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 }
 #endif /* CONFIG_DEBUG_VM */
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


