Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09291946AA
	for <mm-commits@vger.kernel.org>; Wed,  1 Oct 2025 20:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759351792; cv=none; b=LsJNp8bsLIFNxqBizGeHm15ZcBbjQIiYVpsVesvlVSdocMqS+iH+1DdNO8f8S4Mhb2zfg1vz/HSHWRmLiiOTlRMFZzNMzQ4C9aHgMhB+g+CN7zmnbUfVv9Sh+bMb/rHPewp6snpej/X5Dh1ztjlRQxmBRgWz3qabs8FJ5TkTffE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759351792; c=relaxed/simple;
	bh=22msGwpp84lfpU/Uj3RGjDISVsXaxH/Ni9tLvFdkHz0=;
	h=Date:To:From:Subject:Message-Id; b=U4H8uqh+awGhDwAk9rexKbGtHxZCdjAykkSqt5flMHkmiKZtuayM60hi0D/5XEzS8BbL92tnDZuS5enrmlI1do/2iumlKhyewxssWGE/FKXPP971WHwea0YcN0GNtK4CCkDyeMi4dMV4u9KL0IDzmVm/YgF+pzjMsfpXLogKnsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZO5C7OUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZO5C7OUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21737C4CEF1;
	Wed,  1 Oct 2025 20:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759351792;
	bh=22msGwpp84lfpU/Uj3RGjDISVsXaxH/Ni9tLvFdkHz0=;
	h=Date:To:From:Subject:From;
	b=ZO5C7OUITyaE+diFslutSD506/jE5qADoseI+mjHak4ULefIKKJpPLE0Y3Fh3emMO
	 /ein3N8T7h5fK0PVB1h7OAjywTXkqmDvq/OBpRH4YCDd7HEk+3SBuXlGUBXbfrxBdw
	 K0XjQP7Zju7V01Heqy/9ubyvqP+eSCU6q37PYyho=
Date: Wed, 01 Oct 2025 13:49:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xu.xin16@zte.com.cn,sj@kernel.org,ryan.roberts@arm.com,raghavendra.kt@amd.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,kirill@shutemov.name,kas@kernel.org,dev.jain@arm.com,david@redhat.com,dan.carpenter@linaro.org,chengming.zhou@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-cleanup-mm_slot_entry-invocation.patch added to mm-unstable branch
Message-Id: <20251001204952.21737C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: cleanup mm_slot_entry() invocation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-cleanup-mm_slot_entry-invocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-cleanup-mm_slot_entry-invocation.patch

This patch will later appear in the mm-unstable branch at
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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/ksm: cleanup mm_slot_entry() invocation
Date: Wed, 1 Oct 2025 09:18:59 +0000

Patch series "mm_slot: following fixup for usage of mm_slot_entry()", v2.

We got some late review commits during review of "mm_slot: fix the usage of
mm_slot_entry()" in [1].


This patch (of 2):

We got some late review commits during review of commit 08498be43ee6
("mm/ksm: get mm_slot by mm_slot_entry() when slot is !NULL").  Let's
reduce the indentation level and make the code easier to follow by using
gotos to a new label.

Link: https://lkml.kernel.org/r/20251001091900.20041-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20251001091900.20041-2-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20250927004539.19308-1-richard.weiyang@gmail.com [1]
Fixes: 08498be43ee6 ("mm/ksm: get mm_slot by mm_slot_entry() when slot is !NULL")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@amd.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/mm/ksm.c~mm-ksm-cleanup-mm_slot_entry-invocation
+++ a/mm/ksm.c
@@ -2921,7 +2921,7 @@ int __ksm_enter(struct mm_struct *mm)
 
 void __ksm_exit(struct mm_struct *mm)
 {
-	struct ksm_mm_slot *mm_slot;
+	struct ksm_mm_slot *mm_slot = NULL;
 	struct mm_slot *slot;
 	int easy_to_free = 0;
 
@@ -2936,19 +2936,20 @@ void __ksm_exit(struct mm_struct *mm)
 
 	spin_lock(&ksm_mmlist_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
-	if (slot) {
-		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-		if (ksm_scan.mm_slot != mm_slot) {
-			if (!mm_slot->rmap_list) {
-				hash_del(&slot->hash);
-				list_del(&slot->mm_node);
-				easy_to_free = 1;
-			} else {
-				list_move(&slot->mm_node,
-					  &ksm_scan.mm_slot->slot.mm_node);
-			}
-		}
+	if (!slot)
+		goto unlock;
+	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+	if (ksm_scan.mm_slot == mm_slot)
+		goto unlock;
+	if (!mm_slot->rmap_list) {
+		hash_del(&slot->hash);
+		list_del(&slot->mm_node);
+		easy_to_free = 1;
+	} else {
+		list_move(&slot->mm_node,
+			  &ksm_scan.mm_slot->slot.mm_node);
 	}
+unlock:
 	spin_unlock(&ksm_mmlist_lock);
 
 	if (easy_to_free) {
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-ksm-cleanup-mm_slot_entry-invocation.patch
mm-khugepaged-use-kmem_cache.patch

