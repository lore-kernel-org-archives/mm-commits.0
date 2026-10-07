Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1B51D5146;
	Wed,  7 Oct 2026 00:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334130; cv=none; b=DNtDc0SMXUw+Wxk/g6ktYnpGap/g8q+OHNpj0gyWPYoyONjsqvhsgJwZ0/JvpUYFfTaDG6AJ3JSvrEtWQhfTgtmTK9/mSS1Bakb2ibDUw1www+p9GwDpTB25zqluCQIYEsgK97ShIRbxrEN/QTXmHl1hBDjavLjwY8s7aTfQ16I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334130; c=relaxed/simple;
	bh=CQgWVPgmIIYWKTt3eWyToU/aqRN/0tbtBqwSKQ7i01Q=;
	h=Date:To:From:Subject:Message-Id; b=MCztN66mYeyKj3Crhgt+CjTT4HMy8agZb5jX1AwzE9UI+IAzE9EIIycnvYGC7JLLB1eLVMmEOOYmIL4EUs9MqbgvPO0Q0p93/TuMGlJkCxUE2x1br566OPZP966QVZkW9K8DH9QriGqyE+g+03y7uQBcJNoAwS44EgVncZYPISY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TUIxyh9r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TUIxyh9r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D811F0089B;
	Wed,  7 Oct 2026 00:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334129;
	bh=mF1ad3wntuI4KyyvX6I1BAvitwc65wOh6vhzZHcEqD0=;
	h=Date:To:From:Subject;
	b=TUIxyh9r22zaudLtZymlypspgz13nt02K+TTCE50l21TkYYaf7u0xkBNninaWThGj
	 oe3BlugVoefK2E2qyc3H5Ov3DSni+dyQzFhdTBW7bx4xNlp3IrnD7vD6S7CAtJ8yKh
	 YOsCmLk0tCyY9LjFUg0zJuqDdNeNnjCTtM+CytGU=
Date: Tue, 06 Oct 2026 17:48:49 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,stable@vger.kernel.org,hughd@google.com,david@kernel.org,nicoyip.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-mark-migration-stores-with-write_once.patch removed from -mm tree
Message-Id: <20261007004849.63D811F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: mark migration stores with WRITE_ONCE()
has been removed from the -mm tree.  Its filename was
     mm-ksm-mark-migration-stores-with-write_once.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chengfeng Ye <nicoyip.dev@gmail.com>
Subject: mm/ksm: mark migration stores with WRITE_ONCE()
Date: Mon, 24 Aug 2026 19:24:33 +0800

ksm_get_folio() deliberately samples stable_node->kpfn and folio->mapping
without taking the folio lock because the KSM folio may be migrated
concurrently.  folio_migrate_ksm() updates the same state using plain
assignments.

The reader can load the old kpfn, then the migrator can store the new
kpfn, execute smp_wmb(), and clear the old folio's mapping before the
reader checks that mapping.  Thus the initial kpfn load can overlap its
update and the subsequent mapping load can overlap the clear, with no
common lock.  This leaves marked READ_ONCE() accesses racing with plain
stores.

The kernel reported:

  BUG: KCSAN: data-race in folio_migrate_ksm / ksm_get_folio

  read (marked) to 0xffff8ce401421330 of 8 bytes by task 48 on cpu 3:
   ksm_get_folio+0x7f/0x2a0
   ksm_scan_thread+0x1635/0x3330
   kthread+0x1af/0x1f0

  write to 0xffff8ce401421330 of 8 bytes by task 102 on cpu 1:
   folio_migrate_ksm+0x6a/0xd0
   folio_migrate_flags+0x193/0x420
   __migrate_folio.isra.0+0x162/0x1a0
   migrate_folio+0x4c/0x70
   move_to_new_folio+0xd6/0x170

Use WRITE_ONCE() for both stores to pair them with the existing lockless
reads.  This preserves the existing smp_wmb()/smp_rmb() migration protocol
and control flow while preventing compiler transformations of the shared
accesses.

Link: https://lore.kernel.org/20260824112433.191301-1-nicoyip.dev@gmail.com
Fixes: c8d6553b9580 ("ksm: make KSM page migration possible")
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Xu Xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/ksm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/ksm.c~mm-ksm-mark-migration-stores-with-write_once
+++ a/mm/ksm.c
@@ -1115,7 +1115,8 @@ static inline void folio_set_stable_node
 					 struct ksm_stable_node *stable_node)
 {
 	VM_WARN_ON_FOLIO(folio_test_anon(folio) && PageAnonExclusive(&folio->page), folio);
-	folio->mapping = (void *)((unsigned long)stable_node | FOLIO_MAPPING_KSM);
+	WRITE_ONCE(folio->mapping,
+		   (void *)((unsigned long)stable_node | FOLIO_MAPPING_KSM));
 }
 
 #ifdef CONFIG_SYSFS
@@ -3316,7 +3317,7 @@ void folio_migrate_ksm(struct folio *new
 	stable_node = folio_stable_node(folio);
 	if (stable_node) {
 		VM_BUG_ON_FOLIO(stable_node->kpfn != folio_pfn(folio), folio);
-		stable_node->kpfn = folio_pfn(newfolio);
+		WRITE_ONCE(stable_node->kpfn, folio_pfn(newfolio));
 		/*
 		 * newfolio->mapping was set in advance; now we need smp_wmb()
 		 * to make sure that the new stable_node->kpfn is visible
_

Patches currently in -mm which might be from nicoyip.dev@gmail.com are


