Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DAD381AB
	for <mm-commits@vger.kernel.org>; Tue, 30 Jan 2024 06:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596850; cv=none; b=K/F9dUSNmRPOgC6lPmxA0xW0cNDVAVXI6sMNpLNdaxB7EUsClsnUk9KSuto3o5hyCoOSLY49jGYEyPUMzaerbZAMNs+yQ5XMb08IuSvu3j5h8+W2q54NfgPyO0RYLJDI2Pgl/+YH5xSUEfnpZQpWOUJHoMoGwH+20G69ijjKXrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596850; c=relaxed/simple;
	bh=XaUCXDlUUPATeM1OCnezwWm7pvL1XuauNUc99FtgUpw=;
	h=Date:To:From:Subject:Message-Id; b=M+aqBGNGkTXY3a28T+va26Rezq1PQ1hEx74zLu3iibxt82glAInwjPl73rzk+mixkztvfBUWaAUocabwupO+f+BPsHHnT8AjpcW1GhwkxQLMOKVqWUvbOP3sBDFknmKreLtlw4RIoTm0hFFrgdAB3HXUaUYMAIWpq+juk4RJLHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WKrlRYru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WKrlRYru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA40C433F1;
	Tue, 30 Jan 2024 06:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706596849;
	bh=XaUCXDlUUPATeM1OCnezwWm7pvL1XuauNUc99FtgUpw=;
	h=Date:To:From:Subject:From;
	b=WKrlRYru3sz/SVTQCj0c4XCVlS6W4P54wVRzT58uHwk16t1vc8o42ibjVfJR4qVQX
	 IJUEXP2SH+qd5iPI/nqzu1rzpm8awrA9UXuL1JqEdXFpDszJcf90Hf2F/VsXGdg2NJ
	 LohtBme2JyZ8JeWWCMiQMRa23Rz7FzmZYMU5pc1E=
Date: Mon, 29 Jan 2024 22:40:36 -0800
To: mm-commits@vger.kernel.org,zhouchengming@bytedance.com,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-warn-when-referencing-a-dead-entry.patch added to mm-unstable branch
Message-Id: <20240130064048.5CA40C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: zswap: warn when referencing a dead entry
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-warn-when-referencing-a-dead-entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-warn-when-referencing-a-dead-entry.patch

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
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: zswap: warn when referencing a dead entry
Date: Mon, 29 Jan 2024 20:36:40 -0500

Put a standard sanity check on zswap_entry_get() for UAF scenario.

Link: https://lkml.kernel.org/r/20240130014208.565554-5-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zswap.c~mm-zswap-warn-when-referencing-a-dead-entry
+++ a/mm/zswap.c
@@ -542,6 +542,7 @@ static void zswap_entry_free(struct zswa
 /* caller must hold the tree lock */
 static void zswap_entry_get(struct zswap_entry *entry)
 {
+	WARN_ON_ONCE(!entry->refcount);
 	entry->refcount++;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-zswap-fix-objcg-use-after-free-in-entry-destruction.patch
mm-zswap-rename-zswap_free_entry-to-zswap_entry_free.patch
mm-zswap-inline-and-remove-zswap_entry_find_get.patch
mm-zswap-move-zswap_invalidate_entry-to-related-functions.patch
mm-zswap-warn-when-referencing-a-dead-entry.patch
mm-zswap-clean-up-zswap_entry_put.patch
mm-zswap-rename-__zswap_load-to-zswap_decompress.patch
mm-zswap-break-out-zwap_compress.patch
mm-zswap-further-cleanup-zswap_store.patch
mm-zswap-simplify-zswap_invalidate.patch
mm-zswap-function-ordering-pool-alloc-free.patch
mm-zswap-function-ordering-pool-refcounting.patch
mm-zswap-function-ordering-zswap_pools.patch
mm-zswap-function-ordering-pool-params.patch
mm-zswap-function-ordering-public-lru-api.patch
mm-zswap-function-ordering-move-entry-sections-out-of-lru-section.patch
mm-zswap-function-ordering-move-entry-section-out-of-tree-section.patch
mm-zswap-function-ordering-compress-decompress-functions.patch
mm-zswap-function-ordering-per-cpu-compression-infra.patch
mm-zswap-function-ordering-writeback.patch
mm-zswap-function-ordering-shrink_memcg_cb.patch

