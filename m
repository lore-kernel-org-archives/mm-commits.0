Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BA0259C98
	for <mm-commits@vger.kernel.org>; Sun, 28 Sep 2025 18:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759085545; cv=none; b=tvMOFBdAvM2EaZK2ffbPaqj4pQvNNDbfsMcydAeokEEQO0Rca3r4zfmbcI39Eqo1bI2e6A9fhv67AHvclkDYxpHOMD/2gBlkDj+xxnZl8YKQ6IQKMc0s8gg1eKEE5MXe+KFHbGaIRG4O8/Wi4DqFK6i1fjUM38gIkMSgeU6/2e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759085545; c=relaxed/simple;
	bh=J7bVAjb9XdoMnHMALry8ampXpj8CPpKTCHF+VnIStbI=;
	h=Date:To:From:Subject:Message-Id; b=AGxCt2WlxJvMMq4V/MxrkIZnpR7BGpAEIQPFWiup3aEKMx7AdbqElhyrJ76MLY79DwblPK5lwl+hV9MRivhhIgXpsJf8P9+gUGE75cn0iZq7Ymv3AREKdlnSquMj0zCTk6iHW6+AYIMwlgPltr0kBVsMZkBWwmG06FQsT0Zrnxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GauZhfzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GauZhfzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C23C4CEF0;
	Sun, 28 Sep 2025 18:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759085545;
	bh=J7bVAjb9XdoMnHMALry8ampXpj8CPpKTCHF+VnIStbI=;
	h=Date:To:From:Subject:From;
	b=GauZhfzfVbIzIUk8MbBRH2c3webyaGkQEQD2GiNObvXLkLUQZtUsm4XgR9zzcUXhO
	 meBAOWxJoTdGG1dH6nNR0jg2/bua81BPgR3jPTsRFs3fmuBceocT8yAzjXMukMVoKy
	 6IekrsG9tXL1+39mNMbg2ZEoHhD8WhnspA2AIVVw=
Date: Sun, 28 Sep 2025 11:52:24 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,lance.yang@linux.dev,kirill@shutemov.name,dev.jain@arm.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-get-mm_slot-by-mm_slot_entry-when-slot-is-null.patch removed from -mm tree
Message-Id: <20250928185224.E6C23C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: get mm_slot by mm_slot_entry() when slot is !NULL
has been removed from the -mm tree.  Its filename was
     mm-ksm-get-mm_slot-by-mm_slot_entry-when-slot-is-null.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/ksm: get mm_slot by mm_slot_entry() when slot is !NULL
Date: Fri, 19 Sep 2025 07:12:43 +0000

Patch series "mm_slot: fix the usage of mm_slot_entry", v2.

When using mm_slot in ksm, there is code like:

     slot = mm_slot_lookup(mm_slots_hash, mm);
     mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
     if (mm_slot && ..) {
     }

The mm_slot_entry() won't return a valid value if slot is NULL generally. 
But currently it works since slot is the first element of struct
ksm_mm_slot.

To reduce the ambiguity and make it robust, access mm_slot_entry() when
slot is !NULL.

Link: https://lkml.kernel.org/r/20250919071244.17020-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20250919071244.17020-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Kiryl Shutsemau <kirill@shutemov.name>
Cc: xu xin <xu.xin16@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/mm/ksm.c~mm-ksm-get-mm_slot-by-mm_slot_entry-when-slot-is-null
+++ a/mm/ksm.c
@@ -2936,15 +2936,17 @@ void __ksm_exit(struct mm_struct *mm)
 
 	spin_lock(&ksm_mmlist_lock);
 	slot = mm_slot_lookup(mm_slots_hash, mm);
-	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
-		if (!mm_slot->rmap_list) {
-			hash_del(&slot->hash);
-			list_del(&slot->mm_node);
-			easy_to_free = 1;
-		} else {
-			list_move(&slot->mm_node,
-				  &ksm_scan.mm_slot->slot.mm_node);
+	if (slot) {
+		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+		if (ksm_scan.mm_slot != mm_slot) {
+			if (!mm_slot->rmap_list) {
+				hash_del(&slot->hash);
+				list_del(&slot->mm_node);
+				easy_to_free = 1;
+			} else {
+				list_move(&slot->mm_node,
+					  &ksm_scan.mm_slot->slot.mm_node);
+			}
 		}
 	}
 	spin_unlock(&ksm_mmlist_lock);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


