Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEAD236435
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343277; cv=none; b=fxQclaY5XAGbcUc2Idf1If+uNSuVW1gaZQsHNJ3/85HL37qZYgb/xOmX6cYNEw47flSwzmVLRPYepbNHErEN7bNLoxCemMbcZedxn/RKdGWeD0SY/4qL8u22M0FoVHNmkme9olOT5TwpdgziLMi+dapub+uJhoMGt0fU8OWLytM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343277; c=relaxed/simple;
	bh=dsx0BZDcfUbTJOYnQyPgf4NwFVUHAkDpG46wd/sXazM=;
	h=Date:To:From:Subject:Message-Id; b=R1vPJ9hBroK8LVmGEUFUCnqt/6rI+VZ2tQxOlWrgR1Ln52JoA4ftZOk0DmOWkIxDSxipoGFSYI/4ZyeA3XPROU7a5YHDbEb+qinwFeBMX7EfSCoDTfyWrZYBcDb7givl00LX3SBfNdNvz9zLYwRSpgjr6PoVRIUYQrU89/cIdY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c8e2jKnA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c8e2jKnA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012EBC19422;
	Mon, 17 Nov 2025 01:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343277;
	bh=dsx0BZDcfUbTJOYnQyPgf4NwFVUHAkDpG46wd/sXazM=;
	h=Date:To:From:Subject:From;
	b=c8e2jKnAUQldJGQYXnbnxqOMmzUvSqxKSMdNAphoLxo9Oe+qWXW2a7rWe5T74kDar
	 IZ/gkilJoa2ghx3n4WRs5crEAFTNPlt1XEJu/LkZ+nSX9w0SMZrvuln6Pfp/TJvSU/
	 219vmLmlLC4sImSxkFlUbDeJB77ZgLeuoeHM54+c=
Date: Sun, 16 Nov 2025 17:34:36 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,rdunlap@infradead.org,osandov@osandov.com,lorenzo.stoakes@oracle.com,david@redhat.com,linux@israelbatista.dev.br,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-type-of-state-in-struct-memory_block.patch removed from -mm tree
Message-Id: <20251117013437.012EBC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change type of state in struct memory_block
has been removed from the -mm tree.  Its filename was
     mm-change-type-of-state-in-struct-memory_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: fix whitespace, per Randy]
Link: https://lkml.kernel.org/r/20251029195617.2210700-3-linux@israelbatista.dev.br
Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
+	enum memory_block_state state;	/* serialized by the dev->lock */
 	int online_type;		/* for passing data to online routine */
 	int nid;			/* NID for this memory block */
 	/*
_

Patches currently in -mm which might be from linux@israelbatista.dev.br are


