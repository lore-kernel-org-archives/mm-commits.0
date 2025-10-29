Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D879037A3C7
	for <mm-commits@vger.kernel.org>; Wed, 29 Oct 2025 21:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761774906; cv=none; b=e5lrw4R1TwopJcKsOXyh6AFfbywVPJFxWoAUDJtbYoGvDR7W3yNAAqzujmxLcM6X9uFm0MewLRFvJPE17e5ugXWgWspKOctWIjptJWHrpoEGK/pw11B4wRhWONeqaQwpo8mYIbqxxcEkfRJu4IkH3+K4VNd1ndaE4DO6WiGQNqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761774906; c=relaxed/simple;
	bh=YdHkbng5eAWoHpz1LrXh3AJP+gZ/HDWBdGzUDrx5NwI=;
	h=Date:To:From:Subject:Message-Id; b=k69P91XifkXzjt4FfLAay41Z1gccptgvRuz/iVwAD1KBuA3G6wh0L2Don5pnCjLazl7P+XIzHsXYgI/Hsivo60Iu3JInedrcR26/1XJmDW9Q7qVZUjBQyRpRv+CIW2Iym/Su/60tEckerlGTufA7ta5mdJ4OIzdQahEFVs7LeFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ibv32Fa5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ibv32Fa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A81AC4CEF7;
	Wed, 29 Oct 2025 21:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761774904;
	bh=YdHkbng5eAWoHpz1LrXh3AJP+gZ/HDWBdGzUDrx5NwI=;
	h=Date:To:From:Subject:From;
	b=Ibv32Fa5u1Ry74wGtnSnyE0M6a6Y0GKRw4XNdPdOY+TL0KuP8gJwBg+UGA3wS0BJ3
	 llyjKMP5nvgjvubSNErdtrPq7EZpMhHM17YO3iWwXPCW+EtYjg+B22i/r4P6qG4aS7
	 rULU3PHcbRyswYTsN2zY7uybE4Scnrwd0mEyeYNA=
Date: Wed, 29 Oct 2025 14:55:03 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,rdunlap@infradead.org,osandov@osandov.com,lorenzo.stoakes@oracle.com,david@redhat.com,linux@israelbatista.dev.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-type-of-state-in-struct-memory_block.patch added to mm-new branch
Message-Id: <20251029215504.4A81AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: change type of state in struct memory_block
has been added to the -mm mm-new branch.  Its filename is
     mm-change-type-of-state-in-struct-memory_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-type-of-state-in-struct-memory_block.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Israel Batista <linux@israelbatista.dev.br>
Subject: mm: change type of state in struct memory_block
Date: Wed, 29 Oct 2025 19:56:30 +0000 (UTC)

The state of a memory block should be restricted to values specified in
the documentation of the memory hotplug API.  However, since the state
field in the memory_block struct was defined as an unsigned long, this
restriction was not enforced at compile time.

With the introduction of the enum memory_block_state, it is now possible
to incorporate the desired semantics in the field declaration and enforce
these restrictions at compile time.

Link: https://lkml.kernel.org/r/20251029195617.2210700-3-linux@israelbatista.dev.br
Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Omar Sandoval <osandov@osandov.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |    2 +-
 include/linux/memory.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/memory.c~mm-change-type-of-state-in-struct-memory_block
+++ a/drivers/base/memory.c
@@ -198,7 +198,7 @@ static ssize_t state_show(struct device
 		break;
 	default:
 		WARN_ON(1);
-		return sysfs_emit(buf, "ERROR-UNKNOWN-%ld\n", mem->state);
+		return sysfs_emit(buf, "ERROR-UNKNOWN-%d\n", mem->state);
 	}
 
 	return sysfs_emit(buf, "%s\n", output);
--- a/include/linux/memory.h~mm-change-type-of-state-in-struct-memory_block
+++ a/include/linux/memory.h
@@ -78,7 +78,7 @@ enum memory_block_state {
 
 struct memory_block {
 	unsigned long start_section_nr;
-	unsigned long state;		/* serialized by the dev->lock */
+	enum memory_block_state state; /* serialized by the dev->lock */
 	int online_type;		/* for passing data to online routine */
 	int nid;			/* NID for this memory block */
 	/*
_

Patches currently in -mm which might be from linux@israelbatista.dev.br are

mm-convert-memory-block-states-mem_-macros-to-enum.patch
mm-change-type-of-state-in-struct-memory_block.patch
mm-change-type-of-parameter-for-memory_notify.patch

