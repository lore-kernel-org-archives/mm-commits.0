Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F55119007D
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 03:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741663481; cv=none; b=iH36Z8IG5qUi5vIUD5UbGoD7nHDJCNr/l9lXj6UZI71JJBKMnc4+jpIR2md6QoPEn+5dr7gbqi+KdkTvNiAaOzb3/EQGR6pm/G7IZDKxQUOOf6Q8g4Ga2sqDA9h3IH5VqLaAGx8L2JtU7zOZCuxeQH+LZQmN2nJNqKyFfb22b9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741663481; c=relaxed/simple;
	bh=Kl6ZmH3zTUUOGk8i0x8dHW8WkX0xeNiHvP6uNc8mHsM=;
	h=Date:To:From:Subject:Message-Id; b=D+gCu+BFIyAuKrNT15+H207XkvkFkMPv8bqI/h0bvZCNiBW7mY9bBImoE1eRkZNBDQuvaVFdbCbglxfIvgIWe9V5i045cDF+Mj/yp3mdoKxpGx9ZJv1HbGCcxEhFSjX5yRnfEFnE8Y9+PElyeYrok0VNlg9ftu4yco3sp2KZ0p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wp5WdUcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wp5WdUcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C73AC4CEE9;
	Tue, 11 Mar 2025 03:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741663480;
	bh=Kl6ZmH3zTUUOGk8i0x8dHW8WkX0xeNiHvP6uNc8mHsM=;
	h=Date:To:From:Subject:From;
	b=Wp5WdUcLGllgToEeAV3o8IZ22n2ekV8EL2CjjmfyrnVadOy7IORceFy8P6QpGUPte
	 9vOongFUWD0ZOFbCzZB13TyTTFAHHECI9Jb/2FuBStkGWrYjGpTwknXeV2HDUac2Na
	 iUJrXmvW/kDiLo/O1+yMv3TFOdr7EelowPWOj6pg=
Date: Mon, 10 Mar 2025 20:24:39 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,gregkh@linuxfoundation.org,david@redhat.com,dakr@kernel.org,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-memory-correct-the-field-name-in-the-header.patch added to mm-unstable branch
Message-Id: <20250311032440.7C73AC4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/memory: correct the field name in the header
has been added to the -mm mm-unstable branch.  Its filename is
     drivers-base-memory-correct-the-field-name-in-the-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-memory-correct-the-field-name-in-the-header.patch

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
From: Gavin Shan <gshan@redhat.com>
Subject: drivers/base/memory: correct the field name in the header
Date: Tue, 11 Mar 2025 10:46:57 +1000

Replace @blocks with @memory_blocks to match with the definition of struct
memory_group.

Link: https://lkml.kernel.org/r/20250311004657.82985-4-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memory.h~drivers-base-memory-correct-the-field-name-in-the-header
+++ a/include/linux/memory.h
@@ -25,7 +25,7 @@
 /**
  * struct memory_group - a logical group of memory blocks
  * @nid: The node id for all memory blocks inside the memory group.
- * @blocks: List of all memory blocks belonging to this memory group.
+ * @memory_blocks: List of all memory blocks belonging to this memory group.
  * @present_kernel_pages: Present (online) memory outside ZONE_MOVABLE of this
  *			  memory group.
  * @present_movable_pages: Present (online) memory in ZONE_MOVABLE of this
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-sparse-expose-for_each_present_section_nr.patch
drivers-base-memory-improve-add_boot_memory_block.patch
drivers-base-memory-correct-the-field-name-in-the-header.patch

