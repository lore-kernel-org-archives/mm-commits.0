Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9854D14A619
	for <mm-commits@vger.kernel.org>; Fri,  1 May 2026 13:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777641404; cv=none; b=oRCSdLieBe0JYcaOhd1Sh1+7vSCLL10W66RSgBMF84aeorSrrbJl8TCbRXSESu2G+gzmHySen3S6ZQyXPrY8T2LPm0N5G0p/UyvL/A0IcVN9oLl9baQCal7LkraFzvk/TNp0CY6ced4fZZht76VhQPUGdMGOnQEGYRZRlTu9CCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777641404; c=relaxed/simple;
	bh=lAP4sX1ersSABkduWkRtGGtXE+0Rd5+VpAIubGIWY7o=;
	h=Date:To:From:Subject:Message-Id; b=k/8X7s5pK5NaGdIVZleBn3I79X1dlLCrLB3hXdIDKj1mZNXUn82Rt3noPB5uBbA9C4d4TB1/PgnM429VOPIsmS81VJVhwy9OQ6VKtFFNXLHasxr5wZQzio9H2fei5yK7BEsGEmLNkng7xsrhwTG7hgXAJpWOU4jbtA4MeKMyw/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GiGYObuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GiGYObuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAEFC2BCB4;
	Fri,  1 May 2026 13:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777641404;
	bh=lAP4sX1ersSABkduWkRtGGtXE+0Rd5+VpAIubGIWY7o=;
	h=Date:To:From:Subject:From;
	b=GiGYObuCJbejtxAlOFmPZCVTVxK8l6YPUdA6louj2/ZTtXqTttEQppknpD33D47LE
	 B8xgyesfDc3coaNWLj3uUXFTa0UGEWmwUuFcgOwhWDAUtY2QX8aZWgYzs4UA5lygds
	 UCajIU43CRr7M3Nu1IaV37MWYNb4Kt5SeMWQXIdM=
Date: Fri, 01 May 2026 06:16:43 -0700
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,rafael@kernel.org,nphamcs@gmail.com,lenb@kernel.org,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch added to mm-new branch
Message-Id: <20260501131644.3BAEFC2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap, PM: hibernate: atomically replace hibernation pin
has been added to the -mm mm-new branch.  Its filename is
     mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch

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
From: David Carlier <devnexen@gmail.com>
Subject: mm/swap, PM: hibernate: atomically replace hibernation pin
Date: Thu, 30 Apr 2026 20:56:51 +0100

snapshot_set_swap_area() unpins the previously selected swap device and
pins the new one in two separate swap_lock critical sections.  In the gap
between them, swapoff() observes SWP_HIBERNATION cleared, bypasses the
guard, and tears down the device, reopening the race the SWP_HIBERNATION
pin was meant to close.  The window is reachable on any
SNAPSHOT_SET_SWAP_AREA call after the snapshot device is opened for
hibernation, and on any retry after the resume path's first selection.

Add repin_hibernation_swap_type(), which looks up the new device, clears
the old SWP_HIBERNATION flag and sets the new one under a single swap_lock
acquisition.  The same-device case is short- circuited so userspace can
re-select the same swap area without tripping WARN_ON_ONCE and -EBUSY. 
Switch snapshot_set_swap_area() to the new helper.

A failed lookup now preserves the previous pin instead of dropping it, so
a bad SNAPSHOT_SET_SWAP_AREA leaves the prior selection intact.  The open
and release paths keep using pin_hibernation_swap_type() and
unpin_hibernation_swap_type().

The race was identified during AI-assisted review of the SWP_HIBERNATION
pinning series.

Link: https://lore.kernel.org/20260430195651.287659-1-devnexen@gmail.com
Fixes: 8e6e0d845823 ("mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap device")
Assisted-by: Codex (gpt-5-codex)
Signed-off-by: David Carlier <devnexen@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +
 kernel/power/user.c  |   19 ++++--------
 mm/swapfile.c        |   61 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 69 insertions(+), 13 deletions(-)

--- a/include/linux/swap.h~mm-swap-pm-hibernate-atomically-replace-hibernation-pin
+++ a/include/linux/swap.h
@@ -436,6 +436,8 @@ static inline long get_nr_swap_pages(voi
 extern void si_swapinfo(struct sysinfo *);
 extern int pin_hibernation_swap_type(dev_t device, sector_t offset);
 extern void unpin_hibernation_swap_type(int type);
+extern int repin_hibernation_swap_type(int old_type, dev_t device,
+                                       sector_t offset);
 extern int find_hibernation_swap_type(dev_t device, sector_t offset);
 int find_first_swap(dev_t *device);
 extern unsigned int count_swap_pages(int, int);
--- a/kernel/power/user.c~mm-swap-pm-hibernate-atomically-replace-hibernation-pin
+++ a/kernel/power/user.c
@@ -218,6 +218,7 @@ static int snapshot_set_swap_area(struct
 {
 	sector_t offset;
 	dev_t swdev;
+	int new_type;
 
 	if (swsusp_swap_in_use())
 		return -EPERM;
@@ -238,19 +239,11 @@ static int snapshot_set_swap_area(struct
 		offset = swap_area.offset;
 	}
 
-	/*
-	 * Unpin the swap device if a swap area was already
-	 * set by SNAPSHOT_SET_SWAP_AREA.
-	 */
-	unpin_hibernation_swap_type(data->swap);
-
-	/*
-	 * User space encodes device types as two-byte values,
-	 * so we need to recode them
-	 */
-	data->swap = pin_hibernation_swap_type(swdev, offset);
-	if (data->swap < 0)
-		return swdev ? -ENODEV : -EINVAL;
+	new_type = repin_hibernation_swap_type(data->swap, swdev, offset);
+	if (new_type < 0)
+		return new_type;
+
+	data->swap = new_type;
 	data->dev = swdev;
 	return 0;
 }
--- a/mm/swapfile.c~mm-swap-pm-hibernate-atomically-replace-hibernation-pin
+++ a/mm/swapfile.c
@@ -2220,6 +2220,67 @@ int pin_hibernation_swap_type(dev_t devi
 }
 
 /**
+ * repin_hibernation_swap_type - Atomically replace the hibernation pin
+ * @old_type: Swap type currently pinned (or < 0 if none).
+ * @device:   Block device of the new resume image.
+ * @offset:   Offset identifying the new swap area.
+ *
+ * Look up the swap device for @device/@offset and atomically transfer
+ * the SWP_HIBERNATION pin from @old_type (if valid) to the new device,
+ * all under a single swap_lock critical section. This closes the
+ * swapoff() window that exists when callers unpin and re-pin in two
+ * separate operations.
+ *
+ * If the new device cannot be located, the existing pin on @old_type
+ * is preserved and an error is returned. If @old_type already refers
+ * to the same swap_info_struct as the new lookup, no flag changes are
+ * made and @old_type is returned.
+ *
+ * Return:
+ * >= 0 on success (new swap type).
+ * -EINVAL if @device is invalid.
+ * -ENODEV if the swap device is not found.
+ * -EBUSY  if the new device is already pinned by another context.
+ */
+int repin_hibernation_swap_type(int old_type, dev_t device, sector_t offset)
+{
+	struct swap_info_struct *old_si, *new_si;
+	int new_type;
+
+	spin_lock(&swap_lock);
+
+	new_type = __find_hibernation_swap_type(device, offset);
+	if (new_type < 0) {
+		spin_unlock(&swap_lock);
+		return new_type;
+	}
+
+	new_si = swap_type_to_info(new_type);
+	if (WARN_ON_ONCE(!new_si)) {
+		spin_unlock(&swap_lock);
+		return -ENODEV;
+	}
+
+	old_si = swap_type_to_info(old_type);
+	if (new_si == old_si) {
+		spin_unlock(&swap_lock);
+		return new_type;
+	}
+
+	if (WARN_ON_ONCE(new_si->flags & SWP_HIBERNATION)) {
+		spin_unlock(&swap_lock);
+		return -EBUSY;
+	}
+
+	if (old_si)
+		old_si->flags &= ~SWP_HIBERNATION;
+	new_si->flags |= SWP_HIBERNATION;
+
+	spin_unlock(&swap_lock);
+	return new_type;
+}
+
+/**
  * unpin_hibernation_swap_type - Unpin the swap device for hibernation
  * @type: Swap type previously returned by pin_hibernation_swap_type()
  *
_

Patches currently in -mm which might be from devnexen@gmail.com are

mm-hugetlb-restore-reservation-on-error-in-hugetlb_mfill_atomic_pte-resubmission-path.patch
mm-page_io-rename-swap_iocb-fields-for-clarity.patch
mm-swap-pm-hibernate-atomically-replace-hibernation-pin.patch

