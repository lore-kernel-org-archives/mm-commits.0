Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722121C700A
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274635; cv=none; b=iaeVjQOLIMSF3t5CCEP2YQhum7tPGQXVNEjBJ1vyAE17CDMkE73Inzr0rQEfIm50Jka7qNKgdA8vhSDz4lbOJ0247gTj73He9LwW1Yrc15IbTKfRz9veknVvwbtYXT9U3+KwavrBJ0osCofrgJnQVElX/riHbEBp2hibha5l5+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274635; c=relaxed/simple;
	bh=dW5BiOrScAaASi/qLIFFy4/q5zYcEiLhHxDO6m7dRJE=;
	h=Date:To:From:Subject:Message-Id; b=cVeUrQii5VvlRNjZwZfDibklUfUN4OSo5/TCOY8+zPsaWjHDDydnU6uXEsWZr3opRA1CN2I+FC4UkyiNZpYtFASf3l50fZix2t5+jizkK3MDIpCYdZMka5jJqtNRIRbqxcqmuDmZmQdrmFl9u/JVeDeEdfByYqX6BSs+YTxV/xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k0Ygp/77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k0Ygp/77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497B7C4CEDD;
	Tue, 18 Mar 2025 05:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274635;
	bh=dW5BiOrScAaASi/qLIFFy4/q5zYcEiLhHxDO6m7dRJE=;
	h=Date:To:From:Subject:From;
	b=k0Ygp/773QBdvXQajKreZuFk/bXdq1iuLQuW6aUeP54F/qagEX1hYsk1VXEpsq90u
	 CkHqq8MlgVpX/vmvrwxlpC3UV4a5qPh/LTAPWq5/a2JvNgzySo8MnIXCwbEuPDt0eb
	 xSunH++4fZ8VLuwWBTSMipdTHa/iCFQFAsFumnks=
Date: Mon, 17 Mar 2025 22:10:34 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,osalvador@suse.de,gregkh@linuxfoundation.org,david@redhat.com,dakr@kernel.org,gshan@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] drivers-base-memory-improve-add_boot_memory_block.patch removed from -mm tree
Message-Id: <20250318051035.497B7C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: drivers/base/memory: improve add_boot_memory_block()
has been removed from the -mm tree.  Its filename was
     drivers-base-memory-improve-add_boot_memory_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: drivers/base/memory: improve add_boot_memory_block()
Date: Wed, 12 Mar 2025 09:30:43 +1000

Patch series "drivers/base/memory: Two cleanups", v3.

Two cleanups to drivers/base/memory.


This patch (of 2)L

It's unnecessary to count the present sections for the specified block
since the block will be added if any section in the block is present. 
Besides, for_each_present_section_nr() can be reused as Andrew Morton
suggested.

Improve by using for_each_present_section_nr() and dropping the
unnecessary @section_count.

No functional changes intended.

Link: https://lkml.kernel.org/r/20250311233045.148943-1-gshan@redhat.com
Link: https://lkml.kernel.org/r/20250311233045.148943-2-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c  |   17 ++++++++---------
 include/linux/mmzone.h |    5 +++++
 mm/sparse.c            |    5 -----
 3 files changed, 13 insertions(+), 14 deletions(-)

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
--- a/include/linux/mmzone.h~drivers-base-memory-improve-add_boot_memory_block
+++ a/include/linux/mmzone.h
@@ -2140,6 +2140,11 @@ static inline unsigned long next_present
 	return -1;
 }
 
+#define for_each_present_section_nr(start, section_nr)		\
+	for (section_nr = next_present_section_nr(start - 1);	\
+	     section_nr != -1;					\
+	     section_nr = next_present_section_nr(section_nr))
+
 /*
  * These are _only_ used during initialisation, therefore they
  * can use __initdata ...  They could have names to indicate
--- a/mm/sparse.c~drivers-base-memory-improve-add_boot_memory_block
+++ a/mm/sparse.c
@@ -170,11 +170,6 @@ static void __section_mark_present(struc
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
 
-#define for_each_present_section_nr(start, section_nr)		\
-	for (section_nr = next_present_section_nr(start-1);	\
-	     section_nr != -1;								\
-	     section_nr = next_present_section_nr(section_nr))
-
 static inline unsigned long first_present_section_nr(void)
 {
 	return next_present_section_nr(-1);
_

Patches currently in -mm which might be from gshan@redhat.com are


