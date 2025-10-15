Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBCE1917FB;
	Wed, 15 Oct 2025 00:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760489692; cv=none; b=V8JW9NmZkpsJcQCUoumxnxDPBK4gXC5I2He8/jxcke/elhzNUln8wgQOEhl0uV32sjuccvw/Yn7OLFszHpNx+OM4rTnmbLkxvsSkuQoqmpdCaqxSstB4blG0uZ5c4Jjh3FzFX415whf/clV0O95j5/BdKRRKcfUHGODnn8MS1nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760489692; c=relaxed/simple;
	bh=8HqsWkMsX/AwnP8YR/jNjEH4YmO6l8mHpwsKqLJZ5tI=;
	h=Date:To:From:Subject:Message-Id; b=AbYOGz29pGquCDoJw0YiJg+p45larJTrsDIcZqThnACjGibHChASQ6P6kMCvcOcVSUDQrilMF7WR1M4bp21kvFyBuhj7OWc0ntt0HeQoKqxB+Do3Tu/NtJTGF5mP8ylTImB/sQ/CohDkDXdG0c0JJnnqk89UoVKCpZH++yxp3cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yy+lJDCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yy+lJDCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B92C4CEE7;
	Wed, 15 Oct 2025 00:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760489691;
	bh=8HqsWkMsX/AwnP8YR/jNjEH4YmO6l8mHpwsKqLJZ5tI=;
	h=Date:To:From:Subject:From;
	b=Yy+lJDCdy4r3iA+cOnAs9rozdpMp3hvG8347R0WHXo2liqGt78mhvi8/r7IBcRNlY
	 GXCJnTrlcoxFGuWnQP/K18ecmg06rCx0h215OdZe7IWkeeHNZLU33TAf1fCVpqQ3n6
	 IPeYoxIwcjJlJdKif2ulEunQppNjhb3r9NPlaZLo=
Date: Tue, 14 Oct 2025 17:54:50 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jerrin.shaji-george@broadcom.com,gregkh@linuxfoundation.org,bcm-kernel-feedback-list@broadcom.com,arnd@arndb.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vmw_balloon-indicate-success-when-effectively-deflating-during-migration.patch added to mm-hotfixes-unstable branch
Message-Id: <20251015005451.17B92C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vmw_balloon: indicate success when effectively deflating during migration
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     vmw_balloon-indicate-success-when-effectively-deflating-during-migration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmw_balloon-indicate-success-when-effectively-deflating-during-migration.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: vmw_balloon: indicate success when effectively deflating during migration
Date: Tue, 14 Oct 2025 14:44:55 +0200

When migrating a balloon page, we first deflate the old page to then
inflate the new page.

However, if inflating the new page succeeded, we effectively deflated the
old page, reducing the balloon size.

In that case, the migration actually worked: similar to migrating+
immediately deflating the new page.  The old page will be freed back to
the buddy.

Right now, the core will leave the page be marked as isolated (as we
returned an error).  When later trying to putback that page, we will run
into the WARN_ON_ONCE() in balloon_page_putback().

That handling was changed in commit 3544c4faccb8 ("mm/balloon_compaction:
stop using __ClearPageMovable()"); before that change, we would have
tolerated that way of handling it.

To fix it, let's just return 0 in that case, making the core effectively
just clear the "isolated" flag + freeing it back to the buddy as if the
migration succeeded.  Note that the new page will also get freed when the
core puts the last reference.

Note that this also makes it all be more consistent: we will no longer
unisolate the page in the balloon driver while keeping it marked as being
isolated in migration core.

This was found by code inspection.

Link: https://lkml.kernel.org/r/20251014124455.478345-1-david@redhat.com
Fixes: 3544c4faccb8 ("mm/balloon_compaction: stop using __ClearPageMovable()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Jerrin Shaji George <jerrin.shaji-george@broadcom.com>
Cc: Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/vmw_balloon.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/misc/vmw_balloon.c~vmw_balloon-indicate-success-when-effectively-deflating-during-migration
+++ a/drivers/misc/vmw_balloon.c
@@ -1737,7 +1737,7 @@ static int vmballoon_migratepage(struct
 {
 	unsigned long status, flags;
 	struct vmballoon *b;
-	int ret;
+	int ret = 0;
 
 	b = container_of(b_dev_info, struct vmballoon, b_dev_info);
 
@@ -1796,17 +1796,15 @@ static int vmballoon_migratepage(struct
 		 * A failure happened. While we can deflate the page we just
 		 * inflated, this deflation can also encounter an error. Instead
 		 * we will decrease the size of the balloon to reflect the
-		 * change and report failure.
+		 * change.
 		 */
 		atomic64_dec(&b->size);
-		ret = -EBUSY;
 	} else {
 		/*
 		 * Success. Take a reference for the page, and we will add it to
 		 * the list after acquiring the lock.
 		 */
 		get_page(newpage);
-		ret = 0;
 	}
 
 	/* Update the balloon list under the @pages_lock */
@@ -1817,7 +1815,7 @@ static int vmballoon_migratepage(struct
 	 * If we succeed just insert it to the list and update the statistics
 	 * under the lock.
 	 */
-	if (!ret) {
+	if (status == VMW_BALLOON_SUCCESS) {
 		balloon_page_insert(&b->b_dev_info, newpage);
 		__count_vm_event(BALLOON_MIGRATE);
 	}
_

Patches currently in -mm which might be from david@redhat.com are

vmw_balloon-indicate-success-when-effectively-deflating-during-migration.patch

