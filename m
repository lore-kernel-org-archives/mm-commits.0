Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89FB1D6DA3
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274636; cv=none; b=j5kOARe4wJHfITUQRjkGVzt7lCdozDLvoYajlI1xEnJOGgRxlUxnRKUcdH2jbCu60s90uFwzzTGRdNrJLeGQHUDCu6a+KJoY6OSYem8zQCTQdb71SVTWBtJy5QUvzX8+SZLRcnD27eWo8dolpSn5gPFNPEd5u/rm3+BX/htShK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274636; c=relaxed/simple;
	bh=xpRtOGCHKp4euK25rZWyxRBzlGDV1H1+/6Sym7BhQtk=;
	h=Date:To:From:Subject:Message-Id; b=QyHoD8ZBIrRH6ZeQG38GZOzy8nAdSrAS8rWaG4twJnWdMaOGO0BiLgvVHKWOdaY7+yeGioeC2zhtxhgiBQnDLkYFn31H7CXzFMOvn879u+B2Vx4+OeiGn8F4tR5DYwklQzCkihz5nobO/HBkSSTGdLAjvcle6ltWfRdJYz7bXEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kOINMWc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kOINMWc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E8CC4CEDD;
	Tue, 18 Mar 2025 05:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274636;
	bh=xpRtOGCHKp4euK25rZWyxRBzlGDV1H1+/6Sym7BhQtk=;
	h=Date:To:From:Subject:From;
	b=kOINMWc0ncmeNJJCU6GFYCyCFdYj6r1lrD31QLYTF9lcBIz7Xx6yRU4HjBiGnOcnE
	 Ezj7fNhBr1yOvxqwKKWPD6eysbfl6vq9+1n8EwNDy467htRrigOgt6+2TH2ROegKx/
	 Ya1ydnT0nbm7WCsVqzaMNoqSf6HgGmEQWZn9Mfjs=
Date: Mon, 17 Mar 2025 22:10:36 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,gregkh@linuxfoundation.org,david@redhat.com,dakr@kernel.org,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-memory-correct-the-field-name-in-the-header.patch removed from -mm tree
Message-Id: <20250318051036.A0E8CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/memory: correct the field name in the header
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-correct-the-field-name-in-the-header.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: drivers/base/memory: correct the field name in the header
Date: Wed, 12 Mar 2025 09:30:44 +1000

Replace @blocks with @memory_blocks to match with the definition of struct
memory_group.

Link: https://lkml.kernel.org/r/20250311233045.148943-3-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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


