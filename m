Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FAC25A2C6;
	Thu, 27 Aug 2026 03:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787801562; cv=none; b=dQlsj2mVS1L4zBSbodGevgZPcfyZNNm0duIc+Jr3cOgGiZ/UD1TFrHQYa+cJ/h0GRCUKaL/FrWYUK2WpKF1cLnLcTIq7Yu4mJf3F9bCbmzYIGuIzK6D/swUIyeLnZC7J7k3/SwOz+g5j2krurWzzYOjzxW7X5Q+Ewy6Wpzcir5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787801562; c=relaxed/simple;
	bh=mJ8OZZg3jGXhLpkr6AZhQWubzIRCRXHTbwV04Xxxp6A=;
	h=Date:To:From:Subject:Message-Id; b=DH6I7ioU0X79xPZE+9ASwbB3WKBp4UlROwTfQRzLu3dYM3HuiFqq40yaNigWP3C/5z5dP7l9EFXsO5KUOJhnGcfWpCvpeV7KoVnFAO0qPgsD4AvT5T68QwfPgaH5Qt/djljpcPi+6l/L7tcxdNjYLGqlB9T2qpw69XFqtyYHmzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ltdtNuvP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ltdtNuvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACDC1F000E9;
	Thu, 27 Aug 2026 03:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787801561;
	bh=C510wS6+T7pMKaiW1eGElF1e+u8WoMJKWAPKXxRSyi8=;
	h=Date:To:From:Subject;
	b=ltdtNuvPz7CajRu8zQpnCwFKTkoL9iFSGMqGlUkyFW6YoJLvIEHquhu5gLCURPeke
	 WctYBuxYFFLhOm5ImNH1dT2Ov+XR9JmYtaA24ii07V8y5iN3auGKlfMPysMU0gHuZo
	 bRnb5wYqne8DerJISpnu0yN9EpJ5hyzgY9+DlXck=
Date: Wed, 26 Aug 2026 20:32:40 -0700
To: mm-commits@vger.kernel.org,xu.xin16@zte.com.cn,stable@vger.kernel.org,hughd@google.com,david@kernel.org,chengming.zhou@linux.dev,nicoyip.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-mark-migration-stores-with-write_once.patch added to mm-new branch
Message-Id: <20260827033240.DACDC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: mark migration stores with WRITE_ONCE()
has been added to the -mm mm-new branch.  Its filename is
     mm-ksm-mark-migration-stores-with-write_once.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-mark-migration-stores-with-write_once.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Acked-by: Xu Xin <xu.xin16@zte.com.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-ksm-mark-migration-stores-with-write_once.patch

