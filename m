Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C835819007D
	for <mm-commits@vger.kernel.org>; Tue, 11 Mar 2025 03:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741663478; cv=none; b=u/mCrTr66SFiV7zhXNRnw9O/tcClu5KCWrn7aozbu4Hl1X9IMV5ECJrMeIolNE3blmXpXgJgZDHYT1BfxP2U9vfG959ensj5WPmjrlvIZnPr9CBTlggxuLKP2ee5khwq2q6DPa7vuVXWSOdOSRY0q1MFJdYT+8VloDo8jcbzirc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741663478; c=relaxed/simple;
	bh=KJo5QWT+UzIB2LVAna4jwgTBsodpSSg4urXA1QU5wVY=;
	h=Date:To:From:Subject:Message-Id; b=LsoIkFnyOl7odbcwYxTYTuzbIOtmHdOGBSIziKD93Kh22lxAJRiCh1cnQGOZ+GNBLVnQJYOpsaZobJM//98f8oho6QkIHeP3TLhnoZYSy30+s123zavV19Lpcq+rgcmwE2NttLlIKaO6b8nJsoQymiqcvU33ME4tWpfi6H8CcqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GOkZObuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GOkZObuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C722C4CEE9;
	Tue, 11 Mar 2025 03:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741663478;
	bh=KJo5QWT+UzIB2LVAna4jwgTBsodpSSg4urXA1QU5wVY=;
	h=Date:To:From:Subject:From;
	b=GOkZObuWNvlLEkBE5LvSwR+wgQxedE0R4GXzAuaf9j2JNk26jdUFox6k2O+b/CMSD
	 Gq6QYkDd/AC+9+UghyL9HSmHbC6eTgQqCHWz1NokPJWoVo7Zln2wywnT9eqpds4vzU
	 f9GHeInQSfxjbMcOKapFz3aw3hmlyIUSiqjq4ptc=
Date: Mon, 10 Mar 2025 20:24:38 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,gregkh@linuxfoundation.org,david@redhat.com,dakr@kernel.org,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + drivers-base-memory-improve-add_boot_memory_block.patch added to mm-unstable branch
Message-Id: <20250311032438.8C722C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: drivers/base/memory: improve add_boot_memory_block()
has been added to the -mm mm-unstable branch.  Its filename is
     drivers-base-memory-improve-add_boot_memory_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/drivers-base-memory-improve-add_boot_memory_block.patch

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
Subject: drivers/base/memory: improve add_boot_memory_block()
Date: Tue, 11 Mar 2025 10:46:56 +1000

It's unnecessary to count the present sections for the specified block
since the block will be added if any section in the block is present. 
Besides, for_each_present_section_nr() can be reused as Andrew Morton
suggested.

Improve by using for_each_present_section_nr() and dropping the
unnecessary @section_count.

No functional changes intended.

Link: https://lkml.kernel.org/r/20250311004657.82985-3-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/base/memory.c~drivers-base-memory-improve-add_boot_memory_block
+++ a/drivers/base/memory.c
@@ -818,18 +818,17 @@ static int add_memory_block(unsigned lon
 
 static int __init add_boot_memory_block(unsigned long base_section_nr)
 {
-	int section_count = 0;
 	unsigned long nr;
 
-	for (nr = base_section_nr; nr < base_section_nr + sections_per_block;
-	     nr++)
-		if (present_section_nr(nr))
-			section_count++;
+	for_each_present_section_nr(base_section_nr, nr) {
+		if (nr >= (base_section_nr + sections_per_block))
+			break;
 
-	if (section_count == 0)
-		return 0;
-	return add_memory_block(memory_block_id(base_section_nr),
-				MEM_ONLINE, NULL,  NULL);
+		return add_memory_block(memory_block_id(base_section_nr),
+					MEM_ONLINE, NULL, NULL);
+	}
+
+	return 0;
 }
 
 static int add_hotplug_memory_block(unsigned long block_id,
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-sparse-expose-for_each_present_section_nr.patch
drivers-base-memory-improve-add_boot_memory_block.patch
drivers-base-memory-correct-the-field-name-in-the-header.patch

