Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D5B350A02;
	Tue, 21 Oct 2025 22:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761086817; cv=none; b=opvn9/CMOegvJM07uPnbZIpm6qPnN7Xfw9VisBN8c/3x4J0he/lCo9wXKogQ+IWC4Wcgo7bmShVDyNa4kQ/V7lxNK5GiY/HUypRFfUrn9ewS8CnTB4jyT2c/Ge0iLMouKOIEDL6UzEwazvNqRg6RxRmoKZ1s4/5+EhaPQIBlK3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761086817; c=relaxed/simple;
	bh=LM9P/srTUMHNetw2DNwFne4Fy4HW4DxWALPWYyCSX38=;
	h=Date:To:From:Subject:Message-Id; b=ZMZeYTBPXz6JA7WG6hflXR5LbmtI04WFTJEkHCCrmZJxmqayQ+5MGjTMZxFzS7v0lVNnGyAeKF1+MbwAuRwUChoJJji7R3bHODfw8sbClmNPpVtu6WrKtA0QileKwCKyvqR+y6OxkMdMve/Y9rO0kYbYGsYQOYmHeP/T5uBxRAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GfAV3E5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GfAV3E5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B77CC19424;
	Tue, 21 Oct 2025 22:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761086817;
	bh=LM9P/srTUMHNetw2DNwFne4Fy4HW4DxWALPWYyCSX38=;
	h=Date:To:From:Subject:From;
	b=GfAV3E5zrryf+AYwRdc3tS6Qk012SB0/KwMDoMnVtm8beZ3io4Iss7DEBRPUyozgx
	 Ee5IcbJB+mN2WHyzzhUbQM3TL8HvfwFBITH8UpM2zuMG7xbeZOjuApTQpL54EvzC6S
	 lE4yZHez1jpBfOvrzVBHqJwktn4Y1BN75ZO5xuyk=
Date: Tue, 21 Oct 2025 15:46:57 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jerrin.shaji-george@broadcom.com,gregkh@linuxfoundation.org,bcm-kernel-feedback-list@broadcom.com,arnd@arndb.de,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] vmw_balloon-indicate-success-when-effectively-deflating-during-migration.patch removed from -mm tree
Message-Id: <20251021224657.8B77CC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: vmw_balloon: indicate success when effectively deflating during migration
has been removed from the -mm tree.  Its filename was
     vmw_balloon-indicate-success-when-effectively-deflating-during-migration.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


