Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EEC17C220
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854815; cv=none; b=LGRzz8ZrCvh4I3jWmZtz7XKhOdQGWEoUL7ZqgziVefVXvVCg3qYRS+fvo8g2mNmVT2MS2LAKcXjBCu3SCCICIptFR2QeVQub4W13OqHB6SeWWGi++yTM4vtXTybPXLxaiuIsyH2ipHgcmO7klt4ANudU/+1TzCznsQ/uQ/cQQok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854815; c=relaxed/simple;
	bh=wSMR5dp6zf+isUJrkOSU1BHS5cBLDvV6ZNt7z59WH5Y=;
	h=Date:To:From:Subject:Message-Id; b=i4k1jdCQKRrB225BLjNXN4jnhBQ6ualShF/TbyoB4V5sl/Qjy2OndAk+h1Kxe64XPLwB7SYtigVLgA6SwWhANk6bcbCeht6x7dQAfRGtTSFdxHPLgLsbeFkFqrRAc/Zq+NSXx/M26FdDQvCgm6c9Hm6UKryCYUYzXXDSoVfoNqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h/w6eFde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h/w6eFde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99156C4CECF;
	Wed,  6 Nov 2024 01:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854815;
	bh=wSMR5dp6zf+isUJrkOSU1BHS5cBLDvV6ZNt7z59WH5Y=;
	h=Date:To:From:Subject:From;
	b=h/w6eFdeZsD4wY8WidJZzZxPszcDlxhw1t3sjStcTmxsSuUuJf5xeUtlipViMEG+t
	 s+0RKawUCImVfZBTriNVtwkZLmhT6aDOlAtyPd3kkxPih8ZCrAo78Ftau6al0nr1vU
	 G3yTA6X7gAhdhRVYeYDY5YtfA3sMYZ2oWutQkzH0=
Date: Tue, 05 Nov 2024 17:00:15 -0800
To: mm-commits@vger.kernel.org,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-use-str_true_false-helper-function.patch removed from -mm tree
Message-Id: <20241106010015.99156C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: swap: use str_true_false() helper function
has been removed from the -mm tree.  Its filename was
     mm-swap-use-str_true_false-helper-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mm: swap: use str_true_false() helper function
Date: Wed, 16 Oct 2024 16:10:41 +0200

Remove hard-coded strings by using the helper function str_true_false().

Link: https://lkml.kernel.org/r/20241016141040.79168-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/swap_state.c~mm-swap-use-str_true_false-helper-function
+++ a/mm/swap_state.c
@@ -889,8 +889,7 @@ struct folio *swapin_readahead(swp_entry
 static ssize_t vma_ra_enabled_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *buf)
 {
-	return sysfs_emit(buf, "%s\n",
-			  enable_vma_readahead ? "true" : "false");
+	return sysfs_emit(buf, "%s\n", str_true_false(enable_vma_readahead));
 }
 static ssize_t vma_ra_enabled_store(struct kobject *kobj,
 				      struct kobj_attribute *attr,
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mailmap-add-entry-for-thorsten-blum.patch
mm-show_mem-use-str_yes_no-helper-in-show_free_areas.patch
ipc-msg-replace-one-element-array-with-flexible-array-member.patch

